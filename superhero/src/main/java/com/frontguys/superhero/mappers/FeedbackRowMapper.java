package com.frontguys.superhero.mappers;

import com.frontguys.superhero.models.Feedback;
import org.springframework.jdbc.core.RowMapper;

import java.sql.ResultSet;
import java.sql.SQLException;

public class FeedbackRowMapper implements RowMapper<Feedback> {

    @Override
    public Feedback mapRow(ResultSet resultSet, int i) throws SQLException {
        Feedback feedback = new Feedback();

        feedback.setId(resultSet.getInt("id"));
        feedback.setCustomerId(resultSet.getInt("customer_id"));
        feedback.setContractorId(resultSet.getInt("contractor_id"));
        feedback.setValue(resultSet.getInt("value"));
        feedback.setComment(resultSet.getString("comment"));

        return feedback;
    }
}
