package com.frontguys.superhero.services;

import com.frontguys.superhero.dao.FeedbackDAO;
import com.frontguys.superhero.models.Feedback;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class FeedbackService {
    @Autowired
    private FeedbackDAO feedbackDAO;

    public void createFeedback(Feedback feedback) {
        feedbackDAO.createFeedback(feedback);
    }

    public boolean isValidFeedback(Feedback feedback) {
        Integer value = feedback.getValue();

        return feedback.getComment() != null && feedback.getCustomerId() != null && feedback.getContractorId() != null && value != null && value > 0 && value <= 5;
    }

    public List<Feedback> getFeedbacksByContractorId(int contractorId) {
        return feedbackDAO.getFeedbacksByContractorId(contractorId);
    }
}
