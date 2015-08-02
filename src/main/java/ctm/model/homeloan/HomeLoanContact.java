package com.ctm.model.homeloan;

import com.ctm.web.validation.Name;

/**
 * Created by lbuchanan on 15/12/2014.
 */
public class HomeLoanContact {

    @Name
    public String firstName;
    @Name
    public String lastName;
}
