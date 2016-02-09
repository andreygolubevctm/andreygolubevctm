package com.ctm.web.simples.phone.inin.model;

import java.util.List;
import java.util.Objects;

public class Update {
    private String campaignName;
    private Data identity;
    private List<Data> datas;

    private Update() {
    }

    public Update(final String campaignName, final Data identity, final List<Data> datas) {
        this.campaignName = campaignName;
        this.identity = identity;
        this.datas = datas;
    }

    public String getCampaignName() {
        return campaignName;
    }

    public Data getIdentity() {
        return identity;
    }

    public List<Data> getDatas() {
        return datas;
    }

    @Override
    public boolean equals(final Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        final Update update = (Update) o;
        return Objects.equals(campaignName, update.campaignName) &&
                Objects.equals(identity, update.identity) &&
                Objects.equals(datas, update.datas);
    }

    @Override
    public int hashCode() {
        return Objects.hash(campaignName, identity, datas);
    }

    @Override
    public String toString() {
        return "Update{" +
                "campaignName='" + campaignName + '\'' +
                ", identity=" + identity +
                ", datas=" + datas +
                '}';
    }
}
