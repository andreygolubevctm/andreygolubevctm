package com.ctm.web.simples.phone.inin.model;

public class SecurePauseResult {

    private String interactionId;

    private String securePauseClientResponse;

    public SecurePauseResult(final String interactionId,final String response){
        this.interactionId = interactionId;
        this.securePauseClientResponse = response;
    }

    public String getInteractionId(){
        return interactionId;
    }
}
