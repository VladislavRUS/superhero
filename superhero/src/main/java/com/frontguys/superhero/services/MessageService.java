package com.frontguys.superhero.services;

import com.frontguys.superhero.dao.MessageDAO;
import com.frontguys.superhero.models.Message;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class MessageService {
    @Autowired
    private MessageDAO messageDAO;

    public void createMessage(int responseId, Message message) {
        messageDAO.createMessage(responseId, message);
    }

    public List<Message> getMessagesByResponseId(int responseId) {
        return messageDAO.getMessagesByResponseId(responseId);
    }
}
