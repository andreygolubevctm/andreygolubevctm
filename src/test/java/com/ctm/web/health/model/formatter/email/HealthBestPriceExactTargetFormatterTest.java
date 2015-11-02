package com.ctm.web.health.model.formatter.email;

import com.ctm.web.core.email.model.ExactTargetEmailModel;
import com.ctm.web.core.utils.EmailTestUtils;
import com.ctm.web.health.model.email.HealthBestPriceEmailModel;
import org.junit.Test;

import java.util.Map;

import static org.junit.Assert.assertEquals;
public class HealthBestPriceExactTargetFormatterTest {

	private class HealthBestPriceExactTargetFormatterStub extends HealthBestPriceExactTargetFormatter{
		public ExactTargetEmailModel formatXml(HealthBestPriceEmailModel model) {
			return super.formatXml(model);
		}
	}

	@Test
	public void testShouldFormatModelForExactTarget() {

		HealthBestPriceExactTargetFormatterStub formatter = new HealthBestPriceExactTargetFormatterStub();

		ExactTargetEmailModel result = formatter.formatXml(EmailTestUtils.newBestPriceEmailModel());

		Map<String, String> resultAttributes = result.getAttributes();
		assertEquals(resultAttributes.get("FirstName"), EmailTestUtils.firstName);
		assertEquals(resultAttributes.get("LastName"), "");
		assertEquals(resultAttributes.get("OptIn"), EmailTestUtils.optInVar);
		assertEquals(resultAttributes.get("Brand"), EmailTestUtils.brand);
		assertEquals(resultAttributes.get("QuoteReference"), String.valueOf(EmailTestUtils.quoteReference));
		assertEquals(resultAttributes.get("PhoneNumber"), EmailTestUtils.phoneNumber);
		assertEquals( EmailTestUtils.applyURL , resultAttributes.get("ApplyURL1"));
		assertEquals( EmailTestUtils.applyURL ,resultAttributes.get("ApplyURL2"));
		assertEquals( EmailTestUtils.applyURL ,resultAttributes.get("ApplyURL3"));
		assertEquals( EmailTestUtils.applyURL ,resultAttributes.get("ApplyURL4"));
		assertEquals( EmailTestUtils.applyURL ,resultAttributes.get("ApplyURL5"));

		assertEquals(resultAttributes.get("CallcentreHours"), EmailTestUtils.callcentreHours);

		assertEquals(resultAttributes.get("CoverType1"), EmailTestUtils.coverType1);

		assertEquals(resultAttributes.get("PhoneNumber1"), EmailTestUtils.phoneNumber);
		assertEquals(resultAttributes.get("PhoneNumber2"), EmailTestUtils.phoneNumber);
		assertEquals(resultAttributes.get("PhoneNumber3"), EmailTestUtils.phoneNumber);
		assertEquals(resultAttributes.get("PhoneNumber4"), EmailTestUtils.phoneNumber);
		assertEquals(resultAttributes.get("PhoneNumber5"), EmailTestUtils.phoneNumber);

		assertEquals(EmailTestUtils.premium1, resultAttributes.get("Premium1"));
		assertEquals(resultAttributes.get("Premium2"), EmailTestUtils.premium2);
		assertEquals(resultAttributes.get("Premium3"), EmailTestUtils.premium3);
		assertEquals(resultAttributes.get("Premium4"), EmailTestUtils.premium4);
		assertEquals(resultAttributes.get("Premium5"), EmailTestUtils.premium5);

		assertEquals(resultAttributes.get("PremiumFrequency"), EmailTestUtils.premiumFrequency);


		assertEquals(EmailTestUtils.premiumLabel1, resultAttributes.get("PremiumLabel1"));
		assertEquals(resultAttributes.get("PremiumLabel2"), EmailTestUtils.premiumLabel2);
		assertEquals(resultAttributes.get("PremiumLabel3"), EmailTestUtils.premiumLabel3);
		assertEquals(resultAttributes.get("PremiumLabel4"), EmailTestUtils.premiumLabel4);
		assertEquals(resultAttributes.get("PremiumLabel5"), EmailTestUtils.premiumLabel5);

		assertEquals(EmailTestUtils.provider1, resultAttributes.get("Provider1"));
		assertEquals(resultAttributes.get("Provider2"), EmailTestUtils.provider2);
		assertEquals(resultAttributes.get("Provider3"), EmailTestUtils.provider3);
		assertEquals(resultAttributes.get("Provider4"), EmailTestUtils.provider4);
		assertEquals(EmailTestUtils.provider5, resultAttributes.get("Provider5"));

		assertEquals(resultAttributes.get("SmallLogo1"), EmailTestUtils.provider1ImageUrl);
		assertEquals(resultAttributes.get("SmallLogo2"), EmailTestUtils.provider2ImageUrl);
		assertEquals(resultAttributes.get("SmallLogo3"), EmailTestUtils.provider3ImageUrl);
		assertEquals(resultAttributes.get("SmallLogo4"), EmailTestUtils.provider4ImageUrl);
		assertEquals(resultAttributes.get("SmallLogo5"), EmailTestUtils.provider5ImageUrl);
	}

}
