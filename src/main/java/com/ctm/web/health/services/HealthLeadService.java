package com.ctm.web.health.services;

import com.ctm.web.core.leadService.services.LeadService;
import com.ctm.web.core.web.go.Data;

import javax.servlet.http.HttpServletRequest;
import java.text.ParseException;
import java.text.SimpleDateFormat;

public class HealthLeadService extends LeadService {

    public HealthLeadService(HttpServletRequest request, Data data) {
        super(request, 4, data);
    }

    @Override
    protected void updatePayloadData() {
        // TODO: Get source from request environment
        leadData.setSource("secure");
        leadData.setRootId(Long.valueOf(data.getString("current/rootId")));
        leadData.setTransactionId(Long.valueOf(data.getString("current/transactionId")));
        leadData.setBrandCode(String.valueOf(data.getString("current/brandCode")));

        // TODO: Create enum and use based on completion of fields / current step
        leadData.setStatus("OPEN");

        leadData.setClientIpAddress(request.getRemoteAddr());

        // Name
        if(data.hasChild("health/application/primary/firstname")) {
            leadData.setFirstName(String.valueOf(data.getString("health/application/primary/firstname")));
            leadData.setLastName(String.valueOf(data.getString("health/application/primary/surname")));
        } else {
            leadData.setFirstName(String.valueOf(data.getString("health/contactDetails/name")));
        }

        // DOB
        String dobXPath = "health/application/primary/dob";
        if(data.hasChild(dobXPath) && !data.getString(dobXPath).isEmpty()) {
            SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");
            String dobString = String.valueOf(data.getString(dobXPath));
            try {
                leadData.setDateOfBirth(formatter.parse(dobString));
            } catch (ParseException e) {
                LOGGER.error("Could not parse primary applicant's DOB", e);
            }
        }

        // Contact Details
        leadData.setMobile(String.valueOf(data.getString("health/contactDetails/contactNumber/mobile")));
        leadData.setPhone(String.valueOf(data.getString("health/contactDetails/contactNumber/other")));
        leadData.setEmail(String.valueOf(data.getString("health/contactDetails/contactNumber/email")));

        // Location
        leadData.setState(String.valueOf(data.getString("health/situation/state")));
        leadData.setSuburb(String.valueOf(data.getString("health/situation/suburb")));
        leadData.setPostcode(String.valueOf(data.getString("health/situation/postcode")));
    }

}
