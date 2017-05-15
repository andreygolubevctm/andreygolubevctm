package com.ctm.web.fuel.quote.model.request;

import com.ctm.web.fuel.quote.model.config.Coordinate;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;

import javax.validation.constraints.NotNull;

@ApiModel
public class QuoteRequest {
    @ApiModelProperty(position = 1, required = true)
    @NotNull
    private Coordinate initialPoint;

    @ApiModelProperty(position = 2, required = true)
    @NotNull
    private Coordinate endPoint;

    @ApiModelProperty(position = 3, required = true)
    @NotNull
    private Long fuelId;

    private QuoteRequest() {}

    private QuoteRequest(Builder builder) {
        initialPoint = builder.initialPoint;
        endPoint = builder.endPoint;
        fuelId = builder.fuelId;
    }

    public static Builder newBuilder() {
        return new Builder();
    }

    public Coordinate getInitialPoint() {
        return initialPoint;
    }

    public Coordinate getEndPoint() {
        return endPoint;
    }

    public Long getFuelId() {
        return fuelId;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;

        QuoteRequest that = (QuoteRequest) o;

        if (initialPoint != null ? !initialPoint.equals(that.initialPoint) : that.initialPoint != null) return false;
        if (endPoint != null ? !endPoint.equals(that.endPoint) : that.endPoint != null) return false;
        return fuelId != null ? fuelId.equals(that.fuelId) : that.fuelId == null;

    }

    @Override
    public int hashCode() {
        int result = initialPoint != null ? initialPoint.hashCode() : 0;
        result = 31 * result + (endPoint != null ? endPoint.hashCode() : 0);
        result = 31 * result + (fuelId != null ? fuelId.hashCode() : 0);
        return result;
    }

    @Override
    public String toString() {
        return "QuoteRequest{" +
                "initialPoint=" + initialPoint +
                ", endPoint=" + endPoint +
                ", fuelId=" + fuelId +
                '}';
    }

    public static final class Builder {
        private Coordinate initialPoint;
        private Coordinate endPoint;
        private Long fuelId;

        private Builder() {
        }

        public Builder initialPoint(Coordinate val) {
            initialPoint = val;
            return this;
        }

        public Builder endPoint(Coordinate val) {
            endPoint = val;
            return this;
        }

        public Builder fuelId(Long val) {
            fuelId = val;
            return this;
        }

        public QuoteRequest build() {
            return new QuoteRequest(this);
        }
    }
}
