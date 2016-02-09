package com.ctm.web.simples.phone.inin.model;

import java.util.List;
import java.util.Objects;

public class Insert {
    private final String campaignName;
    private final List<Data> datas;

    public Insert(final String campaignName, final List<Data> datas) {
        this.campaignName = campaignName;
        this.datas = datas;
    }

    public String getCampaignName() {
        return campaignName;
    }

    public List<Data> getDatas() {
        return datas;
    }

    @Override
    public boolean equals(final Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        final Insert insert = (Insert) o;
        return Objects.equals(campaignName, insert.campaignName) &&
                Objects.equals(datas, insert.datas);
    }

    @Override
    public int hashCode() {
        return Objects.hash(campaignName, datas);
    }

    @Override
    public String toString() {
        return "Insert{" +
                "campaignName='" + campaignName + '\'' +
                ", datas=" + datas +
                '}';
    }
}
