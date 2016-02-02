package com.ctm.web.simples.phone.inin.model;

import java.util.List;
import java.util.Objects;

public class DeleteScheduleCall {
    private String campaignName;
    private List<String> i3Identity;

    private DeleteScheduleCall(){}

    public DeleteScheduleCall(final String campaignName, final List<String> i3Identity) {
        this.campaignName = campaignName;
        this.i3Identity = i3Identity;
    }

    public String getCampaignName() {
        return campaignName;
    }

    public List<String> getI3Identity() {
        return i3Identity;
    }

    @Override
    public boolean equals(final Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        final DeleteScheduleCall that = (DeleteScheduleCall) o;
        return Objects.equals(campaignName, that.campaignName) &&
                Objects.equals(i3Identity, that.i3Identity);
    }

    @Override
    public int hashCode() {
        return Objects.hash(campaignName, i3Identity);
    }

    @Override
    public String toString() {
        return "DeleteScheduleCall{" +
                "campaignName='" + campaignName + '\'' +
                ", i3Identity=" + i3Identity +
                '}';
    }
}
