package com.ctm.web.email.travel;

import lombok.EqualsAndHashCode;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

import java.time.LocalDate;
import java.util.List;

@Getter
@Setter
@EqualsAndHashCode
@ToString
public class TravelEmailModel {
    private String adultsTravelling;
    private String childrenTravelling;
    private LocalDate travelStartDate;
    private LocalDate travelEndDate;
    private String destination;
    private List<String> luggage;
    private List<String> cancellation;
    private List<String> medical;
    private List<Integer> travellerAge;
}
