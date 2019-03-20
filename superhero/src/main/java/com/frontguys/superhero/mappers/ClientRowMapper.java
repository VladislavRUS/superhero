package com.frontguys.superhero.mappers;

import com.frontguys.superhero.models.Client;
import org.springframework.jdbc.core.RowMapper;

import java.sql.ResultSet;
import java.sql.SQLException;

public class ClientRowMapper implements RowMapper {

    @Override
    public Object mapRow(ResultSet resultSet, int i) throws SQLException {
        Client client = new Client();
        client.setId(resultSet.getInt("id"));
        client.setEmail(resultSet.getString("email"));
        client.setPassword(resultSet.getString("password"));
        client.setRole(resultSet.getString("role"));
        client.setName(resultSet.getString("name"));
        client.setInformation(resultSet.getString("information"));

        return client;
    }
}
