package com.ctm.web.core.model.validators;

import com.ctm.web.core.model.ProviderContent;
import com.ctm.web.core.model.constraints.ProviderContentValidator;
import com.ctm.web.core.model.constraints.ValidProviderContent;
import com.ctm.web.core.utils.common.utils.DateUtils;
import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.Mock;
import org.mockito.runners.MockitoJUnitRunner;

import javax.validation.ConstraintValidatorContext;
import javax.validation.Payload;

import java.lang.annotation.Annotation;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Locale;

import static org.junit.Assert.assertFalse;
import static org.junit.Assert.assertTrue;
import static org.mockito.Matchers.any;
import static org.powermock.api.mockito.PowerMockito.doCallRealMethod;
import static org.powermock.api.mockito.PowerMockito.when;

@RunWith(MockitoJUnitRunner.class)
public class ProviderContentValidatorTest {

	@Mock
	ProviderContentValidator providerContentValidator;

	@Mock
	ConstraintValidatorContext constraintValidatorContext;

	ProviderContent providerContent = new ProviderContent();

	SimpleDateFormat simpleDateFormatIn = new SimpleDateFormat("EEE MMM dd HH:mm:ss zzzz yyyy", Locale.ENGLISH);
	SimpleDateFormat simpleDateFormatOut = new SimpleDateFormat("dd/MM/yyyy", Locale.ENGLISH);

	@Before
	public void setUp() {
		providerContent.setVerticalId(4);
		providerContent.setStyleCodeId(1);
		providerContent.setStyleCode("ctm");
		providerContent.setProviderContentId(666);
		providerContent.setProviderContentTypeId(6);
		providerContent.setEffectiveEnd(new Date());
		providerContent.setEffectiveStart(new Date());
		doCallRealMethod().when(providerContentValidator).initialize(any());
		when(providerContentValidator.isValid(any(), any())).thenCallRealMethod();
		ProviderContentValidatorTestClass testClass = new ProviderContentValidatorTestClass();
		providerContentValidator.initialize(testClass);
	}

	@Test
	public void testIsValidWithValidValues() throws Exception {
		Date dateToParse = DateUtils.addDays(new Date(), 2);
		Date dropDeadDate = simpleDateFormatIn.parse(dateToParse.toString());
		providerContent.setProviderContentText("<p>" + simpleDateFormatOut.format(dropDeadDate) + "</p>");
		assertTrue(providerContentValidator.isValid(providerContent, constraintValidatorContext));
	}

	@Test
	public void testIsValidWithInvalidValuesA() throws Exception {
		Date dateToParse = DateUtils.addDays(new Date(), -2);
		Date dropDeadDate = simpleDateFormatIn.parse(dateToParse.toString());
		providerContent.setProviderContentText("<p>" + simpleDateFormatOut.format(dropDeadDate) + "</p>");
		assertFalse(providerContentValidator.isValid(providerContent, constraintValidatorContext));
	}

	@Test
	public void testIsValidWithInvalidValuesB() throws Exception {
		providerContent.setProviderContentText("<p>31/09/2021</p>");
		assertFalse(providerContentValidator.isValid(providerContent, constraintValidatorContext));
	}

	@Test
	public void testIsValidWithInvalidValuesC() throws Exception {
		providerContent.setProviderContentText("This ain't no drop dead date");
		assertFalse(providerContentValidator.isValid(providerContent, constraintValidatorContext));
	}

	@Test
	public void testIsValidWithInvalidValuesD() throws Exception {
		providerContent.setProviderContentText("");
		assertFalse(providerContentValidator.isValid(providerContent, constraintValidatorContext));
	}

	private class ProviderContentValidatorTestClass implements ValidProviderContent {

		@Override
		public String message() {
			return "Test Message";
		}

		@Override
		public Class<?>[] groups() {
			return new Class[]{};
		}

		@Override
		public Class<? extends Payload>[] payload() {
			return new Class[]{};
		}

		@Override
		public Class<? extends Annotation> annotationType() {
			return ValidProviderContent.class;
		}
	}
}
