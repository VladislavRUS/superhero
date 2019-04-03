package com.frontguys.superhero.services;

import com.frontguys.superhero.dao.RequestDAO;
import com.frontguys.superhero.models.Request;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class RequestService {
    @Autowired
    RequestDAO requestDAO;

    public List<Request> getAllRequests() {
        return requestDAO.getAllRequests();
    }

    public List<Request> getCustomerRequests(int customerId) {
        return requestDAO.getCustomerRequests(customerId);
    }

    public void createRequest(Request request) {
        requestDAO.createRequest(request);
    }

    public void updateRequest(int requestId, Request request) {
        requestDAO.updateRequest(requestId, request);
    }

    public void confirmRequest(int requestId) {
        requestDAO.confirmRequest(requestId);
    }

    public Request getRequestById(int id) {
        return requestDAO.getRequestById(id);
    }

    public void finishRequest(int requestId) {
        requestDAO.finishRequest(requestId);
    }
}
