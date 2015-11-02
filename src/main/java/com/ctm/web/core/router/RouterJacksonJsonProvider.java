package com.ctm.web.core.router;

import com.fasterxml.jackson.databind.MapperFeature;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.jaxrs.json.JacksonJsonProvider;

public class RouterJacksonJsonProvider extends JacksonJsonProvider {

    public RouterJacksonJsonProvider() {
        super(init());

    }

    private static ObjectMapper init() {
        ObjectMapper objectMapper = new ObjectMapper();
        objectMapper.configure(MapperFeature.DEFAULT_VIEW_INCLUSION, false);
        return objectMapper;
    }
}
