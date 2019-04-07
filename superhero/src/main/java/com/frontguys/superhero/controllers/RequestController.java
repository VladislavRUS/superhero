package com.frontguys.superhero.controllers;

import com.frontguys.superhero.constants.ClientRoles;
import com.frontguys.superhero.constants.SystemMessages;
import com.frontguys.superhero.models.Client;
import com.frontguys.superhero.models.Message;
import com.frontguys.superhero.models.Request;
import com.frontguys.superhero.models.Response;
import com.frontguys.superhero.services.ClientService;
import com.frontguys.superhero.services.MessageService;
import com.frontguys.superhero.services.RequestService;
import com.frontguys.superhero.services.ResponseService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletRequest;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@CrossOrigin(value = "*")
@RestController
public class RequestController {
    @Autowired
    ClientService clientService;
    @Autowired
    RequestService requestService;
    @Autowired
    ResponseService responseService;
    @Autowired
    MessageService messageService;

    @RequestMapping(value = "/api/v1/auth/requests", method = RequestMethod.GET)
    public ResponseEntity<Object> getRequests(HttpServletRequest httpServletRequest) {
        String token = httpServletRequest.getHeader("Authorization");
        Client client = clientService.getClientByToken(token);
        String role = client.getRole();

        if (ClientRoles.CUSTOMER.equals(role)) {
            return new ResponseEntity<>(requestService.getCustomerRequests(client.getId()), HttpStatus.OK);
        } else {
            List<Request> allRequests = requestService.getAllRequests();
            return new ResponseEntity<>(allRequests, HttpStatus.OK);
        }
    }

    @RequestMapping(value = "/api/v1/auth/requests/{id}/responses", method = RequestMethod.GET)
    public ResponseEntity<Object> getRequestResponses(HttpServletRequest httpServletRequest, @PathVariable int id) {
        String token = httpServletRequest.getHeader("Authorization");
        Client client = clientService.getClientByToken(token);
        String role = client.getRole();

        Request request = requestService.getRequestById(id);

        // Customer can see only his responses
        if (ClientRoles.CUSTOMER.equals(role)) {
            if (request.getCustomerId() != client.getId()) {
                return new ResponseEntity<>(HttpStatus.FORBIDDEN);
            }
        }

        List<Response> responses = responseService.getResponsesByRequestId(id);
        return new ResponseEntity<>(responses, HttpStatus.OK);
    }

    @RequestMapping(value = "/api/v1/auth/requests/{requestId}/messages", method = RequestMethod.GET)
    public ResponseEntity<Object> getRequestSystemMessages(HttpServletRequest httpServletRequest, @PathVariable int requestId) {
        String token = httpServletRequest.getHeader("Authorization");
        Client client = clientService.getClientByToken(token);
        String role = client.getRole();

        Request request = requestService.getRequestById(requestId);

        // Customer can see only his responses
        if (ClientRoles.CUSTOMER.equals(role)) {
            if (request.getCustomerId() != client.getId()) {
                return new ResponseEntity<>(HttpStatus.FORBIDDEN);
            }
        }

        if (request.getContractorId() == null) {
            return new ResponseEntity<>(new ArrayList<>(), HttpStatus.OK);
        }

        List<Response> responsesByRequestId = responseService.getResponsesByRequestId(requestId);
        for (Response response : responsesByRequestId) {
            if (response.getContractorId() == request.getContractorId()) {
                List<Message> messagesByResponseId = messageService.getMessagesByResponseId(response.getId());
                return new ResponseEntity<>(messagesByResponseId, HttpStatus.OK);
            }
        }


        return new ResponseEntity<>(HttpStatus.NOT_FOUND);
    }

    @RequestMapping(value = "/api/v1/auth/requests/{requestId}/assign", method = RequestMethod.POST)
    public ResponseEntity<Object> assignRequest(HttpServletRequest httpServletRequest, @PathVariable int requestId, @RequestParam int contractorId) {
        String token = httpServletRequest.getHeader("Authorization");
        Client client = clientService.getClientByToken(token);
        String role = client.getRole();

        Request request = requestService.getRequestById(requestId);

        // Customer can see only his responses
        if (ClientRoles.CUSTOMER.equals(role)) {
            if (request.getCustomerId() != client.getId()) {
                return new ResponseEntity<>(HttpStatus.FORBIDDEN);
            }
        }

        List<Response> responsesByContractorId = responseService.getResponsesByContractorId(contractorId);

        if (!responseService.hasResponseWithContractorId(responsesByContractorId, contractorId)) {
            return new ResponseEntity<>("No response from that contractor", HttpStatus.FORBIDDEN);
        }

        if (request.getContractorId() != null) {
            return new ResponseEntity<>("Already assigned", HttpStatus.BAD_REQUEST);
        }


        Message message = new Message();
        message.setSystem(true);
        message.setText(SystemMessages.ASSIGNED);

        List<Response> allResponses = responseService.getAllResponses();

        for (Response resp : allResponses) {
            if (resp.getContractorId() == contractorId) {
                requestService.assignRequest(requestId, contractorId);
                messageService.createMessage(resp.getId(), message);
                break;
            }
        }

        return new ResponseEntity<>(HttpStatus.OK);
    }

    @RequestMapping(value = "/api/v1/auth/requests/{requestId}/finish", method = RequestMethod.POST)
    public ResponseEntity<Object> finish(HttpServletRequest httpServletRequest, @PathVariable int requestId) {
        String token = httpServletRequest.getHeader("Authorization");
        Client client = clientService.getClientByToken(token);
        String role = client.getRole();

        Request request = requestService.getRequestById(requestId);

        // Customer can see only his responses
        if (ClientRoles.CUSTOMER.equals(role)) {
            if (request.getCustomerId() != client.getId()) {
                return new ResponseEntity<>(HttpStatus.FORBIDDEN);
            }
        } else if (ClientRoles.CONTRACTOR.equals(role)) {
            if (request.getContractorId() != client.getId()) {
                return new ResponseEntity<>(HttpStatus.FORBIDDEN);
            }
        }

        if (ClientRoles.CUSTOMER.equals(role) && request.isFinishedByCustomer()) {
            return new ResponseEntity<>("Already finished", HttpStatus.BAD_REQUEST);
        }

        if (ClientRoles.CONTRACTOR.equals(role) && request.isFinishedByContractor()) {
            return new ResponseEntity<>("Already finished", HttpStatus.BAD_REQUEST);
        }

        if (request.getContractorId() == null) {
            return new ResponseEntity<>("No contractor", HttpStatus.BAD_REQUEST);
        }

        Message message = new Message();
        message.setSystem(true);

        if (ClientRoles.CONTRACTOR.equals(role) && !request.isFinishedByContractor()) {
            message.setText(SystemMessages.FINISH_CONTRACTOR);
            requestService.finishContractorRequest(requestId);
        } else if (ClientRoles.CUSTOMER.equals(role) && !request.isFinishedByCustomer()) {
            requestService.finishCustomerRequest(requestId);
            message.setText(SystemMessages.FINISH_CUSTOMER);
        } else if (ClientRoles.ADMIN.equals(role) && !request.isApproved()) {
            requestService.finishAdminRequest(requestId);
            message.setText(SystemMessages.FINISH_ADMIN);
        }

        messageService.createMessageByRequest(message, request);

        return new ResponseEntity<>(HttpStatus.OK);
    }

    @RequestMapping(value = "/api/v1/auth/requests/{requestId}/pay/{responseId}", method = RequestMethod.POST)
    public ResponseEntity<Object> pay(HttpServletRequest httpServletRequest, @PathVariable int requestId, @PathVariable int responseId) {
        String token = httpServletRequest.getHeader("Authorization");
        Client client = clientService.getClientByToken(token);
        String role = client.getRole();

        Request request = requestService.getRequestById(requestId);

        if (!ClientRoles.CUSTOMER.equals(role)) {
            return new ResponseEntity<>(HttpStatus.FORBIDDEN);
        }

        // Customer can see only his responses
        if (ClientRoles.CUSTOMER.equals(role)) {
            if (request.getCustomerId() != client.getId()) {
                return new ResponseEntity<>(HttpStatus.FORBIDDEN);
            }
        }

        Message message = new Message();
        message.setSystem(true);

        Response responseById = responseService.getResponseById(responseId);

        Map<String, String> msgParams = new HashMap<>();

        requestService.pay(requestId);
        msgParams.put("money", String.valueOf(responseById.getPayment()));
        messageService.createMessage(responseId, messageService.createMessageWithParams(SystemMessages.CUSTOMER_PAY, msgParams));

        return new ResponseEntity<>(HttpStatus.OK);
    }
}
