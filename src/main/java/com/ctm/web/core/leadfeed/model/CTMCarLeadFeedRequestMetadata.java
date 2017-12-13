package com.ctm.web.core.leadfeed.model;

import com.fasterxml.jackson.annotation.*;
import org.apache.commons.lang3.StringUtils;
import org.apache.commons.lang3.Validate;
import org.hibernate.validator.constraints.NotBlank;
import org.immutables.value.internal.$processor$.meta.$JacksonMirrors;

import javax.annotation.Nullable;
import javax.validation.constraints.NotNull;
import java.io.Serializable;

/**
 * Metadata to be send as part of car lead feed request to `ctm-leads`.
 * <p>
 * `ctm-leads` api expects all properties defined to be there. Null values are okay except for `providerCode`.
 */
@JsonIgnoreProperties(ignoreUnknown = true)
@JsonInclude(value = JsonInclude.Include.ALWAYS)
public class CTMCarLeadFeedRequestMetadata implements Serializable {

    private static final String RATING = "Rating ";

    @NotNull
    @JsonProperty(value = "@type")
    private MetadataType type;
    @NotBlank
    private String providerCode;
    @Nullable
    private String propensityScore;
    @Nullable
    private String providerQuoteRef;
    @Nullable
    private String vehicleDescription;
    @Nullable
    private String ncdRating;
    @Nullable
    private String ageRestriction;

    public enum MetadataType {
        CAR("car");

        private String label;

        MetadataType(final String label) {
            this.label = label;
        }

        @JsonCreator
        public static MetadataType fromString(String label) {
            return label == null ? null : MetadataType.valueOf(label.toUpperCase());
        }

        @JsonValue
        public String getLabel() {
            return label;
        }
    }

    public MetadataType getType() {
        return type;
    }

    public void setType(MetadataType type) {
        this.type = type;
    }

    public String getPropensityScore() {
        return propensityScore;
    }

    public void setPropensityScore(String propensityScore) {
        this.propensityScore = propensityScore;
    }

    public String getProviderCode() {
        return providerCode;
    }

    public void setProviderCode(String providerCode) {
        this.providerCode = providerCode;
    }

    public String getProviderQuoteRef() {
        return providerQuoteRef;
    }

    public void setProviderQuoteRef(String providerQuoteRef) {
        this.providerQuoteRef = providerQuoteRef;
    }

    public String getVehicleDescription() {
        return vehicleDescription;
    }

    public void setVehicleDescription(String vehicleDescription) {
        this.vehicleDescription = vehicleDescription;
    }

    public String getNcdRating() {
        return ncdRating;
    }

    /**
     * Custom setter with suffix as a readable label for call center agents.
     *
     * @param ncdRating
     */
    public void setNcdRating(String ncdRating) {

        if (StringUtils.isBlank(ncdRating)) {
            this.ncdRating = null;
        } else if (!StringUtils.contains(ncdRating, RATING)) {
            this.ncdRating = RATING + ncdRating;
        } else {
            this.ncdRating = ncdRating;
        }
    }

    public String getAgeRestriction() {
        return ageRestriction;
    }

    /**
     * Custom setter with prefix as a readable label for call center agents.
     *
     * @param ageRestriction could be value or label of {@linkplain DriverOption} in plain string.
     */
    public void setAgeRestriction(String ageRestriction) {

        final DriverOption driverOptionByValue = DriverOption.getDriverOptionByValue(ageRestriction);
        final DriverOption driverOptionByLabel = DriverOption.getDriverOptionByLabel(ageRestriction);

        if (driverOptionByValue == null && driverOptionByLabel == null) {
            this.ageRestriction = null;
        } else if (driverOptionByValue != null) {
            this.ageRestriction = driverOptionByValue.getLabel();
        } else {
            this.ageRestriction = driverOptionByLabel.getLabel();
        }

    }

    public enum DriverOption {
        NO_RESTRICTIONS("3", "No restrictions"),
        TWENTY_ONE_YEARS_AND_OVER("H", "21 years and over"),
        TWENTY_FIVE_YEARS_AND_OVER("7", "25 years and over"),
        THIRTY_YEARS_AND_OVER("A", "30 years and over"),
        FORTY_YEARS_AND_OVER("D", "40 years and over"),
        FIFTY_YEARS_AND_OVER("J", "50 years and over");

        private static final String LABEL_NO_RESTRICTIONS = "No restrictions";
        private static final String LABEL_TWENTY_ONE_YEARS_AND_OVER = "21 years and over";
        private static final String LABEL_TWENTY_FIVE_YEARS_AND_OVER = "25 years and over";
        private static final String LABEL_THIRTY_YEARS_AND_OVER = "30 years and over";
        private static final String LABEL_FORTY_YEARS_AND_OVER = "40 years and over";
        private static final String LABEL_FIFTY_YEARS_AND_OVER = "50 years and over";

        private String value;
        private String label;


        public String getValue() {
            return value;
        }

        public void setValue(String value) {
            this.value = value;
        }

        public String getLabel() {
            return label;
        }

        public void setLabel(String label) {
            this.label = label;
        }

        DriverOption(String value, String label) {
            this.value = value;
            this.label = label;
        }

        public static DriverOption getDriverOptionByValue(final String value) {
            switch (value) {
                case "3":
                    return NO_RESTRICTIONS;
                case "H":
                    return TWENTY_ONE_YEARS_AND_OVER;
                case "7":
                    return TWENTY_FIVE_YEARS_AND_OVER;
                case "A":
                    return THIRTY_YEARS_AND_OVER;
                case "D":
                    return FORTY_YEARS_AND_OVER;
                case "J":
                    return FIFTY_YEARS_AND_OVER;
                default:
                    return null;
            }
        }

        public static DriverOption getDriverOptionByLabel(final String label) {
            switch (label) {
                case LABEL_NO_RESTRICTIONS:
                    return NO_RESTRICTIONS;
                case LABEL_TWENTY_ONE_YEARS_AND_OVER:
                    return TWENTY_ONE_YEARS_AND_OVER;
                case LABEL_TWENTY_FIVE_YEARS_AND_OVER:
                    return TWENTY_FIVE_YEARS_AND_OVER;
                case LABEL_THIRTY_YEARS_AND_OVER:
                    return THIRTY_YEARS_AND_OVER;
                case LABEL_FORTY_YEARS_AND_OVER:
                    return FORTY_YEARS_AND_OVER;
                case LABEL_FIFTY_YEARS_AND_OVER:
                    return FIFTY_YEARS_AND_OVER;
                default:
                    return null;
            }
        }

    }

    @Override
    public String toString() {
        return "CTMCarLeadFeedRequestMetadata{" +
                "type=" + type +
                ", providerCode='" + providerCode + '\'' +
                ", propensityScore='" + propensityScore + '\'' +
                ", providerQuoteRef='" + providerQuoteRef + '\'' +
                ", vehicleDescription='" + vehicleDescription + '\'' +
                ", ncdRating='" + ncdRating + '\'' +
                ", ageRestriction='" + ageRestriction + '\'' +
                '}';
    }
}
