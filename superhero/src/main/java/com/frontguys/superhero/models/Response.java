package com.frontguys.superhero.models;

import java.util.Date;

public class Response {
    private int id;
    private int requestId;
    private int contractorId;
    private Date date;
    private ContractorDetails contractorDetails;

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

    public ContractorDetails getContractorDetails() {
        return contractorDetails;
    }

    public void setContractorDetails(ContractorDetails contractorDetails) {
        this.contractorDetails = contractorDetails;
    }
}
