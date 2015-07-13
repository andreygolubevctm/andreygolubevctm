package com.ctm.model;

import org.json.JSONException;
import org.json.JSONObject;

public class Feature extends AbstractJsonModel {

    private String code;

    private String label;

    private String value;

    private String extra;

    public String getCode() {
        return code;
    }

    public void setCode(String code) {
        this.code = code;
    }

    public String getLabel() {
        return label;
    }

    public void setLabel(String label) {
        this.label = label;
    }

    public String getValue() {
        return value;
    }

    public void setValue(String value) {
        this.value = value;
    }

    public String getExtra() {
        return extra;
    }

    public void setExtra(String extra) {
        this.extra = extra;
    }

    @Override
    protected JSONObject getJsonObject() throws JSONException {
        JSONObject json = new JSONObject();

        json.put("label", getLabel());
        json.put("extra", getExtra());
        json.put("value", getValue());
        json.put("code", getCode());

        return json;
    }
}
