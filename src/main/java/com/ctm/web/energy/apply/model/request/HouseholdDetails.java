package com.ctm.web.energy.apply.model.request;

import com.ctm.web.core.model.formData.YesNo;

/**
 * Created by dkocovski on 14/12/2015.
 */
public class HouseholdDetails {
    private YesNo movingIn;

    public YesNo getMovingIn() {
        return movingIn;
    }

    public void setMovingIn(YesNo movingIn) {
        this.movingIn = movingIn;
    }
}
