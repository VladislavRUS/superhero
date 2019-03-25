package com.frontguys.superhero.services;

import com.frontguys.superhero.dao.ClientDAO;
import com.frontguys.superhero.dao.RequestDAO;
import com.frontguys.superhero.dao.ResponseDAO;
import com.frontguys.superhero.models.Client;
import com.frontguys.superhero.models.ClientDetails;
import com.frontguys.superhero.models.Request;
import com.frontguys.superhero.models.Response;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class ResponseService {
    @Autowired
    ResponseDAO responseDAO;
    @Autowired
    RequestDAO requestDAO;
    @Autowired
    ClientDAO clientDAO;

    public void createResponse(Response response) {
        responseDAO.createResponse(response);
        Request request = requestDAO.getRequestById(response.getRequestId());
        request.setResponseCount(request.getResponseCount() + 1);
        requestDAO.updateRequest(request.getId(), request);
    }

    public Response getResponseById(int responseId) {
        return responseDAO.getResponseById(responseId);
    }

    public List<Response> getResponsesByRequestId(int requestId) {
        List<Response> responsesByRequestId = responseDAO.getResponsesByRequestId(requestId);
        fillResponses(responsesByRequestId);
        return responsesByRequestId;
    }

    public List<Response> getResponsesByCustomerId(int customerId) {
        List<Response> responsesByCustomerId = responseDAO.getResponsesByCustomerId(customerId);
        fillResponses(responsesByCustomerId);

        return responsesByCustomerId;
    }

    public List<Response> getResponsesByContractorId(int contractorId) {
        List<Response> responsesByContractorId = responseDAO.getResponsesByContractorId(contractorId);
        fillResponses(responsesByContractorId);

        return responsesByContractorId;
    }

    public List<Response> getAllResponses() {
        return responseDAO.getAllResponses();
    }

    private void fillResponses(List<Response> responses) {
        for (Response response : responses) {
            Client contractor = clientDAO.getClientById(response.getContractorId());
            ClientDetails contractorDetails = new ClientDetails(contractor);
            response.setContractorDetails(contractorDetails);

            Request request = requestDAO.getRequestById(response.getRequestId());
            response.setRequest(request);

            Client customer = clientDAO.getClientById(request.getCustomerId());
            ClientDetails customerDetails = new ClientDetails(customer);
            response.setCustomerDetails(customerDetails);
        }
    }

    public void deleteResponse(int id) {
        Response response = getResponseById(id);
        Request request = requestDAO.getRequestById(response.getRequestId());
        responseDAO.deleteResponse(id);
        request.setResponseCount(request.getResponseCount() - 1);
        requestDAO.updateRequest(request.getId(), request);
    }
}
