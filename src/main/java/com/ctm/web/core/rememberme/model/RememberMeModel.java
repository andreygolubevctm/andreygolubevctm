package com.ctm.web.core.rememberme.model;

public class RememberMeModel
{
    private Boolean isValidAnswer;

    private String  transactionId;

    public RememberMeModel(final Boolean isValidAnswer, final String transactionId){
        this.isValidAnswer =  isValidAnswer;
        this.transactionId = transactionId;
    }
    public Boolean isValidAnswer() {
        return isValidAnswer;
    }

    public String getTransactionId() {
        return transactionId;
    }

}