package com.ctm.model.simples;

import com.ctm.model.Comment;
import com.ctm.model.Touch;
import com.ctm.model.Transaction;
import com.ctm.model.simples.Message;
import com.fasterxml.jackson.annotation.JsonProperty;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class MessageDetail {

    private Message message;
    private Transaction transaction;

    @JsonProperty(Comment.JSON_COLLECTION_NAME)
    private List<Comment> comments = new ArrayList<>();

    @JsonProperty(Touch.JSON_COLLECTION_NAME)
    private List<Touch> touches = new ArrayList<>();

    @JsonProperty(MessageAudit.JSON_COLLECTION_NAME)
    private List<MessageAudit> audits = new ArrayList<>();

    private Map<String, String> verticalProperties = new HashMap<>();



    public List<MessageAudit> getAudits() {
        return audits;
    }
    public void setAudits(List<MessageAudit> audits) {
        this.audits = audits;
    }

    public List<Comment> getComments() {
        return comments;
    }
    public void setComments(List<Comment> comments) {
        this.comments = comments;
    }

    public List<Touch> getTouches() {
        return touches;
    }
    public void setTouches(List<Touch> touches) {
        this.touches = touches;
    }


    public Message getMessage() {
        return message;
    }
    public void setMessage(Message message) {
        this.message = message;
    }

    public Transaction getTransaction() {
        return transaction;
    }
    public void setTransaction(Transaction transaction) {
        this.transaction = transaction;
    }

    public Map<String, String> getVerticalProperties() {
        return verticalProperties;
    }
    public void setVerticalProperties(Map<String, String> verticalProperties) {
        this.verticalProperties = verticalProperties;
    }
}
