package com.ctm.model.car;

import com.fasterxml.jackson.core.JsonGenerator;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.JsonSerializer;
import com.fasterxml.jackson.databind.SerializerProvider;
import org.apache.commons.lang3.StringUtils;

import java.io.IOException;
import java.util.List;

public class SpecialConditionsSerializer extends JsonSerializer<List<String>> {

    @Override
    public void serialize(List<String> specialConditions, JsonGenerator jsonGenerator, SerializerProvider serializerProvider) throws IOException, JsonProcessingException {
        jsonGenerator.writeStartObject();
        if (specialConditions != null && !specialConditions.isEmpty()) {

            StringBuilder sb = new StringBuilder();
            for (String specialCondition : specialConditions) {
                sb.append(specialCondition);
                if (!StringUtils.endsWith(specialCondition, ".")) {
                    sb.append(".");
                }
                sb.append(" ");
            }
            jsonGenerator.writeStringField("description", sb.toString());
            jsonGenerator.writeFieldName("list");
            jsonGenerator.writeStartArray();
            for (String specialCondition : specialConditions) {
                jsonGenerator.writeString(specialCondition);
            }
            jsonGenerator.writeEndArray();
        }
        jsonGenerator.writeEndObject();
    }
}
