package com.ctm.web.energy.quote.adapter;

public interface WebResponseAdapter<WEB_REQUEST, REQUEST> {
    WEB_REQUEST adapt(REQUEST request);
}
