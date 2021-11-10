package com.ctm.web.health.apply.model;

import com.ctm.web.health.apply.model.request.fundData.Declaration;
import com.ctm.web.health.apply.model.request.fundData.membership.Membership;
import com.ctm.web.health.apply.model.request.fundData.membership.PartnerDetails;
import com.ctm.web.health.apply.model.request.fundData.membership.eligibility.Eligibility;
import com.ctm.web.health.apply.model.request.fundData.membership.eligibility.NhbEligibilityReasonID;
import com.ctm.web.health.apply.model.request.fundData.membership.eligibility.NhbEligibilitySubReasonID;
import com.ctm.web.health.model.form.*;
import org.junit.Test;

import java.util.Optional;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertNotNull;
import static org.junit.Assert.assertNull;
import static org.mockito.Mockito.*;

public class FundDataAdapterTest {

    @Test
    public void testCreateFundDataEmpty() throws Exception {
        final com.ctm.web.health.apply.model.request.fundData.FundData result = FundDataAdapter.createFundData(Optional.empty());
        assertNotNull(result);
        assertNull(result.getProvider());
        assertNull(result.getProduct());
        assertEquals(Declaration.Y, result.getDeclaration());
        assertNull(result.getStartDate());
        assertNull(result.getBenefits());
        assertNull(result.getMembership());
    }

    @Test
    public void testCreateFundData() throws Exception {
        final HealthQuote healthQuote = mock(HealthQuote.class);
        final Application application = mock(Application.class);
        final com.ctm.web.health.model.form.Payment payment = mock(com.ctm.web.health.model.form.Payment.class);
        final PaymentDetails paymentDetails = mock(PaymentDetails.class);
        final com.ctm.web.health.model.form.Situation situation = mock(com.ctm.web.health.model.form.Situation.class);
        when(healthQuote.getApplication()).thenReturn(application);
        when(healthQuote.getPayment()).thenReturn(payment);
        when(payment.getDetails()).thenReturn(paymentDetails);
        when(healthQuote.getSituation()).thenReturn(situation);
        final com.ctm.web.health.apply.model.request.fundData.FundData result = FundDataAdapter.createFundData(Optional.ofNullable(healthQuote));
        assertNotNull(result);
        verify(application, times(1)).getProvider();
        verify(application, times(1)).getProductId();
        verify(paymentDetails, times(1)).getStart();
    }

    @Test
    public void testMembershipEmpty() throws Exception {
        assertNull(FundDataAdapter.createMembership((Cbh)null));
    }

    @Test
    public void testMembership() throws Exception {
        final Cbh cbh = mock(Cbh.class);
        final Membership membership = FundDataAdapter.createMembership(cbh);
        assertNull(membership.getCurrentMember());
        assertNull(membership.getRegisteredMember());
        assertNull(membership.getMembershipNumber());
        assertNull(membership.getMembershipGroup());
        final PartnerDetails partnerDetails = membership.getPartnerDetails();
        assertNotNull(partnerDetails);
        assertNull(partnerDetails.getRelationshipToPrimary());
        assertNull(partnerDetails.getSameGroupMember());
        assertNull(membership.getRegisterForGroupServices());
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
    public void testMembershipCurrent() throws Exception {
        final Cbh cbh = mock(Cbh.class);
        when(cbh.getCurrentemployee()).thenReturn("Y");
        FundDataAdapter.createMembership(cbh);
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
    public void testMembershipFormer() throws Exception {
        final Cbh cbh = mock(Cbh.class);
        when(cbh.getFormeremployee()).thenReturn("Y");
        FundDataAdapter.createMembership(cbh);
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
    public void testMembershipFamily() throws Exception {
        final Cbh cbh = mock(Cbh.class);
        when(cbh.getFamilymember()).thenReturn("Y");
        FundDataAdapter.createMembership(cbh);
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
    public void testNavEmpty() throws Exception {
        assertNull(FundDataAdapter.createMembership((Nhb)null));
    }

    @Test
    public void testNav() throws Exception {
        Nhb nav = mock(Nhb.class);
        FundDataAdapter.createMembership(nav);
        verify(nav, times(2)).getEligibility();
        verify(nav, times(2)).getSubreason();
        verify(nav, times(1)).getPartnerrel();
    }

    @Test
    public void testNavValues() throws Exception {
        Nhb nav = mock(Nhb.class);
        when(nav.getEligibility()).thenReturn("CF");
        when(nav.getSubreason()).thenReturn("DODEFam");
        final Membership membership = FundDataAdapter.createMembership(nav);
        final Eligibility eligibility = membership.getEligibility();
        assertEquals(NhbEligibilityReasonID.ContractorFamily, eligibility.getNhbEligibilityReasonID());
        assertEquals(NhbEligibilitySubReasonID.ContractorFamilyDptDefence, eligibility.getNhbEligibilitySubReasonID());
        assertEquals("CF", eligibility.getEligibilityReasonID().get());
        assertEquals("DODEFam", eligibility.getEligibilitySubReasonID().get());
    }

    @Test
    public void testWfdEmpty() throws Exception {
        assertNull(FundDataAdapter.createMembership((Wfd)null));
    }

    @Test
    public void testWfd() throws Exception {
        Wfd wfd = mock(Wfd.class);
        FundDataAdapter.createMembership(wfd);
        verify(wfd, times(1)).getPartnerrel();
    }

    @Test
    public void testMembershipCurrentQtu() throws Exception {
        final Qtu qtu = mock(Qtu.class);
        when(qtu.getEligibility()).thenReturn("CURR");
        when(qtu.getUnion()).thenReturn("TOGTH");
        final Membership membership = FundDataAdapter.createMembership(qtu);
        final Eligibility eligibility = membership.getEligibility();
        assertEquals("CURR", eligibility.getEligibilityReasonID().get());
        assertEquals("TOGTH", eligibility.getEligibilitySubReasonID().get());
    }

    @Test
    public void testMembershipCurrentUhf() throws Exception {
        final Uhf uhf = mock(Uhf.class);
        when(uhf.getEligibility()).thenReturn("CURR");
        when(uhf.getUnion()).thenReturn("TOGTH");
        final Membership membership = FundDataAdapter.createMembership(uhf);
        final Eligibility eligibility = membership.getEligibility();
        assertEquals("CURR", eligibility.getEligibilityReasonID().get());
        assertEquals("TOGTH", eligibility.getEligibilitySubReasonID().get());
    }

    @Test
    public void testMembershipFormerUhf() throws Exception {
        final Uhf uhf = mock(Uhf.class);
        when(uhf.getEligibility()).thenReturn("FORM");
        final Membership membership = FundDataAdapter.createMembership(uhf);
        final Eligibility eligibility = membership.getEligibility();
        assertEquals("FORM", eligibility.getEligibilityReasonID().get());
        assertNull(eligibility.getEligibilitySubReasonID());
    }

    @Test
    public void testMembershipCallsGetUhf() throws Exception {
        final Uhf uhf = mock(Uhf.class);
        final HealthQuote healthQuote = mock(HealthQuote.class);
        final Application application = mock(Application.class);
        when(healthQuote.getApplication()).thenReturn(application);
        when(application.getCbh()).thenReturn(null);
        when(application.getNhb()).thenReturn(null);
        when(application.getUhf()).thenReturn(uhf);
        Membership membership = FundDataAdapter.createMembership(Optional.ofNullable(healthQuote));
        verify(application, times(1)).getUhf();
        verify(uhf, times(1)).getEligibility();
    }
}
