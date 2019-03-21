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
        client.setLegalEntity(resultSet.getBoolean("is_legal_entity"));
        client.setFirstName(resultSet.getString("first_name"));
        client.setLastName(resultSet.getString("last_name"));
        client.setCompanyName(resultSet.getString("company_name"));
        client.setAddress(resultSet.getString("address"));
        client.setAbout(resultSet.getString("about"));

        return client;
    }
}
