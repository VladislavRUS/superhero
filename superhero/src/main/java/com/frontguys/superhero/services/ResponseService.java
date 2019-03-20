package com.frontguys.superhero.services;

import com.frontguys.superhero.dao.RequestDAO;
import com.frontguys.superhero.dao.ResponseDAO;
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
        return responseDAO.getResponsesByRequestId(requestId);
    }

    public void deleteResponse(int id) {
        Response response = getResponseById(id);
        Request request = requestDAO.getRequestById(response.getRequestId());
        responseDAO.deleteResponse(id);
        request.setResponseCount(request.getResponseCount() - 1);
        requestDAO.updateRequest(request.getId(), request);
    }
}
