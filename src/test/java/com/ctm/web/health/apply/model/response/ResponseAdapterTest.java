package com.ctm.web.health.apply.model.response;

import com.ctm.schema.health.v1_0_0.ApplyResponse;
import com.ctm.schema.serialisation.SchemaObjectMapper;
import com.fasterxml.jackson.databind.DeserializationFeature;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.google.common.base.Charsets;
import com.google.common.io.Resources;
import io.jsonwebtoken.lang.Assert;
import org.json.JSONException;
import org.junit.Test;
import org.skyscreamer.jsonassert.JSONAssert;

import java.io.IOException;

public class ResponseAdapterTest {

    private ObjectMapper MAPPER = SchemaObjectMapper.getInstance()
            .configure(DeserializationFeature.FAIL_ON_UNKNOWN_PROPERTIES, false);

    @Test
    public void givenSuccessfulSchematicHealthResponse_whenResponseAdapted_thenValidHealthResponseIsReturned() throws IOException, JSONException {
        ApplyResponse schematicApplyResponse = MAPPER.readValue(Resources.getResource("com/ctm/web/health/apply/model/schematicApplyResponse_success.json"), ApplyResponse.class);
        String expectedResponse = Resources.toString(Resources.getResource("com/ctm/web/health/apply/model/healthApplyResponse_success.json"), Charsets.UTF_8);
        HealthApplyResponse response = ResponseAdapter.adapt(123456L, schematicApplyResponse);

        String result = MAPPER.writeValueAsString(response);

        Assert.notNull(response);
        JSONAssert.assertEquals(expectedResponse, result, false);
    }

    @Test
    public void givenFailedSchematicHealthResponse_whenResponseAdapted_thenValidHealthResponseIsReturned() throws IOException, JSONException {
        ApplyResponse schematicApplyResponse = MAPPER.readValue(Resources.getResource("com/ctm/web/health/apply/model/schematicApplyResponse_fail.json"), ApplyResponse.class);
        String expectedResponse = Resources.toString(Resources.getResource("com/ctm/web/health/apply/model/healthApplyResponse_fail.json"), Charsets.UTF_8);
        HealthApplyResponse response = ResponseAdapter.adapt(123456L, schematicApplyResponse);

        String result = MAPPER.writeValueAsString(response);

        Assert.notNull(response);
        JSONAssert.assertEquals(expectedResponse, result, false);
    }
}
