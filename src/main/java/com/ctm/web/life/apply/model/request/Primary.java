package com.ctm.web.life.apply.model.request;


import com.ctm.life.model.request.State;

public class Primary extends Partner {

    private State state;

    private Primary(Builder builder) {
        super(builder);
    }

    public State getState() {
        return state;
    }
}
