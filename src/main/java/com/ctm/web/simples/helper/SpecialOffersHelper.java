package com.ctm.web.simples.helper;

import com.ctm.web.core.exceptions.DaoException;
import com.ctm.web.core.validation.FormValidation;
import com.ctm.web.core.validation.SchemaValidationError;
import com.ctm.web.simples.admin.model.SpecialOffers;

import java.util.List;

public class SpecialOffersHelper {

	public List<SchemaValidationError> validateSpecialOffersRowData(SpecialOffers specialOffers) throws DaoException {
		List<SchemaValidationError> validationErrors = FormValidation.validate(specialOffers, "");
		return validationErrors;
	}

	public SpecialOffers  createSpecialOffersObject(int offerId, String content, String terms,
			String effectiveEnd, String effectiveStart, int providerId,
			int styleCodeId,String state,String coverType,String styleCodeName,String providerName,String offerType) {
		SpecialOffers specialOffers = new SpecialOffers();
		specialOffers.setContent(content);
		specialOffers.setTerms(terms);
		specialOffers.setOfferId(offerId);
		specialOffers.setProviderId(providerId);
		specialOffers.setEffectiveStart(effectiveStart);
		specialOffers.setEffectiveEnd(effectiveEnd);
		specialOffers.setStyleCodeId(styleCodeId);
		specialOffers.setState(state);
        specialOffers.setCoverType(coverType);
		specialOffers.setStyleCode(styleCodeName);
		specialOffers.setProviderName(providerName);
		specialOffers.setOfferType(offerType);
		return specialOffers;
	}

}
