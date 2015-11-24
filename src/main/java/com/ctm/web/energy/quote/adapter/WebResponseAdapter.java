package com.ctm.web.energy.quote.adapter;

import com.ctm.web.core.providers.model.Response;


public interface WebResponseAdapter<WEB_REQUEST extends Response, REQUEST> {
    WEB_REQUEST adapt(REQUEST request);
}
