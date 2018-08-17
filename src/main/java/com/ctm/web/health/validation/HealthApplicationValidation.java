package com.ctm.web.health.validation;

import com.ctm.web.core.validation.FormValidation;
import com.ctm.web.core.validation.ValidationUtils;
import com.ctm.web.core.validation.SchemaValidationError;
import com.ctm.web.health.model.form.HealthRequest;
import com.ctm.web.health.model.request.HealthApplicationRequest;
import com.ctm.web.health.services.HealthApplicationService;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

import static com.ctm.web.health.services.HealthApplicationService.*;


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

    public static List<SchemaValidationError> validateCoverType(HealthRequest data) {
        List<SchemaValidationError> validationErrors = new ArrayList<>();
        boolean hasPartner = Optional.ofNullable(data.getHealth().getSituation()).map(sit -> "F".equals(sit.getHealthCvr()) || "C".equals(sit.getHealthCvr())).orElse(false);
        boolean valid = !hasPartner || Optional.ofNullable(data.getHealth().getHealthCover()).map(hc -> hc.getPartner() != null).orElse(false);
        addToListIfInvalid(valid, HealthApplicationService.HEALTH_COVER_XPATH, validationErrors);
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
        addToListIfInvalid( valid,  xpath, validationErrors);
    }

    private static void addToListIfInvalid(boolean valid, String xpath, List<SchemaValidationError> validationErrors) {
        if(!valid) {
            SchemaValidationError error = new SchemaValidationError();
            error.setElementXpath(xpath);
            error.setMessage(SchemaValidationError.INVALID);
            validationErrors.add(error);
        }
    }


	private List<SchemaValidationError> validateMedicareNumber() {

		/**
		 * Medicare number is mandatory for Bupa
		 * Otherwise it is mandatory if yes was selected for do you want a rebate?
		 * don't validate medicare details for AUF when rebate is selected as those details are not sent to AUF
		 */
		if((request.hasRebate && !request.application.provider.equals("AUF")) || request.application.provider.equals("BUP")) {
			String medicareNumber  = ValidationUtils.getValueAndAddToErrorsIfEmptyNumeric(request.payment.medicare.number, MEDICARE_NUMBER_XPATH, validationErrors);
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
