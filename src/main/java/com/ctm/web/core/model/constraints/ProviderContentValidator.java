package com.ctm.web.core.model.constraints;

import com.ctm.web.core.model.ProviderContent;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.validation.ConstraintValidator;
import javax.validation.ConstraintValidatorContext;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Locale;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import static com.ctm.commonlogging.common.LoggingArguments.kv;

/**
 * Created by msmerdon on 8/1/21.
 */
public class ProviderContentValidator implements ConstraintValidator<ValidProviderContent, ProviderContent> {

	private static final Logger LOGGER = LoggerFactory.getLogger(ProviderContentValidator.class);

	private SimpleDateFormat dateFormatter;

	@Override
	public void initialize (ValidProviderContent constraintAnnotation) {
		this.dateFormatter = new SimpleDateFormat("dd/MM/yyyy", Locale.ENGLISH);
	}

	@Override
	public boolean isValid (ProviderContent content, ConstraintValidatorContext context) {
		// Provider content is a Drop Dead Date
		if(content.getProviderContentTypeId() == 6) {
			if(content.getProviderContentText().matches("(\\s)*\\<p\\>\\d\\d\\/\\d\\d\\/\\d\\d\\d\\d\\<\\/p\\>(\\s)*")) {
				// Confirm date is in format dd/mm/yyyy, is valid date and is in the future
				Pattern pattern = Pattern.compile("\\d\\d\\/\\d\\d\\/\\d\\d\\d\\d");
				Matcher matcher = pattern.matcher(content.getProviderContentText());
				if (matcher.find()) {
					String dateToTest = matcher.group(0);
					Date parsedDate = parseDateFromForm(dateToTest);
					return parsedDate != null && parsedDate.after(new Date());
				}
				return true;
			} else {
				return false;
			}
		}
		return true;
	}

	private Date parseDateFromForm(String searchDate) {
		Date searchDateValue = null;
		try {
			this.dateFormatter.setLenient(false);
			searchDateValue = dateFormatter.parse(searchDate);
		} catch (ParseException e) {
			LOGGER.warn("Failed to parse date. {}" , kv("searchDate" , searchDate));
		}
		return searchDateValue;
	}
}
