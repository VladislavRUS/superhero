package com.frontguys.superhero.controllers;

import com.frontguys.superhero.constants.ClientRoles;
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
import java.util.List;

@RestController
public class MessageController {
    @Autowired
    ClientService clientService;
    @Autowired
    RequestService requestService;
    @Autowired
    MessageService messageService;
    @Autowired
    ResponseService responseService;

    @RequestMapping(value = "/api/v1/auth/responses/{responseId}/messages", method = RequestMethod.GET)
    public ResponseEntity<Object> getMessages(HttpServletRequest httpServletRequest, @PathVariable int responseId) {
        String token = httpServletRequest.getHeader("Authorization");
        Client client = clientService.getClientByToken(token);
        String role = client.getRole();

        Response responseById = responseService.getResponseById(responseId);
        Request requestById = requestService.getRequestById(responseById.getRequestId());

        switch (role) {
            case ClientRoles.CUSTOMER:
                if (requestById.getCustomerId() != client.getId()) {
                    return new ResponseEntity<>(HttpStatus.FORBIDDEN);
                } else {
                    List<Message> messagesByRequestId = messageService.getMessagesByResponseId(responseId);
                    return new ResponseEntity<>(messagesByRequestId, HttpStatus.OK);
                }
            case ClientRoles.CONTRACTOR:
                if (responseById.getContractorId() != client.getId()) {
                    return new ResponseEntity<>(HttpStatus.FORBIDDEN);
                } else {
                    List<Message> messagesByResponseId = messageService.getMessagesByResponseId(responseId);
                    return new ResponseEntity<>(messagesByResponseId, HttpStatus.OK);
                }
            default:
                return new ResponseEntity<>(HttpStatus.FORBIDDEN);
        }
    }

    @RequestMapping(value = "/api/v1/auth/responses/{responseId}/messages", method = RequestMethod.POST)
    public ResponseEntity<Object> createMessage(HttpServletRequest httpServletRequest, @RequestBody Message message, @PathVariable int responseId) {
        String token = httpServletRequest.getHeader("Authorization");
        Client client = clientService.getClientByToken(token);
        String role = client.getRole();

        if (ClientRoles.ADMIN.equals(role)) {
            return new ResponseEntity<>(HttpStatus.FORBIDDEN);
        }

        if (message.getText() == null) {
            return new ResponseEntity<>("Empty text", HttpStatus.BAD_REQUEST);
        }

        message.setSenderId(client.getId());
        message.setResponseId(responseId);

        Response responseById = responseService.getResponseById(message.getResponseId());
        Request requestById = requestService.getRequestById(responseById.getRequestId());

        switch (role) {
            case ClientRoles.CUSTOMER:
                if (requestById.getCustomerId() != client.getId()) {
                    return new ResponseEntity<>(HttpStatus.FORBIDDEN);
                } else {
                    messageService.createMessage(message.getResponseId(), message);
                    return new ResponseEntity<>(HttpStatus.CREATED);
                }
            case ClientRoles.CONTRACTOR:
                List<Response> responsesByContractorId = responseService.getResponsesByContractorId(client.getId());

                boolean responded = false;
                for (Response response : responsesByContractorId) {
                    if (response.getContractorId() == client.getId()) {
                        responded = true;
                        break;
                    }
                }

                if (responded) {
                    messageService.createMessage(message.getResponseId(), message);
                    return new ResponseEntity<>(HttpStatus.CREATED);
                } else {
                    return new ResponseEntity<>("You have not responded to that request", HttpStatus.FORBIDDEN);
                }
            default:
                return new ResponseEntity<>(HttpStatus.FORBIDDEN);
        }
    }
}
