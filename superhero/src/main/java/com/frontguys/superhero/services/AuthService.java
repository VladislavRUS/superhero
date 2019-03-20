package com.frontguys.superhero.services;

import com.frontguys.superhero.dao.AuthDAO;
import com.frontguys.superhero.models.Client;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.UUID;

@Service
public class AuthService {
    @Autowired
    AuthDAO authDAO;

    public boolean register(Client client) {
        if (authDAO.findClientByEmail(client) == null) {
            authDAO.register(client);
            return true;
        } else {
            return false;
        }
    }

    public String login(Client client) {
        Client existingClient = authDAO.findClientByCredentials(client);

        if (existingClient != null) {
            String token = UUID.randomUUID().toString();
            authDAO.saveToken(token, existingClient.getId());
            return token;
        } else {
            return null;
        }
    }
}
