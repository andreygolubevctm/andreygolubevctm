package com.ctm.web.school.model;

import org.codehaus.jackson.annotate.JsonIgnoreProperties;

import java.util.List;

@JsonIgnoreProperties(ignoreUnknown = true)
public class Schools {
    private List<School> data;

    public List<School> getData() {
        return data;
    }

    public void setData(List<School> data) {
        this.data = data;
    }
}
