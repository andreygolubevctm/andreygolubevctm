package com.ctm.web.core.leadfeed.model;

import com.ctm.interfaces.common.types.VerticalType;
import com.ctm.web.core.leadService.model.LeadStatus;
import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.fasterxml.jackson.annotation.JsonInclude;
import org.hibernate.validator.constraints.NotBlank;

import javax.annotation.Nullable;
import javax.validation.constraints.NotNull;
import java.io.Serializable;

/**
 * Request to be send to `ctm-leads`
 */
@JsonIgnoreProperties(ignoreUnknown = true)
@JsonInclude(value = JsonInclude.Include.ALWAYS)
public class CTMCarBestPriceLeadFeedRequest implements Serializable {

    @NotBlank
    private String brandCode;
    @NotBlank
    private String clientIP;
    @NotBlank
    private String source;
    @NotNull
    private LeadStatus status;
    @NotNull
    private VerticalType verticalType;
    @NotNull
    private Person person;
    @NotNull
    private CTMCarLeadFeedRequestMetadata metadata;
    @Nullable
    private Long transactionId;
    @Nullable
    private String rootId;

    public String getBrandCode() {
        return brandCode;
    }

    public void setBrandCode(String brandCode) {
        this.brandCode = brandCode;
    }

    public String getClientIP() {
        return clientIP;
    }

    public void setClientIP(String clientIP) {
        this.clientIP = clientIP;
    }

    public String getRootId() {
        return rootId;
    }

    public void setRootId(String rootId) {
        this.rootId = rootId;
    }

    public String getSource() {
        return source;
    }

    public void setSource(String source) {
        this.source = source;
    }

    public LeadStatus getStatus() {
        return status;
    }

    public void setStatus(LeadStatus status) {
        this.status = status;
    }

    public Long getTransactionId() {
        return transactionId;
    }

    public void setTransactionId(Long transactionId) {
        this.transactionId = transactionId;
    }

    public VerticalType getVerticalType() {
        return verticalType;
    }

    public void setVerticalType(VerticalType verticalType) {
        this.verticalType = verticalType;
    }

    public Person getPerson() {
        return person;
    }

    public void setPerson(Person person) {
        this.person = person;
    }

    public CTMCarLeadFeedRequestMetadata getMetadata() {
        return metadata;
    }

    public void setMetadata(CTMCarLeadFeedRequestMetadata metadata) {
        this.metadata = metadata;
    }
}
