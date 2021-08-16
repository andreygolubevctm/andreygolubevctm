package com.ctm.web.health.apply.model.request.payment.medicare;

import com.ctm.web.health.apply.helper.TypeSerializer;
import com.ctm.web.health.apply.model.request.application.applicant.healthCover.Cover;
import com.ctm.web.health.apply.model.request.application.common.FirstName;
import com.ctm.web.health.apply.model.request.application.common.LastName;
import com.ctm.web.health.apply.model.request.payment.common.Expiry;
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
    private final MiddleInitial middleInitial;

    @JsonSerialize(using = TypeSerializer.class)
    private final LastName lastName;

    @JsonSerialize(using = TypeSerializer.class)
    private final Position position;

    private final Expiry expiry;

    @JsonSerialize(using = TypeSerializer.class)
    private CardColour colour;


    public Medicare(final Cover cover, final MedicareNumber number, final FirstName firstName, final MiddleInitial middleInitial,
                    final LastName lastName, final Position position, final Expiry expiry, CardColour colour) {
        this.cover = cover;
        this.number = number;
        this.firstName = firstName;
        this.middleInitial = middleInitial;
        this.lastName = lastName;
        this.position = position;
        this.expiry = expiry;
        this.colour = colour;
    }

    public Cover getCover() {
        return cover;
    }

    public MedicareNumber getNumber() {
        return number;
    }

    public FirstName getFirstName() {
        return firstName;
    }

    public MiddleInitial getMiddleInitial() {
        return middleInitial;
    }

    public LastName getLastName() {
        return lastName;
    }

    public Position getPosition() {
        return position;
    }

    public Expiry getExpiry() {
        return expiry;
    }

    public CardColour getColour() { return colour; }
}
