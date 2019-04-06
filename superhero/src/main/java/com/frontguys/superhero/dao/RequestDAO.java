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
            return (Request) jdbcTemplate.queryForObject(query, new Object[]{id}, requestRowMapper);
        } catch (Exception e) {
            return null;
        }
    }

    public List<Request> getCustomerRequests(int customerId) {
        String query = "select * from request where customer_id = ?";
        return jdbcTemplate.query(query, new Object[]{customerId}, requestRowMapper);
    }

    public void confirmRequest(int requestId) {
        String query = "update request set is_confirmed = true where id = ?";
        jdbcTemplate.update(query, requestId);
    }

    public void finishRequest(int requestId) {
        String query = "update request set is_finished = true where id = ?";
        jdbcTemplate.update(query, requestId);
    }

    public void setResponseCount(int requestId, int responseCount) {
        String query = "update request set response_count = ? where id = ?";
        jdbcTemplate.update(query, responseCount, requestId);
    }

    public void assignRequest(int requestId, int contractorId) {
        String query = "update request set contractor_id = ? where id = ?";
        jdbcTemplate.update(query, contractorId, requestId);
    }

    public void finishContractorRequest(int requestId) {
        String query = "update request set is_finished_by_contractor = true where id = ?";
        jdbcTemplate.update(query, requestId);
    }

    public void finishCustomerRequest(int requestId) {
        String query = "update request set is_finished_by_customer = true where id = ?";
        jdbcTemplate.update(query, requestId);
    }
}
