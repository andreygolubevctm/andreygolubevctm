package com.ctm.router;

import com.ctm.utils.ObjectMapperUtil;
import com.fasterxml.jackson.jaxrs.json.JacksonJsonProvider;

public class RouterJacksonJsonProvider extends JacksonJsonProvider {

    public RouterJacksonJsonProvider() {
        super(ObjectMapperUtil.getObjectMapper());

    }

}
