package com.frontguys.superhero.services;

import com.frontguys.superhero.dao.ClientDAO;
import com.frontguys.superhero.models.Client;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class ClientService {
    @Autowired
    ClientDAO clientDAO;

    public Client getClientByToken(String token) {
        return clientDAO.getClientByToken(token);
    }
    public Client getClientById(int id) {
        return clientDAO.getClientById(id);
    }
}
