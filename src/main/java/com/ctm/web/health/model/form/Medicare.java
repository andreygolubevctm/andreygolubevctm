package com.ctm.web.health.model.form;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class Medicare {

    private String cover;

    private String number;

    private Expiry expiry;

    private String firstName;

    private String middleName;

    private String surname;

    private int cardPosition;

    private String colour;
}
