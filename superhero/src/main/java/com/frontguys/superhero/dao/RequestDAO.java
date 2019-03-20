package com.frontguys.superhero.dao;

import com.frontguys.superhero.mappers.RequestRowMapper;
import com.frontguys.superhero.models.Request;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

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
            return (Request) jdbcTemplate.queryForObject(query, new Object[] { id }, requestRowMapper);
        } catch (Exception e) {
            return null;
        }
    }

    public List<Request> getCustomerRequests(int customerId) {
        String query = "select * from request where customer_id = ?";
        return jdbcTemplate.query(query, new Object[] { customerId }, requestRowMapper);
    }

    public void createRequest(Request request) {
        String query = "insert into request (customer_id, contractor_id, description, expiration_date, is_confirmed) values (?, ?, ?, ?, ?)";
        jdbcTemplate.update(query, request.getCustomerId(), null, request.getDescription(), request.getExpirationDate(), false);
    }

    public void updateRequest(int requestId, Request request) {
        String query = "update request set contractor_id = ?, description = ?, expiration_date = ?, is_confirmed = ?, response_count = ? where id = ?";
        jdbcTemplate.update(query, request.getContractorId(), request.getDescription(), request.getExpirationDate(), request.isConfirmed(), request.getResponseCount(), requestId);
    }
}
