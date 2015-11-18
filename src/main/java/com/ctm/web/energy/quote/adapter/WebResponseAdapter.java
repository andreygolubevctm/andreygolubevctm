package com.ctm.web.energy.quote.adapter;

import com.ctm.web.core.providers.model.Response;


public interface WebResponseAdapter<WEB_REQUEST extends Response, REQUEST> {
    REQUEST adapt(WEB_REQUEST request);
}
