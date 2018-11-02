package com.ctm.web.car.model.results;

import com.fasterxml.jackson.core.JsonGenerator;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.JsonSerializer;
import com.fasterxml.jackson.databind.SerializerProvider;
import org.apache.commons.lang3.StringUtils;

import java.io.IOException;
import java.util.List;

public class ExcessSerializer extends JsonSerializer<Excess> {

    @Override
    public void serialize(Excess excess, JsonGenerator jsonGenerator, SerializerProvider serializerProvider) throws IOException, JsonProcessingException {
        jsonGenerator.writeStartObject();
        if (excess != null) {
            StringBuilder sb = new StringBuilder("<ul>");

            if(StringUtils.isNotBlank(excess.getBasicExcess())) {
                sb.append("<li>").append("Basic Excess");
                sb.append(" ").append("$" + excess.getBasicExcess());
                sb.append("</li>");
            }

            if(StringUtils.isNotBlank(excess.getGlassExcess())) {
                sb.append("<li>").append("Glass Excess");
                sb.append(" ").append("$" + excess.getGlassExcess());
                sb.append("</li>");
            }

            sb.append("</ul>");
            jsonGenerator.writeStringField("value", sb.toString());
        } else {
            jsonGenerator.writeStringField("value", "N");
            jsonGenerator.writeStringField("extra", "<ul>&nbsp;</ul>");
        }
        jsonGenerator.writeEndObject();
    }
}
