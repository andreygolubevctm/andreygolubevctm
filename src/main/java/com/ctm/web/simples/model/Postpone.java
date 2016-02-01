package com.ctm.web.simples.model;

public class Postpone {
    private int messageId;
    private int statusId;
    private int reasonStatusId;
    private String postponeDate;
    private String postponeTime;
    private String postponeAMPM;
    private String comment;
    private boolean assignToUser;

    public int getMessageId() {
        return messageId;
    }

    public void setMessageId(final int messageId) {
        this.messageId = messageId;
    }

    public int getStatusId() {
        return statusId;
    }

    public void setStatusId(final int statusId) {
        this.statusId = statusId;
    }

    public int getReasonStatusId() {
        return reasonStatusId;
    }

    public void setReasonStatusId(final int reasonStatusId) {
        this.reasonStatusId = reasonStatusId;
    }

    public String getPostponeDate() {
        return postponeDate;
    }

    public void setPostponeDate(final String postponeDate) {
        this.postponeDate = postponeDate;
    }

    public String getPostponeTime() {
        return postponeTime;
    }

    public void setPostponeTime(final String postponeTime) {
        this.postponeTime = postponeTime;
    }

    public String getPostponeAMPM() {
        return postponeAMPM;
    }

    public void setPostponeAMPM(final String postponeAMPM) {
        this.postponeAMPM = postponeAMPM;
    }

    public String getComment() {
        return comment;
    }

    public void setComment(final String comment) {
        this.comment = comment;
    }

    public boolean getAssignToUser() {
        return assignToUser;
    }

    public boolean isAssignToUser() {
        return assignToUser;
    }

    public void setAssignToUser(final boolean assignToUser) {
        this.assignToUser = assignToUser;
    }
}
