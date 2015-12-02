package com.ctm.web.core.model.formData;

public interface RequestWithQuote<QUOTE> extends Request {

    QUOTE getQuote();

}
