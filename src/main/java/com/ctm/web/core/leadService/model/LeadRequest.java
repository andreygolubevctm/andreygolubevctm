package com.ctm.web.core.leadService.model;

import com.fasterxml.jackson.annotation.JsonInclude;

@JsonInclude(JsonInclude.Include.NON_EMPTY)
public class LeadRequest {
    private String source;
    private Long rootId;
    private Long transactionId;
    private String brandCode;
    private String verticalType;
    private String clientIP;
    private Person person = new Person();
    private String status;
    private LeadMetadata metadata;

    public String getSource() {
        return source;
    }

    public void setSource(String source) {
        this.source = source;
    }

    public Long getRootId() {
        return rootId;
    }

    public void setRootId(Long rootId) {
        this.rootId = rootId;
    }

    public Long getTransactionId() {
        return transactionId;
    }

    public void setTransactionId(Long transactionId) {
        this.transactionId = transactionId;
    }

    public String getBrandCode() {
        return brandCode;
    }

    public void setBrandCode(String brandCode) {
        this.brandCode = brandCode;
    }

    public String getVerticalType() {
        return verticalType;
    }

    public void setVerticalType(String verticalType) {
        this.verticalType = verticalType;
    }

    public String getClientIP() {
        return clientIP;
    }

    public void setClientIP(String clientIP) {
        this.clientIP = clientIP;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Person getPerson() {
        return person;
    }

    public String getValues() {
        StringBuilder builder = new StringBuilder();
        builder.append(source);
        builder.append(",");
        builder.append(rootId);
        builder.append(",");
        builder.append(transactionId);
        builder.append(",");
        builder.append(brandCode);
        builder.append(",");
        builder.append(verticalType);
        builder.append(",");
        builder.append(clientIP);
        builder.append(",");
        builder.append(person.getValues());
        builder.append(",");
        builder.append(status);
        builder.append(",");
        builder.append(metadata.getValues());

        return builder.toString();
    }

    @Override
    public String toString() {
        return "LeadRequest{" +
                "source='" + source + '\'' +
                ", rootId=" + rootId +
                ", transactionId=" + transactionId +
                ", brandCode=" + brandCode +
                ", verticalType=" + verticalType +
                ", clientIP=" + clientIP +
                ", person=" + person +
                ", status=" + status +
                ", metadata=" + metadata +
                '}';
    }

    public LeadMetadata getMetadata() {
        return metadata;
    }

    public void setMetadata(LeadMetadata metadata) {
        this.metadata = metadata;
    }
}
