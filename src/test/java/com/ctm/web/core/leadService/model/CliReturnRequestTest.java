package com.ctm.web.core.leadService.model;

import com.ctm.httpclient.jackson.DefaultJacksonMappers;
import com.ctm.interfaces.common.util.SerializationMappers;
import com.ctm.web.core.model.settings.Vertical;
import com.fasterxml.jackson.core.type.TypeReference;
import com.google.common.base.Charsets;
import com.google.common.io.Resources;
import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.converter.json.Jackson2ObjectMapperBuilder;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import java.io.IOException;
import static org.junit.Assert.*;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(classes = {DefaultJacksonMappers.class, Jackson2ObjectMapperBuilder.class})
public class CliReturnRequestTest {

	@Autowired
	private SerializationMappers jacksonMappers;

	@Before
	public void setUp() {
	}

	@Test
	public void validCliReturnRequestTest() throws IOException {
		CliReturnRequest request = createLeadRequest("com/ctm/web/core.leadService.model/cli_return_request_good.json");
		assertTrue(request.getPhone().equals("0419123456"));
		assertTrue(request.getStyleCodeId().equals(1));
		assertTrue(request.getVertical().equals(Vertical.VerticalType.HEALTH));
	}

	@Test(expected = NullPointerException.class)
	public void invalidCliReturnRequestTest() throws IOException {
		CliReturnRequest request = createLeadRequest("com/ctm/web/core.leadService.model/cli_return_request_bad.json");
		assertTrue(request.getPhone().equals("0419123456"));
		assertTrue(request.getStyleCodeId().equals(1));
		assertTrue(request.getVertical().equals(Vertical.VerticalType.HEALTH));
	}

	private CliReturnRequest createLeadRequest(final String jsonFile) throws IOException {
		final TypeReference<CliReturnRequest> typeReference = new TypeReference<CliReturnRequest>(){};
		final String json = Resources.toString(Resources.getResource(jsonFile), Charsets.UTF_8);
		return jacksonMappers.getJsonMapper().readValue(json, typeReference);
	}
}
