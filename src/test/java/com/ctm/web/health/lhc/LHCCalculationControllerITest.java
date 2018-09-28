package com.ctm.web.health.lhc;

import com.ctm.web.health.lhc.calculation.Constants;
import com.ctm.web.health.lhc.model.query.CoverDateRange;
import com.ctm.web.health.lhc.model.query.LHCBaseDateQuery;
import com.ctm.web.health.lhc.model.query.LHCCalculationDetails;
import com.ctm.web.health.lhc.model.query.LHCCalculationQuery;
import com.fasterxml.jackson.annotation.JsonInclude;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.datatype.jsr310.JavaTimeModule;
import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.powermock.modules.junit4.PowerMockRunner;
import org.powermock.modules.junit4.PowerMockRunnerDelegate;
import org.springframework.boot.test.SpringApplicationConfiguration;
import org.springframework.http.MediaType;
import org.springframework.mock.web.MockServletContext;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.springframework.test.context.web.WebAppConfiguration;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.setup.MockMvcBuilders;

import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.time.LocalDate;

import static org.mockito.MockitoAnnotations.initMocks;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

@RunWith(PowerMockRunner.class)
@PowerMockRunnerDelegate(SpringJUnit4ClassRunner.class)
@SpringApplicationConfiguration(classes = MockServletContext.class)
@WebAppConfiguration
public class LHCCalculationControllerITest {

    /**
     * MediaType for JSON UTF8
     */
    public static final MediaType APPLICATION_JSON_UTF8 = new MediaType(
            MediaType.APPLICATION_JSON.getType(),
            MediaType.APPLICATION_JSON.getSubtype(), StandardCharsets.UTF_8);
    private static final LocalDate DATE_OF_BIRTH = LocalDate.of(1981, 4, 1);
    private static final LocalDate BASE_DATE = LocalDate.of(2012, 7, 1);
    private static final LocalDate YESTERDAY = LocalDate.now().minusDays(1);
    private static final LocalDate LAST_WEEK = YESTERDAY.minusWeeks(1);
    private MockMvc mockMvc;
    private LHCCalculationController controllerUnderTest;

    /**
     * Convert an object to JSON byte array.
     *
     * @param object the object to convert
     * @return the JSON byte array
     * @throws IOException
     */
    public static byte[] convertObjectToJsonBytes(Object object)
            throws IOException {
        ObjectMapper mapper = new ObjectMapper();
        mapper.setSerializationInclusion(JsonInclude.Include.NON_NULL);
        JavaTimeModule module = new JavaTimeModule();
        mapper.registerModule(module);

        return mapper.writeValueAsBytes(object);
    }

    public static LHCCalculationDetails getValidCalculationDetails() {
        return new LHCCalculationDetails()
                .age(Constants.LHC_EXEMPT_AGE_CUT_OFF)
                .dateOfBirth(DATE_OF_BIRTH)
                .baseDate(BASE_DATE)
                .isContinuousCover(true)
                .lhcDaysApplicable(365)
                .isNeverHadCover(false);
    }

    @Before
    public void setUp() throws Exception {
        initMocks(this);
        controllerUnderTest = new LHCCalculationController();
        mockMvc = MockMvcBuilders.standaloneSetup(controllerUnderTest).build();
    }

    @Test
    public void givenLHCCalculationRequest_whenOnlyHasValidPrimaryApplicant_then200() throws Exception {

        LHCCalculationQuery lhcCalculationQuery = new LHCCalculationQuery()
                .primary(getValidCalculationDetails());

        mockMvc.perform(post("/lhc/calculate/post.json")
                .contentType(APPLICATION_JSON_UTF8)
                .content(convertObjectToJsonBytes(lhcCalculationQuery)))
                .andExpect(status().isOk());
    }

    @Test
    public void givenLHCCalculationRequest_whenHasValidPrimaryAndPartnerApplicant_then200() throws Exception {

        LHCCalculationQuery lhcCalculationQuery = new LHCCalculationQuery()
                .primary(getValidCalculationDetails())
                .partner(getValidCalculationDetails());

        mockMvc.perform(post("/lhc/calculate/post.json")
                .contentType(APPLICATION_JSON_UTF8)
                .content(convertObjectToJsonBytes(lhcCalculationQuery)))
                .andExpect(status().isOk());
    }

    @Test
    public void givenLHCCalculationRequest_whenDataEmpty_then400() throws Exception {

        LHCCalculationQuery lhcCalculationQuery = new LHCCalculationQuery();

        mockMvc.perform(post("/lhc/calculate/post.json")
                .contentType(APPLICATION_JSON_UTF8)
                .content(convertObjectToJsonBytes(lhcCalculationQuery)))
                .andExpect(status().isBadRequest());
    }

    @Test
    public void givenLHCCalculationRequest_whenPrimaryApplicantAgeIsNegative_then400() throws Exception {

        LHCCalculationQuery lhcCalculationQuery = new LHCCalculationQuery()
                .primary(getValidCalculationDetails().age(-1));

        mockMvc.perform(post("/lhc/calculate/post.json")
                .contentType(APPLICATION_JSON_UTF8)
                .content(convertObjectToJsonBytes(lhcCalculationQuery)))
                .andExpect(status().isBadRequest());
    }

    @Test
    public void givenLHCCalculationRequest_whenPartnerApplicantAgeIsNegative_then400() throws Exception {

        LHCCalculationQuery lhcCalculationQuery = new LHCCalculationQuery()
                .primary(getValidCalculationDetails())
                .partner(getValidCalculationDetails().age(-1));

        mockMvc.perform(post("/lhc/calculate/post.json")
                .contentType(APPLICATION_JSON_UTF8)
                .content(convertObjectToJsonBytes(lhcCalculationQuery)))
                .andExpect(status().isBadRequest());
    }

    @Test
    public void givenLHCCalculationRequest_whenPrimaryApplicantDOBIsNull_then400() throws Exception {

        LHCCalculationQuery lhcCalculationQuery = new LHCCalculationQuery()
                .primary(getValidCalculationDetails().dateOfBirth(null));

        mockMvc.perform(post("/lhc/calculate/post.json")
                .contentType(APPLICATION_JSON_UTF8)
                .content(convertObjectToJsonBytes(lhcCalculationQuery)))
                .andExpect(status().isBadRequest());
    }

    @Test
    public void givenLHCCalculationRequest_whenPartnerApplicantDOBIsNull_then400() throws Exception {

        LHCCalculationQuery lhcCalculationQuery = new LHCCalculationQuery()
                .primary(getValidCalculationDetails())
                .partner(getValidCalculationDetails().dateOfBirth(null));

        mockMvc.perform(post("/lhc/calculate/post.json")
                .contentType(APPLICATION_JSON_UTF8)
                .content(convertObjectToJsonBytes(lhcCalculationQuery)))
                .andExpect(status().isBadRequest());
    }

    @Test
    public void givenLHCCalculationRequest_whenPrimaryApplicantLHCDaysApplicableIsNegative_then400() throws Exception {

        LHCCalculationQuery lhcCalculationQuery = new LHCCalculationQuery()
                .primary(getValidCalculationDetails().lhcDaysApplicable(-1));

        mockMvc.perform(post("/lhc/calculate/post.json")
                .contentType(APPLICATION_JSON_UTF8)
                .content(convertObjectToJsonBytes(lhcCalculationQuery)))
                .andExpect(status().isBadRequest());
    }

    @Test
    public void givenLHCCalculationRequest_whenPartnerApplicantLHCDaysApplicableIsNegative_then400() throws Exception {

        LHCCalculationQuery lhcCalculationQuery = new LHCCalculationQuery()
                .primary(getValidCalculationDetails())
                .partner(getValidCalculationDetails().lhcDaysApplicable(-1));

        mockMvc.perform(post("/lhc/calculate/post.json")
                .contentType(APPLICATION_JSON_UTF8)
                .content(convertObjectToJsonBytes(lhcCalculationQuery)))
                .andExpect(status().isBadRequest());
    }

    @Test
    public void givenLHCCalculationRequest_whenPrimaryApplicantHasHadContinuousCoverAndNeverHadCover_then400() throws Exception {

        LHCCalculationQuery lhcCalculationQuery = new LHCCalculationQuery()
                .primary(getValidCalculationDetails().isContinuousCover(true)
                        .isNeverHadCover(true));

        mockMvc.perform(post("/lhc/calculate/post.json")
                .contentType(APPLICATION_JSON_UTF8)
                .content(convertObjectToJsonBytes(lhcCalculationQuery)))
                .andExpect(status().isBadRequest());
    }

    @Test
    public void givenLHCCalculationRequest_whenPartnerApplicantHasHadContinuousCoverAndNeverHadCover_then400() throws Exception {

        LHCCalculationQuery lhcCalculationQuery = new LHCCalculationQuery()
                .primary(getValidCalculationDetails())
                .partner(getValidCalculationDetails().isContinuousCover(true)
                        .isNeverHadCover(true));

        mockMvc.perform(post("/lhc/calculate/post.json")
                .contentType(APPLICATION_JSON_UTF8)
                .content(convertObjectToJsonBytes(lhcCalculationQuery)))
                .andExpect(status().isBadRequest());
    }

    @Test
    public void givenLHCCalculationRequest_whenPrimaryApplicantHasHadContinuousCoverNull_then400() throws Exception {

        LHCCalculationQuery lhcCalculationQuery = new LHCCalculationQuery()
                .primary(getValidCalculationDetails().isContinuousCover(null));

        mockMvc.perform(post("/lhc/calculate/post.json")
                .contentType(APPLICATION_JSON_UTF8)
                .content(convertObjectToJsonBytes(lhcCalculationQuery)))
                .andExpect(status().isBadRequest());
    }

    @Test
    public void givenLHCCalculationRequest_whenPrimaryApplicantHasHadContinuousCover_neverHadCoverIsNull_then400() throws Exception {

        LHCCalculationQuery lhcCalculationQuery = new LHCCalculationQuery()
                .primary(getValidCalculationDetails().isNeverHadCover(null));

        mockMvc.perform(post("/lhc/calculate/post.json")
                .contentType(APPLICATION_JSON_UTF8)
                .content(convertObjectToJsonBytes(lhcCalculationQuery)))
                .andExpect(status().isBadRequest());
    }

    @Test
    public void givenLHCCalculationRequest_whenPrimaryApplicantHasNeverContinuousCoverAndNeverHadCover_then200() throws Exception {

        LHCCalculationQuery lhcCalculationQuery = new LHCCalculationQuery()
                .primary(getValidCalculationDetails().isContinuousCover(false)
                        .isNeverHadCover(false));

        mockMvc.perform(post("/lhc/calculate/post.json")
                .contentType(APPLICATION_JSON_UTF8)
                .content(convertObjectToJsonBytes(lhcCalculationQuery)))
                .andExpect(status().isOk());
    }

    @Test
    public void givenLHCCalculationRequest_whenPartnerApplicantHasNeverContinuousCoverAndNeverHadCover_then200() throws Exception {

        LHCCalculationQuery lhcCalculationQuery = new LHCCalculationQuery()
                .primary(getValidCalculationDetails())
                .partner(getValidCalculationDetails().isContinuousCover(false)
                        .isNeverHadCover(false));

        mockMvc.perform(post("/lhc/calculate/post.json")
                .contentType(APPLICATION_JSON_UTF8)
                .content(convertObjectToJsonBytes(lhcCalculationQuery)))
                .andExpect(status().isOk());
    }

    @Test
    public void givenLHCCalculationRequest_whenCoverDateIsPresentAndFromDateIsNull_then400() throws Exception {

        LHCCalculationQuery lhcCalculationQuery = new LHCCalculationQuery()
                .primary(getValidCalculationDetails()
                        .addCoverDateRange(new CoverDateRange().from(LocalDate.now())));

        mockMvc.perform(post("/lhc/calculate/post.json")
                .contentType(APPLICATION_JSON_UTF8)
                .content(convertObjectToJsonBytes(lhcCalculationQuery)))
                .andExpect(status().isBadRequest());
    }

    @Test
    public void givenLHCCalculationRequest_whenCoverDateIsPresentAndToDateIsNull_then400() throws Exception {

        LHCCalculationQuery lhcCalculationQuery = new LHCCalculationQuery()
                .primary(getValidCalculationDetails()
                        .addCoverDateRange(new CoverDateRange().to(LocalDate.now())));

        mockMvc.perform(post("/lhc/calculate/post.json")
                .contentType(APPLICATION_JSON_UTF8)
                .content(convertObjectToJsonBytes(lhcCalculationQuery)))
                .andExpect(status().isBadRequest());
    }

    @Test
    public void givenLHCCalculationRequest_whenCoverDateToDateIsAfterFromDate_then200() throws Exception {


        LHCCalculationQuery lhcCalculationQuery = new LHCCalculationQuery()
                .primary(getValidCalculationDetails()
                        .addCoverDateRange(new CoverDateRange().from(LAST_WEEK).to(YESTERDAY)));

        mockMvc.perform(post("/lhc/calculate/post.json")
                .contentType(APPLICATION_JSON_UTF8)
                .content(convertObjectToJsonBytes(lhcCalculationQuery)))
                .andExpect(status().isOk());
    }

    @Test
    public void givenLHCCalculationRequest_whenCoverDateToDateEqualsFromDate_then200() throws Exception {

        LHCCalculationQuery lhcCalculationQuery = new LHCCalculationQuery()
                .primary(getValidCalculationDetails()
                        .addCoverDateRange(new CoverDateRange().from(YESTERDAY).to(YESTERDAY)));

        mockMvc.perform(post("/lhc/calculate/post.json")
                .contentType(APPLICATION_JSON_UTF8)
                .content(convertObjectToJsonBytes(lhcCalculationQuery)))
                .andExpect(status().isOk());
    }

    @Test
    public void givenLHCCalculationRequest_whenCoverDateToDateIsBeforeFromDate_then400() throws Exception {

        LHCCalculationQuery lhcCalculationQuery = new LHCCalculationQuery()
                .primary(getValidCalculationDetails()
                        .addCoverDateRange(new CoverDateRange().from(YESTERDAY).to(LAST_WEEK)));

        mockMvc.perform(post("/lhc/calculate/post.json")
                .contentType(APPLICATION_JSON_UTF8)
                .content(convertObjectToJsonBytes(lhcCalculationQuery)))
                .andExpect(status().isBadRequest());
    }

    @Test
    public void givenLHCBaseDateRequest_whenBothPrimaryAndPartnerDOBSet_then200() throws Exception {

        LHCBaseDateQuery baseDateQuery = new LHCBaseDateQuery()
                .primaryDOB(LAST_WEEK)
                .partnerDOB(YESTERDAY);

        mockMvc.perform(post("/lhc/base-dates/post.json")
                .contentType(APPLICATION_JSON_UTF8)
                .content(convertObjectToJsonBytes(baseDateQuery)))
                .andExpect(status().isOk());
    }

    @Test
    public void givenLHCBaseDateRequest_whenOnlyPrimaryDOB_then200() throws Exception {

        LHCBaseDateQuery baseDateQuery = new LHCBaseDateQuery()
                .primaryDOB(LAST_WEEK);

        mockMvc.perform(post("/lhc/base-dates/post.json")
                .contentType(APPLICATION_JSON_UTF8)
                .content(convertObjectToJsonBytes(baseDateQuery)))
                .andExpect(status().isOk());
    }

    @Test
    public void givenLHCBaseDateRequest_whenEmptyData_then400() throws Exception {

        LHCBaseDateQuery baseDateQuery = new LHCBaseDateQuery();

        mockMvc.perform(post("/lhc/base-dates/post.json")
                .contentType(APPLICATION_JSON_UTF8)
                .content(convertObjectToJsonBytes(baseDateQuery)))
                .andExpect(status().isBadRequest());
    }
}