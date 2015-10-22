package com.ctm.providers.health.healthapply.model.request.fundData.membership;

import com.ctm.providers.health.healthapply.model.helper.TypeSerializer;
import com.fasterxml.jackson.databind.annotation.JsonSerialize;

public class Membership {

    private RegisteredMember registeredMember;

    private CurrentMember currentMember;

    @JsonSerialize(using = TypeSerializer.class)
    private MembershipNumber membershipNumber;

    @JsonSerialize(using = TypeSerializer.class)
    private MembershipGroup membershipGroup;

    private PartnerDetails partnerDetails;

    private RegisterForGroupServices registerForGroupServices;

    public Membership(RegisteredMember registeredMember,
                      CurrentMember currentMember,
                      MembershipNumber membershipNumber,
                      MembershipGroup membershipGroup,
                      PartnerDetails partnerDetails,
                      RegisterForGroupServices registerForGroupServices) {
        this.registeredMember = registeredMember;
        this.currentMember = currentMember;
        this.membershipNumber = membershipNumber;
        this.membershipGroup = membershipGroup;
        this.partnerDetails = partnerDetails;
        this.registerForGroupServices = registerForGroupServices;
    }

    public RegisteredMember getRegisteredMember() {
        return registeredMember;
    }

    public CurrentMember getCurrentMember() {
        return currentMember;
    }

    public MembershipNumber getMembershipNumber() {
        return membershipNumber;
    }

    public MembershipGroup getMembershipGroup() {
        return membershipGroup;
    }

    public PartnerDetails getPartnerDetails() {
        return partnerDetails;
    }

    public RegisterForGroupServices getRegisterForGroupServices() {
        return registerForGroupServices;
    }
}
