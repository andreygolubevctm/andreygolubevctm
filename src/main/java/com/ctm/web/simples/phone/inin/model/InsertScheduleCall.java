package com.ctm.web.simples.phone.inin.model;

import java.util.List;

public class InsertScheduleCall {

    private String campaignName;

    private List<Data> datas;

    private String phoneNumber;

    private String agentId;

    private String scheduleTime;

    private InsertScheduleCall(){}

    public InsertScheduleCall(final String campaignName, final List<Data> datas, final String phoneNumber, final String agentId, final String scheduleTime) {
        this.campaignName = campaignName;
        this.datas = datas;
        this.phoneNumber = phoneNumber;
        this.agentId = agentId;
        this.scheduleTime = scheduleTime;
    }

    public String getCampaignName() {
        return campaignName;
    }

    public List<Data> getDatas() {
        return datas;
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
        if (!(o instanceof InsertScheduleCall)) return false;

        final InsertScheduleCall that = (InsertScheduleCall) o;

        if (!campaignName.equals(that.campaignName)) return false;
        if (!datas.equals(that.datas)) return false;
        if (!phoneNumber.equals(that.phoneNumber)) return false;
        if (!agentId.equals(that.agentId)) return false;
        return scheduleTime.equals(that.scheduleTime);

    }

    @Override
    public int hashCode() {
        int result = campaignName.hashCode();
        result = 31 * result + datas.hashCode();
        result = 31 * result + phoneNumber.hashCode();
        result = 31 * result + agentId.hashCode();
        result = 31 * result + scheduleTime.hashCode();
        return result;
    }

    @Override
    public String toString() {
        return "InsertScheduleCall{" +
                "campaignName='" + campaignName + '\'' +
                ", datas=" + datas +
                ", phoneNumber='" + phoneNumber + '\'' +
                ", agentId='" + agentId + '\'' +
                ", scheduleTime='" + scheduleTime + '\'' +
                '}';
    }
}
