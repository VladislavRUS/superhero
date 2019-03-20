package com.frontguys.superhero.dao;

import com.frontguys.superhero.mappers.RequestRowMapper;
import com.frontguys.superhero.mappers.ResponseRowMapper;
import com.frontguys.superhero.models.Response;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public class ResponseDAO {
    @Autowired
    JdbcTemplate jdbcTemplate;
    private ResponseRowMapper responseRowMapper = new ResponseRowMapper();

    public void createResponse(Response response) {
        String query = "insert into response (request_id, contractor_id, date) values (?, ?, ?)";
        jdbcTemplate.update(query, response.getRequestId(), response.getContractorId(), response.getDate());
    }

    public Response getResponseById(int id) {
        String query = "select * from response where id = ?";
        return (Response) jdbcTemplate.queryForObject(query, new Object[] { id }, responseRowMapper);
    }

    public void deleteResponse(int id) {
        String query = "delete from response where id = ?";
        jdbcTemplate.update(query, id);
    }

    public List<Response> getResponsesByRequestId(int requestId) {
        String query = "select * from response where request_id = ?";
        return jdbcTemplate.query(query, new Object[] { requestId }, responseRowMapper);
    }
}
