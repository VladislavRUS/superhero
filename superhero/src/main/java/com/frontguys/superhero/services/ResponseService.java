package com.frontguys.superhero.services;

import com.frontguys.superhero.dao.ClientDAO;
import com.frontguys.superhero.dao.RequestDAO;
import com.frontguys.superhero.dao.ResponseDAO;
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

    public Response createResponse(Response response) {
        Response newResponse = responseDAO.createResponse(response);
        Request request = requestDAO.getRequestById(response.getRequestId());
        request.setResponseCount(request.getResponseCount() + 1);
        requestDAO.setResponseCount(request.getId(), request.getResponseCount());

        return newResponse;
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
        List<Response> allResponses = responseDAO.getAllResponses();
        fillResponses(allResponses);
        return allResponses;
    }

    private void fillResponses(List<Response> responses) {
        for (Response response : responses) {
            Request request = requestDAO.getRequestById(response.getRequestId());
            request.setCustomerDetails(new ClientDetails(clientDAO.getClientById(request.getCustomerId())));
            if (request.getContractorId() != null) {
                request.setCustomerDetails(new ClientDetails(clientDAO.getClientById(request.getContractorId())));
            }
            response.setRequest(request);
            response.setContractorDetails(new ClientDetails(clientDAO.getClientById(response.getContractorId())));
        }
    }

    public boolean hasResponseWithContractorId(List<Response> responses, int contractorId) {
        boolean hasResponse = false;

        for (Response response : responses) {
            if (response.getContractorId() == contractorId) {
                hasResponse = true;
                break;
            }
        }

        return hasResponse;
    }

    public boolean customerAndContractorWorkedTogether(List<Response> responses, int customerId, int contractorId) {
        boolean workedTogether = false;

        for (Response response : responses) {
            if (response.getContractorId() == contractorId && response.getRequest().getCustomerId() == customerId) {
                workedTogether = true;
                break;
            }
        }

        return workedTogether;
    }
}
