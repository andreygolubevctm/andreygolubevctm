package com.ctm.model.home.results;

import com.fasterxml.jackson.core.JsonGenerator;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.JsonSerializer;
import com.fasterxml.jackson.databind.SerializerProvider;
import org.apache.commons.lang3.StringUtils;

import java.io.IOException;
import java.util.List;

public class AdditionalExcessesSerializer extends JsonSerializer<List<AdditionalExcess>> {

    @Override
    public void serialize(List<AdditionalExcess> additionalExcesses, JsonGenerator jsonGenerator, SerializerProvider serializerProvider) throws IOException, JsonProcessingException {
        jsonGenerator.writeStartObject();
        if (additionalExcesses != null && !additionalExcesses.isEmpty()) {
            jsonGenerator.writeStringField("value", "Additional Excess Applies");
            StringBuilder sb = new StringBuilder("<ul>");
            for (AdditionalExcess additionalExcess : additionalExcesses) {
                sb.append("<li>").append(additionalExcess.getDescription());
                if (StringUtils.isNotBlank(additionalExcess.getAmount())) {
                    sb.append(" - ").append(additionalExcess.getAmount());
                }
                sb.append("</li>");
            }
            sb.append("</ul>");
            jsonGenerator.writeStringField("extra", sb.toString());
            jsonGenerator.writeArrayFieldStart("list");
            for (AdditionalExcess additionalExcess : additionalExcesses) {
                jsonGenerator.writeObject(additionalExcess);
            }
            jsonGenerator.writeEndArray();
        } else {
            jsonGenerator.writeStringField("value", "N");
            jsonGenerator.writeStringField("extra", "<ul>&nbsp;</ul>");
        }
        jsonGenerator.writeEndObject();
    }
}
