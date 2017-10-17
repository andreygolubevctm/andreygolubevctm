package com.ctm.web.email.health;

import com.fasterxml.jackson.annotation.JsonIgnore;
import io.swagger.annotations.ApiModel;
/**
 * Created by akhurana on 8/09/17.
 */

import lombok.EqualsAndHashCode;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

/**
 * Created by akhurana on 8/09/17.
 */
@Getter
@Setter
@EqualsAndHashCode
@ToString
@ApiModel( value = "HealthEmailModel", description = "Health specific data" )
public class HealthEmailModel {
    private String benefitCodes;
    private String currentCover;
    private String numberOfChildren;
    private String provider1Copayment;
    private String provider1ExcessPerAdmission;
    private String provider1ExcessPerPolicy;
    private String provider1ExtrasPds;
    private String provider1HospitalPds;
    private String situationType;
}

