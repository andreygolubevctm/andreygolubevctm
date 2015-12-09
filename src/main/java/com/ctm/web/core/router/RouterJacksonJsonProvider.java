package com.ctm.web.core.router;

import com.ctm.web.core.utils.ObjectMapperUtil;
import com.fasterxml.jackson.jaxrs.json.JacksonJsonProvider;

public class RouterJacksonJsonProvider extends JacksonJsonProvider {

    public RouterJacksonJsonProvider() {
        super(ObjectMapperUtil.getObjectMapper());

    }

}
