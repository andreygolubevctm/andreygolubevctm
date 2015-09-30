package com.ctm.providers.health.healthapply.model.request.payment.medicare;

import com.ctm.providers.health.healthapply.model.helper.TypeSerializer;
import com.ctm.providers.health.healthapply.model.request.application.applicant.healthCover.Cover;
import com.ctm.providers.health.healthapply.model.request.application.common.FirstName;
import com.ctm.providers.health.healthapply.model.request.application.common.LastName;
import com.ctm.providers.health.healthapply.model.request.payment.common.Expiry;
import com.fasterxml.jackson.annotation.JsonInclude;
import com.fasterxml.jackson.databind.annotation.JsonSerialize;

import static com.fasterxml.jackson.annotation.JsonInclude.Include.NON_EMPTY;

@JsonInclude(NON_EMPTY)
public class Medicare {

    private final Cover cover;

    @JsonSerialize(using = TypeSerializer.class)
    private final MedicareNumber number;

    @JsonSerialize(using = TypeSerializer.class)
    private final FirstName firstName;

    @JsonSerialize(using = TypeSerializer.class)
    private final LastName lastName;

    @JsonSerialize(using = TypeSerializer.class)
    private final Position position;

    private final Expiry expiry;


    public Medicare(final Cover cover, final MedicareNumber numberumber, final FirstName firstName, final MiddleInitial middleInitial,
                    final LastName lastName, final Position position, final Expiry expiry) {
        this.cover = cover;
        this.number = number;
        this.firstName = firstName;
        this.middleInitial = middleInitial;
        this.lastName = lastName;
        this.position = position;
        this.expiry = expiry;
    }
}
