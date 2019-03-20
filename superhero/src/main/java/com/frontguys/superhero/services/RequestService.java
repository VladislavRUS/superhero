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

    public Request getRequestFromListById(List<Request> requests, int id) {
        for (Request request : requests) {
            if (request.getId() == id) {
                return request;
            }
        }

        return null;
    }

    public Request getRequestById(int id) {
        return requestDAO.getRequestById(id);
    }
}
