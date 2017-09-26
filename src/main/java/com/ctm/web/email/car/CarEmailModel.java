package com.ctm.automation.client.model.car;

import lombok.EqualsAndHashCode;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

/**
 * Created by akhurana on 25/09/17.
 */
@Getter
@Setter
@EqualsAndHashCode
@ToString
public class CarEmailModel {
    private String coverType;
    private String journeyStatus;
}
