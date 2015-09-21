package com.ctm.providers.health.healthapply.model.helper;

import com.fasterxml.jackson.core.JsonGenerator;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.JsonSerializer;
import com.fasterxml.jackson.databind.SerializerProvider;

import java.io.IOException;
import java.util.Optional;
import java.util.function.Supplier;

public class TypeSerializer extends JsonSerializer<Supplier> {

    @Override
    public void serialize(Supplier valueType, JsonGenerator jsonGenerator, SerializerProvider serializerProvider) throws IOException, JsonProcessingException {
        if (valueType != null) {
            jsonGenerator.writeObject(valueType.get());
        }
    }

    @Override
    public boolean isEmpty(Supplier value) {
        if (value != null) {
            if (value.get() instanceof Optional) {
                return !((Optional)value.get()).isPresent();
            }
            return false;
        }
        return true;
    }
}
