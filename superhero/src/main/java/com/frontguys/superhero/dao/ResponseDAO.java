package com.frontguys.superhero.dao;

import com.frontguys.superhero.mappers.ResponseRowMapper;
import com.frontguys.superhero.models.Response;
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
public class ResponseDAO {
    @Autowired
    JdbcTemplate jdbcTemplate;
    private ResponseRowMapper responseRowMapper = new ResponseRowMapper();

//    public void createResponse(Response response) {
//        String query = "insert into response (request_id, contractor_id, date) values (?, ?, ?)";
//        jdbcTemplate.update(query, response.getRequestId(), response.getContractorId(), response.getDate());
//    }

    public Response createResponse(Response response) {
        String query = "insert into response (request_id, contractor_id, date) values (?, ?, ?)";

        java.sql.Date date = new java.sql.Date(new Date().getTime());

        KeyHolder keyHolder = new GeneratedKeyHolder();

        final PreparedStatementCreator psc = connection -> {
            final PreparedStatement ps = connection.prepareStatement(query,
                    Statement.RETURN_GENERATED_KEYS);
            ps.setInt(1, response.getRequestId());
            ps.setInt(2, response.getContractorId());
            ps.setDate(3, date);
            return ps;
        };

        jdbcTemplate.update(psc, keyHolder);

        for (Map.Entry<String, Object> stringObjectEntry : keyHolder.getKeys().entrySet()) {
            if (stringObjectEntry.getKey().equals("id")) {
                return getResponseById(Integer.valueOf(stringObjectEntry.getValue().toString()));
            }
        }

        return null;
    }

    public Response getResponseById(int id) {
        String query = "select * from response where id = ?";
        try {
            return (Response) jdbcTemplate.queryForObject(query, new Object[]{id}, responseRowMapper);
        } catch (Exception exception) {
            return null;
        }
    }

    public List<Response> getResponsesByRequestId(int requestId) {
        String query = "select * from response where request_id = ?";
        return jdbcTemplate.query(query, new Object[]{requestId}, responseRowMapper);
    }

    public List<Response> getResponsesByCustomerId(int customerId) {
        String query = "select * from response where request_id in (select id from request where customer_id = ?)";
        return jdbcTemplate.query(query, new Object[]{customerId}, responseRowMapper);
    }

    public List<Response> getResponsesByContractorId(int contractorId) {
        String query = "select * from response where contractor_id = ?";
        return jdbcTemplate.query(query, new Object[]{contractorId}, responseRowMapper);
    }

    public List<Response> getAllResponses() {
        String query = "select * from response";
        return jdbcTemplate.query(query, responseRowMapper);
    }
}
