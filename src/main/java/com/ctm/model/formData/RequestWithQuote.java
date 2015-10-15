package com.ctm.model.formData;

public interface RequestWithQuote<QUOTE> extends Request {

    QUOTE getQuote();

}
