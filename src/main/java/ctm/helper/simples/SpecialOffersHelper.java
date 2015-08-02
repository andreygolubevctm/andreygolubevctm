package com.ctm.helper.simples;

import com.ctm.exceptions.DaoException;
import com.ctm.model.SpecialOffers;
import com.ctm.web.validation.FormValidation;
import com.ctm.web.validation.SchemaValidationError;

import java.util.List;

public class SpecialOffersHelper {

	public List<SchemaValidationError> validateSpecialOffersRowData(SpecialOffers specialOffers) throws DaoException {
		List<SchemaValidationError> validationErrors = FormValidation.validate(specialOffers, "");
		return validationErrors;
	}

	public SpecialOffers createSpecialOffersObject(int offerId, String content, String terms,
			String effectiveEnd, String effectiveStart, int providerId,
			int styleCodeId,String state,String styleCodeName,String providerName) {
		SpecialOffers specialOffers = new SpecialOffers();
		specialOffers.setContent(content);
		specialOffers.setTerms(terms);
		specialOffers.setOfferId(offerId);
		specialOffers.setProviderId(providerId);
		specialOffers.setEffectiveStart(effectiveStart);
		specialOffers.setEffectiveEnd(effectiveEnd);
		specialOffers.setStyleCodeId(styleCodeId);
		specialOffers.setState(state);
		specialOffers.setStyleCode(styleCodeName);
		specialOffers.setProviderName(providerName);
		return specialOffers;
	}

}
