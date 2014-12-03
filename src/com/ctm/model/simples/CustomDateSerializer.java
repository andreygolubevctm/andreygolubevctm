package com.ctm.model.simples;

import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;

import com.fasterxml.jackson.core.JsonGenerator;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.JsonSerializer;
import com.fasterxml.jackson.databind.SerializerProvider;

public class CustomDateSerializer extends JsonSerializer<Date> {
	@Override
	public void serialize(final Date date, final JsonGenerator jsonGenerator, final SerializerProvider serializerProvider) throws IOException, JsonProcessingException {
		jsonGenerator.writeString(new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss").format(date));
	}
}
