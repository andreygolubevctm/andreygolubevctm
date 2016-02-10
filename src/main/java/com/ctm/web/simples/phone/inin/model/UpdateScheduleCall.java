package com.ctm.web.simples.phone.inin.model;

public class UpdateScheduleCall {

    private String campaignName;

    private Data identity;

    private String phoneNumber;

    private String agentId;

    private String scheduleTime;

    private UpdateScheduleCall(){}

    public UpdateScheduleCall(final String campaignName, final Data identity, final String phoneNumber, final String agentId, final String scheduleTime) {
        this.campaignName = campaignName;
        this.identity = identity;
        this.phoneNumber = phoneNumber;
        this.agentId = agentId;
        this.scheduleTime = scheduleTime;
    }

    public String getCampaignName() {
        return campaignName;
    }

    public Data getIdentity() {
        return identity;
    }

    public String getPhoneNumber() {
        return phoneNumber;
    }

    public String getAgentId() {
        return agentId;
    }

    public String getScheduleTime() {
        return scheduleTime;
    }

    @Override
    public boolean equals(final Object o) {
        if (this == o) return true;
        if (!(o instanceof UpdateScheduleCall)) return false;

        final UpdateScheduleCall that = (UpdateScheduleCall) o;

        if (!campaignName.equals(that.campaignName)) return false;
        if (!identity.equals(that.identity)) return false;
        if (!phoneNumber.equals(that.phoneNumber)) return false;
        if (!agentId.equals(that.agentId)) return false;
        return scheduleTime.equals(that.scheduleTime);

    }

    @Override
    public int hashCode() {
        int result = campaignName.hashCode();
        result = 31 * result + identity.hashCode();
        result = 31 * result + phoneNumber.hashCode();
        result = 31 * result + agentId.hashCode();
        result = 31 * result + scheduleTime.hashCode();
        return result;
    }

    @Override
    public String toString() {
        return "UpdateScheduleCall{" +
                "campaignName='" + campaignName + '\'' +
                ", identity=" + identity +
                ", phoneNumber='" + phoneNumber + '\'' +
                ", agentId='" + agentId + '\'' +
                ", scheduleTime='" + scheduleTime + '\'' +
                '}';
    }
}
