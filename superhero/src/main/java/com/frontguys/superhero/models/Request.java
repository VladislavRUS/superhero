package com.frontguys.superhero.models;

import com.fasterxml.jackson.annotation.JsonProperty;

import java.util.Date;

public class Request {
    private int id;
    private Integer customerId;
    private ClientDetails customerDetails;
    private Integer contractorId;
    private ClientDetails contractorDetails;
    private String type;
    private String address;
    private Date expirationDate;
    private Date publishDate;
    private boolean isFinishedByCustomer;
    private boolean isFinishedByContractor;
    private boolean isApproved;
    private int responseCount;

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public Integer getCustomerId() {
        return customerId;
    }

    public void setCustomerId(Integer customerId) {
        this.customerId = customerId;
    }

    public ClientDetails getCustomerDetails() {
        return customerDetails;
    }

    public void setCustomerDetails(ClientDetails customerDetails) {
        this.customerDetails = customerDetails;
    }

    public Integer getContractorId() {
        return contractorId;
    }

    public void setContractorId(Integer contractorId) {
        this.contractorId = contractorId;
    }

    public ClientDetails getContractorDetails() {
        return contractorDetails;
    }

    public void setContractorDetails(ClientDetails contractorDetails) {
        this.contractorDetails = contractorDetails;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public Date getExpirationDate() {
        return expirationDate;
    }

    public void setExpirationDate(Date expirationDate) {
        this.expirationDate = expirationDate;
    }

    public Date getPublishDate() {
        return publishDate;
    }

    public void setPublishDate(Date publishDate) {
        this.publishDate = publishDate;
    }

    @JsonProperty(value = "isFinishedByCustomer")
    public boolean isFinishedByCustomer() {
        return isFinishedByCustomer;
    }

    public void setFinishedByCustomer(boolean finishedByCustomer) {
        isFinishedByCustomer = finishedByCustomer;
    }

    @JsonProperty(value = "isFinishedByContractor")
    public boolean isFinishedByContractor() {
        return isFinishedByContractor;
    }

    public void setFinishedByContractor(boolean finishedByContractor) {
        isFinishedByContractor = finishedByContractor;
    }

    @JsonProperty(value = "isApproved")
    public boolean isApproved() {
        return isApproved;
    }

    public void setApproved(boolean approved) {
        isApproved = approved;
    }

    public int getResponseCount() {
        return responseCount;
    }

    public void setResponseCount(int responseCount) {
        this.responseCount = responseCount;
    }
}
