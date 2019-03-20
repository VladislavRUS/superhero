package com.frontguys.superhero.dao;

import com.frontguys.superhero.mappers.TokenRowMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

@Repository
public class TokenDAO {
    @Autowired
    JdbcTemplate jdbcTemplate;
    private TokenRowMapper tokenRowMapper = new TokenRowMapper();

    public boolean validateToken(String token) {
        String query = "select * from token where value = ?";
        try {
            jdbcTemplate.queryForObject(query, new Object[] { token }, tokenRowMapper);
            return true;
        } catch (Exception e) {
            return false;
        }
    }
}
