package com.frontguys.superhero.controllers;

import com.frontguys.superhero.constants.ClientRoles;
import com.frontguys.superhero.models.Client;
import com.frontguys.superhero.models.Request;
import com.frontguys.superhero.models.Response;
import com.frontguys.superhero.models.ClientDetails;
import com.frontguys.superhero.services.ClientService;
import com.frontguys.superhero.services.RequestService;
import com.frontguys.superhero.services.ResponseService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletRequest;
import java.util.ArrayList;
import java.util.List;

@CrossOrigin(value = "*")
@RestController
public class RequestController {
    @Autowired
    ClientService clientService;
    @Autowired
    RequestService requestService;
    @Autowired
    ResponseService responseService;

    @RequestMapping(value = "/api/v1/auth/requests", method = RequestMethod.GET)
    public ResponseEntity<Object> getRequests(HttpServletRequest httpServletRequest) {
        String token = httpServletRequest.getHeader("Authorization");
        Client client = clientService.getClientByToken(token);
        String role = client.getRole();

        if (ClientRoles.CUSTOMER.equals(role)) {
            return new ResponseEntity<>(requestService.getCustomerRequests(client.getId()), HttpStatus.OK);
        } else {
            List<Request> allRequests = requestService.getAllRequests();

            if (ClientRoles.ADMIN.equals(role)) {
                return new ResponseEntity<>(allRequests, HttpStatus.OK);
            } else {
                assert ClientRoles.CONTRACTOR.equals(role);

                List<Request> confirmedRequests = new ArrayList<>();

                for (Request request : allRequests) {
                    if (request.isConfirmed()) {
                        confirmedRequests.add(request);
                    }
                }

                return new ResponseEntity<>(confirmedRequests, HttpStatus.OK);
            }
        }
    }

    @RequestMapping(value = "/api/v1/auth/requests", method = RequestMethod.POST)
    public ResponseEntity<Object> createRequest(@RequestBody Request request, HttpServletRequest httpServletRequest) {
        String token = httpServletRequest.getHeader("Authorization");
        Client client = clientService.getClientByToken(token);
        String role = client.getRole();

        if (ClientRoles.CONTRACTOR.equals(role)) {
            return new ResponseEntity<>("Contractors cannot create requests", HttpStatus.FORBIDDEN);
        }

        request.setCustomerId(client.getId());
        requestService.createRequest(request);
        return new ResponseEntity<>(HttpStatus.CREATED);
    }

    @RequestMapping(value = "/api/v1/auth/requests/{id}/confirm", method = RequestMethod.POST)
    public ResponseEntity<Object> confirmRequest(HttpServletRequest httpServletRequest, @PathVariable int id) {
        String token = httpServletRequest.getHeader("Authorization");
        Client client = clientService.getClientByToken(token);
        String role = client.getRole();

        if (ClientRoles.ADMIN.equals(role)) {
            requestService.confirmRequest(id);
            return new ResponseEntity<>(HttpStatus.OK);
        } else {
            return new ResponseEntity<>("You are not allowed to confirm requests", HttpStatus.FORBIDDEN);
        }
    }

    @RequestMapping(value = "/api/v1/auth/requests/{id}", method = RequestMethod.PUT)
    public ResponseEntity<Object> updateRequest(@RequestBody Request newRequest, HttpServletRequest httpServletRequest, @PathVariable int id) {
        String token = httpServletRequest.getHeader("Authorization");
        Client client = clientService.getClientByToken(token);
        String role = client.getRole();

        if (ClientRoles.CONTRACTOR.equals(role)) {
            return new ResponseEntity<>("Contractors cannot update requests", HttpStatus.FORBIDDEN);
        }

        Request request = requestService.getRequestById(id);

        // Customer can update only his requests
        if (ClientRoles.CUSTOMER.equals(role)) {
            if (request.getCustomerId() != client.getId()) {
                return new ResponseEntity<>(HttpStatus.FORBIDDEN);
            }
        }

        newRequest.setResponseCount(request.getResponseCount());
        requestService.updateRequest(id, newRequest);
        return new ResponseEntity<>(requestService.getRequestById(id), HttpStatus.OK);
    }

    @RequestMapping(value = "/api/v1/auth/requests/{id}/responses", method = RequestMethod.GET)
    public ResponseEntity<Object> getRequestResponses(HttpServletRequest httpServletRequest, @PathVariable int id) {
        String token = httpServletRequest.getHeader("Authorization");
        Client client = clientService.getClientByToken(token);
        String role = client.getRole();

        if (ClientRoles.CONTRACTOR.equals(role)) {
            return new ResponseEntity<>("Contractors cannot update requests", HttpStatus.FORBIDDEN);
        }

        Request request = requestService.getRequestById(id);

        // Customer can see only his responses
        if (ClientRoles.CUSTOMER.equals(role)) {
            if (request.getCustomerId() != client.getId()) {
                return new ResponseEntity<>(HttpStatus.FORBIDDEN);
            }
        }

        List<Response> responses = responseService.getResponsesByRequestId(id);
        for (Response response : responses) {
            Client contractor = clientService.getClientById(response.getContractorId());

            ClientDetails contractorDetails = new ClientDetails();
            contractorDetails.setId(contractor.getId());
            contractorDetails.setEmail(contractor.getEmail());
            contractorDetails.setRole(contractor.getRole());
            contractorDetails.setLegalEntity(contractor.isLegalEntity());
            contractorDetails.setFirstName(contractor.getFirstName());
            contractorDetails.setLastName(contractor.getLastName());
            contractorDetails.setCompanyName(contractor.getCompanyName());
            contractorDetails.setAddress(contractor.getAddress());
            contractorDetails.setAbout(contractor.getAbout());

            response.setContractorDetails(contractorDetails);
        }

        return new ResponseEntity<>(responses, HttpStatus.OK);
    }
}
