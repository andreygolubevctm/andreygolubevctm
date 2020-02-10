package com.ctm.web.health.apply.model;

import com.ctm.web.health.apply.model.request.payment.credit.CreditCard;
import com.ctm.web.health.apply.model.request.payment.credit.GatewayCreditCard;
import com.ctm.web.health.model.form.*;
import org.junit.Test;

import java.time.LocalDate;
import java.util.Optional;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertNotNull;
import static org.junit.Assert.assertNull;
import static org.mockito.Mockito.*;

public class PaymentAdapterTest {

    @Test
    public void testCreatePaymentEmpty() throws Exception {
        final com.ctm.web.health.apply.model.request.payment.Payment result = PaymentAdapter.createPayment(Optional.empty());
        assertNull(result);
    }

    @Test
    public void testCreatePayment() throws Exception {
        final HealthQuote healthQuote = mock(HealthQuote.class);
        final com.ctm.web.health.model.form.Payment payment = mock(com.ctm.web.health.model.form.Payment.class);
        final PaymentDetails paymentDetails = mock(PaymentDetails.class);
        when(healthQuote.getPayment()).thenReturn(payment);
        when(payment.getDetails()).thenReturn(paymentDetails);
        final com.ctm.web.health.apply.model.request.payment.Payment result = PaymentAdapter.createPayment(Optional.ofNullable(healthQuote));
        assertNotNull(result);
        // 2 times - createBank and claims valueOf
        verify(paymentDetails, times(2)).getClaims();
    }

    @Test
    public void testCreatePaymentDetailsEmpty() throws Exception {
        assertNotNull(PaymentAdapter.createPaymentDetails(Optional.empty(), Optional.empty()));
    }

    @Test
    public void testCreatePaymentDetails() throws Exception {
        final HealthQuote healthQuote = mock(HealthQuote.class);
        final com.ctm.web.health.model.form.Payment payment = mock(com.ctm.web.health.model.form.Payment.class);
        final PaymentDetails paymentDetails = mock(PaymentDetails.class);
        final HealthCover healthCover = mock(HealthCover.class);
        when(payment.getDetails()).thenReturn(paymentDetails);
        when(healthQuote.getHealthCover()).thenReturn(healthCover);

        assertNotNull(PaymentAdapter.createPaymentDetails(Optional.of(healthQuote), Optional.of(payment)));

        // times 2 paymentStartDate and findByCode
        verify(paymentDetails, times(2)).getType();
        verify(paymentDetails, times(1)).getFrequency();
        verify(healthCover, times(1)).getRebate();
        verify(healthQuote, times(1)).getRebate();
        verify(healthCover, times(1)).getIncome();
        verify(healthQuote, times(1)).getLoading();
    }

    @Test
    public void testCreateMedicare() throws Exception {
        final Medicare medicare = mock(Medicare.class);
        final Expiry expiry = mock(Expiry.class);
        when(medicare.getExpiry()).thenReturn(expiry);
        assertNotNull(PaymentAdapter.createMedicare(Optional.of(medicare)));
        verify(medicare, times(1)).getCover();
        verify(medicare, times(1)).getNumber();
        verify(medicare, times(1)).getFirstName();
        verify(medicare, times(1)).getSurname();
        verify(medicare, times(1)).getExpiry();
        verify(expiry, times(1)).getCardExpiryMonth();
        verify(expiry, times(1)).getCardExpiryYear();
        verify(expiry, times(1)).getCardExpiryDay();
    }

    @Test
    public void testCreateMedicareEmpty() throws Exception {
        assertNull(PaymentAdapter.createMedicare(Optional.empty()));
    }

    @Test
    public void testCreateBankEmpty() throws Exception {
        assertNull(PaymentAdapter.createBank(Optional.empty(), Optional.empty()));
    }

    @Test
    public void testCreateBankDiffType() throws Exception {
        final com.ctm.web.health.model.form.Payment payment = mock(com.ctm.web.health.model.form.Payment.class);
        final PaymentDetails paymentDetails = mock(PaymentDetails.class);
        when(payment.getDetails()).thenReturn(paymentDetails);
        when(paymentDetails.getType()).thenReturn("xx");
        assertNull(PaymentAdapter.createBank(Optional.of(payment), Optional.empty()));
    }

    @Test
    public void testCreateBankWithClaims() throws Exception {
        final com.ctm.web.health.model.form.Payment payment = mock(com.ctm.web.health.model.form.Payment.class);
        final PaymentDetails paymentDetails = mock(PaymentDetails.class);
        final Bank bank = mock(Bank.class);
        when(payment.getDetails()).thenReturn(paymentDetails);
        when(payment.getBank()).thenReturn(bank);
        when(paymentDetails.getType()).thenReturn("ba");
        when(paymentDetails.getClaims()).thenReturn("Y");
        assertNotNull(PaymentAdapter.createBank(Optional.of(payment), Optional.empty()));
        verify(paymentDetails, times(1)).getType();
        verify(bank, times(1)).getClaims();
        verify(paymentDetails, times(1)).getClaims();
        verify(bank, times(1)).getClaim();
    }

    @Test
    public void testCreateBankCCWithClaims() throws Exception {
        final com.ctm.web.health.model.form.Payment payment = mock(com.ctm.web.health.model.form.Payment.class);
        final PaymentDetails paymentDetails = mock(PaymentDetails.class);
        final Bank bank = mock(Bank.class);
        when(payment.getDetails()).thenReturn(paymentDetails);
        when(payment.getBank()).thenReturn(bank);
        when(paymentDetails.getType()).thenReturn("cc");
        when(paymentDetails.getClaims()).thenReturn("Y");
        assertNotNull(PaymentAdapter.createBank(Optional.of(payment), Optional.empty()));
        verify(paymentDetails, times(1)).getType();
        verify(bank, never()).getAccount();
        verify(paymentDetails, times(1)).getClaims();
        verify(bank, times(1)).getClaim();
    }

    @Test
    public void testCreateBankFromProviderNoSameBankClaimsCheck() {
        final com.ctm.web.health.model.form.Payment payment = mock(com.ctm.web.health.model.form.Payment.class);
        final PaymentDetails paymentDetails = mock(PaymentDetails.class);
        final Bank bank = mock(Bank.class);
        when(bank.getClaims()).thenReturn("Y");
        when(payment.getDetails()).thenReturn(paymentDetails);
        when(payment.getBank()).thenReturn(bank);
        when(paymentDetails.getType()).thenReturn("cc");
        when(paymentDetails.getClaims()).thenReturn("Y");

        final Application application = mock(Application.class);
        when(application.getProvider()).thenReturn("BUD");

        assertNotNull(PaymentAdapter.createBank(Optional.of(payment), Optional.of(application)));
        verify(paymentDetails, times(1)).getType();
        verify(bank, never()).getAccount();
        verify(paymentDetails, times(1)).getClaims();
        verify(bank, times(1)).getClaim();
        verify(bank, never()).getClaims();
    }

    @Test
    public void testCreateBankFromProviderSameBankClaimsCheck() {
        final com.ctm.web.health.model.form.Payment payment = mock(com.ctm.web.health.model.form.Payment.class);
        final PaymentDetails paymentDetails = mock(PaymentDetails.class);
        final Bank bank = mock(Bank.class);
        when(bank.getClaims()).thenReturn("Y");
        when(payment.getDetails()).thenReturn(paymentDetails);
        when(payment.getBank()).thenReturn(bank);
        when(paymentDetails.getType()).thenReturn("cc");
        when(paymentDetails.getClaims()).thenReturn("Y");

        final Application application = mock(Application.class);
        when(application.getProvider()).thenReturn("BUP");

        assertNotNull(PaymentAdapter.createBank(Optional.of(payment), Optional.of(application)));
        verify(paymentDetails, times(1)).getType();
        verify(bank, never()).getAccount();
        verify(paymentDetails, times(1)).getClaims();
        verify(bank, times(1)).getClaims();
        verify(bank, never()).getClaim();
    }

    @Test
    public void testCreateAccountEmpty() throws Exception {
        assertNull(PaymentAdapter.createAccount(Optional.empty()));
    }

    @Test
    public void testCreateAccount() throws Exception {
        final BankDetails bankDetails = mock(BankDetails.class);
        assertNotNull(PaymentAdapter.createAccount(Optional.of(bankDetails)));
        verify(bankDetails, times(1)).getName();
        verify(bankDetails, times(1)).getBsb();
        verify(bankDetails, times(1)).getAccount();
        verify(bankDetails, times(1)).getNumber();
    }

    @Test
    public void testCreateCreditCardEmpty() throws Exception {
        assertNull(PaymentAdapter.createCreditCard(Optional.empty()));
    }

    @Test
    public void testCreateCreditCardDiffType() throws Exception {
        final com.ctm.web.health.model.form.Payment payment = mock(com.ctm.web.health.model.form.Payment.class);
        final PaymentDetails paymentDetails = mock(PaymentDetails.class);
        when(payment.getDetails()).thenReturn(paymentDetails);
        when(paymentDetails.getType()).thenReturn("xx");
        assertNull(PaymentAdapter.createCreditCard(Optional.of(payment)));
    }

    @Test
    public void testCreateCreditCardGateway() throws Exception {
        final com.ctm.web.health.model.form.Payment payment = mock(com.ctm.web.health.model.form.Payment.class);
        final PaymentDetails paymentDetails = mock(PaymentDetails.class);
        final Gateway gateway = mock(Gateway.class);
        when(payment.getDetails()).thenReturn(paymentDetails);
        when(payment.getGateway()).thenReturn(gateway);
        when(paymentDetails.getType()).thenReturn("cc");
        final GatewayCreditCard result = PaymentAdapter.createGatewayCreditCard(Optional.of(payment));
        assertNotNull(result);
        verify(gateway, times(1)).getType();
        verify(gateway, times(1)).getName();
        verify(gateway, times(1)).getNumber();
        verify(gateway, times(1)).getExpiry();
        verify(gateway, times(1)).getNab();
    }

    @Test
    public void testCreateCreditCardGatewayNab() throws Exception {
        final com.ctm.web.health.model.form.Payment payment = mock(com.ctm.web.health.model.form.Payment.class);
        final PaymentDetails paymentDetails = mock(PaymentDetails.class);
        final Gateway gateway = mock(Gateway.class);
        final Nab nab = mock(Nab.class);
        when(payment.getDetails()).thenReturn(paymentDetails);
        when(payment.getGateway()).thenReturn(gateway);
        when(paymentDetails.getType()).thenReturn("cc");
        when(gateway.getNab()).thenReturn(nab);
        final GatewayCreditCard result = PaymentAdapter.createGatewayCreditCard(Optional.of(payment));
        assertNotNull(result);
        verify(gateway, never()).getType();
        verify(gateway, never()).getName();
        verify(gateway, never()).getNumber();
        verify(gateway, never()).getExpiry();
        verify(gateway, times(2)).getNab();
        verify(nab, times(1)).getCardNumber();
        verify(nab, times(1)).getCardType();
        verify(nab, times(1)).getCrn();
        verify(nab, times(1)).getExpiryMonth();
        verify(nab, times(1)).getExpiryYear();
    }

    @Test
    public void testCreateCreditCard() throws Exception {
        final com.ctm.web.health.model.form.Payment payment = mock(com.ctm.web.health.model.form.Payment.class);
        final PaymentDetails paymentDetails = mock(PaymentDetails.class);
        final Credit credit = mock(Credit.class);
        final Expiry expiry = mock(Expiry.class);
        when(payment.getDetails()).thenReturn(paymentDetails);
        when(payment.getCredit()).thenReturn(credit);
        when(credit.getExpiry()).thenReturn(expiry);
        when(paymentDetails.getType()).thenReturn("cc");
        final CreditCard result = PaymentAdapter.createCreditCard(Optional.of(payment));
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
        assertNull(PaymentAdapter.paymentStartDate(Optional.empty()));
    }

    @Test
    public void testPaymentStartDate() throws Exception {
        final com.ctm.web.health.model.form.Payment payment = mock(com.ctm.web.health.model.form.Payment.class);
        final PaymentDetails paymentDetails = mock(PaymentDetails.class);
        when(payment.getDetails()).thenReturn(paymentDetails);
        when(paymentDetails.getType()).thenReturn("xx");
        assertNull(PaymentAdapter.paymentStartDate(Optional.ofNullable(payment)));
    }

    @Test
    public void testPaymentStartDateCreditCard() throws Exception {
        final com.ctm.web.health.model.form.Payment payment = mock(com.ctm.web.health.model.form.Payment.class);
        final PaymentDetails paymentDetails = mock(PaymentDetails.class);
        final Credit credit = mock(Credit.class);
        when(payment.getDetails()).thenReturn(paymentDetails);
        when(paymentDetails.getType()).thenReturn("cc");
        when(payment.getCredit()).thenReturn(credit);
        when(credit.getDay()).thenReturn(null);
        assertNull(PaymentAdapter.paymentStartDate(Optional.ofNullable(payment)));
    }

    @Test
    public void testPaymentStartDateCreditCardDay() throws Exception {
        final com.ctm.web.health.model.form.Payment payment = mock(com.ctm.web.health.model.form.Payment.class);
        final PaymentDetails paymentDetails = mock(PaymentDetails.class);
        final Credit credit = mock(Credit.class);
        when(payment.getDetails()).thenReturn(paymentDetails);
        when(paymentDetails.getType()).thenReturn("cc");
        when(payment.getCredit()).thenReturn(credit);
        when(credit.getDay()).thenReturn(1);
        assertEquals(LocalDate.now().withDayOfMonth(1), PaymentAdapter.paymentStartDate(Optional.ofNullable(payment)));
    }

    @Test
    public void testPaymentStartDateCreditCardPaymentDay() throws Exception {
        final com.ctm.web.health.model.form.Payment payment = mock(com.ctm.web.health.model.form.Payment.class);
        final PaymentDetails paymentDetails = mock(PaymentDetails.class);
        final Credit credit = mock(Credit.class);
        when(payment.getDetails()).thenReturn(paymentDetails);
        when(paymentDetails.getType()).thenReturn("cc");
        when(payment.getCredit()).thenReturn(credit);
        when(credit.getPaymentDay()).thenReturn("2015-01-01");
        assertEquals(LocalDate.of(2015, 1, 1), PaymentAdapter.paymentStartDate(Optional.ofNullable(payment)));
    }

    @Test
    public void testPaymentStartDateCreditCardPolicyDay() throws Exception {
        final com.ctm.web.health.model.form.Payment payment = mock(com.ctm.web.health.model.form.Payment.class);
        final PaymentDetails paymentDetails = mock(PaymentDetails.class);
        final Credit credit = mock(Credit.class);
        when(payment.getDetails()).thenReturn(paymentDetails);
        when(paymentDetails.getType()).thenReturn("cc");
        when(payment.getCredit()).thenReturn(credit);
        when(credit.getPolicyDay()).thenReturn("2015-01-01");
        assertEquals(LocalDate.of(2015, 1, 1), PaymentAdapter.paymentStartDate(Optional.ofNullable(payment)));
    }

    @Test
    public void testPaymentStartDateCreditCardPolicyDate() throws Exception {
        final com.ctm.web.health.model.form.Payment payment = mock(com.ctm.web.health.model.form.Payment.class);
        final PaymentDetails paymentDetails = mock(PaymentDetails.class);
        final Credit credit = mock(Credit.class);
        when(payment.getDetails()).thenReturn(paymentDetails);
        when(paymentDetails.getType()).thenReturn("cc");
        when(payment.getCredit()).thenReturn(credit);
        when(payment.getPolicyDate()).thenReturn("2015-01-01");
        assertEquals(LocalDate.of(2015, 1, 1), PaymentAdapter.paymentStartDate(Optional.ofNullable(payment)));
    }

    @Test
    public void testPaymentStartDateBank() throws Exception {
        final com.ctm.web.health.model.form.Payment payment = mock(com.ctm.web.health.model.form.Payment.class);
        final PaymentDetails paymentDetails = mock(PaymentDetails.class);
        final Bank bank = mock(Bank.class);
        when(payment.getDetails()).thenReturn(paymentDetails);
        when(paymentDetails.getType()).thenReturn("ba");
        when(payment.getBank()).thenReturn(bank);
        when(bank.getDay()).thenReturn(null);
        assertNull(PaymentAdapter.paymentStartDate(Optional.ofNullable(payment)));
    }

    @Test
    public void testPaymentStartDateBankDay() throws Exception {
        final com.ctm.web.health.model.form.Payment payment = mock(com.ctm.web.health.model.form.Payment.class);
        final PaymentDetails paymentDetails = mock(PaymentDetails.class);
        final Bank bank = mock(Bank.class);
        when(payment.getDetails()).thenReturn(paymentDetails);
        when(paymentDetails.getType()).thenReturn("ba");
        when(payment.getBank()).thenReturn(bank);
        when(bank.getDay()).thenReturn(1);
        assertEquals(LocalDate.now().withDayOfMonth(1), PaymentAdapter.paymentStartDate(Optional.ofNullable(payment)));
    }

    @Test
    public void testPaymentStartDateBankPaymentDay() throws Exception {
        final com.ctm.web.health.model.form.Payment payment = mock(com.ctm.web.health.model.form.Payment.class);
        final PaymentDetails paymentDetails = mock(PaymentDetails.class);
        final Bank bank = mock(Bank.class);
        when(payment.getDetails()).thenReturn(paymentDetails);
        when(paymentDetails.getType()).thenReturn("ba");
        when(payment.getBank()).thenReturn(bank);
        when(bank.getPaymentDay()).thenReturn("2015-01-01");
        assertEquals(LocalDate.of(2015, 1, 1), PaymentAdapter.paymentStartDate(Optional.ofNullable(payment)));
    }

    @Test
    public void testPaymentStartDateBankPolicyDay() throws Exception {
        final com.ctm.web.health.model.form.Payment payment = mock(com.ctm.web.health.model.form.Payment.class);
        final PaymentDetails paymentDetails = mock(PaymentDetails.class);
        final Bank bank = mock(Bank.class);
        when(payment.getDetails()).thenReturn(paymentDetails);
        when(paymentDetails.getType()).thenReturn("ba");
        when(payment.getBank()).thenReturn(bank);
        when(bank.getPolicyDay()).thenReturn("2015-01-01");
        assertEquals(LocalDate.of(2015, 1, 1), PaymentAdapter.paymentStartDate(Optional.ofNullable(payment)));
    }

    @Test
    public void testPaymentStartDateBankPolicyDate() throws Exception {
        final com.ctm.web.health.model.form.Payment payment = mock(com.ctm.web.health.model.form.Payment.class);
        final PaymentDetails paymentDetails = mock(PaymentDetails.class);
        final Bank bank = mock(Bank.class);
        when(payment.getDetails()).thenReturn(paymentDetails);
        when(paymentDetails.getType()).thenReturn("ba");
        when(payment.getBank()).thenReturn(bank);
        when(payment.getPolicyDate()).thenReturn("2015-01-01");
        assertEquals(LocalDate.of(2015, 1, 1), PaymentAdapter.paymentStartDate(Optional.ofNullable(payment)));
    }
}
