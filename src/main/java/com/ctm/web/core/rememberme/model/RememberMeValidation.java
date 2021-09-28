package com.ctm.web.core.rememberme.model;

public class RememberMeValidation
{
    private Boolean isValidAnswer;

    private String  transactionId;

    private Boolean isReviewEdit;

    private String journeyType;

    public RememberMeValidation(final Boolean isValidAnswer, final String transactionId, final Boolean isReviewEdit, final String journeyType){
        this.isValidAnswer =  isValidAnswer;
        this.transactionId = transactionId;
        this.isReviewEdit = isReviewEdit;
        this.journeyType = journeyType;
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

    public String getJourneyType() {
        return journeyType;
    }

}