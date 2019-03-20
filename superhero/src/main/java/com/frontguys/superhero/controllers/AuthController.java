package com.frontguys.superhero.controllers;

import com.frontguys.superhero.constants.ClientRoles;
import com.frontguys.superhero.models.Client;
import com.frontguys.superhero.services.AuthService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;

@CrossOrigin
@RestController
public class AuthController {
    @Autowired
    AuthService authService;

    @RequestMapping(value = "/api/v1/register", method = RequestMethod.POST)
    public ResponseEntity<Object> register(@RequestBody Client newClient) {

        String email = newClient.getEmail();
        String password = newClient.getPassword();
        String role = newClient.getRole();

        if (email == null || password == null || role == null) {
            return new ResponseEntity<>(HttpStatus.BAD_REQUEST);
        }

        if (!role.equals(ClientRoles.CUSTOMER) && !role.equals(ClientRoles.CONTRACTOR)) {
            return new ResponseEntity<>("Incorrect role", HttpStatus.BAD_REQUEST);
        }

        if (authService.register(newClient)) {
            return new ResponseEntity<>(HttpStatus.CREATED);
        } else {
            return new ResponseEntity<>("Already exists", HttpStatus.CONFLICT);
        }
    }

    @RequestMapping(value = "/api/v1/login", method = RequestMethod.POST)
    public ResponseEntity<Object> login(@RequestBody Client client) {

        String email = client.getEmail();
        String password = client.getPassword();

        if (email == null || password == null) {
            return new ResponseEntity<>("Empty credentials", HttpStatus.BAD_REQUEST);
        }

        String token = authService.login(client);

        if (token != null) {
            HashMap<String, String> result = new HashMap<>();
            result.put("token", token);

            return new ResponseEntity<>(result, HttpStatus.OK);
        } else {
            return new ResponseEntity<>("Client was not found", HttpStatus.NOT_FOUND);
        }
    }
}
