package com.ctm.web.health.apply.model;

import java.math.BigDecimal;

import com.ctm.web.health.apply.model.request.product.PricePremiums;
import com.ctm.web.health.apply.model.request.product.PriceResultExtraInfo;
import com.ctm.web.health.model.results.HealthQuoteResult;
import com.ctm.web.health.model.results.Premium;
import com.ctm.web.health.model.results.SelectedProduct;

public class ProductAdapter {

    static final String PRODUCT_ID_PREFIX = "PHIO-HEALTH-";
    static final String RESTRICTED_FUND_TRUE = "1";
    static final String RESTRICTED_FUND_FALSE = "0";
    static final String RESTRICTED_FUND_FLAG = "Y";
    static final String EMPTY_STRING = "";

    protected static PriceResultExtraInfo createProduct(SelectedProduct result, String fundProductCode, String PaymentType, String extrasName, String hospitalName) {
        return PriceResultExtraInfo.newBuilder()
                .pricePremiums(createPricePremiums(result.getPaymentTypePremiums().get(PaymentType)))
                .fundCode(result.getInfo().getFundCode())
                .fundName(result.getInfo().getProviderName())
                .restrictedFund(result.getInfo().getRestrictedFund().equals(RESTRICTED_FUND_FLAG) ? RESTRICTED_FUND_TRUE : RESTRICTED_FUND_FALSE)
                .phioData(EMPTY_STRING) //Looks like this isn't actually required
                .extrasName(extrasName)
                .hospitalName(hospitalName)
                .fundProductCode(fundProductCode)
                .excess(result.getHospital().get("inclusions").get("excesses").get("perPerson").asInt())
                .title(result.getInfo().getName())
                .productId(result.getProductId().replaceAll(PRODUCT_ID_PREFIX, ""))
                .productType(result.getInfo().getProductType())
                .abdFlag(result.getCustom().get("reform").get("yad").asText())
                .build();
    }



    protected static PricePremiums createPricePremiums(Premium premium) {
        PricePremiums premiums = PricePremiums.newBuilder()
                                    .annualLhc(premium.getAnnually().getHospitalValue())
                                    .annualPremium(new BigDecimal(formatPricePremium(premium.getAnnually().getBase())))
                                    .grossAnnualPremium(new BigDecimal(formatPricePremium(premium.getAnnually().getGrossPremium())))
                                    .annualPayableAmount(premium.getAnnually().getValue())

                                    .halfYearlyLHC(premium.getHalfyearly().getHospitalValue())
                                    .halfYearlyPremium(new BigDecimal(formatPricePremium(premium.getHalfyearly().getBase())))
                                    .grossHalfYearlyPremium(new BigDecimal(formatPricePremium(premium.getHalfyearly().getGrossPremium())))
                                    .halfYearlyPayableAmount(premium.getHalfyearly().getValue())

                                    .quarterlyLHC(premium.getQuarterly().getHospitalValue())
                                    .quarterlyPremium(new BigDecimal(formatPricePremium(premium.getQuarterly().getBase())))
                                    .grossQuarterlyPremium(new BigDecimal(formatPricePremium(premium.getQuarterly().getGrossPremium())))
                                    .quarterlyPayableAmount(premium.getQuarterly().getValue())

                                    .monthlyLHC(premium.getMonthly().getHospitalValue())
                                    .monthlyPremium(new BigDecimal(formatPricePremium(premium.getMonthly().getBase())))
                                    .grossMonthlyPremium(new BigDecimal(formatPricePremium(premium.getMonthly().getGrossPremium())))
                                    .monthlyPayableAmount(premium.getMonthly().getValue())

                                    .fortnightlyLHC(premium.getFortnightly().getHospitalValue())
                                    .fortnightlyPremium(new BigDecimal(formatPricePremium(premium.getFortnightly().getBase())))
                                    .grossFortnightlyPremium(new BigDecimal(formatPricePremium(premium.getFortnightly().getGrossPremium())))
                                    .fortnightlyPayableAmount(premium.getFortnightly().getValue())

                                    .weeklyLHC(premium.getWeekly().getHospitalValue())
                                    .weeklyPremium(new BigDecimal(formatPricePremium(premium.getWeekly().getBase())))
                                    .grossWeeklyPremium(new BigDecimal(formatPricePremium(premium.getWeekly().getGrossPremium())))
                                    .weeklyPayableAmount(premium.getWeekly().getValue())
                                    .build();

        return premiums;
    }

    protected static String formatPricePremium(String premium) {
        return premium.replace("$", EMPTY_STRING).replace(",", EMPTY_STRING);
    }
}
