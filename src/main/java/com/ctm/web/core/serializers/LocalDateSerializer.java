package com.ctm.web.core.serializers;

import com.fasterxml.jackson.core.JsonGenerator;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.JsonSerializer;
import com.fasterxml.jackson.databind.SerializerProvider;

import java.io.IOException;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;

public class LocalDateSerializer extends JsonSerializer<LocalDate> {

    @Override
    public void serialize(final LocalDate value, final JsonGenerator gen, final SerializerProvider serializers) throws IOException, JsonProcessingException {
        String str = value.format(DateTimeFormatter.ISO_DATE);
        gen.writeString(str);
    }
}
