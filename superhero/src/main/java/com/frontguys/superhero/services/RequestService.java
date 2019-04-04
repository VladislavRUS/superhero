package com.frontguys.superhero.services;

import com.frontguys.superhero.dao.RequestDAO;
import com.frontguys.superhero.models.Request;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
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

    public List<Request> getConfirmedRequests() {
        List<Request> allRequests = requestDAO.getAllRequests();
        List<Request> confirmedRequests = new ArrayList<>();

        for (Request request: allRequests) {
            if (request.isConfirmed()) {
                confirmedRequests.add(request);
            }
        }

        return fillRequestListWithClientDetails(confirmedRequests);
    }

    public List<Request> getCustomerRequests(int customerId) {
        return fillRequestListWithClientDetails(requestDAO.getCustomerRequests(customerId));
    }

    public Request createRequest(Request request) {
        return fillRequestWithClientDetails(requestDAO.createRequest(request));
    }

    public void updateRequest(int requestId, Request request) {
        requestDAO.updateRequest(requestId, request);
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
        for (Request req: requests) {
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
}
