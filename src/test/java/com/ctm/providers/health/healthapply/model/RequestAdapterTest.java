package com.ctm.providers.health.healthapply.model;

import com.ctm.model.health.form.*;
import com.ctm.providers.health.healthapply.model.request.application.ApplicationGroup;
import com.ctm.providers.health.healthapply.model.request.application.applicant.Applicant;
import com.ctm.providers.health.healthapply.model.request.application.applicant.previousFund.PreviousFund;
import com.ctm.providers.health.healthapply.model.request.application.situation.Situation;
import com.ctm.providers.health.healthapply.model.request.fundData.Declaration;
import com.ctm.providers.health.healthapply.model.request.fundData.FundData;
import com.ctm.providers.health.healthapply.model.request.payment.Payment;
import com.ctm.providers.health.healthapply.model.request.payment.credit.CreditCard;
import org.junit.Test;

import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

import static org.junit.Assert.*;
import static org.mockito.Mockito.*;

public class RequestAdapterTest {

    @Test
    public void testCreateApplicationGroupEmpty() throws Exception {
        final ApplicationGroup applicationGroup = RequestAdapter.createApplicationGroup(Optional.empty());
        assertNotNull(applicationGroup);
    }

    @Test
    public void testCreateApplicationGroup() throws Exception {
        final HealthQuote healthQuote = mock(HealthQuote.class);
        final Application application = mock(Application.class);
        final com.ctm.model.health.form.PreviousFund previousFund = mock(com.ctm.model.health.form.PreviousFund.class);
        when(healthQuote.getApplication()).thenReturn(application);
        when(healthQuote.getPreviousFund()).thenReturn(previousFund);
        final ApplicationGroup applicationGroup = RequestAdapter.createApplicationGroup(Optional.ofNullable(healthQuote));
        assertNotNull(applicationGroup);
        assertNull(applicationGroup.getSituation());
        assertNull(applicationGroup.getDependants());
        verify(application, times(1)).getPrimary();
        verify(previousFund, times(1)).getPrimary();
        verify(application, times(1)).getPartner();
        verify(application, times(1)).getDependants();
        verify(healthQuote, times(1)).getSituation();
    }

    @Test
    public void testCreateApplicantEmpty() throws Exception {
        final Applicant applicant = RequestAdapter.createApplicant(Optional.empty(), Optional.empty());
        assertNull(applicant);
    }

    @Test
    public void testCreateSituationEmpty() throws Exception {
        final Situation situation = RequestAdapter.createSituation(Optional.empty());
        assertNull(situation);
    }

    @Test
    public void testCreateSituation() throws Exception {
        final com.ctm.model.health.form.Situation situation = mock(com.ctm.model.health.form.Situation.class);
        final Situation result = RequestAdapter.createSituation(Optional.ofNullable(situation));
        assertNotNull(result);
        verify(situation, times(1)).getHealthSitu();
        verify(situation, times(1)).getHealthCvr();
    }

    @Test
    public void testCreateApplicant() throws Exception {
        final Person person = mock(Person.class);
        final Applicant applicant = RequestAdapter.createApplicant(Optional.ofNullable(person), Optional.empty());
        assertNotNull(applicant);
        assertNotNull(applicant.getHealthCover());
        assertNull(applicant.getPreviousFund());
        verify(person, times(1)).getTitle();
        verify(person, times(1)).getFirstname();
        verify(person, times(1)).getSurname();
        verify(person, times(1)).getGender();
        verify(person, times(1)).getDob();
        verify(person, times(1)).getCover();
        verify(person, times(1)).getHealthCoverLoading();
    }

    @Test
    public void testPreviousFundEmpty() throws Exception {
        final PreviousFund previousFund = RequestAdapter.createPreviousFund(Optional.empty());
        assertNull(previousFund);
    }

    @Test
    public void testPreviousFund() throws Exception {
        final Fund fund = mock(Fund.class);
        final PreviousFund previousFund = RequestAdapter.createPreviousFund(Optional.ofNullable(fund));
        assertNotNull(previousFund);
        verify(fund, times(1)).getFundName();
        verify(fund, times(1)).getMemberId();
    }

    @Test
    public void testCreateFundDataEmpty() throws Exception {
        final FundData result = RequestAdapter.createFundData(Optional.empty());
        assertNotNull(result);
        assertNull(result.getProvider());
        assertNull(result.getProduct());
        assertEquals(Declaration.Y, result.getDeclaration());
        assertNull(result.getStartDate());
        assertNull(result.getBenefits());
    }

    @Test
    public void testCreateFundData() throws Exception {
        final HealthQuote healthQuote = mock(HealthQuote.class);
        final Application application = mock(Application.class);
        final com.ctm.model.health.form.Payment payment = mock(com.ctm.model.health.form.Payment.class);
        final PaymentDetails paymentDetails = mock(PaymentDetails.class);
        final com.ctm.model.health.form.Situation situation = mock(com.ctm.model.health.form.Situation.class);
        when(healthQuote.getApplication()).thenReturn(application);
        when(healthQuote.getPayment()).thenReturn(payment);
        when(payment.getDetails()).thenReturn(paymentDetails);
        when(healthQuote.getSituation()).thenReturn(situation);
        final FundData result = RequestAdapter.createFundData(Optional.ofNullable(healthQuote));
        assertNotNull(result);
        verify(application, times(1)).getProvider();
        verify(application, times(1)).getProductId();
        verify(paymentDetails, times(1)).getStart();
        verify(situation, times(1)).getHealthSitu();
    }

    @Test
    public void testCreatePaymentEmpty() throws Exception {
        final Payment result = RequestAdapter.createPayment(Optional.empty());
        assertNull(result);
    }

    @Test
    public void testCreatePayment() throws Exception {
        final HealthQuote healthQuote = mock(HealthQuote.class);
        final com.ctm.model.health.form.Payment payment = mock(com.ctm.model.health.form.Payment.class);
        final PaymentDetails paymentDetails = mock(PaymentDetails.class);
        when(healthQuote.getPayment()).thenReturn(payment);
        when(payment.getDetails()).thenReturn(paymentDetails);
        final Payment result = RequestAdapter.createPayment(Optional.ofNullable(healthQuote));
        assertNotNull(result);
        // 2 times - createBank and claims valueOf
        verify(paymentDetails, times(2)).getClaims();
    }

    @Test
    public void testCreatePaymentDetailsEmpty() throws Exception {
        assertNotNull(RequestAdapter.createPaymentDetails(Optional.empty(), Optional.empty()));
    }

    @Test
    public void testCreatePaymentDetails() throws Exception {
        final HealthQuote healthQuote = mock(HealthQuote.class);
        final com.ctm.model.health.form.Payment payment = mock(com.ctm.model.health.form.Payment.class);
        final PaymentDetails paymentDetails = mock(PaymentDetails.class);
        final HealthCover healthCover = mock(HealthCover.class);
        when(payment.getDetails()).thenReturn(paymentDetails);
        when(healthQuote.getHealthCover()).thenReturn(healthCover);

        assertNotNull(RequestAdapter.createPaymentDetails(Optional.of(healthQuote), Optional.of(payment)));

        // times 2 paymentStartDate and findByCode
        verify(paymentDetails, times(2)).getType();
        verify(paymentDetails, times(1)).getFrequency();
        verify(healthCover, times(1)).getRebate();
        verify(healthCover, times(1)).getIncome();
        verify(healthQuote, times(1)).getLoading();
    }

    @Test
    public void testCreateContactDetailsEmpty() throws Exception {
        assertNull(RequestAdapter.createContactDetails(Optional.empty()));
    }

    @Test
    public void testCreateContactDetails() throws Exception {
        final HealthQuote healthQuote = mock(HealthQuote.class);
        final ContactDetails contactDetails = mock(ContactDetails.class);
        final ContactNumber contactNumber = mock(ContactNumber.class);
        final Application application = mock(Application.class);
        when(healthQuote.getContactDetails()).thenReturn(contactDetails);
        when(contactDetails.getContactNumber()).thenReturn(contactNumber);
        when(healthQuote.getApplication()).thenReturn(application);
        assertNotNull(RequestAdapter.createContactDetails(Optional.of(healthQuote)));
        verify(contactDetails, times(1)).getEmail();
        verify(contactDetails, times(1)).getOptin();
        verify(contactDetails, times(1)).getCall();
        verify(contactNumber, times(1)).getMobile();
        verify(contactNumber, times(1)).getOther();
        verify(application, times(1)).getPostalMatch();
        verify(application, times(1)).getPostal();
    }

    @Test
    public void testCreateContactDetailsDiffPostal() throws Exception {
        final HealthQuote healthQuote = mock(HealthQuote.class);
        final ContactDetails contactDetails = mock(ContactDetails.class);
        final ContactNumber contactNumber = mock(ContactNumber.class);
        final Application application = mock(Application.class);
        when(healthQuote.getContactDetails()).thenReturn(contactDetails);
        when(contactDetails.getContactNumber()).thenReturn(contactNumber);
        when(healthQuote.getApplication()).thenReturn(application);
        when(application.getPostalMatch()).thenReturn("Y");
        assertNotNull(RequestAdapter.createContactDetails(Optional.of(healthQuote)));
        verify(contactDetails, times(1)).getEmail();
        verify(contactDetails, times(1)).getOptin();
        verify(contactDetails, times(1)).getCall();
        verify(contactNumber, times(1)).getMobile();
        verify(contactNumber, times(1)).getOther();
        verify(application, times(1)).getPostalMatch();
        verify(application, never()).getPostal();
    }

    @Test
    public void testCreateAddressEmpty() throws Exception {
        assertNull(RequestAdapter.createAddress(Optional.empty()));
    }

    @Test
    public void testCreateAddress() throws Exception {
        final Address address = mock(Address.class);
        assertNotNull(RequestAdapter.createAddress(Optional.of(address)));
        verify(address, times(1)).getPostCode();
        verify(address, times(1)).getFullAddressLineOne();
        verify(address, times(1)).getSuburbName();
        verify(address, times(1)).getStreetNum();
        verify(address, times(1)).getDpId();
        verify(address, times(1)).getState();
    }

    @Test
    public void testCreateMedicare() throws Exception {
        final Medicare medicare = mock(Medicare.class);
        final Expiry expiry = mock(Expiry.class);
        when(medicare.getExpiry()).thenReturn(expiry);
        assertNotNull(RequestAdapter.createMedicare(Optional.of(medicare)));
        verify(medicare, times(1)).getCover();
        verify(medicare, times(1)).getNumber();
        verify(medicare, times(1)).getFirstName();
        verify(medicare, times(1)).getLastName();
        verify(medicare, times(1)).getExpiry();
        verify(expiry, times(1)).getCardExpiryMonth();
        verify(expiry, times(1)).getCardExpiryYear();
    }

    @Test
    public void testCreateMedicareEmpty() throws Exception {
        assertNull(RequestAdapter.createMedicare(Optional.empty()));
    }

    @Test
    public void testCreateBankEmpty() throws Exception {
        assertNull(RequestAdapter.createBank(Optional.empty()));
    }

    @Test
    public void testCreateBankDiffType() throws Exception {
        final com.ctm.model.health.form.Payment payment = mock(com.ctm.model.health.form.Payment.class);
        final PaymentDetails paymentDetails = mock(PaymentDetails.class);
        when(payment.getDetails()).thenReturn(paymentDetails);
        when(paymentDetails.getType()).thenReturn("xx");
        assertNull(RequestAdapter.createBank(Optional.of(payment)));
    }

    @Test
    public void testCreateBankWithoutClaims() throws Exception {
        final com.ctm.model.health.form.Payment payment = mock(com.ctm.model.health.form.Payment.class);
        final PaymentDetails paymentDetails = mock(PaymentDetails.class);
        final Bank bank = mock(Bank.class);
        when(payment.getDetails()).thenReturn(paymentDetails);
        when(payment.getBank()).thenReturn(bank);
        when(paymentDetails.getType()).thenReturn("ba");
        when(paymentDetails.getClaims()).thenReturn("N");
        assertNotNull(RequestAdapter.createBank(Optional.of(payment)));
        verify(paymentDetails, times(1)).getType();
        verify(bank, times(1)).getClaims();
        verify(paymentDetails, times(1)).getClaims();
        verify(bank, never()).getClaim();
    }

    @Test
    public void testCreateBankWithClaims() throws Exception {
        final com.ctm.model.health.form.Payment payment = mock(com.ctm.model.health.form.Payment.class);
        final PaymentDetails paymentDetails = mock(PaymentDetails.class);
        final Bank bank = mock(Bank.class);
        when(payment.getDetails()).thenReturn(paymentDetails);
        when(payment.getBank()).thenReturn(bank);
        when(paymentDetails.getType()).thenReturn("ba");
        when(paymentDetails.getClaims()).thenReturn("Y");
        assertNotNull(RequestAdapter.createBank(Optional.of(payment)));
        verify(paymentDetails, times(1)).getType();
        verify(bank, times(1)).getClaims();
        verify(paymentDetails, times(1)).getClaims();
        verify(bank, times(1)).getClaim();
    }

    @Test
    public void testCreateBankCCWithoutClaims() throws Exception {
        final com.ctm.model.health.form.Payment payment = mock(com.ctm.model.health.form.Payment.class);
        final PaymentDetails paymentDetails = mock(PaymentDetails.class);
        final Bank bank = mock(Bank.class);
        when(payment.getDetails()).thenReturn(paymentDetails);
        when(payment.getBank()).thenReturn(bank);
        when(paymentDetails.getType()).thenReturn("cc");
        when(paymentDetails.getClaims()).thenReturn("N");
        assertNull(RequestAdapter.createBank(Optional.of(payment)));
        verify(paymentDetails, times(1)).getType();
        verify(bank, never()).getAccount();
        verify(paymentDetails, times(1)).getClaims();
        verify(bank, never()).getClaim();
    }

    @Test
    public void testCreateBankCCWithClaims() throws Exception {
        final com.ctm.model.health.form.Payment payment = mock(com.ctm.model.health.form.Payment.class);
        final PaymentDetails paymentDetails = mock(PaymentDetails.class);
        final Bank bank = mock(Bank.class);
        when(payment.getDetails()).thenReturn(paymentDetails);
        when(payment.getBank()).thenReturn(bank);
        when(paymentDetails.getType()).thenReturn("cc");
        when(paymentDetails.getClaims()).thenReturn("Y");
        assertNotNull(RequestAdapter.createBank(Optional.of(payment)));
        verify(paymentDetails, times(1)).getType();
        verify(bank, never()).getAccount();
        verify(paymentDetails, times(1)).getClaims();
        verify(bank, times(1)).getClaim();
    }

    @Test
    public void testCreateAccountEmpty() throws Exception {
        assertNull(RequestAdapter.createAccount(Optional.empty()));
    }

    @Test
    public void testCreateAccount() throws Exception {
        final BankDetails bankDetails = mock(BankDetails.class);
        assertNotNull(RequestAdapter.createAccount(Optional.of(bankDetails)));
        verify(bankDetails, times(1)).getName();
        verify(bankDetails, times(1)).getBsb();
        verify(bankDetails, times(1)).getAccount();
        verify(bankDetails, times(1)).getNumber();
    }

    @Test
    public void testCreateCreditCardEmpty() throws Exception {
        assertNull(RequestAdapter.createCreditCard(Optional.empty()));
    }

    @Test
    public void testCreateCreditCardDiffType() throws Exception {
        final com.ctm.model.health.form.Payment payment = mock(com.ctm.model.health.form.Payment.class);
        final PaymentDetails paymentDetails = mock(PaymentDetails.class);
        when(payment.getDetails()).thenReturn(paymentDetails);
        when(paymentDetails.getType()).thenReturn("xx");
        assertNull(RequestAdapter.createCreditCard(Optional.of(payment)));
    }

    @Test
    public void testCreateCreditCardGateway() throws Exception {
        final com.ctm.model.health.form.Payment payment = mock(com.ctm.model.health.form.Payment.class);
        final PaymentDetails paymentDetails = mock(PaymentDetails.class);
        final Gateway gateway = mock(Gateway.class);
        when(payment.getDetails()).thenReturn(paymentDetails);
        when(payment.getGateway()).thenReturn(gateway);
        when(paymentDetails.getType()).thenReturn("cc");
        final CreditCard result = RequestAdapter.createCreditCard(Optional.of(payment));
        assertNotNull(result);
        assertNull(result.getCcv());
        verify(gateway, times(1)).getType();
        verify(gateway, times(1)).getName();
        verify(gateway, times(1)).getNumber();
        verify(gateway, times(1)).getExpiry();
    }

    @Test
    public void testCreateCreditCard() throws Exception {
        final com.ctm.model.health.form.Payment payment = mock(com.ctm.model.health.form.Payment.class);
        final PaymentDetails paymentDetails = mock(PaymentDetails.class);
        final Credit credit = mock(Credit.class);
        final Expiry expiry = mock(Expiry.class);
        when(payment.getDetails()).thenReturn(paymentDetails);
        when(payment.getCredit()).thenReturn(credit);
        when(credit.getExpiry()).thenReturn(expiry);
        when(paymentDetails.getType()).thenReturn("cc");
        final CreditCard result = RequestAdapter.createCreditCard(Optional.of(payment));
        assertNotNull(result);
        verify(credit, times(1)).getType();
        verify(credit, times(1)).getName();
        verify(credit, times(1)).getNumber();
        verify(credit, times(1)).getExpiry();
        verify(credit, times(1)).getCcv();
        verify(expiry, times(1)).getCardExpiryMonth();
        verify(expiry, times(1)).getCardExpiryYear();
    }

    @Test
    public void testPaymentStartDateEmpty() throws Exception {
        assertNull(RequestAdapter.paymentStartDate(Optional.empty()));
    }

    @Test
    public void testPaymentStartDate() throws Exception {
        final com.ctm.model.health.form.Payment payment = mock(com.ctm.model.health.form.Payment.class);
        final PaymentDetails paymentDetails = mock(PaymentDetails.class);
        when(payment.getDetails()).thenReturn(paymentDetails);
        when(paymentDetails.getType()).thenReturn("xx");
        assertNull(RequestAdapter.paymentStartDate(Optional.ofNullable(payment)));
    }

    @Test
    public void testPaymentStartDateCreditCard() throws Exception {
        final com.ctm.model.health.form.Payment payment = mock(com.ctm.model.health.form.Payment.class);
        final PaymentDetails paymentDetails = mock(PaymentDetails.class);
        final Credit credit = mock(Credit.class);
        when(payment.getDetails()).thenReturn(paymentDetails);
        when(paymentDetails.getType()).thenReturn("cc");
        when(payment.getCredit()).thenReturn(credit);
        assertNull(RequestAdapter.paymentStartDate(Optional.ofNullable(payment)));
    }

    @Test
    public void testPaymentStartDateCreditCardPaymentDay() throws Exception {
        final com.ctm.model.health.form.Payment payment = mock(com.ctm.model.health.form.Payment.class);
        final PaymentDetails paymentDetails = mock(PaymentDetails.class);
        final Credit credit = mock(Credit.class);
        when(payment.getDetails()).thenReturn(paymentDetails);
        when(paymentDetails.getType()).thenReturn("cc");
        when(payment.getCredit()).thenReturn(credit);
        when(credit.getPaymentDay()).thenReturn("2015-01-01");
        assertEquals(LocalDate.of(2015, 1, 1), RequestAdapter.paymentStartDate(Optional.ofNullable(payment)));
    }

    @Test
    public void testPaymentStartDateCreditCardPolicyDay() throws Exception {
        final com.ctm.model.health.form.Payment payment = mock(com.ctm.model.health.form.Payment.class);
        final PaymentDetails paymentDetails = mock(PaymentDetails.class);
        final Credit credit = mock(Credit.class);
        when(payment.getDetails()).thenReturn(paymentDetails);
        when(paymentDetails.getType()).thenReturn("cc");
        when(payment.getCredit()).thenReturn(credit);
        when(credit.getPolicyDay()).thenReturn("2015-01-01");
        assertEquals(LocalDate.of(2015, 1, 1), RequestAdapter.paymentStartDate(Optional.ofNullable(payment)));
    }

    @Test
    public void testPaymentStartDateBank() throws Exception {
        final com.ctm.model.health.form.Payment payment = mock(com.ctm.model.health.form.Payment.class);
        final PaymentDetails paymentDetails = mock(PaymentDetails.class);
        final Bank bank = mock(Bank.class);
        when(payment.getDetails()).thenReturn(paymentDetails);
        when(paymentDetails.getType()).thenReturn("ba");
        when(payment.getBank()).thenReturn(bank);
        assertNull(RequestAdapter.paymentStartDate(Optional.ofNullable(payment)));
    }

    @Test
    public void testPaymentStartDateBankPaymentDay() throws Exception {
        final com.ctm.model.health.form.Payment payment = mock(com.ctm.model.health.form.Payment.class);
        final PaymentDetails paymentDetails = mock(PaymentDetails.class);
        final Bank bank = mock(Bank.class);
        when(payment.getDetails()).thenReturn(paymentDetails);
        when(paymentDetails.getType()).thenReturn("ba");
        when(payment.getBank()).thenReturn(bank);
        when(bank.getPaymentDay()).thenReturn("2015-01-01");
        assertEquals(LocalDate.of(2015, 1, 1), RequestAdapter.paymentStartDate(Optional.ofNullable(payment)));
    }

    @Test
    public void testPaymentStartDateBankPolicyDay() throws Exception {
        final com.ctm.model.health.form.Payment payment = mock(com.ctm.model.health.form.Payment.class);
        final PaymentDetails paymentDetails = mock(PaymentDetails.class);
        final Bank bank = mock(Bank.class);
        when(payment.getDetails()).thenReturn(paymentDetails);
        when(paymentDetails.getType()).thenReturn("ba");
        when(payment.getBank()).thenReturn(bank);
        when(bank.getPolicyDay()).thenReturn("2015-01-01");
        assertEquals(LocalDate.of(2015, 1, 1), RequestAdapter.paymentStartDate(Optional.ofNullable(payment)));
    }

    @Test
    public void testCreateDependantsEmpty() throws Exception {
        assertNull(RequestAdapter.createDependants(Optional.empty()));
    }

    @Test
    public void testCreateDependantsEmpty1() throws Exception {
        final Dependants dependants = mock(Dependants.class);
        final List<com.ctm.providers.health.healthapply.model.request.application.dependant.Dependant> result = RequestAdapter.createDependants(Optional.of(dependants));
        assertNotNull(result);
        assertTrue(result.isEmpty());
    }

    @Test
    public void testCreateDependants1Dependant() throws Exception {
        final Dependants dependants = mock(Dependants.class);
        final Dependant dependant = mock(Dependant.class);
        when(dependants.getDependant1()).thenReturn(dependant);
        final List<com.ctm.providers.health.healthapply.model.request.application.dependant.Dependant> result = RequestAdapter.createDependants(Optional.of(dependants));
        assertNotNull(result);
        assertEquals(1, result.size());
    }

    @Test
    public void testCreateDependants12Dependant() throws Exception {
        final Dependants dependants = mock(Dependants.class);
        final Dependant dependant = mock(Dependant.class);
        when(dependants.getDependant1()).thenReturn(dependant);
        when(dependants.getDependant2()).thenReturn(dependant);
        when(dependants.getDependant3()).thenReturn(dependant);
        when(dependants.getDependant4()).thenReturn(dependant);
        when(dependants.getDependant5()).thenReturn(dependant);
        when(dependants.getDependant6()).thenReturn(dependant);
        when(dependants.getDependant7()).thenReturn(dependant);
        when(dependants.getDependant8()).thenReturn(dependant);
        when(dependants.getDependant9()).thenReturn(dependant);
        when(dependants.getDependant10()).thenReturn(dependant);
        when(dependants.getDependant11()).thenReturn(dependant);
        when(dependants.getDependant12()).thenReturn(dependant);
        final List<com.ctm.providers.health.healthapply.model.request.application.dependant.Dependant> result = RequestAdapter.createDependants(Optional.of(dependants));
        assertNotNull(result);
        assertEquals(12, result.size());
    }

    @Test
    public void testCreateDependantEmpty() throws Exception {
        assertNull(RequestAdapter.createDependant(Optional.empty()));
    }

    @Test
    public void testCreateDependant() throws Exception {
        final Dependant dependant = mock(Dependant.class);
        assertNotNull(RequestAdapter.createDependant(Optional.of(dependant)));
        // 2 times - title and gender
        verify(dependant, times(2)).getTitle();
        verify(dependant, times(1)).getFirstname();
        verify(dependant, times(1)).getLastname();
        verify(dependant, times(1)).getDob();
        verify(dependant, times(1)).getSchool();
        verify(dependant, times(1)).getSchoolDate();
        verify(dependant, times(1)).getSchoolID();
    }
}