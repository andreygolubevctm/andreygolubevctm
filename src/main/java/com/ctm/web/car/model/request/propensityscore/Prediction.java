package com.ctm.web.car.model.request.propensityscore;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.fasterxml.jackson.annotation.JsonProperty;

import java.io.Serializable;

@JsonIgnoreProperties(ignoreUnknown = true)
public class Prediction implements Serializable {
    @JsonProperty(value = "row_id")
    private Integer rowId;
    @JsonProperty(value = "class_probabilities")
    private ClassProbability classProbabilities;

    public Integer getRowId() {
        return rowId;
    }

    public void setRowId(Integer rowId) {
        this.rowId = rowId;
    }

    public ClassProbability getClassProbabilities() {
        return classProbabilities;
    }

    public void setClassProbabilities(ClassProbability classProbabilities) {
        this.classProbabilities = classProbabilities;
    }
}
