package com.ctm.web.health.apply.model;

import com.ctm.schema.health.v1_0_0.Eligibility;
import com.ctm.schema.health.v1_0_0.PartnerDetails;
import com.ctm.schema.health.v1_0_0.ProviderDetails;
import com.ctm.web.health.model.form.Application;
import com.ctm.web.health.model.form.Cbh;
import com.ctm.web.health.model.form.HealthQuote;
import com.ctm.web.health.model.form.Nhb;
import com.ctm.web.health.model.form.PaymentDetails;
import com.ctm.web.health.model.form.Qtu;
import com.ctm.web.health.model.form.Uhf;
import com.ctm.web.health.model.form.Wfd;
import org.junit.Test;

import java.util.Optional;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertFalse;
import static org.junit.Assert.assertNotNull;
import static org.junit.Assert.assertNull;
import static org.junit.Assert.assertTrue;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.never;
import static org.mockito.Mockito.times;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

public class ProviderDetailsAdapterTest {

    @Test
    public void testCreateFundDataEmpty() {
        final ProviderDetails result = ProviderDetailsAdapter.createProviderDetails(Optional.empty());
        assertNotNull(result);
        assertTrue(result.getFundJoinDeclarationConfirmation());
        assertNull(result.getPolicyStartDate());
        assertNull(result.getBenefits());
        assertNull(result.getMembership());
    }

    @Test
    public void testCreateFundData() {
        final HealthQuote healthQuote = mock(HealthQuote.class);
        final Application application = mock(Application.class);
        final com.ctm.web.health.model.form.Payment payment = mock(com.ctm.web.health.model.form.Payment.class);
        final PaymentDetails paymentDetails = mock(PaymentDetails.class);
        final com.ctm.web.health.model.form.Situation situation = mock(com.ctm.web.health.model.form.Situation.class);
        when(healthQuote.getApplication()).thenReturn(application);
        when(healthQuote.getPayment()).thenReturn(payment);
        when(payment.getDetails()).thenReturn(paymentDetails);
        when(healthQuote.getSituation()).thenReturn(situation);
        final ProviderDetails result = ProviderDetailsAdapter.createProviderDetails(Optional.of(healthQuote));
        assertNotNull(result);
        verify(application, never()).getProvider();
        verify(application, never()).getProductId();
        verify(paymentDetails, times(1)).getStart();
    }

    @Test
    public void testMembershipEmpty() {
        assertNull(ProviderDetailsAdapter.createMembership((Cbh) null));
    }

    @Test
    public void testMembership() {
        final Cbh cbh = mock(Cbh.class);
        final com.ctm.schema.health.v1_0_0.Membership membership = ProviderDetailsAdapter.createMembership(cbh);
        assertNull(membership.getIsACurrentMember());
        assertNull(membership.getRegisteredMember());
        assertNull(membership.getMembershipNumber());
        assertNull(membership.getMembershipGroup());
        final PartnerDetails partnerDetails = membership.getPartnerDetails();
        assertNotNull(partnerDetails);
        assertNull(partnerDetails.getRelationshipToPrimary());
        assertNull(partnerDetails.getIsGroupMember());
        assertFalse(membership.getRegisterForGroupServices());
        verify(cbh, times(1)).getCurrentemployee();
        verify(cbh, never()).getCurrentnumber();
        verify(cbh, never()).getCurrentwork();
        verify(cbh, times(1)).getFormeremployee();
        verify(cbh, never()).getFormernumber();
        verify(cbh, never()).getFormerwork();
        verify(cbh, times(1)).getFamilymember();
        verify(cbh, never()).getFamilynumber();
        verify(cbh, never()).getFamilywork();
        verify(cbh, times(1)).getPartnerrel();
        verify(cbh, times(1)).getPartneremployee();
        verify(cbh, times(1)).getRegister();
    }

    @Test
    public void testMembershipCurrent() {
        final Cbh cbh = mock(Cbh.class);
        when(cbh.getCurrentemployee()).thenReturn("Y");
        ProviderDetailsAdapter.createMembership(cbh);
        verify(cbh, times(1)).getCurrentemployee();
        verify(cbh, times(1)).getCurrentnumber();
        verify(cbh, times(1)).getCurrentwork();
        verify(cbh, never()).getFormeremployee();
        verify(cbh, never()).getFormernumber();
        verify(cbh, never()).getFormerwork();
        verify(cbh, never()).getFamilymember();
        verify(cbh, never()).getFamilynumber();
        verify(cbh, never()).getFamilywork();
        verify(cbh, times(1)).getPartnerrel();
        verify(cbh, times(1)).getPartneremployee();
        verify(cbh, times(1)).getRegister();
    }

    @Test
    public void testMembershipFormer() {
        final Cbh cbh = mock(Cbh.class);
        when(cbh.getFormeremployee()).thenReturn("Y");
        ProviderDetailsAdapter.createMembership(cbh);
        verify(cbh, times(1)).getCurrentemployee();
        verify(cbh, never()).getCurrentnumber();
        verify(cbh, never()).getCurrentwork();
        verify(cbh, times(1)).getFormeremployee();
        verify(cbh, times(1)).getFormernumber();
        verify(cbh, times(1)).getFormerwork();
        verify(cbh, never()).getFamilymember();
        verify(cbh, never()).getFamilynumber();
        verify(cbh, never()).getFamilywork();
        verify(cbh, times(1)).getPartnerrel();
        verify(cbh, times(1)).getPartneremployee();
        verify(cbh, times(1)).getRegister();
    }

    @Test
    public void testMembershipFamily() {
        final Cbh cbh = mock(Cbh.class);
        when(cbh.getFamilymember()).thenReturn("Y");
        ProviderDetailsAdapter.createMembership(cbh);
        verify(cbh, times(1)).getCurrentemployee();
        verify(cbh, never()).getCurrentnumber();
        verify(cbh, never()).getCurrentwork();
        verify(cbh, times(1)).getFormeremployee();
        verify(cbh, never()).getFormernumber();
        verify(cbh, never()).getFormerwork();
        verify(cbh, times(1)).getFamilymember();
        verify(cbh, times(1)).getFamilynumber();
        verify(cbh, times(1)).getFamilywork();
        verify(cbh, times(1)).getPartnerrel();
        verify(cbh, times(1)).getPartneremployee();
        verify(cbh, times(1)).getRegister();
    }

    @Test
    public void testNhbEmpty() {
        assertNull(ProviderDetailsAdapter.createMembership((Nhb) null));
    }

    @Test
    public void testNhb() {
        Nhb nav = mock(Nhb.class);
        ProviderDetailsAdapter.createMembership(nav);
        verify(nav, times(1)).getEligibility();
        verify(nav, times(1)).getSubreason();
        verify(nav, times(1)).getPartnerrel();
    }

    @Test
    public void testWfdEmpty() {
        assertNull(ProviderDetailsAdapter.createMembership((Wfd) null));
    }

    @Test
    public void testWfd() {
        Wfd wfd = mock(Wfd.class);
        ProviderDetailsAdapter.createMembership(wfd);
        verify(wfd, times(1)).getPartnerrel();
    }

    @Test
    public void testMembershipCurrentQtu() {
        final Qtu qtu = mock(Qtu.class);
        when(qtu.getEligibility()).thenReturn("CURR");
        when(qtu.getUnion()).thenReturn("TOGTH");
        final com.ctm.schema.health.v1_0_0.Membership membership = ProviderDetailsAdapter.createMembership(qtu);
        final Optional<Eligibility> eligibility = Optional.ofNullable(membership.getEligibility());
        assertTrue(eligibility.isPresent());
        assertEquals("CURR", eligibility.map(Eligibility::getReason).orElse(""));
        assertEquals("TOGTH", eligibility.map(Eligibility::getSubReason).orElse(""));
    }

    @Test
    public void testMembershipCurrentUhf() throws Exception {
        final Uhf uhf = mock(Uhf.class);
        when(uhf.getEligibility()).thenReturn("CURR");
        when(uhf.getUnion()).thenReturn("TOGTH");
        final com.ctm.schema.health.v1_0_0.Membership membership = ProviderDetailsAdapter.createMembership(uhf);
        final Optional<Eligibility> eligibility = Optional.ofNullable(membership.getEligibility());
        assertTrue(eligibility.isPresent());
        assertEquals("CURR", eligibility.map(Eligibility::getReason).orElse(""));
        assertEquals("TOGTH", eligibility.map(Eligibility::getSubReason).orElse(""));
    }

    @Test
    public void testMembershipFormerUhf() throws Exception {
        final Uhf uhf = mock(Uhf.class);
        when(uhf.getEligibility()).thenReturn("FORM");
        final com.ctm.schema.health.v1_0_0.Membership membership = ProviderDetailsAdapter.createMembership(uhf);
        final Optional<Eligibility> eligibility = Optional.ofNullable(membership.getEligibility());
        assertTrue(eligibility.isPresent());
        assertEquals("FORM", eligibility.map(Eligibility::getReason).orElse(""));
        assertNull(eligibility.map(Eligibility::getSubReason).orElse(null));
    }

    @Test
    public void testMembershipCallsGetUhf() {
        final Uhf uhf = mock(Uhf.class);
        final HealthQuote healthQuote = mock(HealthQuote.class);
        final Application application = mock(Application.class);
        when(healthQuote.getApplication()).thenReturn(application);
        when(application.getCbh()).thenReturn(null);
        when(application.getNhb()).thenReturn(null);
        when(application.getUhf()).thenReturn(uhf);
        com.ctm.schema.health.v1_0_0.Membership membership = ProviderDetailsAdapter.createMembership(Optional.of(healthQuote));
        verify(application, times(1)).getUhf();
        verify(uhf, times(1)).getEligibility();
    }
}
