package com.ctm.web.simples.phone.inin.model;

public class DeleteScheduleCall {

    private String campaignName;

    private Data identity;

    private DeleteScheduleCall(){}

    public DeleteScheduleCall(final String campaignName, final Data identity) {
        this.campaignName = campaignName;
        this.identity = identity;
    }

    public String getCampaignName() {
        return campaignName;
    }

    public Data getIdentity() {
        return identity;
    }

    @Override
    public String toString() {
        return "DeleteScheduleCall{" +
                "campaignName='" + campaignName + '\'' +
                ", identity=" + identity +
                '}';
    }

    @Override
    public boolean equals(final Object o) {
        if (this == o) return true;
        if (!(o instanceof DeleteScheduleCall)) return false;

        final DeleteScheduleCall that = (DeleteScheduleCall) o;

        if (!campaignName.equals(that.campaignName)) return false;
        return identity.equals(that.identity);

    }

    @Override
    public int hashCode() {
        int result = campaignName.hashCode();
        result = 31 * result + identity.hashCode();
        return result;
    }
}
