package com.frontguys.superhero.controllers;

import com.frontguys.superhero.constants.ClientRoles;
import com.frontguys.superhero.models.Client;
import com.frontguys.superhero.models.Request;
import com.frontguys.superhero.models.Response;
import com.frontguys.superhero.services.ClientService;
import com.frontguys.superhero.services.RequestService;
import com.frontguys.superhero.services.ResponseService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletRequest;

@CrossOrigin(value = "*")
@RestController
public class ResponseController {
    @Autowired
    ResponseService responseService;
    @Autowired
    RequestService requestService;
    @Autowired
    ClientService clientService;

    @RequestMapping(value = "/api/v1/auth/responses", method = RequestMethod.POST)
    public ResponseEntity<String> createResponse(@RequestBody Response response, HttpServletRequest httpServletRequest) {
        String token = httpServletRequest.getHeader("Authorization");
        Client client = clientService.getClientByToken(token);
        String role = client.getRole();

        if (ClientRoles.CUSTOMER.equals(role)) {
            return new ResponseEntity<>("Customers cannot create responses", HttpStatus.FORBIDDEN);
        } else {
            int requestId = response.getRequestId();
            Request request = requestService.getRequestById(requestId);

            if (request == null) {
                return new ResponseEntity<>("Request does not exists", HttpStatus.NOT_FOUND);
            }

            if (!request.isConfirmed()) {
                return new ResponseEntity<>("Request is not confirmed", HttpStatus.BAD_REQUEST);
            } else {
                response.setContractorId(client.getId());
                responseService.createResponse(response);
                return new ResponseEntity<>(HttpStatus.CREATED);
            }
        }
    }

    @RequestMapping(value = "/api/v1/auth/responses/{id}", method = RequestMethod.DELETE)
    public ResponseEntity<Object> deleteResponse(HttpServletRequest httpServletRequest, @PathVariable int id) {
        String token = httpServletRequest.getHeader("Authorization");
        Client client = clientService.getClientByToken(token);
        String role = client.getRole();

        if (ClientRoles.CUSTOMER.equals(role)) {
            return new ResponseEntity<>("Customers cannot delete responses", HttpStatus.FORBIDDEN);
        } else {
            if (ClientRoles.ADMIN.equals(role)) {
                responseService.deleteResponse(id);
                return new ResponseEntity<>(HttpStatus.OK);
            } else {
                Response response = responseService.getResponseById(id);

                if (response.getContractorId() == client.getId()) {
                    responseService.deleteResponse(id);
                    return new ResponseEntity<>(HttpStatus.OK);
                } else {
                    return new ResponseEntity<>(HttpStatus.FORBIDDEN);
                }
            }
        }
    }
}
