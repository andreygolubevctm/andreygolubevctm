package com.ctm.web.core.rememberme.model;

import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@NoArgsConstructor
@AllArgsConstructor
@Getter
@Setter
@ToString
public class RememberMeCookie
{
    private String  transactionId;
    private String  createdTime;
    private String  journeyType;
}