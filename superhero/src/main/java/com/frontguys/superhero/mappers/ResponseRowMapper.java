package com.frontguys.superhero.mappers;

import com.frontguys.superhero.models.Response;
import org.springframework.jdbc.core.RowMapper;

import java.sql.ResultSet;
import java.sql.SQLException;

public class ResponseRowMapper implements RowMapper {
    @Override
    public Object mapRow(ResultSet resultSet, int i) throws SQLException {
        Response response = new Response();
        response.setId(resultSet.getInt("id"));
        response.setRequestId(resultSet.getInt("request_id"));
        response.setContractorId(resultSet.getInt("contractor_id"));
        response.setDate(resultSet.getDate("date"));
        response.setPayment(resultSet.getInt("payment"));
        response.setDate(resultSet.getDate("planned_date"));
        return response;
    }
}
