package com.ctm.providers.health.healthapply.model.request.payment.medicare;

import com.ctm.providers.health.healthapply.model.request.application.applicant.healthCover.Cover;
import com.ctm.providers.health.healthapply.model.request.application.common.FirstName;
import com.ctm.providers.health.healthapply.model.request.application.common.LastName;
import com.ctm.providers.health.healthapply.model.request.payment.common.Expiry;

public class Medicare {

    private final Cover cover;

    private final MedicareNumber numberumber;

    private final FirstName firstName;

    private final LastName lastName;

    private final Position position;

    private final Expiry expiry;


    public Medicare(final Cover cover, final MedicareNumber numberumber, final FirstName firstName,
                    final LastName lastName, final Position position, final Expiry expiry) {
        this.cover = cover;
        this.numberumber = numberumber;
        this.firstName = firstName;
        this.lastName = lastName;
        this.position = position;
        this.expiry = expiry;
    }
}
