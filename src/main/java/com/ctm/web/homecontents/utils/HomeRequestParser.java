package com.ctm.web.homecontents.utils;

import com.ctm.web.homecontents.model.HomeRequest;
import com.ctm.web.homecontents.model.PolicyHolder;
import com.ctm.web.core.web.go.Data;

/**
 * Created by voba on 18/06/2015.
 */
public class HomeRequestParser {
    public static HomeRequest parseRequest(Data data, String vertical) {
        HomeRequest request = new HomeRequest();

        PolicyHolder policyHolder = new PolicyHolder();
        policyHolder.firstName = data.getString(vertical.toLowerCase() + "/policyHolder/firstName");
        policyHolder.lastName = data.getString(vertical.toLowerCase() + "/policyHolder/lastName");
        policyHolder.jointFirstName = data.getString(vertical.toLowerCase() + "/policyHolder/jointFirstName");
        policyHolder.jointLastName = data.getString(vertical.toLowerCase() + "/policyHolder/jointLastName");

        request.setPolicyHolder(policyHolder);

        return request;
    }
}
