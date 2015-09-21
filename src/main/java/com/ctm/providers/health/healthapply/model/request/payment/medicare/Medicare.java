package com.ctm.providers.health.healthapply.model.request.payment.medicare;

import com.ctm.providers.health.healthapply.model.helper.TypeSerializer;
import com.ctm.providers.health.healthapply.model.request.application.applicant.healthCover.Cover;
import com.ctm.providers.health.healthapply.model.request.application.common.FirstName;
import com.ctm.providers.health.healthapply.model.request.application.common.LastName;
import com.ctm.providers.health.healthapply.model.request.payment.common.Expiry;
import com.fasterxml.jackson.databind.annotation.JsonSerialize;

public class Medicare {

    private final Cover cover;

    @JsonSerialize(using = TypeSerializer.class)
    private final MedicareNumber numberumber;

    @JsonSerialize(using = TypeSerializer.class)
    private final FirstName firstName;

    @JsonSerialize(using = TypeSerializer.class)
    private final LastName lastName;

    @JsonSerialize(using = TypeSerializer.class)
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
