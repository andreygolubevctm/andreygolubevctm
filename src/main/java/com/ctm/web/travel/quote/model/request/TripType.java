package com.ctm.web.travel.quote.model.request;

import lombok.EqualsAndHashCode;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@EqualsAndHashCode
@ToString
public class TripType {
    private Boolean snowSports;
    private Boolean cruising;
    private Boolean adventureSports;
}
