package com.frontguys.superhero.models;

import java.util.Date;

public class Response {
    private int id;
    private int requestId;
    private int contractorId;
    private Date date;
    private ClientDetails contractorDetails;
    private Request request;
    private int payment;
    private Date plannedDate;

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getRequestId() {
        return requestId;
    }

    public void setRequestId(int requestId) {
        this.requestId = requestId;
    }

    public int getContractorId() {
        return contractorId;
    }

    public void setContractorId(int contractorId) {
        this.contractorId = contractorId;
    }

    public Date getDate() {
        return date;
    }

    public void setDate(Date date) {
        this.date = date;
    }

    public Request getRequest() {
        return request;
    }

    public void setRequest(Request request) {
        this.request = request;
    }

    public int getPayment() {
        return payment;
    }

    public void setPayment(int payment) {
        this.payment = payment;
    }

    public Date getPlannedDate() {
        return plannedDate;
    }

    public void setPlannedDate(Date plannedDate) {
        this.plannedDate = plannedDate;
    }

    public ClientDetails getContractorDetails() {
        return contractorDetails;
    }

    public void setContractorDetails(ClientDetails contractorDetails) {
        this.contractorDetails = contractorDetails;
    }
}
