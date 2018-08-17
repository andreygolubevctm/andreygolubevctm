package com.ctm.web.health.apply.model.request.fundData.membership;

import com.ctm.web.health.apply.helper.TypeSerializer;
import com.fasterxml.jackson.databind.annotation.JsonSerialize;

public class PartnerDetails {

    @JsonSerialize(using = TypeSerializer.class)
    private RelationshipToPrimary relationshipToPrimary;

    private SameGroupMember sameGroupMember;

    private String partnerAuthorityLevel;

    public PartnerDetails(RelationshipToPrimary relationshipToPrimary, SameGroupMember sameGroupMember, String partnerAuthorityLevel) {
        this.relationshipToPrimary = relationshipToPrimary;
        this.sameGroupMember = sameGroupMember;
        this.partnerAuthorityLevel = partnerAuthorityLevel;
    }

    public RelationshipToPrimary getRelationshipToPrimary() {
        return relationshipToPrimary;
    }

    public SameGroupMember getSameGroupMember() {
        return sameGroupMember;
    }

    public String getPartnerAuthorityLevel() {
        return partnerAuthorityLevel;
    }

}
