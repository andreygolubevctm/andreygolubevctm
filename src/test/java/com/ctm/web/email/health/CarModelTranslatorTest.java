package com.ctm.web.email.health;

import com.ctm.web.core.web.go.Data;
import com.ctm.web.core.web.go.xml.XmlNode;
import org.junit.Test;

import javax.validation.ValidationException;

import static org.junit.Assert.assertEquals;

/**
 * Responsible for testing CarModelTranslator.
 *
 * @See test/resources/email/car for example session data for different cases.
 */
public class CarModelTranslatorTest {

    public static final String BUDD_05_04 = "BUDD-05-04";
    public static final String BUDD_05_04_TPPD = "BUDD-05-04_TPPD";

    @Test
    public void givenSessionDataWithSingleTransaction_whenGetPremium_thenReturnValidPremium() {

        //given
        final Data sessionData = new Data();
        final XmlNode xmlNodeTempResultDetailsForComprehensiveCover = getXmlNodeForTempResultDetails(BUDD_05_04, 1111);
        sessionData.addChild(xmlNodeTempResultDetailsForComprehensiveCover);

        //when
        final String premiumFromSessionData = CarModelTranslator.getPremiumFromSessionData(sessionData, BUDD_05_04);

        //then
        assertEquals("1111", premiumFromSessionData);
    }

    @Test
    public void givenSessionDataWithMultipleTransactionsButDifferentCoverType_whenGetPremium_thenReturnValidPremium() {

        //given
        final Data sessionData = new Data();
        final XmlNode xmlNodeTempResultDetailsForComprehensiveCover = getXmlNodeForTempResultDetails(BUDD_05_04, 1111);
        final XmlNode xmlNodeTempResultDetailsForThirdPartyCover = getXmlNodeForTempResultDetails(BUDD_05_04_TPPD, 800);
        //multiple transactions but of different cover type hence different product ids.
        sessionData.addChild(xmlNodeTempResultDetailsForComprehensiveCover);
        sessionData.addChild(xmlNodeTempResultDetailsForThirdPartyCover);

        //when
        final String premiumFromSessionDataComprehensiveCover = CarModelTranslator.getPremiumFromSessionData(sessionData, BUDD_05_04);
        final String premiumFromSessionDataThirdPartyCover = CarModelTranslator.getPremiumFromSessionData(sessionData, BUDD_05_04_TPPD);

        //then
        assertEquals(2, sessionData.size());
        assertEquals("1111", premiumFromSessionDataComprehensiveCover);
        assertEquals("800", premiumFromSessionDataThirdPartyCover);
    }

    @Test
    public void givenSessionDataWithMultipleTransactionsWithSameCoverType_whenGetPremium_thenReturnValidPremium() {

        //given
        final Data sessionData = new Data();
        final XmlNode xmlNodeTempResultDetailsForComprehensiveCover = getXmlNodeForTempResultDetails(BUDD_05_04, 1111);
        final XmlNode xmlNodeTempResultDetailsForComprehensiveCoverEdited1 = getXmlNodeForTempResultDetails(BUDD_05_04, 2222);
        final XmlNode xmlNodeTempResultDetailsForComprehensiveCoverEdited2 = getXmlNodeForTempResultDetails(BUDD_05_04, 3333);
        //multiple transactions
        sessionData.addChild(xmlNodeTempResultDetailsForComprehensiveCover);
        sessionData.addChild(xmlNodeTempResultDetailsForComprehensiveCoverEdited1);
        sessionData.addChild(xmlNodeTempResultDetailsForComprehensiveCoverEdited2);

        //when
        final String premiumFromSessionData = CarModelTranslator.getPremiumFromSessionData(sessionData, BUDD_05_04);

        //then
        assertEquals(3, sessionData.size());
        assertEquals("3333", premiumFromSessionData);
    }

    @Test(expected = ValidationException.class)
    public void givenEmptySessionData_whenGetPremium_thenThrowException() {
        //given
        final Data sessionData = new Data();
        //when
        CarModelTranslator.getPremiumFromSessionData(sessionData, BUDD_05_04);
        //then exception thrown
    }

    /* ***********************************************************************************************************
     * Helper methods
     */

    private XmlNode getXmlNodeForTempResultDetails(final String productId, final Integer lumpSumTotal) {
        final XmlNode xmlNodeTempResultDetails = new XmlNode("tempResultDetails");
        xmlNodeTempResultDetails
                .addChild(new XmlNode("results"))
                .addChild(new XmlNode(productId))
                .addChild(new XmlNode("headline"))
                .put("lumpSumTotal", lumpSumTotal);
        return xmlNodeTempResultDetails;
    }
}
