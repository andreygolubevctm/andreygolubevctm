package com.ctm.providers.health.healthapply.model;

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
import com.ctm.providers.health.healthapply.model.request.application.common.*;
import com.ctm.providers.health.healthapply.model.request.application.dependant.Dependant;
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
import com.ctm.providers.health.healthapply.model.request.payment.medicare.Medicare;
import com.ctm.providers.health.healthapply.model.request.payment.medicare.MedicareNumber;
import com.ctm.providers.health.healthapply.model.request.payment.medicare.Position;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.Collections;
import java.util.List;

import static java.util.Collections.singletonList;

public class RequestAdapter {

    private static final DateTimeFormatter AUS_FORMAT = DateTimeFormatter.ofPattern("dd/MM/yyyy");

    public static HealthApplicationRequest adapt(HealthRequest healthRequest) {
        final HealthQuote quote = healthRequest.getQuote();
        final com.ctm.model.health.form.ContactDetails quoteContactDetails = quote.getContactDetails();
        final com.ctm.model.health.form.Address quoteAddress = quote.getApplication().getAddress();
        final com.ctm.model.health.form.Address quotePostal = quote.getApplication().getPostal();
        final ContactDetails contactDetails = new ContactDetails(
                new Email(quoteContactDetails.getEmail()),
                OptInEmail.valueOf(quoteContactDetails.getOptin()),
                new MobileNumber(quoteContactDetails.getContactNumber().getMobile()),
                new OtherNumber(quoteContactDetails.getContactNumber().getOther()),
                Call.valueOf(quoteContactDetails.getCall()),
                PostalMatch.valueOf(quote.getApplication().getPostalMatch()),
                new Address(
                        new Postcode(quoteAddress.getPostCode()),
                        new FullAddressOneLine(quoteAddress.getFullAddress()),
                        new Suburb(quoteAddress.getSuburbName()),
                        new StreetNumber(quoteAddress.getStreetNum()),
                        new DPID(quoteAddress.getDpId()),
                        State.valueOf(quoteAddress.getState())),
                new Address(
                        new Postcode(quotePostal.getPostCode()),
                        new FullAddressOneLine(quotePostal.getFullAddress()),
                        new Suburb(quotePostal.getSuburbName()),
                        new StreetNumber(quotePostal.getStreetNum()),
                        new DPID(quotePostal.getDpId()),
                        State.valueOf(quotePostal.getState())));

        final Payment payment = new Payment(
                new Details(
                        new StartDate(paymentStartDate(quote.getPayment())),
                        PaymentType.findByCode(quote.getPayment().getDetails().getType()),
                        Frequency.fromCode(quote.getPayment().getDetails().getFrequency()),
                        Rebate.valueOf(quote.getHealthCover().getRebate()),
                        new Income(quote.getHealthCover().getIncome())),
                new CreditCard(
                        new Type(quote.getPayment().getCredit().getType()),
                        new Name(quote.getPayment().getCredit().getName()),
                        new Number(quote.getPayment().getCredit().getNumber()),
                        new Expiry(
                                new ExpiryMonth(quote.getPayment().getCredit().getExpiry().getCardExpiryMonth()),
                                new ExpiryYear(quote.getPayment().getCredit().getExpiry().getCardExpiryYear())),
                        new CCV(quote.getPayment().getCredit().getCcv())),
                new Bank(
                        new Account(
                                new BankName(quote.getPayment().getBank().getName()),
                                new BSB(quote.getPayment().getBank().getBsb()),
                                new AccountName(quote.getPayment().getBank().getAccount()),
                                new AccountNumber(quote.getPayment().getBank().getNumber())),
                        null,
                        Claims.Y),
                new Medicare(
                        Cover.valueOf(quote.getPayment().getMedicare().getCover()),
                        new MedicareNumber(quote.getPayment().getMedicare().getNumber()),
                        new FirstName(quote.getPayment().getMedicare().getFirstName()),
                        new LastName(quote.getPayment().getMedicare().getLastName()),
                        new Position(1),
                        new Expiry(
                                new ExpiryMonth(quote.getPayment().getMedicare().getExpiry().getCardExpiryMonth()),
                                new ExpiryYear(quote.getPayment().getMedicare().getExpiry().getCardExpiryYear()))));

        final FundData fundData = new FundData(
                new FundCode(quote.getApplication().getProductName()),
                new HospitalCoverName(""),
                new ExtrasCoverName(""),
                new Provider(quote.getApplication().getProvider()),
                new ProductId(quote.getApplication().getProductId()),
                Declaration.Y,
                new StartDate(LocalDate.parse(quote.getPayment().getDetails().getStart(), AUS_FORMAT)),
                new Benefits(
                        HealthSituation.valueOf(quote.getSituation().getHealthSitu())));

        final ApplicationGroup applicationGroup = new ApplicationGroup(
                new Applicant(
                        Title.valueOf(quote.getApplication().getPrimary().getTitle()),
                        new FirstName(quote.getApplication().getPrimary().getFirstname()),
                        new LastName(quote.getApplication().getPrimary().getSurname()),
                        Gender.valueOf(quote.getApplication().getPrimary().getGender()),
                        new DateOfBirth(LocalDate.parse(quote.getApplication().getPrimary().getDob(), AUS_FORMAT)),
                        new HealthCover(
                                Cover.valueOf(quote.getApplication().getPrimary().getCover()),
                                HealthCoverLoading.valueOf(quote.getApplication().getPrimary().getHealthCoverLoading())),
                        new PreviousFund(
                                HealthFund.valueOf(quote.getPreviousFund().getPrimary().getFundName()),
                                new MemberId(quote.getPreviousFund().getPrimary().getMemberId()),
                                ConfirmCover.Y,
                                Authority.Y)),
                new Applicant(
                        Title.valueOf(quote.getApplication().getPartner().getTitle()),
                        new FirstName(quote.getApplication().getPartner().getFirstname()),
                        new LastName(quote.getApplication().getPartner().getSurname()),
                        Gender.valueOf(quote.getApplication().getPartner().getGender()),
                        new DateOfBirth(LocalDate.parse(quote.getApplication().getPartner().getDob(), AUS_FORMAT)),
                        new HealthCover(
                                Cover.valueOf(quote.getApplication().getPartner().getCover()),
                                HealthCoverLoading.valueOf(quote.getApplication().getPartner().getHealthCoverLoading())),
                        new PreviousFund(
                                HealthFund.valueOf(quote.getPreviousFund().getPartner().getFundName()),
                                new MemberId(quote.getPreviousFund().getPartner().getMemberId()),
                                ConfirmCover.Y,
                                Authority.Y)),
                createDependants(quote.getApplication().getDependants()),
                new Situation(
                        HealthSituation.valueOf(quote.getSituation().getHealthSitu()),
                        HealthCoverCategory.valueOf(quote.getSituation().getHealthCvr())));


        return new HealthApplicationRequest(contactDetails, payment, fundData, applicationGroup, singletonList(quote.getApplication().getProvider()));
    }

    private static LocalDate paymentStartDate(com.ctm.model.health.form.Payment payment) {
        final LocalDate startDate = LocalDate.parse(payment.getDetails().getStart(), AUS_FORMAT);
        final LocalDate paymentDate = startDate.withDayOfMonth(payment.getCredit().getDay());
        return paymentDate.isBefore(startDate) ? paymentDate.plusMonths(1) : paymentDate;
    }

    private static List<Dependant> createDependants(Dependants dependants) {
        // FIXME: return the dependant list
        return Collections.emptyList();
    }

}
