package com.ctm.web.health.apply.model;

import com.ctm.schema.health.v1_0_0.ApplyRequest;
import com.ctm.schema.serialisation.SchemaObjectMapper;
import com.ctm.web.core.exceptions.DaoException;
import com.ctm.web.health.exceptions.HealthApplyServiceException;
import com.ctm.web.health.model.form.HealthRequest;
import com.ctm.web.health.model.results.HealthQuoteResult;
import com.fasterxml.jackson.databind.DeserializationFeature;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.google.common.base.Charsets;
import com.google.common.io.Resources;
import io.jsonwebtoken.lang.Assert;
import org.json.JSONException;
import org.junit.Test;
import org.skyscreamer.jsonassert.JSONAssert;

import java.io.IOException;
import java.net.URISyntaxException;
import java.time.Instant;
import java.time.LocalDateTime;
import java.time.ZoneId;
import java.time.ZonedDateTime;
import java.util.Optional;

public class RequestAdapterTest {

    private ObjectMapper MAPPER = SchemaObjectMapper.getInstance()
            .configure(DeserializationFeature.FAIL_ON_UNKNOWN_PROPERTIES, false);

    @Test
    public void givenValidHealthRequestAndSelectedProduct_whenRequestAdapted_thenValidSchematicRequestIsReturned() throws IOException, HealthApplyServiceException, DaoException, JSONException {
        HealthRequest healthRequest = MAPPER.readValue(Resources.getResource("com/ctm/web/health/apply/model/healthRequest.json"), HealthRequest.class);
        HealthQuoteResult healthSelectedProduct = MAPPER.readValue(Resources.getResource("com/ctm/web/health/apply/model/healthSelectedProduct.json"), HealthQuoteResult.class);
        String expectedRequest = Resources.toString(Resources.getResource("com/ctm/web/health/apply/model/schematicApplyRequest.json"), Charsets.UTF_8);
        ApplyRequest request = RequestAdapter.adapt(healthRequest, healthSelectedProduct, "test.user", null, null, "ctm");

        String result = MAPPER.writeValueAsString(request);

        Assert.notNull(request);
        JSONAssert.assertEquals(expectedRequest, result, false);
    }
}