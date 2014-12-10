package com.ctm.services.health;

import java.util.ArrayList;
import java.util.List;

import com.ctm.model.HealthApplication;
import com.ctm.web.validation.SchemaValidationError;
import com.disc_au.web.go.Data;


/**
 * This is a short term fix for server side validation. The way validation is handled will be
 * reviewed at a later date. Keep this in mind for future changes.
 * @author lbuchanan
 *
 */
public class HealthApplicationValidationService {

	private static final String PREFIX = "health";
	
	private static final String REBATE_XPATH = PREFIX + "/healthCover/rebate";
	private static final String PROVIDER_XPATH = PREFIX + "/application/provider";
	private static final String MEDICARE_NUMBER_XPATH = PREFIX + "/payment/medicare/number";
	
	private static final String REBATE_HIDDEN_XPATH = PREFIX + "/rebate";
	private static final String LOADING_XPATH = PREFIX + "/loading";
	
	List<SchemaValidationError> validationErrors;

	private HealthApplication healthApplication;

	public List<SchemaValidationError> validate(Data data) {
		parseData(data);
		validationErrors = new ArrayList<SchemaValidationError>();
		validateRebate();
		validateLoading();
		validateMedicareNumber();
		return validationErrors;
	}

	private void parseData(Data data) {
		healthApplication = new HealthApplication();
		healthApplication.rebateValue = data.getDouble(REBATE_HIDDEN_XPATH); 
		healthApplication.loadingValue = data.getDouble(LOADING_XPATH); 
		healthApplication.rebate =  data.getString(REBATE_XPATH);
		healthApplication.provider =  data.getString(PROVIDER_XPATH);
		healthApplication.medicareNumber =  data.getString(MEDICARE_NUMBER_XPATH);
	}

	private void validateRebate() {
		boolean valid = false;
		valid = healthApplication.rebateValue <= 40 && healthApplication.rebateValue >= 0;
		addToListIfInvalid(valid, REBATE_HIDDEN_XPATH);
		
	}

	private void validateLoading() {
		String xpath = LOADING_XPATH;
		boolean valid = false;
		valid = healthApplication.loadingValue < 100 && healthApplication.loadingValue >= 0;
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
		if(healthApplication.rebate.equals("Y") || healthApplication.provider.equals("BUP")) {
			String medicareNumber  = getValueAndAddToErrorsIfEmpty(healthApplication.medicareNumber, MEDICARE_NUMBER_XPATH);
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
