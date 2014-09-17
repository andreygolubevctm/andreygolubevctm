package com.ctm.services.health;

import java.util.ArrayList;
import java.util.List;

import com.ctm.web.validation.SchemaValidationError;
import com.disc_au.web.go.Data;


/**
 * This is a short term fix for server side validation. The way validation is handled will be
 * reviewed at a later date. Keep this in mind for future changes.
 * @author lbuchanan
 *
 */
public class HealthApplicationValidationService {

	private static final String REBATE_XPATH = "health/healthCover/rebate";
	private static final String PROVIDER_XPATH = "health/application/provider";
	private static final String MEDICARE_NUMBER_XPATH = "health/payment/medicare/number";

	public List<SchemaValidationError> validate(Data data) {
		return validateMedicareNumber(data);
	}

	private List<SchemaValidationError> validateMedicareNumber(Data data) {
		List<SchemaValidationError> validationErrors= new ArrayList<SchemaValidationError>();
		SchemaValidationError error = new SchemaValidationError();
		error.setElementXpath(MEDICARE_NUMBER_XPATH);

		Object rebateObj = data.get(REBATE_XPATH);
		String rebate = "";
		if (rebateObj instanceof String) {
			rebate = (String) rebateObj;
		}

		Object providerObj = data.get(PROVIDER_XPATH);
		String provider = "";
		if (providerObj instanceof String) {
			provider = (String) providerObj;
		}

		/**
		 * Medicare number is mandatory for Bupa
		 * Otherwise it is mandatory if yes was selected for do you want a rebate?
		 */
		if(rebate.equals("Y") || provider.equals("BUP")) {
			Object obj = data.get(MEDICARE_NUMBER_XPATH);
			String medicareNumber = "";
			if (obj instanceof String) {
				// don't worry about space etc
				medicareNumber =  ((String) obj).replaceAll( "[^\\d]", "" );
				// check not empty
				if(medicareNumber.isEmpty()) {
					error.setMessage(SchemaValidationError.REQUIRED);
					validationErrors.add(error);
				// check that 10 digits
				} else if(medicareNumber.length() != 10) {
					error.setMessage(SchemaValidationError.INVALID);
					validationErrors.add(error);
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
						error.setMessage(SchemaValidationError.INVALID);
						validationErrors.add(error);
					// Remainder needs to = the 9th number
					} else if( sumTotalOFFirstToEighth % 10 != medicareNinethDigit){
						error.setMessage(SchemaValidationError.INVALID);
						validationErrors.add(error);
					}
				}
			} else {
				error.setMessage(SchemaValidationError.REQUIRED);
				validationErrors.add(error);
			}
		}
		return validationErrors;
	}

}
