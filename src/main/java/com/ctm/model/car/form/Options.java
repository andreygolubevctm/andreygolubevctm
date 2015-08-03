package com.ctm.model.car.form;

import static org.apache.commons.lang3.StringUtils.isBlank;

public class Options {

    private String commencementDate;

    private String commencementDateInputD;

    private String commencementDateInputM;

    private String commencementDateInputY;

    private String driverOption;

    public String getCommencementDate() {
        return commencementDate;
    }

    public void setCommencementDate(String commencementDate) {
        this.commencementDate = commencementDate;
    }

    public String getCommencementDateInputD() {
        return commencementDateInputD;
    }

    public void setCommencementDateInputD(String commencementDateInputD) {
        this.commencementDateInputD = commencementDateInputD;
    }

    public String getCommencementDateInputM() {
        return commencementDateInputM;
    }

    public void setCommencementDateInputM(String commencementDateInputM) {
        this.commencementDateInputM = commencementDateInputM;
    }

    public String getCommencementDateInputY() {
        return commencementDateInputY;
    }

    public void setCommencementDateInputY(String commencementDateInputY) {
        this.commencementDateInputY = commencementDateInputY;
    }

    public String getDriverOption() {
        // Driver Options needs a default value when it is hidden due to the youngest driver being under 21
        if (isBlank(driverOption)) {
            driverOption = "3";
        }
        return driverOption;
    }

    public void setDriverOption(String driverOption) {
        this.driverOption = driverOption;
    }
}
