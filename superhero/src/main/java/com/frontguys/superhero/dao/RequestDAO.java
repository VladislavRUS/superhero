package com.frontguys.superhero.dao;

import com.frontguys.superhero.mappers.RequestRowMapper;
import com.frontguys.superhero.models.Request;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

import java.util.Date;
import java.util.List;

@Repository
public class RequestDAO {
    @Autowired
    JdbcTemplate jdbcTemplate;
    RequestRowMapper requestRowMapper = new RequestRowMapper();

    public List<Request> getAllRequests() {
        String query = "select * from request";
        return jdbcTemplate.query(query, requestRowMapper);
    }

    public Request getRequestById(int id) {
        String query = "select * from request where id = ?";
        try {
            return (Request) jdbcTemplate.queryForObject(query, new Object[]{id}, requestRowMapper);
        } catch (Exception e) {
            return null;
        }
    }

    public List<Request> getCustomerRequests(int customerId) {
        String query = "select * from request where customer_id = ?";
        return jdbcTemplate.query(query, new Object[]{customerId}, requestRowMapper);
    }

    public void createRequest(Request request) {
        String query = "insert into request (customer_id, contractor_id, title, description, budget, expiration_date, publish_date, is_confirmed, is_finished) values (?, ?, ?, ?, ?, ?, ?, ?, ?)";

        Date publishDate = new Date();

        jdbcTemplate.update(query, request.getCustomerId(), null, request.getTitle(), request.getDescription(), request.getBudget(), request.getExpirationDate(), publishDate, false, false);
    }

    public void updateRequest(int requestId, Request request) {
        String query = "update request set contractor_id = ?, description = ?, expiration_date = ?, budget = ?, response_count = ? where id = ?";
        jdbcTemplate.update(query, request.getContractorId(), request.getDescription(), request.getExpirationDate(), request.getBudget(), request.getResponseCount(), requestId);
    }

    public void confirmRequest(int requestId) {
        String query = "update request set is_confirmed = true where id = ?";
        jdbcTemplate.update(query, requestId);
    }

    public void finishRequest(int requestId) {
        String query = "update request set is_finished = true where id = ?";
        jdbcTemplate.update(query, requestId);
    }
}
