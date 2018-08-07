package com.ctm.web.email;

import io.swagger.annotations.ApiModel;
import lombok.*;

@Getter
@Setter
@EqualsAndHashCode
@ToString
@ApiModel(value = "EmailEventRequest", description = "Email event specific data")
public class EmailEventRequest {

    //Common properties
    private EmailEventType eventType;
    private String emailAddress;
    private boolean establishContactKey;
    private String firstName;
    private String transactionId;
    private String providerName;
    private String providerCode;
    private String providerPhone;
    private String quoteRef;
    private String brand;
    private String coverType;
    private String premium;
    private String premiumFrequency;
    private String productDescription;
    private String verticalCode;

    //Common Health properties
    private String extrasPds;
    private String hospitalPds;

    //Health Application properties
    private String confirmationUrl;
    private String gaClientId;

    //Health PDS properties
    private String applyUrl;
    private String callCentreHours;
    private String lastName;
    private String optIn;
    private String phoneNumber;
    private String premiumLabel;
    private String source;
    private String uid;
}
