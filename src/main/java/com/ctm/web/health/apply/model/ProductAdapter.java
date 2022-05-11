package com.ctm.web.health.apply.model;

import com.ctm.schema.health.v1_0_0.AbdFlag;
import com.ctm.schema.health.v1_0_0.PaymentFrequency;
import com.ctm.schema.health.v1_0_0.PremiumAmount;
import com.ctm.schema.health.v1_0_0.ProductDetails;
import com.ctm.web.health.model.results.HealthQuoteResult;
import com.ctm.web.health.model.results.Info;
import com.ctm.web.health.model.results.Premium;

import java.math.BigDecimal;
import java.util.Arrays;
import java.util.List;
import java.util.Optional;

public class ProductAdapter {

    private static final String EMPTY_STRING = "";

    protected static ProductDetails createProduct(HealthQuoteResult result, String fundProductCode, String PaymentType, String extrasName, String hospitalName, int excess) {
        return new ProductDetails()
                .withProductCode(fundProductCode)
                .withAbdFlag(Optional.of(result.getCustom())
                        .map(custom -> custom.get("reform").get("yad").asText())
                        .map(String::toUpperCase)
                        .map(AbdFlag::fromValue)
                        .orElse(null))
                .withExcessAmount(excess)
                .withPolicyType(Optional.of(result.getInfo())
                        .map(Info::getProductType)
                        .map(String::toUpperCase)
                        .map(String::trim)
                        .filter(policyType -> policyType.length() > 0)
                        .map(policyType -> policyType.substring(0, 1))
                        .map(RequestAdapter.POLICY_TYPE_MAP::get)
                        .orElse(null))
                .withProductTitle(result.getInfo().getName())
                .withProductHospitalName(hospitalName)
                .withProductExtrasName(extrasName)
                .withIsRestrictedFund(Optional.of(result.getInfo())
                        .map(Info::getRestrictedFund)
                        .map(RequestAdapter.YES_INDICATOR::equalsIgnoreCase)
                        .orElse(false))
                .withPremiumAmounts(createPricePremiums(result.getPaymentTypePremiums().get(PaymentType)));
    }

    protected static List<PremiumAmount> createPricePremiums(Premium premium) {
        return Arrays.asList(
                new PremiumAmount()
                        .withPaymentFrequency(PaymentFrequency.ANNUALLY)
                        .withBasePremium(new BigDecimal(formatPricePremium(premium.getAnnually().getBase())))
                        .withGrossPremium(new BigDecimal(formatPricePremium(premium.getAnnually().getGrossPremium())))
                        .withHospitalAmount(premium.getAnnually().getHospitalValue())
                        .withPayableAmount(premium.getAnnually().getValue()),
                new PremiumAmount()
                        .withPaymentFrequency(PaymentFrequency.HALF_YEARLY)
                        .withBasePremium(new BigDecimal(formatPricePremium(premium.getHalfyearly().getBase())))
                        .withGrossPremium(new BigDecimal(formatPricePremium(premium.getHalfyearly().getGrossPremium())))
                        .withHospitalAmount(premium.getHalfyearly().getHospitalValue())
                        .withPayableAmount(premium.getHalfyearly().getValue()),
                new PremiumAmount()
                        .withPaymentFrequency(PaymentFrequency.QUARTERLY)
                        .withBasePremium(new BigDecimal(formatPricePremium(premium.getQuarterly().getBase())))
                        .withGrossPremium(new BigDecimal(formatPricePremium(premium.getQuarterly().getGrossPremium())))
                        .withHospitalAmount(premium.getQuarterly().getHospitalValue())
                        .withPayableAmount(premium.getQuarterly().getValue()),
                new PremiumAmount()
                        .withPaymentFrequency(PaymentFrequency.MONTHLY)
                        .withBasePremium(new BigDecimal(formatPricePremium(premium.getMonthly().getBase())))
                        .withGrossPremium(new BigDecimal(formatPricePremium(premium.getMonthly().getGrossPremium())))
                        .withHospitalAmount(premium.getMonthly().getHospitalValue())
                        .withPayableAmount(premium.getMonthly().getValue()),
                new PremiumAmount()
                        .withPaymentFrequency(PaymentFrequency.FORTNIGHTLY)
                        .withBasePremium(new BigDecimal(formatPricePremium(premium.getFortnightly().getBase())))
                        .withGrossPremium(new BigDecimal(formatPricePremium(premium.getFortnightly().getGrossPremium())))
                        .withHospitalAmount(premium.getFortnightly().getHospitalValue())
                        .withPayableAmount(premium.getFortnightly().getValue()),
                new PremiumAmount()
                        .withPaymentFrequency(PaymentFrequency.WEEKLY)
                        .withBasePremium(new BigDecimal(formatPricePremium(premium.getWeekly().getBase())))
                        .withGrossPremium(new BigDecimal(formatPricePremium(premium.getWeekly().getGrossPremium())))
                        .withHospitalAmount(premium.getWeekly().getHospitalValue())
                        .withPayableAmount(premium.getWeekly().getValue())
        );

    }

    protected static String formatPricePremium(String premium) {
        return premium.replace("$", EMPTY_STRING).replace(",", EMPTY_STRING);
    }
}
