package com.ctm.web.core.web.homecontents;

import com.ctm.test.controller.BaseControllerTest;
import com.ctm.web.core.security.StringEncryption;
import com.ctm.web.core.transaction.dao.TransactionDetailsDao;
import com.ctm.web.core.transaction.model.TransactionDetail;
import com.ctm.web.homecontents.controller.HomeContentsTransactionController;
import com.ctm.web.simples.services.TransactionDetailService;
import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.powermock.core.classloader.annotations.PowerMockIgnore;
import org.powermock.core.classloader.annotations.PrepareForTest;
import org.powermock.modules.junit4.PowerMockRunner;
import org.powermock.modules.junit4.PowerMockRunnerDelegate;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.boot.test.SpringApplicationConfiguration;
import org.springframework.mock.web.MockServletContext;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.springframework.test.context.web.WebAppConfiguration;
import org.springframework.test.util.ReflectionTestUtils;
import org.springframework.test.web.servlet.request.MockMvcRequestBuilders;
import wiremock.org.apache.commons.lang.math.RandomUtils;

import java.security.GeneralSecurityException;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.Optional;

import static com.ctm.web.homecontents.controller.HomeContentsTransactionController.URI_TRANSACTION_ID;
import static org.junit.Assert.assertTrue;
import static org.mockito.BDDMockito.given;
import static org.mockito.Matchers.any;
import static org.mockito.MockitoAnnotations.initMocks;
import static org.springframework.http.MediaType.APPLICATION_JSON_VALUE;
import static org.springframework.test.web.servlet.result.MockMvcResultHandlers.print;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.content;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

/**
 * Created by xna on 22/08/17.
 */
@RunWith(PowerMockRunner.class)
@PowerMockRunnerDelegate(SpringJUnit4ClassRunner.class)
@PowerMockIgnore({"javax.crypto.*"})
@SpringApplicationConfiguration(classes = MockServletContext.class)
@WebAppConfiguration
@PrepareForTest({HomeContentsTransactionController.class})
public class HomeContentsTransactionControllerTest extends BaseControllerTest {

    private static final Logger LOGGER = LoggerFactory.getLogger(HomeContentsTransactionControllerTest.class);

    @Mock
    TransactionDetailService transactionDetailService;

    @Mock
    private TransactionDetailsDao transactionDetailsDao;

    @InjectMocks
    private HomeContentsTransactionController transactionController;

    private final String secretKey = "UyNf-Kh4jnzztSZQI8Z6Wg";
    private final Long transactionId = RandomUtils.nextLong();
    private final List<TransactionDetail> transactionDetails = new ArrayList<>();

    @Before
    public void setUp() throws Exception {
        initMocks(this);
        setUp(transactionController);

        given(this.transactionDetailService.getTransactionDetailsInMap(any())).willCallRealMethod();
        given(this.transactionDetailService.getTransactionDetailsInXmlData(any())).willCallRealMethod();
        ReflectionTestUtils.setField(transactionDetailService, "transactionDetailsDao", transactionDetailsDao);
        ReflectionTestUtils.setField(transactionController, "secretKey", secretKey);

        // init mock result data
        transactionDetails.add(new TransactionDetail("home/property/address/unitType", "SH"));
        transactionDetails.add(new TransactionDetail("home/property/address/type", "R"));
        transactionDetails.add(new TransactionDetail("home/property/address/lastSearch", "13/9 Sherwood Road, Toowong, QLD, 4066"));
        transactionDetails.add(new TransactionDetail("home/property/address/state", "QLD"));
        transactionDetails.add(new TransactionDetail("home/property/address/unitSel", "13"));
        transactionDetails.add(new TransactionDetail("home/property/address/autofilllessSearch", "13/9 Sherwood Road, Toowong, QLD, 4066"));
        transactionDetails.add(new TransactionDetail("home/coverAmounts/rebuildCostentry", "$150,000"));
        transactionDetails.add(new TransactionDetail("home/baseContentsExcess", "500"));
        transactionDetails.add(new TransactionDetail("home/policyHolder/title", "MR"));
        transactionDetails.add(new TransactionDetail("home/policyHolder/firstName", "Meerkat"));
        transactionDetails.add(new TransactionDetail("home/policyHolder/lastName", "Manor"));
    }

    /**
     * Dependency "com.jayway.jsonpath:json-path" is excluded by "com.github.tomakehurst:wiremock"
     * Therefore, here we can't assert values by JsonPath
     * {@link org.springframework.test.util.JsonPathExpectationsHelper#JsonPathExpectationsHelper(String, Object...) }
     */
    @Test
    public void givenEncryptedTransationId_whenGettingTransaction_thenDetailsReturnedInJson() throws Exception {

        given(this.transactionDetailsDao.getTransactionDetails(transactionId)).willReturn(transactionDetails);

        // encrypt transaction id
        final Optional<String> optEncryptedTransactionId = this.encrypt(transactionId);
        assertTrue("Transaction ID should be encrypted", optEncryptedTransactionId.isPresent());

        mvc.perform(
                MockMvcRequestBuilders
                        .get(URI_TRANSACTION_ID, optEncryptedTransactionId.get())
                        .accept(APPLICATION_JSON_VALUE))
                .andDo(print())
                .andExpect(status().isOk())
                .andExpect(content().contentType(APPLICATION_JSON_VALUE));
        // .andExpect(jsonPath("$.home.baseContentsExcess").value(500))
        // .andExpect(jsonPath("$.home.property.address.state").value("QLD"))
        // .andExpect(jsonPath("$.home.policyHolder.firstName").value("Meerkat"));
    }

    @Test
    public void givenEmptyTransactionDetails_whenGettingTransaction_thenIs404NotFound() throws Exception {

        given(this.transactionDetailsDao.getTransactionDetails(transactionId)).willReturn(Collections.emptyList());

        // encrypt transaction id
        final Optional<String> optEncryptedTransactionId = this.encrypt(transactionId);
        assertTrue("Transaction ID should be encrypted", optEncryptedTransactionId.isPresent());

        mvc.perform(
                MockMvcRequestBuilders
                        .get(URI_TRANSACTION_ID, optEncryptedTransactionId.get())
                        .accept(APPLICATION_JSON_VALUE))
                .andDo(print())
                .andExpect(status().isNotFound())
                .andExpect(content().contentType(APPLICATION_JSON_VALUE));
    }


    @Test
    public void givenBadEncryptedId_whenGettingTransaction_thenIs400BadRequest() throws Exception {

        // encrypt transaction id
        final String badEncryptedTransactionId = "abcd";

        mvc.perform(
                MockMvcRequestBuilders
                        .get(URI_TRANSACTION_ID, badEncryptedTransactionId)
                        .accept(APPLICATION_JSON_VALUE))
                .andDo(print())
                .andExpect(status().isBadRequest())
                .andExpect(content().contentType(APPLICATION_JSON_VALUE));
    }


    private Optional<String> encrypt(Long transactionId) {
        try {
            return Optional.of(StringEncryption.encrypt(secretKey, transactionId.toString()));
        } catch (GeneralSecurityException e) {
            LOGGER.error("Failed to encrypt Transaction ID [{}]. Reason: {}", transactionId, e.getMessage(), e);
            return Optional.empty();
        }
    }

}