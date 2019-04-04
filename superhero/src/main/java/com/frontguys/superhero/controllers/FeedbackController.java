package com.frontguys.superhero.controllers;

import com.frontguys.superhero.constants.ClientRoles;
import com.frontguys.superhero.models.Client;
import com.frontguys.superhero.models.Feedback;
import com.frontguys.superhero.models.Response;
import com.frontguys.superhero.services.ClientService;
import com.frontguys.superhero.services.FeedbackService;
import com.frontguys.superhero.services.ResponseService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletRequest;
import java.util.List;

@CrossOrigin(value = "*")
@RestController
public class FeedbackController {
    @Autowired
    FeedbackService feedbackService;
    @Autowired
    ClientService clientService;
    @Autowired
    ResponseService responseService;

    @RequestMapping(value = "/api/v1/auth/feedbacks", method = RequestMethod.POST)
    public ResponseEntity<Object> createRequest(@RequestBody Feedback feedback, HttpServletRequest httpServletRequest) {
        String token = httpServletRequest.getHeader("Authorization");
        Client client = clientService.getClientByToken(token);
        String role = client.getRole();

        if (!ClientRoles.CUSTOMER.equals(role)) {
            return new ResponseEntity<>("Only customers can create feedback", HttpStatus.FORBIDDEN);
        }

        feedback.setCustomerId(client.getId());

        List<Response> responsesByContractorId = responseService.getResponsesByContractorId(feedback.getContractorId());

        if (!responseService.customerAndContractorWorkedTogether(responsesByContractorId, client.getId(), feedback.getContractorId())) {
            return new ResponseEntity<>("You cannot create feedback for contractor you did not work with", HttpStatus.FORBIDDEN);
        }

        if (!feedbackService.isValidFeedback(feedback)) {
            return new ResponseEntity<>("Empty feedback or invalid value (min: 1, max: 5)", HttpStatus.BAD_REQUEST);
        }

        feedbackService.createFeedback(feedback);
        return new ResponseEntity<>(HttpStatus.CREATED);
    }

    @RequestMapping(value = "/api/v1/auth/feedbacks", method = RequestMethod.GET)
    public ResponseEntity<Object> createRequest(@RequestParam int contractorId) {
        List<Feedback> feedbacksByContractorId = feedbackService.getFeedbacksByContractorId(contractorId);
        return new ResponseEntity<>(feedbacksByContractorId, HttpStatus.OK);
    }
}
