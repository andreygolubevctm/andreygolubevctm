package com.ctm.services.homeloan;

import com.ctm.model.homeloan.HomeLoanContact;
import com.ctm.model.homeloan.HomeLoanModel;

import javax.servlet.http.HttpServletRequest;

public class HomeLoanFormParser {

    public static HomeLoanContact parseNames(HttpServletRequest request) {
        HomeLoanContact contact = new HomeLoanContact();
        parseContact(request,  contact, "homeloan_");
        parseContact(request,  contact, "homeloan_enquiry_");
        return contact;
    }

    private static void parseContact(HttpServletRequest request, HomeLoanContact contact, String prefix) {
        prefix = prefix  + "contact_";
        String value = request.getParameter(prefix + "firstName");
        if (value != null && !value.isEmpty()) {
            contact.firstName = value;
        }
        value = request.getParameter(prefix + "lastName");
        if (value != null && !value.isEmpty()) {
            contact.lastName = value;
        }
    }
}
