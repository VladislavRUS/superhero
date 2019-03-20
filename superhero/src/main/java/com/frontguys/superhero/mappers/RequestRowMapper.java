package com.frontguys.superhero.mappers;

import com.frontguys.superhero.models.Request;
import org.springframework.jdbc.core.RowMapper;

import java.sql.ResultSet;
import java.sql.SQLException;

public class RequestRowMapper implements RowMapper {
    @Override
    public Object mapRow(ResultSet resultSet, int i) throws SQLException {
        Request request = new Request();
        request.setId(resultSet.getInt("id"));
        request.setCustomerId(resultSet.getInt("customer_id"));

        if (resultSet.getObject("contractor_id") != null) {
            request.setContractorId(resultSet.getInt("contractor_id"));
        } else {
            request.setContractorId(null);
        }

        request.setExpirationDate(resultSet.getDate("expiration_date"));
        request.setDescription(resultSet.getString("description"));
        request.setConfirmed(resultSet.getBoolean("is_confirmed"));
        request.setResponseCount(resultSet.getInt("response_count"));

        return request;
    }
}
