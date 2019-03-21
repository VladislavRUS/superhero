package com.frontguys.superhero.models;

import com.fasterxml.jackson.annotation.JsonProperty;

public class ClientDetails {
    private int id;
    private String email;
    private String role;
    private String firstName;
    private String lastName;
    private String companyName;
    private String address;
    private String about;
    private boolean isLegalEntity;

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getRole() {
        return role;
    }

    public void setRole(String role) {
        this.role = role;
    }

    public String getFirstName() {
        return firstName;
    }

    public void setFirstName(String firstName) {
        this.firstName = firstName;
    }

    public String getLastName() {
        return lastName;
    }

    public void setLastName(String lastName) {
        this.lastName = lastName;
    }

    public String getCompanyName() {
        return companyName;
    }

    public void setCompanyName(String companyName) {
        this.companyName = companyName;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public String getAbout() {
        return about;
    }

    public void setAbout(String about) {
        this.about = about;
    }

    @JsonProperty(value="isLegalEntity")
    public boolean isLegalEntity() {
        return isLegalEntity;
    }

    public void setLegalEntity(boolean legalEntity) {
        isLegalEntity = legalEntity;
    }
}
