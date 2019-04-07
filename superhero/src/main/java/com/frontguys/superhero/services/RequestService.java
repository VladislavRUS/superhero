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
    @Autowired
    ClientService clientService;

    public List<Request> getAllRequests() {
        return fillRequestListWithClientDetails(requestDAO.getAllRequests());
    }

    public List<Request> getCustomerRequests(int customerId) {
        return fillRequestListWithClientDetails(requestDAO.getCustomerRequests(customerId));
    }

    public void confirmRequest(int requestId) {
        requestDAO.confirmRequest(requestId);
    }

    public Request getRequestById(int id) {
        return fillRequestWithClientDetails(requestDAO.getRequestById(id));
    }

    public void finishRequest(int requestId) {
        requestDAO.finishRequest(requestId);
    }

    public Request getRequestFromListById(List<Request> requests, int requestId) {
        for (Request req : requests) {
            if (req.getId() == requestId) {
                return req;
            }
        }

        return null;
    }

    private Request fillRequestWithClientDetails(Request request) {
        request.setCustomerDetails(clientService.getClientDetails(request.getCustomerId()));
        return request;
    }

    private List<Request> fillRequestListWithClientDetails(List<Request> requests) {
        for (Request request : requests) {
            fillRequestWithClientDetails(request);
        }

        return requests;
    }

    public void assignRequest(int requestId, int contractorId) {
        requestDAO.assignRequest(requestId, contractorId);
    }

    public void finishContractorRequest(int requestId) {
        requestDAO.finishContractorRequest(requestId);
    }

    public void finishCustomerRequest(int requestId) {
        requestDAO.finishCustomerRequest(requestId);
    }

    public void finishAdminRequest(int requestId) {
        requestDAO.finishAdminRequest(requestId);
    }

    public void pay(int requestId) {
        requestDAO.pay(requestId);
    }
}
