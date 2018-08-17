package com.ctm.web.health.apply.model;

import com.ctm.web.core.utils.common.utils.LocalDateUtils;
import com.ctm.web.health.apply.model.request.application.applicant.healthCover.Cover;
import com.ctm.web.health.apply.model.request.application.common.FirstName;
import com.ctm.web.health.apply.model.request.application.common.LastName;
import com.ctm.web.health.apply.model.request.payment.Claims;
import com.ctm.web.health.apply.model.request.payment.Payment;
import com.ctm.web.health.apply.model.request.payment.bank.Bank;
import com.ctm.web.health.apply.model.request.payment.bank.account.*;
import com.ctm.web.health.apply.model.request.payment.common.Expiry;
import com.ctm.web.health.apply.model.request.payment.common.ExpiryMonth;
import com.ctm.web.health.apply.model.request.payment.common.ExpiryYear;
import com.ctm.web.health.apply.model.request.payment.credit.*;
import com.ctm.web.health.apply.model.request.payment.credit.Number;
import com.ctm.web.health.apply.model.request.payment.details.*;
import com.ctm.web.health.apply.model.request.payment.medicare.Medicare;
import com.ctm.web.health.apply.model.request.payment.medicare.MedicareNumber;
import com.ctm.web.health.apply.model.request.payment.medicare.MiddleInitial;
import com.ctm.web.health.apply.model.request.payment.medicare.Position;
import com.ctm.web.health.model.form.*;
import org.apache.commons.lang3.StringUtils;

import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

import static java.util.Arrays.asList;

public class PaymentAdapter {

    private static final List<String> PROVIDERS_NO_SAME_BANK_CLAIMS_CHECK = asList("BUD", "CUA", "FRA", "GMH", "AHM", "QTU", "NIB", "MYO", "HIF", "WFD");


    public static Payment createPayment(Optional<HealthQuote> quote) {
        final Optional<com.ctm.web.health.model.form.Payment> payment = quote.map(HealthQuote::getPayment);
        if (payment.isPresent()) {
            return new Payment(
                    createPaymentDetails(quote, payment),
                    createCreditCard(quote.map(HealthQuote::getPayment)),
                    createCreditIppCreditCard(quote.map(HealthQuote::getPayment)),
                    createGatewayCreditCard(quote.map(HealthQuote::getPayment)),
                    createBank(quote.map(HealthQuote::getPayment), quote.map(HealthQuote::getApplication)),
                    createMedicare(quote.map(HealthQuote::getPayment)
                            .map(com.ctm.web.health.model.form.Payment::getMedicare)),
                    payment.map(com.ctm.web.health.model.form.Payment::getDetails)
                            .map(PaymentDetails::getClaims)
                            .map(Claims::valueOf)
                            .orElse(null));
        } else {
            return null;
        }
    }

    protected static Details createPaymentDetails(Optional<HealthQuote> quote, Optional<com.ctm.web.health.model.form.Payment> payment) {
        return new Details(
                paymentStartDate(payment),
                payment.map(com.ctm.web.health.model.form.Payment::getDetails)
                        .map(PaymentDetails::getType)
                        .map(PaymentType::findByCode)
                        .orElse(null),
                payment.map(com.ctm.web.health.model.form.Payment::getDetails)
                        .map(PaymentDetails::getFrequency)
                        .map(Frequency::findByDescription)
                        .orElse(null),
                quote.map(HealthQuote::getHealthCover)
                        .map(com.ctm.web.health.model.form.HealthCover::getRebate)
                        .map(Rebate::valueOf)
                        .orElse(null),
                quote.map(HealthQuote::getRebate)
                        .map(Double::new)
                        .map(RebatePercentage::new)
                        .orElse(null),
                quote.map(HealthQuote::getHealthCover)
                        .map(com.ctm.web.health.model.form.HealthCover::getIncome)
                        .map(Income::new)
                        .orElse(null),
                quote.map(HealthQuote::getLoading)
                        .map(Integer::doubleValue)
                        .map(LifetimeHealthCoverLoading::new)
                        .orElse(null));
    }

    protected static Medicare createMedicare(Optional<com.ctm.web.health.model.form.Medicare> medicare) {
        if (medicare.isPresent()) {
            return new Medicare(
                    medicare.map(com.ctm.web.health.model.form.Medicare::getCover)
                            .map(Cover::valueOf)
                            .orElse(null),
                    medicare.map(com.ctm.web.health.model.form.Medicare::getNumber)
                            .map(MedicareNumber::new)
                            .orElse(null),
                    medicare.map(com.ctm.web.health.model.form.Medicare::getFirstName)
                            .map(FirstName::new)
                            .orElse(null),
                    medicare.map(com.ctm.web.health.model.form.Medicare::getMiddleInitial)
                            .map(MiddleInitial::new)
                            .orElse(null),
                    medicare.map(com.ctm.web.health.model.form.Medicare::getSurname)
                            .map(LastName::new)
                            .orElse(null),
                    new Position(1),
                    medicare.map(com.ctm.web.health.model.form.Medicare::getExpiry)
                            .map(e -> {
                                Optional<com.ctm.web.health.model.form.Expiry> expiry = Optional.ofNullable(e);
                                return new Expiry(
                                        expiry.map(com.ctm.web.health.model.form.Expiry::getCardExpiryMonth)
                                                .map(ExpiryMonth::new).orElse(null),
                                        expiry.map(com.ctm.web.health.model.form.Expiry::getCardExpiryYear)
                                                .map(ExpiryYear::new).orElse(null)
                                );
                            })
                            .orElse(null));
        } else {
            return null;
        }
    }

    protected static Bank createBank(Optional<com.ctm.web.health.model.form.Payment> payment, Optional<Application> application) {

        final String paymentType = payment.map(com.ctm.web.health.model.form.Payment::getDetails)
                .map(PaymentDetails::getType)
                .orElse(null);
        final Optional<com.ctm.web.health.model.form.Bank> bank = payment.map(com.ctm.web.health.model.form.Payment::getBank);

        final Claims claimsSameBankAccount;
        // Check if one of the providers then set to N
        if (application.filter(a -> PROVIDERS_NO_SAME_BANK_CLAIMS_CHECK.contains(a.getProvider())).isPresent() && "cc".equals(paymentType)) {
            claimsSameBankAccount = Claims.N;
        } else {
            claimsSameBankAccount = bank.map(com.ctm.web.health.model.form.Bank::getClaims)
                    .map(Claims::valueOf)
                    .orElse(Claims.N);
        }

        final Claims withRefund = payment.map(com.ctm.web.health.model.form.Payment::getDetails)
                .map(PaymentDetails::getClaims)
                .map(Claims::valueOf)
                .orElse(Claims.N);
        if ("ba".equals(paymentType)) {
            return new Bank(
                    createAccount(bank),
                    Claims.Y.equals(withRefund) && Claims.N.equals(claimsSameBankAccount) ?
                            createAccount(bank.map(com.ctm.web.health.model.form.Bank::getClaim)) :
                            Claims.N.equals(withRefund) && Claims.N.equals(claimsSameBankAccount) ?
                                    createAccount(bank.map(com.ctm.web.health.model.form.Bank::getClaim)) : null,
                    claimsSameBankAccount);
        } else if ("cc".equals(paymentType) && Claims.Y.equals(withRefund)) {
            return new Bank(
                    null,
                    Claims.N.equals(claimsSameBankAccount) ?
                            createAccount(bank.map(com.ctm.web.health.model.form.Bank::getClaim)) : null,
                    claimsSameBankAccount);
        } else if ("cc".equals(paymentType) && Claims.N.equals(withRefund)) {
            return new Bank(
                    null,
                    Claims.N.equals(claimsSameBankAccount) ?
                            createAccount(bank.map(com.ctm.web.health.model.form.Bank::getClaim)) : null,
                    claimsSameBankAccount);
        } else {
            return null;
        }
    }

    protected static Account createAccount(Optional<? extends BankDetails> bank) {
        if (bank.isPresent()) {
            return new Account(
                    bank.map(BankDetails::getName)
                            .map(BankName::new)
                            .orElse(null),
                    bank.map(BankDetails::getBsb)
                            .map(BSB::new)
                            .orElse(null),
                    bank.map(BankDetails::getAccount)
                            .map(AccountName::new)
                            .orElse(null),
                    bank.map(BankDetails::getNumber)
                            .map(AccountNumber::new)
                            .orElse(null));
        } else {
            return null;
        }
    }

    protected static GatewayCreditCard createGatewayCreditCard(Optional<com.ctm.web.health.model.form.Payment> payment) {
        if (payment.map(com.ctm.web.health.model.form.Payment::getDetails)
                .map(PaymentDetails::getType).filter(t -> "cc".equals(t)).isPresent()) {
            if (payment.map(com.ctm.web.health.model.form.Payment::getGateway)
                    .map(Gateway::getNab).isPresent()) {
                final Optional<Nab> nab = payment.map(com.ctm.web.health.model.form.Payment::getGateway)
                        .map(Gateway::getNab);
                return new GatewayCreditCard(
                        nab.map(Nab::getCardType)
                                .map(StringUtils::trim)
                                .map(Type::new)
                                .orElse(null),
                        nab.map(Nab::getCardName)
                                .map(Name::new)
                                .orElse(null),
                        nab.map(Nab::getCardNumber)
                                .map(com.ctm.web.health.apply.model.request.payment.credit.Number::new)
                                .orElse(null),
                        nab.map(n ->
                                new Expiry(
                                        Optional.ofNullable(n.getExpiryMonth())
                                                .map(ExpiryMonth::new)
                                                .orElse(null),
                                        Optional.ofNullable(n.getExpiryYear())
                                                .map(ExpiryYear::new)
                                                .orElse(null)))
                                .orElse(null),
                        nab.map(Nab::getCrn)
                                .map(CRN::new)
                                .orElse(null));
            } else if (payment.map(com.ctm.web.health.model.form.Payment::getGateway).isPresent()) {
                final Optional<Gateway> gateway = payment.map(com.ctm.web.health.model.form.Payment::getGateway);
                return new GatewayCreditCard(
                        gateway.map(Gateway::getType)
                                .map(Type::new)
                                .orElse(null),
                        gateway.map(Gateway::getName)
                                .map(Name::new)
                                .orElse(null),
                        gateway.map(Gateway::getNumber)
                                .map(Number::new)
                                .orElse(null),
                        gateway.map(Gateway::getExpiry)
                                .map(e -> {
                                    final String[] params = StringUtils.split(e, "/");
                                    if (params != null && params.length == 2) {
                                        return new Expiry(new ExpiryMonth(params[0]), new ExpiryYear(params[1]));
                                    } else {
                                        return null;
                                    }
                                }).orElse(null),
                        null);
            } else {
                return null;
            }
        } else {
            return null;
        }
    }

    protected static CreditCard createCreditCard(Optional<com.ctm.web.health.model.form.Payment> payment) {
        if (payment.map(com.ctm.web.health.model.form.Payment::getDetails)
                .map(PaymentDetails::getType).filter(t -> "cc".equals(t)).isPresent() &&
                !payment.map(com.ctm.web.health.model.form.Payment::getGateway).isPresent() &&
                payment.map(com.ctm.web.health.model.form.Payment::getCredit).isPresent() &&
                !payment.map(com.ctm.web.health.model.form.Payment::getCredit)
                        .map(Credit::getIpp)
                        .map(Ipp::getTokenisation).isPresent()) {
            final Optional<Credit> credit = payment.map(com.ctm.web.health.model.form.Payment::getCredit);
            return new CreditCard(
                    credit.map(Credit::getType)
                            .map(Type::new)
                            .orElse(null),
                    credit.map(Credit::getName)
                            .map(Name::new)
                            .orElse(null),
                    credit.map(Credit::getNumber)
                            .map(Number::new)
                            .orElse(null),
                    credit.map(Credit::getExpiry)
                            .map(e -> {
                                Optional<com.ctm.web.health.model.form.Expiry> expiry = Optional.ofNullable(e);
                                return new Expiry(
                                        expiry.map(com.ctm.web.health.model.form.Expiry::getCardExpiryMonth)
                                                .map(ExpiryMonth::new).orElse(null),
                                        expiry.map(com.ctm.web.health.model.form.Expiry::getCardExpiryYear)
                                                .map(ExpiryYear::new).orElse(null)
                                );})
                            .orElse(null),
                    credit.map(Credit::getCcv)
                            .map(CCV::new)
                            .orElse(null));
        } else {
            return null;
        }
    }

    private static IppCreditCard createCreditIppCreditCard(Optional<com.ctm.web.health.model.form.Payment> payment) {
        if (payment.map(com.ctm.web.health.model.form.Payment::getDetails)
                .map(PaymentDetails::getType).filter(t -> "cc".equals(t)).isPresent() &&
                payment.map(com.ctm.web.health.model.form.Payment::getCredit)
                        .map(Credit::getIpp)
                        .map(Ipp::getTokenisation).isPresent()) {
            final Optional<Credit> credit = payment.map(com.ctm.web.health.model.form.Payment::getCredit);
            return new IppCreditCard(
                    credit.map(Credit::getType)
                            .map(Type::new)
                            .orElse(null),
                    credit.map(Credit::getName)
                            .map(Name::new)
                            .orElse(null),
                    credit.map(Credit::getIpp)
                            .map(Ipp::getMaskedNumber)
                            .map(Number::new)
                            .orElse(null),
                    credit.map(Credit::getIpp)
                            .map(Ipp::getTokenisation)
                            .map(Token::new)
                            .orElse(null),
                    credit.map(Credit::getExpiry)
                            .map(e -> {
                                Optional<com.ctm.web.health.model.form.Expiry> expiry = Optional.ofNullable(e);
                                return new Expiry(
                                        expiry.map(com.ctm.web.health.model.form.Expiry::getCardExpiryMonth)
                                                .map(ExpiryMonth::new).orElse(null),
                                        expiry.map(com.ctm.web.health.model.form.Expiry::getCardExpiryYear)
                                                .map(ExpiryYear::new).orElse(null)
                                );})
                            .orElse(null));
        } else {
            return null;
        }
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
            } else if(payment.map(com.ctm.web.health.model.form.Payment::getPolicyDate).isPresent()) { // For BUD, GMB and Frank
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
