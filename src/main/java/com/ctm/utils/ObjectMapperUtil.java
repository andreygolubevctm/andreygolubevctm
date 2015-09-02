package com.ctm.utils;

import com.fasterxml.jackson.databind.ObjectMapper;

public class ObjectMapperUtil {

    private static ObjectMapper objectMapper = new ObjectMapper();

    public static ObjectMapper getObjectMapper() {
        return objectMapper;
    }

}
