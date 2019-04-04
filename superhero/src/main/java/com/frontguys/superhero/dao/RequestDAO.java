package com.frontguys.superhero.dao;

import com.frontguys.superhero.mappers.RequestRowMapper;
import com.frontguys.superhero.models.Request;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.PreparedStatementCreator;
import org.springframework.jdbc.support.GeneratedKeyHolder;
import org.springframework.jdbc.support.KeyHolder;
import org.springframework.stereotype.Repository;

import java.sql.PreparedStatement;
import java.sql.Statement;
import java.util.Date;
import java.util.List;
import java.util.Map;

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

    public Request createRequest(Request request) {
        String query = "insert into request (customer_id, contractor_id, title, description, budget, expiration_date, publish_date, is_confirmed, is_finished) values (?, ?, ?, ?, ?, ?, ?, ?, ?)";

        java.sql.Date publishDate = new java.sql.Date(new Date().getTime());

        KeyHolder keyHolder = new GeneratedKeyHolder();

        final PreparedStatementCreator psc = connection -> {
            final PreparedStatement ps = connection.prepareStatement(query,
                    Statement.RETURN_GENERATED_KEYS);
            ps.setInt(1, request.getCustomerId());
            ps.setObject(2, null);
            ps.setString(3, request.getTitle());
            ps.setString(4, request.getDescription());
            ps.setInt(5, request.getBudget());
            ps.setDate(6, request.getExpirationDate() == null ? null : new java.sql.Date(request.getExpirationDate().getTime()));
            ps.setDate(7, publishDate);
            ps.setBoolean(8, false);
            ps.setBoolean(9, false);
            return ps;
        };

        jdbcTemplate.update(psc, keyHolder);

        for (Map.Entry<String, Object> stringObjectEntry : keyHolder.getKeys().entrySet()) {
            if (stringObjectEntry.getKey().equals("id")) {
                return getRequestById(Integer.valueOf(stringObjectEntry.getValue().toString()));
            }
        }

        return null;
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
