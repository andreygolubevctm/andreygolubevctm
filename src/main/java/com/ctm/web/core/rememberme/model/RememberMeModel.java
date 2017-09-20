package com.ctm.web.core.rememberme.model;

public class RememberMeModel
{
    private Boolean isValidAnswer;

    private String  transactionId;

    private Boolean isReviewEdit;

    public RememberMeModel(final Boolean isValidAnswer, final String transactionId, final Boolean isReviewEdit){
        this.isValidAnswer =  isValidAnswer;
        this.transactionId = transactionId;
        this.isReviewEdit = isReviewEdit;
    }
    public Boolean isValidAnswer() {
        return isValidAnswer;
    }

    public String getTransactionId() {
        return transactionId;
    }

    public Boolean isReviewEdit() {
        return isReviewEdit;
    }

}