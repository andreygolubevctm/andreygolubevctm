package com.ctm.utils;

import com.fasterxml.jackson.annotation.JsonAutoDetect;
import com.fasterxml.jackson.annotation.PropertyAccessor;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.dataformat.xml.XmlMapper;

public class ObjectMapperUtil {

    private static final ObjectMapper objectMapper = new ObjectMapper()
            .setVisibility(PropertyAccessor.FIELD, JsonAutoDetect.Visibility.ANY);

    private static final XmlMapper xmlMapper = new XmlMapper();

    public static ObjectMapper getObjectMapper() {
        return objectMapper;
    }

    public static XmlMapper getXmlMapper() {
        return xmlMapper;
    }

}
