package com.ctm.web.health.apply.model;

import com.ctm.schema.health.v1_0_0.BankingDetails;
import com.ctm.schema.health.v1_0_0.CreditCard;
import com.ctm.schema.health.v1_0_0.CreditCardExpiry;
import com.ctm.schema.health.v1_0_0.CreditCardType;
import com.ctm.schema.health.v1_0_0.IncomeTier;
import com.ctm.schema.health.v1_0_0.MedicareCardExpiry;
import com.ctm.schema.health.v1_0_0.MedicareCardType;
import com.ctm.schema.health.v1_0_0.PaymentAccount;
import com.ctm.schema.health.v1_0_0.PaymentGatewayType;
import com.ctm.web.core.utils.common.utils.LocalDateUtils;
import com.ctm.web.health.apply.model.request.payment.details.PaymentType;
import com.ctm.web.health.exceptions.HealthApplyServiceException;
import com.ctm.web.health.model.form.Application;
import com.ctm.web.health.model.form.BankDetails;
import com.ctm.web.health.model.form.Credit;
import com.ctm.web.health.model.form.Expiry;
import com.ctm.web.health.model.form.Gateway;
import com.ctm.web.health.model.form.HealthQuote;
import com.ctm.web.health.model.form.Ipp;
import com.ctm.web.health.model.form.Medicare;
import com.ctm.web.health.model.form.Nab;
import com.ctm.web.health.model.form.Payment;
import com.ctm.web.health.model.form.PaymentDetails;
import com.google.common.collect.ImmutableMap;
import org.apache.commons.lang3.StringUtils;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

import static java.util.Arrays.asList;

public class PaymentAdapter {

    private static final List<String> PROVIDERS_NO_SAME_BANK_CLAIMS_CHECK = asList("BUD", "CUA", "FRA", "GMH", "AHM", "QTU", "NIB", "QTS", "MYO", "HIF", "WFD", "HEA", "UHF");

    private static final String MEDICARE_YEAR_EXPIRY_FORMAT = "20%s";

    private static final String BSB_FORMAT = "%s-%s";

    private static final ImmutableMap<String, com.ctm.schema.health.v1_0_0.PaymentType> PAYMENT_TYPE_MAP = ImmutableMap.<String, com.ctm.schema.health.v1_0_0.PaymentType>builder()
            .put("BA", com.ctm.schema.health.v1_0_0.PaymentType.BANK)
            .put("CC", com.ctm.schema.health.v1_0_0.PaymentType.CREDIT_CARD)
            .build();

    private static final ImmutableMap<String, CreditCardType> CREDIT_CARD_TYPE_MAP = ImmutableMap.<String, CreditCardType>builder()
            .put("V", CreditCardType.VISA)
            .put("M", CreditCardType.MASTERCARD)
            .put("A", CreditCardType.AMEX)
            .build();

    private static final ImmutableMap<String, CreditCardType> NAB_CREDIT_CARD_TYPE_MAP = ImmutableMap.<String, CreditCardType>builder()
            .put("VISA", CreditCardType.VISA)
            .put("MCARD", CreditCardType.MASTERCARD)
            .put("AMEX", CreditCardType.AMEX)
            .build();

    public static com.ctm.schema.health.v1_0_0.Payment createPayment(Optional<HealthQuote> quote) throws HealthApplyServiceException {
        final Optional<com.ctm.web.health.model.form.Payment> payment = quote.map(HealthQuote::getPayment);
        if (payment.isPresent()) {
            final Optional<Medicare> medicare = quote.map(HealthQuote::getPayment)
                    .map(com.ctm.web.health.model.form.Payment::getMedicare);

            return new com.ctm.schema.health.v1_0_0.Payment()
                    .withDetails(createPaymentDetails(quote, payment))
                    .withIsCoveredByMedicare(medicare.map(com.ctm.web.health.model.form.Medicare::getCover)
                            .map(RequestAdapter.YES_INDICATOR::equalsIgnoreCase)
                            .orElse(false))
                    .withMedicare(createMedicare(medicare))
                    .withBankingDetails(createBankDetails(quote.map(HealthQuote::getPayment), quote.map(HealthQuote::getApplication)))
                    .withCreditCard(createCreditCard(quote.map(HealthQuote::getPayment)));
        } else {
            return null;
        }
    }

    protected static com.ctm.schema.health.v1_0_0.Details createPaymentDetails(Optional<HealthQuote> quote, Optional<com.ctm.web.health.model.form.Payment> payment) {

        return new com.ctm.schema.health.v1_0_0.Details()
                .withFrequency(payment.map(com.ctm.web.health.model.form.Payment::getDetails)
                        .map(PaymentDetails::getFrequency)
                        .map(String::toUpperCase)
                        .map(com.ctm.schema.health.v1_0_0.PaymentFrequency::fromValue)
                        .orElse(null))
                .withPaymentType(payment.map(com.ctm.web.health.model.form.Payment::getDetails)
                        .map(PaymentDetails::getType)
                        .map(String::toUpperCase)
                        .map(PAYMENT_TYPE_MAP::get)
                        .orElse(null))
                .withIsEligibleForRebate(quote.map(HealthQuote::getHealthCover)
                        .map(com.ctm.web.health.model.form.HealthCover::getRebate)
                        .map(RequestAdapter.YES_INDICATOR::equalsIgnoreCase)
                        .orElse(false))
                .withIncomeTier(new IncomeTier()
                        .withTier(quote.map(HealthQuote::getHealthCover)
                                .map(com.ctm.web.health.model.form.HealthCover::getIncome)
                                .orElse(0)))
//                .withTaxFileStatus()  // not currently sent to health-apply
                .withRebatePercentage(quote.map(HealthQuote::getRebate)
                        .map(BigDecimal::valueOf)
                        .orElse(null))
                .withPaymentStartDate(paymentStartDate(payment))
                .withLifetimeHealthCoverLoading(quote.map(HealthQuote::getLoading)
                        .map(BigDecimal::valueOf)
                        .orElse(null));
    }

    protected static com.ctm.schema.health.v1_0_0.Medicare createMedicare(Optional<com.ctm.web.health.model.form.Medicare> medicare) {
        if (medicare.isPresent()) {
            return new com.ctm.schema.health.v1_0_0.Medicare()
                    .withFirstName(medicare.map(com.ctm.web.health.model.form.Medicare::getFirstName).orElse(null))
                    .withLastName(medicare.map(com.ctm.web.health.model.form.Medicare::getSurname).orElse(null))
                    .withMiddleInitial(medicare.map(com.ctm.web.health.model.form.Medicare::getMiddleName)
                            .map(String::trim)
                            .map(m -> StringUtils.substring(m, 0, 1))
                            .orElse(null))
                    .withCardType(getMedicareCardType(medicare))
                    .withCardExpiry(medicare.map(com.ctm.web.health.model.form.Medicare::getExpiry)
                            .map(e -> new MedicareCardExpiry()
                                    .withDay(e.getCardExpiryDay())
                                    .withMonth(e.getCardExpiryMonth())
                                    .withYear(String.format(MEDICARE_YEAR_EXPIRY_FORMAT, e.getCardExpiryYear())))
                            .orElse(null))
                    .withIrn(medicare.map(com.ctm.web.health.model.form.Medicare::getCardPosition).orElse(null))
                    .withNumber(medicare.map(com.ctm.web.health.model.form.Medicare::getNumber).orElse(null));
        } else {
            return null;
        }
    }

    private static MedicareCardType getMedicareCardType(Optional<com.ctm.web.health.model.form.Medicare> medicare) {
        String colour = medicare.map(com.ctm.web.health.model.form.Medicare::getColour).map(String::toUpperCase).orElse("");
        switch (colour) {
            case "GREEN":
                return MedicareCardType.AUSTRALIAN_RESIDENT;
            case "YELLOW":
                return MedicareCardType.RECIPROCAL;
            case "BLUE":
                return MedicareCardType.INTERIM;
            default:
                return MedicareCardType.NONE;
        }
    }

    protected static BankingDetails createBankDetails(Optional<com.ctm.web.health.model.form.Payment> payment, Optional<Application> application) {

        final String paymentType = getPaymentType(payment);

        final Optional<com.ctm.web.health.model.form.Bank> bank = payment.map(com.ctm.web.health.model.form.Payment::getBank);

        boolean usePaymentAccountForClaimsAndRefunds = bank.map(com.ctm.web.health.model.form.Bank::getClaims)
                .map(RequestAdapter.YES_INDICATOR::equalsIgnoreCase)
                .orElse(false);
        // Check if one of the providers then set to N
        if (application.filter(a -> PROVIDERS_NO_SAME_BANK_CLAIMS_CHECK.contains(a.getProvider())).isPresent() && PaymentType.CREDIT_CARD.getCode().equals(paymentType)) {
            usePaymentAccountForClaimsAndRefunds = false;
        }

        final boolean supplyRefundBankAccount = payment.map(com.ctm.web.health.model.form.Payment::getDetails)
                .map(PaymentDetails::getClaims)
                .map(RequestAdapter.YES_INDICATOR::equalsIgnoreCase)
                .orElse(false);

        final BankingDetails bankingDetails = new BankingDetails()
                .withUsePaymentBankAccountForRefunds(usePaymentAccountForClaimsAndRefunds)
                .withSupplyClaimsAccountForRefunds(supplyRefundBankAccount);

        if (PaymentType.BANK.getCode().equals(paymentType)) {
            return bankingDetails
                    .withPaymentAccount(createAccount(bank))
                    .withRefundAccount(!usePaymentAccountForClaimsAndRefunds ? createAccount(bank.map(com.ctm.web.health.model.form.Bank::getClaim)) : null);
        } else if (PaymentType.CREDIT_CARD.getCode().equals(paymentType)) {
            return bankingDetails
                    .withRefundAccount(!usePaymentAccountForClaimsAndRefunds ? createAccount(bank.map(com.ctm.web.health.model.form.Bank::getClaim)) : null);
        } else {
            return null;
        }
    }


    protected static PaymentAccount createAccount(Optional<? extends BankDetails> bank) {
        if (bank.isPresent()) {
            return new PaymentAccount()
                    .withBankName(bank.map(BankDetails::getName).orElse(null))
                    .withBsb(bank.map(BankDetails::getBsb)
                            .map(String::trim)
                            .filter(bsb -> bsb.length() == 6)
                            .map(bsb -> String.format(BSB_FORMAT, bsb.substring(0,3), bsb.substring(3,6)))
                            .orElse(null))
                    .withAccountName(bank.map(BankDetails::getAccount).orElse(null))
                    .withAccountNumber(bank.map(BankDetails::getNumber).orElse(null));
        } else {
            return null;
        }
    }

    protected static CreditCard createCreditCard(Optional<Payment> payment) throws HealthApplyServiceException {
        final String paymentType = getPaymentType(payment);
        if (!PaymentType.CREDIT_CARD.getCode().equals(paymentType)) {
            return null;
        }
        return getPaymentGatewayCreditCard(payment)
                .orElseThrow(() -> new HealthApplyServiceException("The PaymentGatewayType cannot be determined for the application which has credit card set as the payment method"));
    }

    protected static Optional<CreditCard> getPaymentGatewayCreditCard(Optional<com.ctm.web.health.model.form.Payment> payment) {
        // NAB and WESTPAC payment gateways
        Optional<Gateway> gateway = payment.map(com.ctm.web.health.model.form.Payment::getGateway);
        if (gateway.isPresent()) {
            if (gateway.map(Gateway::getNab).isPresent()) {
                return Optional.of(getNabCreditCard(gateway));
            } else {
                return Optional.of(getWestpacCreditCard(gateway));
            }
        }

        final Optional<Credit> credit = payment.map(com.ctm.web.health.model.form.Payment::getCredit);
        // IPP payment gateway
        if (credit.map(Credit::getIpp)
                .map(Ipp::getTokenisation).isPresent()) {
            return Optional.of(getIppCreditCard(credit));
        }

        // Inline credit card form
        if (credit.isPresent()) {
            return Optional.of(getInlineCreditCard(credit));
        }

        return Optional.empty();
    }

    protected static CreditCard getNabCreditCard(Optional<Gateway> gateway) {
        final Optional<Nab> nab = gateway.map(Gateway::getNab);
        return new CreditCard()
                .withPaymentGatewayType(PaymentGatewayType.NAB)
                .withCardType(nab.map(Nab::getCardType)
                        .map(StringUtils::trim)
                        .map(String::toUpperCase)
                        .map(NAB_CREDIT_CARD_TYPE_MAP::get)
                        .orElse(null))
                .withName(nab.map(Nab::getCardName).orElse(null))
                .withNumber(nab.map(Nab::getCardNumber).orElse(null))
                .withCardExpiry(new CreditCardExpiry()
                        .withMonth(nab.map(Nab::getExpiryMonth).orElse(null))
                        .withYear(nab.map(Nab::getExpiryYear).orElse(null)))
                .withCrn(nab.map(Nab::getCrn).orElse(null));
    }

    protected static CreditCard getWestpacCreditCard(Optional<Gateway> gateway) {
        return new CreditCard()
                .withPaymentGatewayType(PaymentGatewayType.WESTPAC)
                .withCardType(gateway.map(Gateway::getType)
                        .map(String::toUpperCase)
                        .map(CreditCardType::fromValue)
                        .orElse(null))
                .withName(gateway.map(Gateway::getName).orElse(null))
                .withNumber(gateway.map(Gateway::getNumber).orElse(null))
                .withCardExpiry(gateway.map(Gateway::getExpiry)
                        .map(e -> {
                            final String[] params = StringUtils.split(e, "/");
                            if (params != null && params.length == 2) {
                                return new CreditCardExpiry()
                                        .withMonth(params[0])
                                        .withYear(params[1].substring(Math.max(params[1].length() - 2, 0)));
                            } else {
                                return null;
                            }
                        }).orElse(null));
    }

    protected static CreditCard getIppCreditCard(Optional<Credit> credit) {
        return new CreditCard()
                .withPaymentGatewayType(PaymentGatewayType.IPP)
                .withCardType(credit.map(Credit::getType)
                        .map(String::toUpperCase)
                        .map(CREDIT_CARD_TYPE_MAP::get)
                        .orElse(null))
                .withName(credit.map(Credit::getName).orElse(null))
                .withNumber(credit.map(Credit::getIpp)
                        .map(Ipp::getMaskedNumber)
                        .orElse(null))
                .withToken(credit.map(Credit::getIpp)
                        .map(Ipp::getTokenisation)
                        .orElse(null))
                .withCardExpiry(new CreditCardExpiry()
                        .withMonth(credit.map(Credit::getExpiry).map(Expiry::getCardExpiryMonth).orElse(null))
                        .withYear(credit.map(Credit::getExpiry).map(Expiry::getCardExpiryYear).orElse(null)));
    }

    protected static CreditCard getInlineCreditCard(Optional<Credit> credit) {
        return new CreditCard()
                .withPaymentGatewayType(PaymentGatewayType.INLINE)
                .withCardType(credit.map(Credit::getType)
                        .map(String::toUpperCase)
                        .map(CREDIT_CARD_TYPE_MAP::get)
                        .orElse(null))
                .withName(credit.map(Credit::getName).orElse(null))
                .withNumber(credit.map(Credit::getNumber).orElse(null))
                .withCvv(credit.map(Credit::getCcv).orElse(null))
                .withCardExpiry(new CreditCardExpiry()
                        .withMonth(credit.map(Credit::getExpiry).map(Expiry::getCardExpiryMonth).orElse(null))
                        .withYear(credit.map(Credit::getExpiry).map(Expiry::getCardExpiryYear).orElse(null)));
    }

    private static String getPaymentType(Optional<com.ctm.web.health.model.form.Payment> payment) {
        return payment.map(com.ctm.web.health.model.form.Payment::getDetails)
                .map(PaymentDetails::getType)
                .orElse(null);
    }

    protected static LocalDate paymentStartDate(Optional<com.ctm.web.health.model.form.Payment> payment) {
        PaymentType paymentType = payment.map(com.ctm.web.health.model.form.Payment::getDetails)
                .map(PaymentDetails::getType)
                .map(PaymentType::findByCode)
                .orElse(null);

        if (PaymentType.CREDIT_CARD.equals(paymentType)) {
            final Optional<Credit> credit = payment.map(com.ctm.web.health.model.form.Payment::getCredit);
            if (credit.map(Credit::getPaymentDay).isPresent()) {
                return credit.map(Credit::getPaymentDay)
                        .map(LocalDate::parse)
                        .orElse(null);
            } else if (credit.map(Credit::getPolicyDay).isPresent()) {
                return credit.map(Credit::getPolicyDay)
                        .map(LocalDate::parse)
                        .orElse(null);
            } else if (payment.map(com.ctm.web.health.model.form.Payment::getPolicyDate).isPresent()) { // For BUD, GMB and Frank
                return payment.map(com.ctm.web.health.model.form.Payment::getPolicyDate)
                        .map(LocalDateUtils::parseISOLocalDate)
                        .orElse(null);
            } else if (credit.map(Credit::getDay).isPresent()) {
                return LocalDate.now().withDayOfMonth(credit.map(Credit::getDay).get());
            } else {
                return payment
                        .map(com.ctm.web.health.model.form.Payment::getDetails)
                        .map(PaymentDetails::getStart)
                        .map(LocalDateUtils::parseAUSLocalDate)
                        .orElse(null);
            }
        } else if (PaymentType.BANK.equals(paymentType)) {
            final Optional<com.ctm.web.health.model.form.Bank> bank = payment.map(com.ctm.web.health.model.form.Payment::getBank);
            if (bank.map(com.ctm.web.health.model.form.Bank::getPaymentDay).isPresent()) {
                return bank.map(com.ctm.web.health.model.form.Bank::getPaymentDay)
                        .map(LocalDate::parse)
                        .orElse(null);
            } else if (bank.map(com.ctm.web.health.model.form.Bank::getPolicyDay).isPresent()) {
                return bank.map(com.ctm.web.health.model.form.Bank::getPolicyDay)
                        .map(LocalDate::parse)
                        .orElse(null);
            } else if (payment.map(com.ctm.web.health.model.form.Payment::getPolicyDate).isPresent()) { // For BUD, GMB and Frank
                // For BUD, GMB and Frank
                return payment.map(com.ctm.web.health.model.form.Payment::getPolicyDate)
                        .map(LocalDateUtils::parseISOLocalDate)
                        .orElse(null);
            } else if (bank.map(com.ctm.web.health.model.form.Bank::getDay).isPresent()) {
                return LocalDate.now().withDayOfMonth(bank.map(com.ctm.web.health.model.form.Bank::getDay).get());
            } else {
                return payment
                        .map(com.ctm.web.health.model.form.Payment::getDetails)
                        .map(PaymentDetails::getStart)
                        .map(LocalDateUtils::parseAUSLocalDate)
                        .orElse(null);
            }
        } else {
            //
            return null;
        }
    }
}
