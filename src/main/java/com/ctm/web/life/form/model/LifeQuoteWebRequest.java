package com.ctm.web.life.form.model;

import com.ctm.web.core.model.formData.RequestImpl;
import com.ctm.web.core.model.formData.RequestWithQuote;

import javax.validation.Valid;

public class LifeQuoteWebRequest extends RequestImpl implements RequestWithQuote<LifeQuote> {

    @Valid
    private LifeQuote life;

    @Override
    public LifeQuote getQuote() {
        return life;
    }

    public LifeQuote getLife() {
        return life;
    }

    public void setLife(LifeQuote life) {
        this.life = life;
    }
}
