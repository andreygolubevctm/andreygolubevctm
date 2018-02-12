package com.ctm.web.email;

import com.ctm.web.email.car.CarEmailModel;
import com.ctm.web.email.health.HealthEmailModel;
import com.ctm.web.email.travel.TravelEmailModel;
import com.fasterxml.jackson.databind.annotation.JsonDeserialize;
import com.fasterxml.jackson.databind.annotation.JsonSerialize;
import com.fasterxml.jackson.datatype.jsr310.deser.LocalDateDeserializer;
import com.fasterxml.jackson.datatype.jsr310.ser.LocalDateSerializer;
import io.swagger.annotations.ApiModel;
import lombok.EqualsAndHashCode;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;

/**
 * Created by akhurana on 8/09/17.
 */
@Getter
@Setter
@EqualsAndHashCode
@ToString
@ApiModel(value = "EmailRequest", description = "Email request object")
public class EmailRequest {
    private String address;
    private List<String> applyUrls;
    private String brand;
    private String callCentreHours;
    private String callCentreHoursText;
    @JsonSerialize(using = LocalDateSerializer.class)
    @JsonDeserialize(using = LocalDateDeserializer.class)
    private LocalDate commencementDate;
    private List<String> coverTypes;
    private List<String> productDescriptions;
    private String emailAddress;
    private OptIn optIn;
    private String firstName;
    private String gaClientID;
    private String lastName;
    private Integer partnersQuoted;
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
    private boolean isPopularProductsSelected;
    List<Boolean> popularProducts;
    private List<BigDecimal> premiumDiscountPercentage;

    private HealthEmailModel healthEmailModel;
    private CarEmailModel carEmailModel;
    private TravelEmailModel travelEmailModel;
}
