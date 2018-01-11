package com.ctm.web.core.model;

public class TouchLifebrokerProperty extends AbstractTouchProperty {

    private String clientReference;

    public String getClientReference() {
        return clientReference;
    }

    public void setClientReference(String clientReference) {
        this.clientReference = clientReference;
    }

    @Override
    public String toString() {
        return "TouchLifebrokerProperty{" +
                "clientReference='" + clientReference + '\'' +
                '}';
    }
}
