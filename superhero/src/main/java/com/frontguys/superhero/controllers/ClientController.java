package com.frontguys.superhero.controllers;

import com.frontguys.superhero.models.Client;
import com.frontguys.superhero.models.ClientDetails;
import com.frontguys.superhero.services.ClientService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletRequest;

@CrossOrigin(value = "*")
@RestController
public class ClientController {
    @Autowired
    ClientService clientService;

    @RequestMapping(value = "/api/v1/auth/clients/{id}", method = RequestMethod.PUT)
    public ResponseEntity<Object> updateClient(ClientDetails clientDetails, @PathVariable int id, HttpServletRequest httpServletRequest) {
        String token = httpServletRequest.getHeader("Authorization");
        Client client = clientService.getClientByToken(token);

        if (id == client.getId()) {
            clientService.updateClient(id, clientDetails);
            return new ResponseEntity<>(HttpStatus.OK);
        } else {
            return new ResponseEntity<>(HttpStatus.FORBIDDEN);
        }
    }

    @RequestMapping(value = "/api/v1/auth/clients/current", method = RequestMethod.GET)
    public ResponseEntity<Object> getCurrentClient(HttpServletRequest httpServletRequest) {
        String token = httpServletRequest.getHeader("Authorization");
        Client client = clientService.getClientByToken(token);

        return new ResponseEntity<>(new ClientDetails(client), HttpStatus.OK);
    }
}
