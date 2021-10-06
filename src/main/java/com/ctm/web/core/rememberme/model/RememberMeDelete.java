package com.ctm.web.core.rememberme.model;

import lombok.AllArgsConstructor;
import lombok.Getter;

@Getter
@AllArgsConstructor
public class RememberMeDelete
{
    private Boolean success;
    private String journeyType;
}