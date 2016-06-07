package com.ctm.web.health.router;

import com.ctm.web.core.utils.ObjectMapperUtil;
import com.ctm.web.health.confirmation.model.ConfirmationData;
import com.ctm.web.health.model.providerInfo.ProviderInfo;
import org.apache.commons.io.IOUtils;
import org.custommonkey.xmlunit.XMLUnit;
import org.junit.Test;

import java.time.LocalDate;
import java.time.Month;

import static org.junit.Assert.assertTrue;

public class ConfirmationDataTest {

    @Test
    public void testConfirmData() throws Exception {

        String firstName = "Test";
        String lastName = "O'Testing";
        String providerEmail = "ahm.com.au";
        String providerPhoneNumber = "134 246";
        String providerWebsite = "";
        ProviderInfo providerInfo = ProviderInfo.newProviderInfo()
                .email(providerEmail)
                .phoneNumber(providerPhoneNumber).website(providerWebsite).build();
        final ConfirmationData confirmationData = ConfirmationData.newConfirmationData()
                .transID("2643064")
                .startDate(LocalDate.of(2015, Month.SEPTEMBER, 24))
                .frequency("M").about( "<ul> \t\t<li>HIF is all about choice. Choice of cover, choice of providers, " +
                        "choice of ways to claim, and more.</li> \t\t<li>HIF is one of Australia's most affordable health funds, " +
                        "with Extras cover starting from a tiny 50 cents per day.</li> \t\t<li>HIF is a not-for-profit, 100% member " +
                        "based organisation which is committed to providing excellent value for money.</li> \t\t<li>HIF is Australia's " +
                        "first and only certified Carbon Neutral health fund.</li> \t\t<li>HIF members with top Hospital + Extras cover " +
                        "can access HIF's exclusive 'Second Opinion' service at no additional cost.</li> \t</ul>")
                .whatsNext(  "<ul> \t\t<li>HIF will send a welcome letter to your nominated email address within ten working days of receiving " +
                        "your application. The welcome letter will confirm all the details of your new HIF health policy, so please take a few " +
                        "minutes to read it carefully.</li> \t\t<li>Your first premium will be deducted on the date you have chosen today. " +
                        "Please note that if your nominated payment date is different to your nominated commencement date, " +
                        "your initial premium will include any arrears incurred between your commencement date and the deduction " +
                                   "\"providerPhoneNumber\":\"1300 134 060\",\"extrasPDF\":\"health_brochure.jsp?pdf=/HIF/SpecialOptions.pdf\"," +
                                "\"discountText\":\"HIF offer 4% discount for annual payment and 2% for half-yearly\"}"
                        )
                .providerInfo(providerInfo)
                .firstName(firstName)
                .lastName(lastName)
                .product("test")
                .policyNo("12334")
                .build();

        final String actual = ObjectMapperUtil.getXmlMapper().writeValueAsString(confirmationData);

        String expected = IOUtils.toString(getClass().getResourceAsStream("/router/confirmationData.xml"));

        XMLUnit.setIgnoreWhitespace(true);
        assertTrue(XMLUnit.compareXML(expected, actual).identical());
    }

}