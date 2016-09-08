package com.ctm.web.simples.model;

import com.fasterxml.jackson.annotation.JsonAutoDetect;
import com.fasterxml.jackson.annotation.JsonInclude;
import com.fasterxml.jackson.databind.annotation.JsonSerialize;

/**
 * Created by akhurana on 8/09/2016.
 */
@JsonAutoDetect(fieldVisibility= JsonAutoDetect.Visibility.ANY)
public class BSBResponse {

    private String bsbNumber;
    private String branchName;
    private String address;
    private String suburb;
    private String postCode;
    private String state;

    public BSBResponse(String bsbNumber, String branchName, String address, String suburb, String postCode, String state) {
        this.bsbNumber = bsbNumber;
        this.branchName = branchName;
        this.address = address;
        this.suburb = suburb;
        this.postCode = postCode;
        this.state = state;
    }
}
