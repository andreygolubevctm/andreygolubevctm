package com.ctm.providers.health.healthapply.model;

import com.ctm.model.health.form.Credit;
import com.ctm.model.health.form.Dependants;
import com.ctm.model.health.form.HealthQuote;
import com.ctm.model.health.form.HealthRequest;
import com.ctm.providers.health.healthapply.model.request.HealthApplicationRequest;
import com.ctm.providers.health.healthapply.model.request.application.ApplicationGroup;
import com.ctm.providers.health.healthapply.model.request.application.applicant.Applicant;
import com.ctm.providers.health.healthapply.model.request.application.applicant.healthCover.Cover;
import com.ctm.providers.health.healthapply.model.request.application.applicant.healthCover.HealthCover;
import com.ctm.providers.health.healthapply.model.request.application.applicant.healthCover.HealthCoverLoading;
import com.ctm.providers.health.healthapply.model.request.application.applicant.previousFund.Authority;
import com.ctm.providers.health.healthapply.model.request.application.applicant.previousFund.ConfirmCover;
import com.ctm.providers.health.healthapply.model.request.application.applicant.previousFund.MemberId;
import com.ctm.providers.health.healthapply.model.request.application.applicant.previousFund.PreviousFund;
import com.ctm.providers.health.healthapply.model.request.application.common.FirstName;
import com.ctm.providers.health.healthapply.model.request.application.common.Gender;
import com.ctm.providers.health.healthapply.model.request.application.common.LastName;
import com.ctm.providers.health.healthapply.model.request.application.common.Title;
import com.ctm.providers.health.healthapply.model.request.application.dependant.Dependant;
import com.ctm.providers.health.healthapply.model.request.application.dependant.School;
import com.ctm.providers.health.healthapply.model.request.application.dependant.SchoolId;
import com.ctm.providers.health.healthapply.model.request.application.situation.HealthCoverCategory;
import com.ctm.providers.health.healthapply.model.request.application.situation.HealthSituation;
import com.ctm.providers.health.healthapply.model.request.application.situation.Situation;
import com.ctm.providers.health.healthapply.model.request.contactDetails.Address.*;
import com.ctm.providers.health.healthapply.model.request.contactDetails.*;
import com.ctm.providers.health.healthapply.model.request.fundData.*;
import com.ctm.providers.health.healthapply.model.request.fundData.benefits.Benefits;
import com.ctm.providers.health.healthapply.model.request.payment.Payment;
import com.ctm.providers.health.healthapply.model.request.payment.bank.Bank;
import com.ctm.providers.health.healthapply.model.request.payment.bank.Claims;
import com.ctm.providers.health.healthapply.model.request.payment.bank.account.*;
import com.ctm.providers.health.healthapply.model.request.payment.common.Expiry;
import com.ctm.providers.health.healthapply.model.request.payment.common.ExpiryMonth;
import com.ctm.providers.health.healthapply.model.request.payment.common.ExpiryYear;
import com.ctm.providers.health.healthapply.model.request.payment.credit.*;
import com.ctm.providers.health.healthapply.model.request.payment.credit.Number;
import com.ctm.providers.health.healthapply.model.request.payment.details.*;
import com.ctm.providers.health.healthapply.model.request.payment.details.Frequency;
import com.ctm.providers.health.healthapply.model.request.payment.medicare.Medicare;
import com.ctm.providers.health.healthapply.model.request.payment.medicare.MedicareNumber;
import com.ctm.providers.health.healthapply.model.request.payment.medicare.Position;
import org.apache.commons.lang3.StringUtils;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;

import static java.util.Collections.singletonList;

public class RequestAdapter {

    private static final DateTimeFormatter AUS_FORMAT = DateTimeFormatter.ofPattern("dd/MM/yyyy");

    public static HealthApplicationRequest adapt(HealthRequest healthRequest) {
        final HealthQuote quote = healthRequest.getQuote();
        final com.ctm.model.health.form.ContactDetails quoteContactDetails = quote.getContactDetails();
        final com.ctm.model.health.form.Address quoteAddress = quote.getApplication().getAddress();
        final com.ctm.model.health.form.Address quotePostal = quote.getApplication().getPostal();
        final PostalMatch postalMatch = PostalMatch.valueOf(StringUtils.defaultIfEmpty(quote.getApplication().getPostalMatch(), "N"));
        final ContactDetails contactDetails = new ContactDetails(
                new Email(quoteContactDetails.getEmail()),
                OptInEmail.valueOf(quoteContactDetails.getOptin()),
                new MobileNumber(quoteContactDetails.getContactNumber().getMobile()),
                new OtherNumber(quoteContactDetails.getContactNumber().getOther()),
                Call.valueOf(quoteContactDetails.getCall()),
                postalMatch,
                new Address(
                        new Postcode(quoteAddress.getPostCode()),
                        new FullAddressOneLine(quoteAddress.getFullAddressLineOne()),
                        new Suburb(quoteAddress.getSuburbName()),
                        new StreetNumber(quoteAddress.getStreetNum()),
                        new DPID(quoteAddress.getDpId()),
                        State.valueOf(quoteAddress.getState())),
                !PostalMatch.Y.equals(postalMatch) ?
                new Address(
                        new Postcode(quotePostal.getPostCode()),
                        new FullAddressOneLine(quotePostal.getFullAddressLineOne()),
                        new Suburb(quotePostal.getSuburbName()),
                        new StreetNumber(quotePostal.getStreetNum()),
                        new DPID(quotePostal.getDpId()),
                        State.valueOf(quotePostal.getState())) : null);

        final Payment payment = new Payment(
                new Details(
                        paymentStartDate(quote.getPayment()),
                        PaymentType.findByCode(quote.getPayment().getDetails().getType()),
                        Frequency.fromCode(quote.getPayment().getDetails().getFrequency()),
                        Rebate.valueOf(quote.getHealthCover() != null ? quote.getHealthCover().getRebate() : null),
                        quote.getHealthCover() != null && quote.getHealthCover().getIncome() != null ?
                                new Income(quote.getHealthCover().getIncome()) : null,
                        quote.getLoading() != null ? new LifetimeHealthCoverLoading(quote.getLoading().doubleValue()) : null),
                createCreditCard(quote),
                createBank(quote),
                createMedicare(quote));
        final FundData fundData = new FundData(
                new Provider(quote.getApplication().getProvider()),
                new ProductId(quote.getApplication().getProductId()
                        .substring(quote.getApplication().getProductId().indexOf("HEALTH-") + 7)),
                Declaration.Y,
                LocalDate.parse(quote.getPayment().getDetails().getStart(), AUS_FORMAT),
                new Benefits(
                        HealthSituation.valueOf(quote.getSituation().getHealthSitu())));

        final ApplicationGroup applicationGroup = new ApplicationGroup(
                new Applicant(
                        Title.valueOf(quote.getApplication().getPrimary().getTitle()),
                        new FirstName(quote.getApplication().getPrimary().getFirstname()),
                        new LastName(quote.getApplication().getPrimary().getSurname()),
                        Gender.valueOf(quote.getApplication().getPrimary().getGender()),
                        LocalDate.parse(quote.getApplication().getPrimary().getDob(), AUS_FORMAT),
                        new HealthCover(
                                quote.getApplication().getPrimary().getCover() != null ? Cover.valueOf(quote.getApplication().getPrimary().getCover()) : null,
                                quote.getApplication().getPrimary().getHealthCoverLoading() != null ?
                                        HealthCoverLoading.valueOf(quote.getApplication().getPrimary().getHealthCoverLoading()) : null),
                        new PreviousFund(
                                HealthFund.valueOf(quote.getPreviousFund().getPrimary().getFundName()),
                                new MemberId(quote.getPreviousFund().getPrimary().getMemberId()),
                                ConfirmCover.Y,
                                Authority.Y)),
                quote.getApplication().getPartner().getTitle() != null ?
                new Applicant(
                        Title.valueOf(quote.getApplication().getPartner().getTitle()),
                        new FirstName(quote.getApplication().getPartner().getFirstname()),
                        new LastName(quote.getApplication().getPartner().getSurname()),
                        Gender.valueOf(quote.getApplication().getPartner().getGender()),
                        LocalDate.parse(quote.getApplication().getPartner().getDob(), AUS_FORMAT),
                        new HealthCover(
                                quote.getApplication().getPartner().getCover() != null ? Cover.valueOf(quote.getApplication().getPartner().getCover()) : null,
                                quote.getApplication().getPartner().getHealthCoverLoading() != null ? HealthCoverLoading.valueOf(quote.getApplication().getPartner().getHealthCoverLoading()): null),
                        new PreviousFund(
                                HealthFund.valueOf(quote.getPreviousFund().getPartner().getFundName()),
                                new MemberId(quote.getPreviousFund().getPartner().getMemberId()),
                                ConfirmCover.Y,
                                Authority.Y)) : null,
                createDependants(quote.getApplication().getDependants()),
                new Situation(
                        HealthSituation.valueOf(quote.getSituation().getHealthSitu()),
                        HealthCoverCategory.valueOf(quote.getSituation().getHealthCvr())));


        return new HealthApplicationRequest(contactDetails, payment, fundData, applicationGroup, singletonList(quote.getApplication().getProvider()));
    }

    private static Medicare createMedicare(HealthQuote quote) {
        final com.ctm.model.health.form.Medicare medicare = quote.getPayment().getMedicare();
        if (medicare != null) {
            return new Medicare(
                    Cover.valueOf(medicare.getCover()),
                    new MedicareNumber(medicare.getNumber()),
                    new FirstName(medicare.getFirstName()),
                    new LastName(medicare.getLastName()),
                    new Position(1),
                    new Expiry(
                            new ExpiryMonth(medicare.getExpiry().getCardExpiryMonth()),
                            new ExpiryYear(medicare.getExpiry().getCardExpiryYear())));
        } else {
            return null;
        }
    }

    private static Bank createBank(HealthQuote quote) {
        final com.ctm.model.health.form.Payment payment = quote.getPayment();
        if ("ba".equals(payment.getDetails().getType())) {
            final com.ctm.model.health.form.Bank bank = payment.getBank();
            return new Bank(
                    new Account(
                            new BankName(bank.getName()),
                            new BSB(bank.getBsb()),
                            new AccountName(bank.getAccount()),
                            new AccountNumber(bank.getNumber())),
                    "Y".equals(bank.getClaims()) && bank.getClaim() != null ?
                    new Account(
                            new BankName(bank.getClaim().getName()),
                            new BSB(bank.getClaim().getBsb()),
                            new AccountName(bank.getClaim().getAccount()),
                            new AccountNumber(bank.getClaim().getNumber())) : null,
                    bank.getClaims() != null ? Claims.valueOf(bank.getClaims()) : null);
        } else if ("cc".equals(payment.getDetails().getType())) {
            final com.ctm.model.health.form.Bank bank = payment.getBank();
            return new Bank(
                    null,
                    "Y".equals(bank.getClaims()) ?
                            new Account(
                                    new BankName(bank.getClaim().getName()),
                                    new BSB(bank.getClaim().getBsb()),
                                    new AccountName(bank.getClaim().getAccount()),
                                    new AccountNumber(bank.getClaim().getNumber())) : null,
                    Claims.valueOf(bank.getClaims()));
        } else {
            return null;
        }
    }

    private static CreditCard createCreditCard(HealthQuote quote) {
        final com.ctm.model.health.form.Payment payment = quote.getPayment();
        if("cc".equals(payment.getDetails().getType()) && payment.getCredit().getType() != null) {
            final Credit credit = payment.getCredit();
            return new CreditCard(
                    new Type(credit.getType()),
                    new Name(credit.getName()),
                    new Number(credit.getNumber()),
                    new Expiry(
                            new ExpiryMonth(credit.getExpiry().getCardExpiryMonth()),
                            new ExpiryYear(credit.getExpiry().getCardExpiryYear())),
                    new CCV(credit.getCcv()));
        } else {
            return null;
        }
    }

    private static LocalDate paymentStartDate(com.ctm.model.health.form.Payment payment) {
        final LocalDate startDate = LocalDate.parse(payment.getDetails().getStart(), AUS_FORMAT);
        if (payment.getCredit() != null) {
            final LocalDate paymentDate = startDate.withDayOfMonth(payment.getCredit().getDay());
            return paymentDate.isBefore(startDate) ? paymentDate.plusMonths(1) : paymentDate;
        } else {
            return startDate;
        }
    }

    private static List<Dependant> createDependants(Dependants dependants) {
        final List<Dependant> dependantList = new ArrayList<>();
        if(dependants.getDependant1() != null) {
            dependantList.add(createDependant(dependants.getDependant1()));
        }
        if(dependants.getDependant2() != null) {
            dependantList.add(createDependant(dependants.getDependant2()));
        }
        if(dependants.getDependant3() != null) {
            dependantList.add(createDependant(dependants.getDependant3()));
        }
        if(dependants.getDependant4() != null) {
            dependantList.add(createDependant(dependants.getDependant4()));
        }
        if(dependants.getDependant5() != null) {
            dependantList.add(createDependant(dependants.getDependant5()));
        }
        if(dependants.getDependant6() != null) {
            dependantList.add(createDependant(dependants.getDependant6()));
        }
        if(dependants.getDependant7() != null) {
            dependantList.add(createDependant(dependants.getDependant7()));
        }
        if(dependants.getDependant8() != null) {
            dependantList.add(createDependant(dependants.getDependant8()));
        }
        if(dependants.getDependant9() != null) {
            dependantList.add(createDependant(dependants.getDependant9()));
        }
        if(dependants.getDependant10() != null) {
            dependantList.add(createDependant(dependants.getDependant10()));
        }
        if(dependants.getDependant11() != null) {
            dependantList.add(createDependant(dependants.getDependant11()));
        }
        if(dependants.getDependant12() != null) {
            dependantList.add(createDependant(dependants.getDependant12()));
        }
        return dependantList;
    }

    private static Dependant createDependant(com.ctm.model.health.form.Dependant formDependant) {
        if (formDependant.getTitle() != null) {

            return new Dependant(
                    Title.valueOf(formDependant.getTitle()),
                    new FirstName(formDependant.getFirstname()),
                    new LastName(formDependant.getLastname()),
                    LocalDate.parse(formDependant.getDob(), AUS_FORMAT),
                    new School(formDependant.getSchool()),
                    StringUtils.isNotBlank(formDependant.getSchoolDate()) ? LocalDate.parse(formDependant.getSchoolDate(), AUS_FORMAT) : null,
                    new SchoolId(formDependant.getSchoolID()),
                    Title.MR.equals(Title.valueOf(formDependant.getTitle())) ? Gender.M : Gender.F);
        } else {
            return null;
        }
    }
}
