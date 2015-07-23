package com.ctm.providers.travel.travelquote.model.response;

import com.fasterxml.jackson.core.JsonGenerator;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.JsonSerializer;
import com.fasterxml.jackson.databind.SerializerProvider;

import java.io.IOException;

import static org.apache.commons.lang3.StringUtils.EMPTY;

public class BenefitTypeSerializer extends JsonSerializer<BenefitType> {

    @Override
    public void serialize(final BenefitType benefitType, final JsonGenerator jsonGenerator, final SerializerProvider serializerProvider) throws IOException, JsonProcessingException {
        if (benefitType != null) {
            jsonGenerator.writeString(benefitType.getBenefitName());
        } else {
            jsonGenerator.writeString(EMPTY);
        }
    }
}
