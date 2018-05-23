package com.ctm.web.email.health;

import io.swagger.annotations.ApiModel;
import lombok.EqualsAndHashCode;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

import java.util.List;

/**
 * Created by akhurana on 8/09/17.
 */
@Getter
@Setter
@EqualsAndHashCode
@ToString
@ApiModel(value = "HealthEmailModel", description = "Health specific data")
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
    private List<String> altPremiums;
    private List<String> altPremiumLabels;
    private List<String> popPremiums;
    private List<String> popPremiumLabels;
    private List<String> popProviders;
    private List<String> popProviderCodes;
    private String popProvider1HospitalPds;
    private String popProvider1ExtrasPds;
}

