package com.ctm.web.car.model.request.propensityscore;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.fasterxml.jackson.annotation.JsonProperty;

import java.io.Serializable;
import java.util.List;

@JsonIgnoreProperties(ignoreUnknown = true)
public class DataRobotCarQuotePropensityScoreResponse implements Serializable{

    @JsonProperty(value = "status")
    private String status;
    @JsonProperty(value = "model_id")
    private String modelId;
    @JsonProperty(value = "code")
    private Integer code;
    @JsonProperty(value = "execution_time")
    private String executionTime;
    @JsonProperty(value = "predictions")
    private List<Prediction> predictions;
    @JsonProperty(value = "task")
    private String task;
    @JsonProperty(value = "version")
    private String version;

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getModelId() {
        return modelId;
    }

    public void setModelId(String modelId) {
        this.modelId = modelId;
    }

    public Integer getCode() {
        return code;
    }

    public void setCode(Integer code) {
        this.code = code;
    }

    public String getExecutionTime() {
        return executionTime;
    }

    public void setExecutionTime(String executionTime) {
        this.executionTime = executionTime;
    }

    public List<Prediction> getPredictions() {
        return predictions;
    }

    public void setPredictions(List<Prediction> predictions) {
        this.predictions = predictions;
    }

    public String getTask() {
        return task;
    }

    public void setTask(String task) {
        this.task = task;
    }

    public String getVersion() {
        return version;
    }

    public void setVersion(String version) {
        this.version = version;
    }
}
