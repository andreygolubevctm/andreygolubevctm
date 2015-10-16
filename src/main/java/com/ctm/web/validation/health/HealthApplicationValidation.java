package com.ctm.web.validation.health;

import com.ctm.model.request.health.HealthApplicationRequest;
import com.ctm.web.validation.FormValidation;
import com.ctm.web.validation.SchemaValidationError;

import java.util.List;

import static com.ctm.services.health.HealthApplicationService.*;


/**
 * This is a short term fix for server side validation. The way validation is handled will be
 * reviewed at a later date. Keep this in mind for future changes.
 * @author lbuchanan
 *
 */
public class HealthApplicationValidation {

	List<SchemaValidationError> validationErrors;

	private HealthApplicationRequest request;

	public List<SchemaValidationError> validate(HealthApplicationRequest request) {
		this.request = request;
		validationErrors = FormValidation.validate(request , "health");
		validateRebate();
		validateLoading();
		validateMedicareNumber();
		return validationErrors;
	}

	private void validateRebate() {
		boolean valid = false;
		valid = request.rebateValue <= 40 && request.rebateValue >= 0;
		addToListIfInvalid(valid, REBATE_HIDDEN_XPATH);

	}

	private void validateLoading() {
		String xpath = LOADING_XPATH;
		boolean valid = false;
		valid = request.loadingValue < 100 && request.loadingValue >= 0;
		addToListIfInvalid(valid, xpath);
	}

	private void addToListIfInvalid(boolean valid, String xpath) {
		if(!valid) {
			SchemaValidationError error = new SchemaValidationError();
			error.setElementXpath(xpath);
			error.setMessage(SchemaValidationError.INVALID);
			validationErrors.add(error);
		}
	}

	private String getValueAndAddToErrorsIfEmpty(String value, String xpath) {
		boolean hasValue = false;
		if(value != null){
			value =  value.replaceAll( "[^\\d]", "" );
			hasValue = !value.isEmpty();
		}
		if(!hasValue) {
			SchemaValidationError error = new SchemaValidationError();
			error.setElementXpath(xpath);
			error.setMessage(SchemaValidationError.REQUIRED);
			validationErrors.add(error);
		}
		return value;
	}

	private List<SchemaValidationError> validateMedicareNumber() {

		/**
		 * Medicare number is mandatory for Bupa
		 * Otherwise it is mandatory if yes was selected for do you want a rebate?
		 */
		if(request.hasRebate || request.application.provider.equals("BUP")) {
			String medicareNumber  = getValueAndAddToErrorsIfEmpty(request.payment.medicare.number, MEDICARE_NUMBER_XPATH);
			if (!medicareNumber.isEmpty()) {
				// check not empty
				if(medicareNumber.length() != 10) {
					addToListIfInvalid(false, MEDICARE_NUMBER_XPATH);
					// check format is valid
				} else {
					int medicareFirstDigit = Integer.parseInt(medicareNumber.substring(0,1));
					int sumTotalOFFirstToEighth =
							(medicareFirstDigit * 1)
									+ (Integer.parseInt(medicareNumber.substring(1,2)) * 3)
									+ (Integer.parseInt(medicareNumber.substring(2,3)) * 7)
									+ (Integer.parseInt(medicareNumber.substring(3,4)) * 9)
									+ (Integer.parseInt(medicareNumber.substring(4,5)) * 1)
									+ (Integer.parseInt(medicareNumber.substring(5,6)) * 3)
									+ (Integer.parseInt(medicareNumber.substring(6,7)) * 7)
									+ (Integer.parseInt(medicareNumber.substring(7,8)) * 9);

					Integer medicareNinethDigit = Integer.parseInt(medicareNumber.substring(8,9));

					// Must start between 2 and 6
					if(medicareFirstDigit < 2 || medicareFirstDigit > 6 ) {
						addToListIfInvalid(false, MEDICARE_NUMBER_XPATH);
						// Remainder needs to = the 9th number
					} else if( sumTotalOFFirstToEighth % 10 != medicareNinethDigit){
						addToListIfInvalid(false, MEDICARE_NUMBER_XPATH);
					}
				}
			}
		}
		return validationErrors;
	}

}
