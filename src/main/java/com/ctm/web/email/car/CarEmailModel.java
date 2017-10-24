package com.ctm.web.email.car;

import lombok.EqualsAndHashCode;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

/**
 * Created by akhurana on 25/09/17.
 */
@Getter
@Setter
@EqualsAndHashCode
@ToString
public class CarEmailModel {
    private String coverType;
    private String vehicleMake;
    private String vehicleModel;
    private String vehicleVariant;
    private String vehicleYear;
}

