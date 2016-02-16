package com.ctm.web.core.model.request;

import com.ctm.web.core.model.formData.RequestImpl;

import static com.ctm.web.core.utils.PhoneNumberUtil.stripOffNonNumericChars;

public class ContactValidatorRequest extends RequestImpl {

    private String contact;

    public String getContact() {
        return contact;
    }

    public void setContact(String contact) {
        this.contact = stripOffNonNumericChars(contact);
    }

}
