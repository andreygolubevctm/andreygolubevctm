package com.ctm.model.request.utilities;


import javax.validation.Valid;

/**
 * Created by voba on 15/06/2015.
 */
public class UtilitiesRequest {
    @Valid
    public Application application;

    @Valid
    public Details resultsDisplayed;
}
