package com.ctm.web.core.marketingContent.model;

import com.ctm.web.core.model.AbstractJsonModel;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.Date;

public class MarketingContent extends AbstractJsonModel {
    private int marketingContentId;
    private int styleCodeId;
    private int verticalId;
    private String url;
    private Date effectiveStart;
    private Date effectiveEnd;

    public int getMarketingContentId() {
        return marketingContentId;
    }

    public void setMarketingContentId(int marketingContentId) {
        this.marketingContentId = marketingContentId;
    }

    public int getStyleCodeId() {
        return styleCodeId;
    }

    public void setStyleCodeId(int styleCodeId) {
        this.styleCodeId = styleCodeId;
    }

    public int getVerticalId() {
        return verticalId;
    }

    public void setVerticalId(int verticalId) {
        this.verticalId = verticalId;
    }

    public String getUrl() {
        return url;
    }

    public void setUrl(String url) {
        this.url = url;
    }

    public Date getEffectiveStart() {
        return effectiveStart;
    }

    public void setEffectiveStart(Date effectiveStart) {
        this.effectiveStart = effectiveStart;
    }

    public Date getEffectiveEnd() {
        return effectiveEnd;
    }

    public void setEffectiveEnd(Date effectiveEnd) {
        this.effectiveEnd = effectiveEnd;
    }

    @Override
    protected JSONObject getJsonObject() throws JSONException {
        JSONObject json = new JSONObject();

        json.put("marketingContentId", getMarketingContentId());
        json.put("url", getUrl());

        return json;
    }
    @Override
    public String toString() {
        return "MarketingContent{" +
                "marketingContentId=" + marketingContentId +
                ", styleCodeId=" + styleCodeId +
                ", verticalId=" + verticalId +
                ", url=" + url +
                ", effectiveStart=" + effectiveStart +
                ", effectiveEnd=" + effectiveEnd +
                '}';
    }
}
