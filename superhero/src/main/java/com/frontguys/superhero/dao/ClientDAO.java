package com.frontguys.superhero.dao;

import com.frontguys.superhero.mappers.ClientRowMapper;
import com.frontguys.superhero.models.Client;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

@Repository
public class ClientDAO {
    @Autowired
    JdbcTemplate jdbcTemplate;
    private ClientRowMapper clientRowMapper = new ClientRowMapper();

    public Client getClientByToken(String token) {
        String query = "select * from client where id = (select client_id from token where value = ?)";
        return (Client) jdbcTemplate.queryForObject(query, new Object[] { token }, clientRowMapper);
    }

    public Client getClientById(int id) {
        String query = "select * from client where id = ?";
        return (Client) jdbcTemplate.queryForObject(query, new Object[] { id }, clientRowMapper);
    }
}
