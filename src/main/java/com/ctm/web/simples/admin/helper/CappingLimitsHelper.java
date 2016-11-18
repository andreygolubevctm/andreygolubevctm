package com.ctm.web.simples.admin.helper;

import com.ctm.web.core.validation.SchemaValidationError;
import com.ctm.web.health.model.request.CappingLimit;
import com.ctm.web.simples.admin.model.response.CappingLimitInformation;

import java.time.LocalDate;
import java.util.List;

public class CappingLimitsHelper {

    private static List<SchemaValidationError> validateCappingAmount(CappingLimit cappingLimit, List<SchemaValidationError> validationErrors) {
        if (cappingLimit.getCappingAmount() == null || cappingLimit.getCappingAmount() == 0) {
            SchemaValidationError error = new SchemaValidationError();
            error.setElementXpath("cappingAmount");
            error.setMessage("cappingAmount cannot be empty");
            validationErrors.add(error);
        }
        return validationErrors;
    }

    public CappingLimit createCappingLimitsObject(int providerId, String propertyId, int sequenceNo, int cappingAmount, LocalDate effectiveStart, LocalDate effectiveEnd) {
        CappingLimit cappingLimit = new CappingLimit();
        mapCappingLimitsObject(cappingLimit, providerId, propertyId, sequenceNo, cappingAmount, effectiveStart, effectiveEnd);
        return cappingLimit;
    }

    private void mapCappingLimitsObject(CappingLimit cappingLimit, int providerId, String propertyId,
                                        int sequenceNo, int cappingAmount, LocalDate effectiveStart, LocalDate effectiveEnd) {
        cappingLimit.setProviderId(providerId);
        if (CappingLimit.CappingLimitType.Monthly.text.equals(propertyId)) {
            cappingLimit.setLimitType(CappingLimit.CappingLimitType.Monthly.toString());
        } else {
            cappingLimit.setLimitType(CappingLimit.CappingLimitType.Daily.toString());
        }
        cappingLimit.setSequenceNo(sequenceNo);
        cappingLimit.setCappingAmount(cappingAmount);
        cappingLimit.setEffectiveStart(effectiveStart);
        cappingLimit.setEffectiveEnd(effectiveEnd);
    }


    public CappingLimitInformation createCappingLimitsObject(int providerId, String providerName, String propertyId,
                                                             int sequenceNo, int cappingAmount, int currentJoinCount,
                                                             LocalDate effectiveStart, LocalDate effectiveEnd, boolean isCurrent, String limitCategory) {
        CappingLimitInformation cappingLimit = new CappingLimitInformation();
        mapCappingLimitsObject(cappingLimit, providerId, propertyId, sequenceNo, cappingAmount, effectiveStart, effectiveEnd);
        cappingLimit.setProviderName(providerName);
        cappingLimit.setCurrentJoinCount(currentJoinCount);
        cappingLimit.setIsCurrent(isCurrent);
        cappingLimit.setCappingLimitCategory(limitCategory);
        return cappingLimit;
    }

    public void validateCappingLimitCategory(CappingLimit cappingLimit, List<SchemaValidationError> validationErrors) {

//        if (cappingLimit.getLimitType().equals(CappingLimit.CappingLimitType.Monthly) &&
//                cappingLimit.getCappingLimitCategory().equals(CappingLimit.CappingLimitCategory.Soft.text)) {
//            SchemaValidationError error = new SchemaValidationError();
//            error.setMessage("Limit Category must be Hard for Monthly Capping Limit");
//            validationErrors.add(error);
//        }
    }
}