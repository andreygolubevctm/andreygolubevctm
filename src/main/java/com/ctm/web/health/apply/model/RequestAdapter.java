package com.ctm.web.health.apply.model;

import com.ctm.web.health.apply.model.request.HealthApplicationRequest;
import com.ctm.web.health.apply.model.request.application.ApplicationGroup;
import com.ctm.web.health.apply.model.request.application.Emigrate;
import com.ctm.web.health.apply.model.request.application.applicant.Applicant;
import com.ctm.web.health.apply.model.request.application.applicant.CertifiedAgeEntry;
import com.ctm.web.health.apply.model.request.application.applicant.healthCover.Cover;
import com.ctm.web.health.apply.model.request.application.applicant.healthCover.HealthCover;
import com.ctm.web.health.apply.model.request.application.applicant.healthCover.HealthCoverLoading;
import com.ctm.web.health.apply.model.request.application.applicant.previousFund.ConfirmCover;
import com.ctm.web.health.apply.model.request.application.applicant.previousFund.MemberId;
import com.ctm.web.health.apply.model.request.application.applicant.previousFund.PreviousFund;
import com.ctm.web.health.apply.model.request.application.common.*;
import com.ctm.web.health.apply.model.request.application.dependant.Dependant;
import com.ctm.web.health.apply.model.request.application.dependant.FullTimeStudent;
import com.ctm.web.health.apply.model.request.application.dependant.School;
import com.ctm.web.health.apply.model.request.application.dependant.SchoolId;
import com.ctm.web.health.apply.model.request.application.situation.HealthCoverCategory;
import com.ctm.web.health.apply.model.request.application.situation.HealthSituation;
import com.ctm.web.health.apply.model.request.application.situation.Situation;
import com.ctm.web.health.apply.model.request.contactDetails.Address.Address;
import com.ctm.web.health.apply.model.request.contactDetails.Address.*;
import com.ctm.web.health.apply.model.request.contactDetails.*;
import com.ctm.web.health.apply.model.request.contactDetails.ContactDetails;
import com.ctm.web.health.apply.model.request.fundData.*;
import com.ctm.web.health.apply.model.request.fundData.FundData;
import com.ctm.web.health.apply.model.request.fundData.benefits.Benefits;
import com.ctm.web.health.apply.model.request.fundData.membership.*;
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
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.Optional;

import static java.util.Collections.emptyList;

public class RequestAdapter {

    private static final DateTimeFormatter AUS_FORMAT = DateTimeFormatter.ofPattern("dd/MM/yyyy");
    private static final DateTimeFormatter ISO_FORMAT = DateTimeFormatter.ofPattern("yyyy-MM-dd");

    public static HealthApplicationRequest adapt(HealthRequest healthRequest) {
        final Optional<HealthQuote> quote = Optional.ofNullable(healthRequest.getQuote());
        return new HealthApplicationRequest(
                createContactDetails(quote),
                createPayment(quote),
                createFundData(quote),
                createApplicationGroup(quote),
                quote.map(HealthQuote::getApplication)
                    .map(Application::getProvider)
                    .map(Collections::singletonList)
                        .orElse(emptyList()));
    }

    protected static ApplicationGroup createApplicationGroup(Optional<HealthQuote> quote) {
        return new ApplicationGroup(
                createApplicant(
                        quote.map(HealthQuote::getApplication)
                                .map(Application::getPrimary),
                        quote.map(HealthQuote::getPreviousFund)
                                .map(com.ctm.web.health.model.form.PreviousFund::getPrimary),
                        quote.map(HealthQuote::getPrimaryCAE),
                        quote.map(HealthQuote::getHealthCover)
                                .map(com.ctm.web.health.model.form.HealthCover::getPrimary)),
                quote.map(HealthQuote::getApplication)
                    .map(Application::getPartner)
                    .map(Person::getTitle).isPresent()
                 ? createApplicant(
                        quote.map(HealthQuote::getApplication)
                                .map(Application::getPartner),
                        quote.map(HealthQuote::getPreviousFund)
                                .map(com.ctm.web.health.model.form.PreviousFund::getPartner),
                        quote.map(HealthQuote::getPartnerCAE),
                        quote.map(HealthQuote::getHealthCover)
                                .map(com.ctm.web.health.model.form.HealthCover::getPartner)) : null,
                createDependants(quote.map(HealthQuote::getApplication)
                        .map(Application::getDependants)),
                createSituation(quote.map(HealthQuote::getSituation)),
                quote.map(HealthQuote::getApplication)
                        .map(Application::getHif)
                        .map(Hif::getEmigrate)
                        .map(Emigrate::valueOf)
                        .orElse(quote.map(HealthQuote::getApplication)
                                    .map(Application::getQch)
                                    .map(Qch::getEmigrate)
                                    .map(Emigrate::valueOf)
                                    .orElse(null)));
    }

    protected static Situation createSituation(Optional<com.ctm.web.health.model.form.Situation> situation) {
        if (situation.isPresent()) {
            return new Situation(
                    situation.map(com.ctm.web.health.model.form.Situation::getHealthSitu)
                            .map(HealthSituation::valueOf)
                            .orElse(null),
                    situation.map(com.ctm.web.health.model.form.Situation::getHealthCvr)
                            .map(HealthCoverCategory::valueOf)
                            .orElse(null));
        } else {
            return null;
        }
    }

    protected static Applicant createApplicant(Optional<Person> person, Optional<Fund> previousFund, Optional<Integer> certifiedAgeEntry, Optional<Insured> insured) {
        if (person.isPresent()) {
            return new Applicant(
                    person.map(Person::getTitle)
                            .map(Title::valueOf)
                            .orElse(null),
                    person.map(Person::getFirstname)
                            .map(FirstName::new)
                            .orElse(null),
                    person.map(Person::getSurname)
                            .map(LastName::new)
                            .orElse(null),
                    person.map(Person::getGender)
                            .map(Gender::valueOf)
                            .orElse(null),
                    person.map(Person::getDob)
                            .map(v -> LocalDate.parse(v, AUS_FORMAT))
                            .orElse(null),
                    insured.map(i -> new HealthCover(
                            Optional.ofNullable(i.getCover())
                                    .map(Cover::valueOf)
                                    .orElse(null),
                            Optional.ofNullable(i.getHealthCoverLoading())
                                    .map(HealthCoverLoading::valueOf)
                                    .orElse(null)))
                            .orElse(null),
                    createPreviousFund(previousFund),
                    certifiedAgeEntry
                            .map(CertifiedAgeEntry::new)
                            .orElse(null),
                    person.map(Person::getAuthority)
                        .map(Authority::valueOf)
                        .orElse(null));
        }
        return null;
    }

    protected static PreviousFund createPreviousFund(Optional<Fund> previousFund) {
        final HealthFund healthFund = previousFund.map(Fund::getFundName)
                .map(HealthFund::findByCode)
                .orElse(HealthFund.NONE);
        if (previousFund.isPresent() && !HealthFund.NONE.equals(healthFund)) {
            return new PreviousFund(
                    healthFund,
                    previousFund.map(Fund::getMemberId)
                            .map(MemberId::new)
                            .orElse(null),
                    ConfirmCover.Y,
                    previousFund.map(Fund::getAuthority)
                        .map(Authority::valueOf)
                        .orElse(null));
        } else {
            return null;
        }
    }

    protected static FundData createFundData(Optional<HealthQuote> quote) {
        return new FundData(
                quote.map(HealthQuote::getApplication)
                    .map(Application::getProvider)
                    .map(Provider::new)
                    .orElse(null),
                quote.map(HealthQuote::getApplication)
                        .map(Application::getProductId)
                        .map(v -> StringUtils.substringAfter(v, "HEALTH-"))
                        .map(ProductId::new)
                        .orElse(null),
                Declaration.Y,
                quote.map(HealthQuote::getPayment)
                    .map(com.ctm.web.health.model.form.Payment::getDetails)
                    .map(PaymentDetails::getStart)
                    .map(v -> LocalDate.parse(v, AUS_FORMAT))
                    .orElse(null),
                quote.map(HealthQuote::getSituation)
                    .map(com.ctm.web.health.model.form.Situation::getHealthSitu)
                    .map(v -> new Benefits(HealthSituation.valueOf(v)))
                    .orElse(null),
                createMembership(quote.map(HealthQuote::getApplication)
                    .map(Application::getCbh)));
    }

    protected static Membership createMembership(Optional<Cbh> cbh) {
        if (cbh.isPresent()) {
            final RegisteredMember registeredMember;
            final CurrentMember currentMember;
            final MembershipNumber membershipNumber;
            final MembershipGroup membershipGroup;
            if (cbh.map(Cbh::getCurrentemployee)
                    .filter(s -> "Y".equals(s)).isPresent()) {
                registeredMember = RegisteredMember.PRIMARY;
                currentMember = CurrentMember.Y;
                membershipNumber = cbh.map(Cbh::getCurrentnumber)
                        .map(MembershipNumber::new)
                        .orElse(null);
                membershipGroup = cbh.map(Cbh::getCurrentwork)
                        .map(MembershipGroup::new)
                        .orElse(null);
            } else if (cbh.map(Cbh::getFormeremployee)
                    .filter(s -> "Y".equals(s)).isPresent()) {
                registeredMember = RegisteredMember.PRIMARY;
                currentMember = CurrentMember.N;
                membershipNumber = cbh.map(Cbh::getFormernumber)
                        .map(MembershipNumber::new)
                        .orElse(null);
                membershipGroup = cbh.map(Cbh::getFormerwork)
                        .map(MembershipGroup::new)
                        .orElse(null);
            } else if (cbh.map(Cbh::getFamilymember)
                    .filter(s -> "Y".equals(s)).isPresent()) {
                registeredMember = cbh.map(Cbh::getFamilyrel)
                        .map(StringUtils::upperCase)
                        .map(RegisteredMember::valueOf)
                        .orElse(null);
                currentMember = null;
                membershipNumber = cbh.map(Cbh::getFamilynumber)
                        .map(MembershipNumber::new)
                        .orElse(null);
                membershipGroup = cbh.map(Cbh::getFamilywork)
                        .map(MembershipGroup::new)
                        .orElse(null);
            } else {
                registeredMember = null;
                currentMember = null;
                membershipNumber = null;
                membershipGroup = null;
            }

            return new Membership(
                    registeredMember,
                    currentMember,
                    membershipNumber,
                    membershipGroup,
                    createPartnerDetails(cbh),
                    cbh.map(Cbh::getRegister)
                        .map(RegisterForGroupServices::valueOf)
                        .orElse(null));
        } else {
            return null;
        }
    }

    private static PartnerDetails createPartnerDetails(Optional<Cbh> cbh) {
        if (cbh.isPresent()) {
            return new PartnerDetails(
                    cbh.map(Cbh::getPartnerrel)
                            .map(RelationshipToPrimary::new)
                            .orElse(null),
                    cbh.map(Cbh::getPartneremployee)
                            .map(SameGroupMember::valueOf)
                            .orElse(null));
        } else {
            return null;
        }
    }


    protected static Payment createPayment(Optional<HealthQuote> quote) {
        final Optional<com.ctm.web.health.model.form.Payment> payment = quote.map(HealthQuote::getPayment);
        if (payment.isPresent()) {
            return new Payment(
                    createPaymentDetails(quote, payment),
                    createCreditCard(quote.map(HealthQuote::getPayment)),
                    createCreditIppCreditCard(quote.map(HealthQuote::getPayment)),
                    createGatewayCreditCard(quote.map(HealthQuote::getPayment)),
                    createBank(quote.map(HealthQuote::getPayment)),
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
                        .map(Frequency::fromCode)
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

    protected static ContactDetails createContactDetails(Optional<HealthQuote> quote) {
        final Optional<com.ctm.web.health.model.form.ContactDetails> contactDetails = quote.map(HealthQuote::getContactDetails);
        PostalMatch postalMatch = quote.map(HealthQuote::getApplication)
                                        .map(Application::getPostalMatch)
                                        .map(PostalMatch::valueOf)
                                        .orElse(PostalMatch.N);
        if (contactDetails.isPresent()) {
            return new ContactDetails(
                    contactDetails.map(com.ctm.web.health.model.form.ContactDetails::getEmail)
                            .map(Email::new)
                            .orElse(null),
                    contactDetails.map(com.ctm.web.health.model.form.ContactDetails::getOptin)
                            .map(OptInEmail::valueOf)
                            .orElse(null),
                    quote.map(HealthQuote::getApplication)
                        .map(Application::getMobile)
                        .map(MobileNumber::new)
                        .orElse(null),
                    quote.map(HealthQuote::getApplication)
                            .map(Application::getOther)
                            .map(OtherNumber::new)
                            .orElse(null),
                    quote.map(HealthQuote::getApplication)
                            .map(Application::getCall)
                            .map(Call::valueOf)
                            .orElse(null),
                    postalMatch,
                    createAddress(quote.map(HealthQuote::getApplication)
                            .map(Application::getAddress)),
                    !PostalMatch.Y.equals(postalMatch) ?
                            createAddress(quote.map(HealthQuote::getApplication)
                                    .map(Application::getPostal)) : null,
                    quote.map(HealthQuote::getApplication)
                        .map(Application::getContactPoint)
                        .filter(c -> c.equals("E") || c.equals("P"))
                        .map(c -> c.equals("E") ? PreferredContact.EMAIL : PreferredContact.PHONE)
                        .orElse(null),
                    quote.map(HealthQuote::getContactAuthority)
                        .map(Contactable::valueOf)
                        .orElse(null));
        } else {
            return null;
        }
    }

    protected static Address createAddress(Optional<com.ctm.web.health.model.form.Address> address) {
        if (address.isPresent()) {
            return new Address(
                    address.map(com.ctm.web.health.model.form.Address::getPostCode)
                            .map(Postcode::new)
                            .orElse(null),
                    address.map(com.ctm.web.health.model.form.Address::getFullAddressLineOne)
                            .map(FullAddressOneLine::new)
                            .orElse(null),
                    address.map(com.ctm.web.health.model.form.Address::getSuburbName)
                            .map(Suburb::new)
                            .orElse(null),
                    address.map(com.ctm.web.health.model.form.Address::getStreetNum)
                            .map(StreetNumber::new)
                            .orElse(null),
                    address.map(com.ctm.web.health.model.form.Address::getDpId)
                            .map(DPID::new)
                            .orElse(null),
                    address.map(com.ctm.web.health.model.form.Address::getState)
                            .map(State::valueOf)
                            .orElse(null));
        } else {
            return null;
        }
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

    protected static Bank createBank(Optional<com.ctm.web.health.model.form.Payment> payment) {
        final String paymentType = payment.map(com.ctm.web.health.model.form.Payment::getDetails)
                                        .map(PaymentDetails::getType)
                                        .orElse(null);
        final Optional<com.ctm.web.health.model.form.Bank> bank = payment.map(com.ctm.web.health.model.form.Payment::getBank);
        final Claims claimsSameBankAccount = bank.map(com.ctm.web.health.model.form.Bank::getClaims)
                .map(Claims::valueOf)
                .orElse(Claims.N);
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
                                .map(Number::new)
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
                        .map(v -> LocalDate.parse(v, ISO_FORMAT))
                        .orElse(null);
            } else if (credit.map(Credit::getDay).isPresent()) {
                return LocalDate.now().withDayOfMonth(credit.map(Credit::getDay).get());
            } else {
                return payment
                        .map(com.ctm.web.health.model.form.Payment::getDetails)
                        .map(PaymentDetails::getStart)
                        .map(v -> LocalDate.parse(v, AUS_FORMAT))
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
                        .map(v -> LocalDate.parse(v, ISO_FORMAT))
                        .orElse(null);
            } else if (bank.map(com.ctm.web.health.model.form.Bank::getDay).isPresent()) {
                return LocalDate.now().withDayOfMonth(bank.map(com.ctm.web.health.model.form.Bank::getDay).get());
            } else {
                return payment
                        .map(com.ctm.web.health.model.form.Payment::getDetails)
                        .map(PaymentDetails::getStart)
                        .map(v -> LocalDate.parse(v, AUS_FORMAT))
                        .orElse(null);
            }
        } else {
            //
            return null;
        }
    }

    protected static List<Dependant> createDependants(Optional<Dependants> dependants) {
        if (dependants.isPresent()) {
            final List<Dependant> dependantList = new ArrayList<>();
            Optional.ofNullable(createDependant(dependants.map(Dependants::getDependant1)))
                    .ifPresent(dependantList::add);
            Optional.ofNullable(createDependant(dependants.map(Dependants::getDependant2)))
                    .ifPresent(dependantList::add);
            Optional.ofNullable(createDependant(dependants.map(Dependants::getDependant3)))
                    .ifPresent(dependantList::add);
            Optional.ofNullable(createDependant(dependants.map(Dependants::getDependant4)))
                    .ifPresent(dependantList::add);
            Optional.ofNullable(createDependant(dependants.map(Dependants::getDependant5)))
                    .ifPresent(dependantList::add);
            Optional.ofNullable(createDependant(dependants.map(Dependants::getDependant6)))
                    .ifPresent(dependantList::add);
            Optional.ofNullable(createDependant(dependants.map(Dependants::getDependant7)))
                    .ifPresent(dependantList::add);
            Optional.ofNullable(createDependant(dependants.map(Dependants::getDependant8)))
                    .ifPresent(dependantList::add);
            Optional.ofNullable(createDependant(dependants.map(Dependants::getDependant9)))
                    .ifPresent(dependantList::add);
            Optional.ofNullable(createDependant(dependants.map(Dependants::getDependant10)))
                    .ifPresent(dependantList::add);
            Optional.ofNullable(createDependant(dependants.map(Dependants::getDependant11)))
                    .ifPresent(dependantList::add);
            Optional.ofNullable(createDependant(dependants.map(Dependants::getDependant12)))
                    .ifPresent(dependantList::add);
            return dependantList;
        } else {
            return null;
        }
    }

    protected static Dependant createDependant(Optional<com.ctm.web.health.model.form.Dependant> dependant) {
        if (dependant.isPresent()) {
            return new Dependant(
                    dependant.map(com.ctm.web.health.model.form.Dependant::getTitle)
                        .map(Title::valueOf)
                        .orElse(null),
                    dependant.map(com.ctm.web.health.model.form.Dependant::getFirstname)
                        .map(FirstName::new)
                        .orElse(null),
                    dependant.map(com.ctm.web.health.model.form.Dependant::getLastname)
                        .map(LastName::new)
                        .orElse(null),
                    dependant.map(com.ctm.web.health.model.form.Dependant::getDob)
                        .map(v -> LocalDate.parse(v, AUS_FORMAT))
                        .orElse(null),
                    dependant.map(com.ctm.web.health.model.form.Dependant::getSchool)
                        .map(School::new)
                        .orElse(null),
                    dependant.map(com.ctm.web.health.model.form.Dependant::getSchoolDate)
                        .map(v -> LocalDate.parse(v, AUS_FORMAT))
                        .orElse(null),
                    dependant.map(com.ctm.web.health.model.form.Dependant::getSchoolID)
                        .map(SchoolId::new)
                        .orElse(null),
                    dependant.map(com.ctm.web.health.model.form.Dependant::getTitle)
                        .map(Title::valueOf)
                        .filter(t -> Title.MR.equals(t))
                        .map(v -> Gender.M)
                        .orElse(Gender.F),
                    dependant.map(com.ctm.web.health.model.form.Dependant::getFulltime)
                        .map(FullTimeStudent::valueOf)
                        .orElse(null));
        } else {
            return null;
        }
    }
}
