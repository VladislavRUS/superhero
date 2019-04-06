package com.frontguys.superhero.services;

import com.frontguys.superhero.dao.MessageDAO;
import com.frontguys.superhero.dao.ResponseDAO;
import com.frontguys.superhero.models.Message;
import com.frontguys.superhero.models.Request;
import com.frontguys.superhero.models.Response;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

@Service
public class MessageService {
    @Autowired
    private MessageDAO messageDAO;
    @Autowired
    private ResponseDAO responseDAO;

    public void createMessage(int responseId, Message message) {
        messageDAO.createMessage(responseId, message);
    }

    public List<Message> getMessagesByResponseId(int responseId) {
        return messageDAO.getMessagesByResponseId(responseId);
    }

    public Message createMessageWithParams(String text, Map<String, String> params) {
        for (Map.Entry<String, String> entrySet : params.entrySet()) {
            text = text.replace("{" + entrySet.getKey() + "}", entrySet.getValue());
        }

        Message message = new Message();
        message.setText(text);
        return message;
    }

    public void createMessageByRequest(Message message, Request request) {
        List<Response> responsesByRequestId = responseDAO.getResponsesByRequestId(request.getId());
        for (Response response : responsesByRequestId) {
            if (response.getContractorId() == request.getContractorId() && response.getRequestId() == request.getId()) {
                createMessage(response.getId(), message);
            }
        }

    }
}
