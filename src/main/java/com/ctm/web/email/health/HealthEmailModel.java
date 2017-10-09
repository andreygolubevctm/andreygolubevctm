package com.ctm.web.email.health;

import com.fasterxml.jackson.annotation.JsonIgnore;
import io.swagger.annotations.ApiModel;
/**
 * Created by akhurana on 8/09/17.
 */
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

    public String getBenefitCodes() {
        return benefitCodes;
    }

    public void setBenefitCodes(String benefitCodes) {
        this.benefitCodes = benefitCodes;
    }

    public String getCurrentCover() {
        return currentCover;
    }

    public void setCurrentCover(String currentCover) {
        this.currentCover = currentCover;
    }

    public String getNumberOfChildren() {
        return numberOfChildren;
    }

    public void setNumberOfChildren(String numberOfChildren) {
        this.numberOfChildren = numberOfChildren;
    }

    public String getProvider1Copayment() {
        return provider1Copayment;
    }

    public void setProvider1Copayment(String provider1Copayment) {
        this.provider1Copayment = provider1Copayment;
    }

    public String getProvider1ExcessPerAdmission() {
        return provider1ExcessPerAdmission;
    }

    public void setProvider1ExcessPerAdmission(String provider1ExcessPerAdmission) {
        this.provider1ExcessPerAdmission = provider1ExcessPerAdmission;
    }

    public String getProvider1ExcessPerPolicy() {
        return provider1ExcessPerPolicy;
    }

    public void setProvider1ExcessPerPolicy(String provider1ExcessPerPolicy) {
        this.provider1ExcessPerPolicy = provider1ExcessPerPolicy;
    }

    public String getProvider1ExtrasPds() {
        return provider1ExtrasPds;
    }

    public void setProvider1ExtrasPds(String provider1ExtrasPds) {
        this.provider1ExtrasPds = provider1ExtrasPds;
    }

    public String getProvider1HospitalPds() {
        return provider1HospitalPds;
    }

    public void setProvider1HospitalPds(String provider1HospitalPds) {
        this.provider1HospitalPds = provider1HospitalPds;
    }

    public String getSituationType() {
        return situationType;
    }

    public void setSituationType(String situationType) {
        this.situationType = situationType;
    }

}
