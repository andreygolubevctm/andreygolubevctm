package com.ctm.web.core.model.formData;

public abstract class RequestWithQuote<QUOTE> extends RequestImpl {

    public abstract QUOTE getQuote();

}
