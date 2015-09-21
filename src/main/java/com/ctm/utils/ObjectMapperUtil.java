package com.ctm.utils;

import com.fasterxml.jackson.annotation.JsonAutoDetect;
import com.fasterxml.jackson.annotation.PropertyAccessor;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.dataformat.xml.XmlMapper;
import com.fasterxml.jackson.datatype.jdk8.Jdk8Module;
import com.fasterxml.jackson.datatype.jsr310.JSR310Module;

public class ObjectMapperUtil {

    private static final ObjectMapper objectMapper = new ObjectMapper()
            .setVisibility(PropertyAccessor.FIELD, JsonAutoDetect.Visibility.ANY)
            .registerModule(new Jdk8Module());

    private static final ObjectMapper xmlMapper = new XmlMapper()
            .registerModule(new Jdk8Module())
            .registerModule(new JSR310Module());

    public static ObjectMapper getObjectMapper() {
        return objectMapper;
    }

    public static ObjectMapper getXmlMapper() {
        return xmlMapper;
    }

}
