package com.frontguys.superhero.dao;

import com.frontguys.superhero.mappers.ClientRowMapper;
import com.frontguys.superhero.models.Client;
import org.apache.commons.codec.digest.DigestUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

@Repository
public class AuthDAO {
    @Autowired
    JdbcTemplate jdbcTemplate;
    private ClientRowMapper clientRowMapper = new ClientRowMapper();

    public Client findClientByEmail(Client client) {
        String email = client.getEmail();

        String query = "select * from client where email = ?";

        try {
            return (Client)jdbcTemplate.queryForObject(query, new Object[] { email }, clientRowMapper);
        } catch (Exception exception) {
            return null;
        }
    }

    public Client findClientByCredentials(Client client) {
        String email = client.getEmail();
        String password = DigestUtils.sha256Hex(client.getPassword());

        String query = "select * from client where email = ? and password = ?";

        try {
            return (Client)jdbcTemplate.queryForObject(query, new Object[] { email, password }, clientRowMapper);
        } catch (Exception exception) {
            return null;
        }
    }

    public void register(Client client) {
        String query = "insert into client (email, password, role, is_legal_entity, first_name, last_name, company_name, address, about) values (?, ?, ?, ?, ?, ?, ?, ?, ?)";

        String email = client.getEmail();
        String password = DigestUtils.sha256Hex(client.getPassword());
        String role = client.getRole();
        boolean legalEntity = client.isLegalEntity();
        String firstName = client.getFirstName();
        String lastName = client.getLastName();
        String companyName = client.getCompanyName();
        String address = client.getAddress();
        String about = client.getAbout();

        jdbcTemplate.update(query, email, password, role, legalEntity, firstName, lastName, companyName, address, about);
    }

    public void saveToken(String token, int clientId) {
        String query = "insert into token (value, client_id) values (?, ?)";
        jdbcTemplate.update(query, token, clientId);
    }
}
