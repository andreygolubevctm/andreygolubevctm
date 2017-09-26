package com.ctm.web.email;

import com.ctm.web.email.car.CarEmailModel;
import com.ctm.web.email.health.HealthEmailModel;
import com.fasterxml.jackson.databind.annotation.JsonDeserialize;
import com.fasterxml.jackson.databind.annotation.JsonSerialize;
import com.fasterxml.jackson.datatype.jsr310.deser.LocalDateDeserializer;
import com.fasterxml.jackson.datatype.jsr310.deser.LocalDateTimeDeserializer;
import com.fasterxml.jackson.datatype.jsr310.ser.LocalDateSerializer;
import com.fasterxml.jackson.datatype.jsr310.ser.LocalDateTimeSerializer;
import io.swagger.annotations.ApiModel;
import lombok.EqualsAndHashCode;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

/**
 * Created by akhurana on 8/09/17.
 */
@Getter
@Setter
@EqualsAndHashCode
@ToString
@ApiModel( value = "EmailRequest", description = "Email request object" )
public class EmailRequest {
    private String address;
    private List<String> applyUrls;
    private String brand;
    private String callCentreHours;
    private String callCentreHoursText;
    @JsonSerialize(using = LocalDateSerializer.class)
    @JsonDeserialize(using = LocalDateDeserializer.class)
    private LocalDate commencementDate;
    private List<String> productDescriptions;
    private String emailAddress;
    private OptIn optIn;
    private String firstName;
    private String gaClientID;
    private String lastName;
    private String partnersQuoted;
    private String phoneNumber;
    private String premiumFrequency;
    private List<String> premiumLabels;
    private List<String> premiums;
    private List<String> excesses;
    private String prospectID;
    private List<String> providers;
    private List<String> providerCodes;
    private List<String> providerPhoneNumbers;
    private List<String> providerSpecialOffers;
    private List<String> quoteRefs;
    private List<String> validDates;
    private String subscriberKey;
    private String transactionId;
    private String unsubscribeURL;
    private String vertical;

    private Optional<HealthEmailModel> healthEmailModel;
    private Optional<CarEmailModel> carEmailModel;
}
