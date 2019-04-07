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
        request.setContractorId((Integer) resultSet.getObject("contractor_id"));
        request.setType(resultSet.getString("type"));
        request.setAddress(resultSet.getString("address"));
        request.setExpirationDate(resultSet.getDate("expiration_date"));
        request.setPublishDate(resultSet.getDate("publish_date"));
        request.setFinishedByContractor(resultSet.getBoolean("is_finished_by_contractor"));
        request.setFinishedByCustomer(resultSet.getBoolean("is_finished_by_customer"));
        request.setApproved(resultSet.getBoolean("is_approved"));
        request.setResponseCount(resultSet.getInt("response_count"));
        request.setPayed(resultSet.getBoolean("is_payed"));

        return request;
    }
}
