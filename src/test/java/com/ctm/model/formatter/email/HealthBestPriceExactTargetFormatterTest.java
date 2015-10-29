package com.ctm.model.formatter.email;

import static org.junit.Assert.assertEquals;

import java.util.Map;

import org.junit.Test;

import com.ctm.web.core.model.email.ExactTargetEmailModel;
import com.ctm.web.health.model.email.HealthBestPriceEmailModel;
import com.ctm.web.health.model.formatter.email.HealthBestPriceExactTargetFormatter;
import com.ctm.services.email.EmailUtils;

public class HealthBestPriceExactTargetFormatterTest {

	private class HealthBestPriceExactTargetFormatterStub extends HealthBestPriceExactTargetFormatter{
		public ExactTargetEmailModel formatXml(HealthBestPriceEmailModel model) {
			return super.formatXml(model);
		}
	}

	@Test
	public void testShouldFormatModelForExactTarget() {

		HealthBestPriceExactTargetFormatterStub formatter = new HealthBestPriceExactTargetFormatterStub();

		ExactTargetEmailModel result = formatter.formatXml(EmailUtils.newBestPriceEmailModel());

		Map<String, String> resultAttributes = result.getAttributes();
		assertEquals(resultAttributes.get("FirstName"), EmailUtils.firstName);
		assertEquals(resultAttributes.get("LastName"), "");
		assertEquals(resultAttributes.get("OptIn"), EmailUtils.optInVar);
		assertEquals(resultAttributes.get("Brand"), EmailUtils.brand);
		assertEquals(resultAttributes.get("QuoteReference"), String.valueOf(EmailUtils.quoteReference));
		assertEquals(resultAttributes.get("PhoneNumber"), EmailUtils.phoneNumber);
		assertEquals( EmailUtils.applyURL , resultAttributes.get("ApplyURL1"));
		assertEquals( EmailUtils.applyURL ,resultAttributes.get("ApplyURL2"));
		assertEquals( EmailUtils.applyURL ,resultAttributes.get("ApplyURL3"));
		assertEquals( EmailUtils.applyURL ,resultAttributes.get("ApplyURL4"));
		assertEquals( EmailUtils.applyURL ,resultAttributes.get("ApplyURL5"));

		assertEquals(resultAttributes.get("CallcentreHours"), EmailUtils.callcentreHours);

		assertEquals(resultAttributes.get("CoverType1"), EmailUtils.coverType1);

		assertEquals(resultAttributes.get("PhoneNumber1"), EmailUtils.phoneNumber);
		assertEquals(resultAttributes.get("PhoneNumber2"), EmailUtils.phoneNumber);
		assertEquals(resultAttributes.get("PhoneNumber3"), EmailUtils.phoneNumber);
		assertEquals(resultAttributes.get("PhoneNumber4"), EmailUtils.phoneNumber);
		assertEquals(resultAttributes.get("PhoneNumber5"), EmailUtils.phoneNumber);

		assertEquals(EmailUtils.premium1, resultAttributes.get("Premium1"));
		assertEquals(resultAttributes.get("Premium2"), EmailUtils.premium2);
		assertEquals(resultAttributes.get("Premium3"), EmailUtils.premium3);
		assertEquals(resultAttributes.get("Premium4"), EmailUtils.premium4);
		assertEquals(resultAttributes.get("Premium5"), EmailUtils.premium5);

		assertEquals(resultAttributes.get("PremiumFrequency"), EmailUtils.premiumFrequency);


		assertEquals(EmailUtils.premiumLabel1, resultAttributes.get("PremiumLabel1"));
		assertEquals(resultAttributes.get("PremiumLabel2"), EmailUtils.premiumLabel2);
		assertEquals(resultAttributes.get("PremiumLabel3"), EmailUtils.premiumLabel3);
		assertEquals(resultAttributes.get("PremiumLabel4"), EmailUtils.premiumLabel4);
		assertEquals(resultAttributes.get("PremiumLabel5"), EmailUtils.premiumLabel5);

		assertEquals(EmailUtils.provider1, resultAttributes.get("Provider1"));
		assertEquals(resultAttributes.get("Provider2"), EmailUtils.provider2);
		assertEquals(resultAttributes.get("Provider3"), EmailUtils.provider3);
		assertEquals(resultAttributes.get("Provider4"), EmailUtils.provider4);
		assertEquals(EmailUtils.provider5, resultAttributes.get("Provider5"));

		assertEquals(resultAttributes.get("SmallLogo1"), EmailUtils.provider1ImageUrl);
		assertEquals(resultAttributes.get("SmallLogo2"), EmailUtils.provider2ImageUrl);
		assertEquals(resultAttributes.get("SmallLogo3"), EmailUtils.provider3ImageUrl);
		assertEquals(resultAttributes.get("SmallLogo4"), EmailUtils.provider4ImageUrl);
		assertEquals(resultAttributes.get("SmallLogo5"), EmailUtils.provider5ImageUrl);
	}

}
