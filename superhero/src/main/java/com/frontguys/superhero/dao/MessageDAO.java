package com.frontguys.superhero.dao;

import com.frontguys.superhero.mappers.MessageRowMapper;
import com.frontguys.superhero.models.Message;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

import java.sql.Timestamp;
import java.util.List;

@Repository
public class MessageDAO {
    @Autowired
    JdbcTemplate jdbcTemplate;
    private MessageRowMapper messageRowMapper = new MessageRowMapper();

    public void createMessage(int responseId, Message message) {
        String query = "insert into message (response_id, sender_id, text, timestamp) values (?, ?, ?, ?)";
        Timestamp timestamp = new Timestamp(System.currentTimeMillis());

        jdbcTemplate.update(query, responseId, message.getSenderId(), message.getText(), String.valueOf(timestamp.getTime()));
    }

    public List<Message> getMessagesByResponseId(int requestId) {
        String query = "select * from message where response_id = ?";
        return jdbcTemplate.query(query, new Object[]{requestId}, messageRowMapper);
    }

    public List<Message> getMessagesByContractorId(int contractorId) {
        String query = "select * from message where contractor_id = ?";
        return jdbcTemplate.query(query, new Object[]{contractorId}, messageRowMapper);
    }
}
