package com.ctm.web.health.router;

import com.ctm.web.core.utils.ObjectMapperUtil;
import org.apache.commons.io.IOUtils;
import org.custommonkey.xmlunit.XMLUnit;
import org.junit.Test;

import java.time.LocalDate;
import java.time.Month;

public class ConfirmationDataTest {

    @Test
    public void testConfirmData() throws Exception {

        final ConfirmationData confirmationData = new ConfirmationData(
                "2643064",
                LocalDate.of(2015, Month.SEPTEMBER, 24),
                "M",
                "<ul> \t\t<li>HIF is all about choice. Choice of cover, choice of providers, choice of ways to claim, and more.</li> \t\t<li>HIF is one of Australia's most affordable health funds, with Extras cover starting from a tiny 50 cents per day.</li> \t\t<li>HIF is a not-for-profit, 100% member based organisation which is committed to providing excellent value for money.</li> \t\t<li>HIF is Australia's first and only certified Carbon Neutral health fund.</li> \t\t<li>HIF members with top Hospital + Extras cover can access HIF's exclusive 'Second Opinion' service at no additional cost.</li> \t</ul>",
                "<ul> \t\t<li>HIF will send a welcome letter to your nominated email address within ten working days of receiving your application. The welcome letter will confirm all the details of your new HIF health policy, so please take a few minutes to read it carefully.</li> \t\t<li>Your first premium will be deducted on the date you have chosen today. Please note that if your nominated payment date is different to your nominated commencement date, your initial premium will include any arrears incurred between your commencement date and the deduction of your first direct debit in addition to your standard payment which is based on the frequency you have selected.</li> \t\t<li>Future payments will be debited as standard from that point onwards based on your chosen payment frequency.</li> \t\t<li>Should you wish to change your Direct Debit arrangement, payment frequency or product selection at any stage in your relationship with HIF, please call the fund directly or login to their online member services area.</li> \t\t<li><strong>Important:</strong> If you are switching to HIF and still have a Direct Debit arrangement in place with your previous fund, we suggest that you cancel the arrangement as soon as possible. You may be able to do this through your previous fund's online member service area.</li> \t</ul>",
                "\"price\":[{\"promo\":{\"promoText\":\"\",\"hospitalPDF\":\"health_brochure.jsp?pdf=/HIF/GoldStarterHospital.pdf\",\"providerPhoneNumber\":\"1300 134 060\",\"extrasPDF\":\"health_brochure.jsp?pdf=/HIF/SpecialOptions.pdf\",\"discountText\":\"HIF offer 4% discount for annual payment and 2% for half-yearly\"}",
                "118966");

        final String actual = ObjectMapperUtil.getXmlMapper().writeValueAsString(confirmationData);

        String expected = IOUtils.toString(getClass().getResourceAsStream("/router/confirmationData.xml"));

        XMLUnit.setIgnoreWhitespace(true);
        XMLUnit.compareXML(expected, actual);
    }

}