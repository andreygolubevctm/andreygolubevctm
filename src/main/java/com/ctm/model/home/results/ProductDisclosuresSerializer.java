package com.ctm.model.home.results;

import com.fasterxml.jackson.core.JsonGenerator;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.JsonSerializer;
import com.fasterxml.jackson.databind.SerializerProvider;

import java.io.IOException;
import java.util.List;

public class ProductDisclosuresSerializer extends JsonSerializer<List<ProductDisclosure>> {

    @Override
    public void serialize(List<ProductDisclosure> productDisclosures, JsonGenerator jsonGenerator, SerializerProvider serializerProvider) throws IOException, JsonProcessingException {
        jsonGenerator.writeStartObject();
        for (ProductDisclosure productDisclosure : productDisclosures) {
            jsonGenerator.writeFieldName(productDisclosure.getCode());

            jsonGenerator.writeStartObject();
            jsonGenerator.writeStringField("title", productDisclosure.getTitle());
            jsonGenerator.writeStringField("url", productDisclosure.getUrl());
            jsonGenerator.writeEndObject();
        }
        jsonGenerator.writeEndObject();
    }
}
