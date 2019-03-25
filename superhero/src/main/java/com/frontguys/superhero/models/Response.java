package com.frontguys.superhero.models;

import java.util.Date;

public class Response {
    private int id;
    private int requestId;
    private int contractorId;
    private Date date;
    private ClientDetails contractorDetails;
    private ClientDetails customerDetails;
    private Request request;

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

    public ClientDetails getContractorDetails() {
        return contractorDetails;
    }

    public void setContractorDetails(ClientDetails contractorDetails) {
        this.contractorDetails = contractorDetails;
    }

    public ClientDetails getCustomerDetails() {
        return customerDetails;
    }

    public void setCustomerDetails(ClientDetails customerDetails) {
        this.customerDetails = customerDetails;
    }

    public Request getRequest() {
        return request;
    }

    public void setRequest(Request request) {
        this.request = request;
    }
}
