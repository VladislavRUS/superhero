package com.frontguys.superhero.dao;

import com.frontguys.superhero.mappers.FeedbackRowMapper;
import com.frontguys.superhero.models.Feedback;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public class FeedbackDAO {
    @Autowired
    JdbcTemplate jdbcTemplate;
    FeedbackRowMapper feedbackRowMapper = new FeedbackRowMapper();

    public void createFeedback(Feedback feedback) {
        String query = "insert into feedback (customer_id, contractor_id, value, comment) values (?, ?, ?, ?)";

        jdbcTemplate.update(query, feedback.getCustomerId(), feedback.getContractorId(), feedback.getValue(), feedback.getComment());
    }

    public List<Feedback> getFeedbacksByContractorId(int contractorId) {
        String query = "select * from feedback where contractor_id = ?";
        return jdbcTemplate.query(query, new Object[]{contractorId}, feedbackRowMapper);
    }
}
