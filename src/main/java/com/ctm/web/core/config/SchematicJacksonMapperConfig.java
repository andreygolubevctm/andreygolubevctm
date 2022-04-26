package com.ctm.web.core.config;

import com.ctm.httpclient.jackson.DefaultJacksonMappers;
import com.ctm.schema.serialisation.SchemaObjectMapper;
import com.fasterxml.jackson.databind.DeserializationFeature;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Primary;
import org.springframework.http.converter.json.Jackson2ObjectMapperBuilder;
import org.springframework.stereotype.Component;

/**
 * This class overrides the {@link DefaultJacksonMappers} Spring Bean
 *  which is inherited from the com.ctm.common.http-client dependency, and
 *  allows us to override the ObjectMapper used for serialising/ de-serialising Schematic objects.
 *  Schematic objects define certain PropertyFilters eg FILTERED that are not supported by the default ObjectMapper
 *  supplied by {@link DefaultJacksonMappers}
 */
@Primary
@Component
public class SchematicJacksonMapperConfig extends DefaultJacksonMappers {

    private final ObjectMapper jsonMapper;

    @Autowired
    public SchematicJacksonMapperConfig(final Jackson2ObjectMapperBuilder jacksonMapperBuilder) {
        super(jacksonMapperBuilder);
        this.jsonMapper = SchemaObjectMapper
                .getInstance(com.ctm.schema.filter.Filter.EXCLUDED_FROM_RESULTS)
                .configure(DeserializationFeature.FAIL_ON_UNKNOWN_PROPERTIES, false);
    }

    @Override
    public ObjectMapper getJsonMapper() {
        return jsonMapper;
    }
}
