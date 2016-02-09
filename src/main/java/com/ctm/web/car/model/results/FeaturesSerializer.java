package com.ctm.web.car.model.results;

import com.fasterxml.jackson.core.JsonGenerator;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.JsonSerializer;
import com.fasterxml.jackson.databind.SerializerProvider;

import java.io.IOException;
import java.util.List;

public class FeaturesSerializer extends JsonSerializer<List<Feature>> {

    @Override
    public void serialize(List<Feature> features, JsonGenerator jsonGenerator, SerializerProvider serializerProvider) throws IOException, JsonProcessingException {
        jsonGenerator.writeStartObject();
        for (Feature feature : features) {
            jsonGenerator.writeFieldName(feature.getCode());

            jsonGenerator.writeStartObject();
            jsonGenerator.writeStringField("extra", feature.getExtra());
            jsonGenerator.writeStringField("value", feature.getValue());
            jsonGenerator.writeEndObject();

        }
        jsonGenerator.writeEndObject();

    }
}
