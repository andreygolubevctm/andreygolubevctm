package com.ctm.web.life.apply.model.request;

import com.ctm.energyapply.model.request.application.address.AddressDetails;
import com.ctm.web.core.web.go.Data;


public class LifeQuoteRequest {

    private Partner partner;
    private Primary primary;

    public LifeQuoteRequest(Data data){
        String firstName = data.getString("life_partner_firstName");
        String gender = data.getString("life_partner_gender");
        String dob = data.getString("life_partner_dob");
        String age = data.getString("life_partner_age");
        String smoker = data.getString("life_partner_smoker");
        String occupation= data.getString("life_partner_occupation");
        String hannover = data.getString("life_partner_hannover");
        String occupationTitle = data.getString("life_partner_occupationTitle");
        partner = new Partner(data.get("life_partner_gender"));
    }

    public Partner getPartner() {
        return partner;
    }

    public Primary getPrimary() {
        return primary;
    }
}
