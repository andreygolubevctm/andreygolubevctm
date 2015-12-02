package com.ctm.web.energy.quote.adapter;

import com.ctm.web.core.model.formData.Request;


public interface WebRequestAdapter<WEB_REQUEST extends Request, REQUEST> {
    REQUEST adapt(WEB_REQUEST request);
}
