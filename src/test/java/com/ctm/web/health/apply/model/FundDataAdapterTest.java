package com.ctm.web.health.apply.model;

import com.ctm.web.health.apply.model.request.fundData.Declaration;
import com.ctm.web.health.apply.model.request.fundData.membership.Membership;
import com.ctm.web.health.apply.model.request.fundData.membership.PartnerDetails;
import com.ctm.web.health.model.form.Application;
import com.ctm.web.health.model.form.Cbh;
import com.ctm.web.health.model.form.HealthQuote;
import com.ctm.web.health.model.form.PaymentDetails;
import org.junit.Test;

import java.util.Optional;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertNotNull;
import static org.junit.Assert.assertNull;
import static org.mockito.Mockito.*;
import static org.mockito.Mockito.times;
import static org.mockito.Mockito.verify;

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
        verify(situation, times(1)).getHealthSitu();
    }

    @Test
    public void testMembershipEmpty() throws Exception {
        assertNull(FundDataAdapter.createMembership(Optional.empty()));
    }

    @Test
    public void testMembership() throws Exception {
        final Cbh cbh = mock(Cbh.class);
        final Membership membership = FundDataAdapter.createMembership(Optional.ofNullable(cbh));
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
        FundDataAdapter.createMembership(Optional.ofNullable(cbh));
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
        FundDataAdapter.createMembership(Optional.ofNullable(cbh));
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
        FundDataAdapter.createMembership(Optional.ofNullable(cbh));
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

}
