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
import java.text.SimpleDateFormat;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@CrossOrigin(value = "*")
@RestController
public class ResponseController {
    @Autowired
    ResponseService responseService;
    @Autowired
    RequestService requestService;
    @Autowired
    ClientService clientService;
    @Autowired
    MessageService messageService;

    @RequestMapping(value = "/api/v1/auth/responses", method = RequestMethod.POST)
    public ResponseEntity<String> createResponse(@RequestBody Response response, HttpServletRequest httpServletRequest) {
        String token = httpServletRequest.getHeader("Authorization");
        Client client = clientService.getClientByToken(token);
        String role = client.getRole();

        if (response.getPlannedDate() == null) {
            return new ResponseEntity<>("Fill response", HttpStatus.NOT_ACCEPTABLE);
        }

        if (ClientRoles.CUSTOMER.equals(role)) {
            return new ResponseEntity<>("Customers cannot create responses", HttpStatus.FORBIDDEN);
        } else {
            int requestId = response.getRequestId();
            Request request = requestService.getRequestById(requestId);

            if (request == null) {
                return new ResponseEntity<>("Request does not exists", HttpStatus.NOT_FOUND);
            }

            response.setContractorId(client.getId());
            Response newResponse = responseService.createResponse(response);
            Map<String, String> msgParams = new HashMap<>();
            SimpleDateFormat simpleDateFormat = new SimpleDateFormat("yyyy-MM-dd");
            String format = simpleDateFormat.format(response.getPlannedDate());
            msgParams.put("plannedDate", format);
            msgParams.put("payment", String.valueOf(response.getPayment()));
            Message messageWithParams = messageService.createMessageWithParams(SystemMessages.CREATE_RESPONSE, msgParams);
            messageWithParams.setSenderId(client.getId());
            messageService.createMessage(newResponse.getId(), messageWithParams);

            return new ResponseEntity<>(HttpStatus.CREATED);
        }
    }

    @RequestMapping(value = "/api/v1/auth/responses", method = RequestMethod.GET)
    public ResponseEntity<Object> getResponses(HttpServletRequest httpServletRequest) {
        String token = httpServletRequest.getHeader("Authorization");
        Client client = clientService.getClientByToken(token);
        String role = client.getRole();

        if (ClientRoles.CUSTOMER.equals(role)) {
            List<Response> responsesByCustomerId = responseService.getResponsesByCustomerId(client.getId());
            return new ResponseEntity<>(responsesByCustomerId, HttpStatus.OK);
        } else if (ClientRoles.CONTRACTOR.equals(role)) {
            List<Response> responsesByContractorId = responseService.getResponsesByContractorId(client.getId());
            return new ResponseEntity<>(responsesByContractorId, HttpStatus.OK);
        } else {
            List<Response> allResponses = responseService.getAllResponses();
            return new ResponseEntity<>(allResponses, HttpStatus.OK);
        }
    }
}
