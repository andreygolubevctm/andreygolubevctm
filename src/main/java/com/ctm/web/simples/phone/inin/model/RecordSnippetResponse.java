package com.ctm.web.simples.phone.inin.model;



public class RecordSnippetResponse {

    private boolean success;
    private Error error;
    private String interactionId;

    private RecordSnippetResponse() {

    }

    private RecordSnippetResponse(boolean success, String errorMessage, String interactionId) {
        this.success = success;
        this.error = new Error(errorMessage);
        this.interactionId = interactionId;
    }

    public static RecordSnippetResponse of(boolean success) {
        return new RecordSnippetResponse(success, null, null);
    }

    public static RecordSnippetResponse fail(String errorMessage) {
        return new RecordSnippetResponse(false, errorMessage, null);
    }

    public static RecordSnippetResponse success() {
        return new RecordSnippetResponse(true, null, null);
    }

    public static RecordSnippetResponse success(String interactionId) {
        return new RecordSnippetResponse(true, null, interactionId);
    }

    public boolean isSuccess() {
        return success;
    }

    public Error getError() {
        return error;
    }

    public String getInteractionId() {
        return interactionId;
    }

}
