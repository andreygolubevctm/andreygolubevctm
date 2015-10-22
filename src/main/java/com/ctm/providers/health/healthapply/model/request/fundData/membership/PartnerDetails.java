package com.ctm.providers.health.healthapply.model.request.fundData.membership;

import com.ctm.providers.health.healthapply.model.helper.TypeSerializer;
import com.fasterxml.jackson.databind.annotation.JsonSerialize;

public class PartnerDetails {

    @JsonSerialize(using = TypeSerializer.class)
    private RelationshipToPrimary relationshipToPrimary;

    private SameGroupMember sameGroupMember;

    public PartnerDetails(RelationshipToPrimary relationshipToPrimary, SameGroupMember sameGroupMember) {
        this.relationshipToPrimary = relationshipToPrimary;
        this.sameGroupMember = sameGroupMember;
    }

    public RelationshipToPrimary getRelationshipToPrimary() {
        return relationshipToPrimary;
    }

    public SameGroupMember getSameGroupMember() {
        return sameGroupMember;
    }
}
