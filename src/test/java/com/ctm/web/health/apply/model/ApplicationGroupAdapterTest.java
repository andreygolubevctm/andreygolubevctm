package com.ctm.web.health.apply.model;

import com.ctm.web.health.apply.model.request.application.ApplicationGroup;
import com.ctm.web.health.apply.model.request.application.applicant.Applicant;
import com.ctm.web.health.apply.model.request.application.situation.Situation;
import com.ctm.web.health.model.form.*;
import org.junit.Test;

import java.util.List;
import java.util.Optional;

import static org.junit.Assert.*;
import static org.mockito.Mockito.*;

public class ApplicationGroupAdapterTest {

    @Test
    public void testCreateApplicationGroupEmpty() throws Exception {
        final ApplicationGroup applicationGroup = ApplicationGroupAdapter.createApplicationGroup(Optional.empty());
        assertNotNull(applicationGroup);
    }

    @Test
    public void testCreateApplicationGroup() throws Exception {
        final HealthQuote healthQuote = mock(HealthQuote.class);
        final Application application = mock(Application.class);
        final Hif hif = mock(Hif.class);
        final Qch qch = mock(Qch.class);
        final com.ctm.web.health.model.form.PreviousFund previousFund = mock(com.ctm.web.health.model.form.PreviousFund.class);
        when(healthQuote.getApplication()).thenReturn(application);
        when(healthQuote.getPreviousFund()).thenReturn(previousFund);
        when(application.getHif()).thenReturn(hif);
        when(application.getQch()).thenReturn(qch);
        final ApplicationGroup applicationGroup = ApplicationGroupAdapter.createApplicationGroup(Optional.ofNullable(healthQuote));
        assertNotNull(applicationGroup);
        assertNull(applicationGroup.getSituation());
        assertNull(applicationGroup.getDependants());
        verify(application, times(1)).getPrimary();
        verify(previousFund, times(1)).getPrimary();
        verify(application, times(1)).getPartner();
        verify(application, times(1)).getDependants();
        verify(healthQuote, times(1)).getSituation();
        verify(hif, times(1)).getEmigrate();
        verify(qch, times(1)).getEmigrate();
    }

    @Test
    public void testCreateApplicantEmpty() throws Exception {
        final Applicant applicant = ApplicationGroupAdapter.createApplicant(Optional.empty(), Optional.empty(), Optional.empty(), Optional.empty());
        assertNull(applicant);
    }

    @Test
    public void testCreateSituationEmpty() throws Exception {
        final Situation situation = ApplicationGroupAdapter.createSituation(Optional.empty());
        assertNull(situation);
    }

    @Test
    public void testCreateSituation() throws Exception {
        final com.ctm.web.health.model.form.Situation situation = mock(com.ctm.web.health.model.form.Situation.class);
        final Situation result = ApplicationGroupAdapter.createSituation(Optional.ofNullable(situation));
        assertNotNull(result);
        verify(situation, times(1)).getHealthSitu();
        verify(situation, times(1)).getHealthCvr();
    }

    @Test
    public void testCreateApplicant() throws Exception {
        final Person person = mock(Person.class);
        final Fund previousFund = mock(Fund.class);
        final Integer certifiedAge = 1;
        final Insured insured = mock(Insured.class);
        final Applicant applicant = ApplicationGroupAdapter.createApplicant(Optional.of(person), Optional.of(previousFund),
                Optional.of(certifiedAge), Optional.of(insured));
        assertNotNull(applicant);
        assertNotNull(applicant.getHealthCover());
        assertNull(applicant.getPreviousFund());
        assertNotNull(applicant.getCertifiedAgeEntry());
        verify(person, times(1)).getTitle();
        verify(person, times(1)).getFirstname();
        verify(person, times(1)).getSurname();
        verify(person, times(1)).getGender();
        verify(person, times(1)).getDob();
        verify(insured, times(1)).getCover();
        verify(insured, times(1)).getHealthCoverLoading();
        verify(person, times(1)).getAuthority();
    }

    @Test
    public void testCreateApplicantEmptyExceptPerson() throws Exception {
        final Person person = mock(Person.class);
        final Applicant applicant = ApplicationGroupAdapter.createApplicant(Optional.of(person), Optional.empty(),
                Optional.empty(), Optional.empty());
        assertNotNull(applicant);
        assertNull(applicant.getHealthCover());
        assertNull(applicant.getPreviousFund());
        assertNull(applicant.getCertifiedAgeEntry());
        verify(person, times(1)).getTitle();
        verify(person, times(1)).getFirstname();
        verify(person, times(1)).getSurname();
        verify(person, times(1)).getGender();
        verify(person, times(1)).getDob();
    }

    @Test
    public void testPreviousFundEmpty() throws Exception {
        final com.ctm.web.health.apply.model.request.application.applicant.previousFund.PreviousFund previousFund = ApplicationGroupAdapter.createPreviousFund(Optional.empty());
        assertNull(previousFund);
    }

    @Test
    public void testPreviousFund() throws Exception {
        final Fund fund = mock(Fund.class);
        when(fund.getFundName()).thenReturn("BUPA");
        final com.ctm.web.health.apply.model.request.application.applicant.previousFund.PreviousFund previousFund = ApplicationGroupAdapter.createPreviousFund(Optional.ofNullable(fund));
        assertNotNull(previousFund);
        verify(fund, times(1)).getFundName();
        verify(fund, times(1)).getMemberId();
    }

    @Test
    public void testCreateDependantsEmpty() throws Exception {
        assertNull(ApplicationGroupAdapter.createDependants(Optional.empty()));
    }

    @Test
    public void testCreateDependantsEmpty1() throws Exception {
        final Dependants dependants = mock(Dependants.class);
        final List<com.ctm.web.health.apply.model.request.application.dependant.Dependant> result = ApplicationGroupAdapter.createDependants(Optional.of(dependants));
        assertNotNull(result);
        assertTrue(result.isEmpty());
    }

    @Test
    public void testCreateDependants1Dependant() throws Exception {
        final Dependants dependants = mock(Dependants.class);
        final Dependant dependant = mock(Dependant.class);
        when(dependants.getDependant1()).thenReturn(dependant);
        final List<com.ctm.web.health.apply.model.request.application.dependant.Dependant> result = ApplicationGroupAdapter.createDependants(Optional.of(dependants));
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
        final List<com.ctm.web.health.apply.model.request.application.dependant.Dependant> result = ApplicationGroupAdapter.createDependants(Optional.of(dependants));
        assertNotNull(result);
        assertEquals(12, result.size());
    }

    @Test
    public void testCreateDependantEmpty() throws Exception {
        assertNull(ApplicationGroupAdapter.createDependant(Optional.empty()));
    }

    @Test
    public void testCreateDependant() throws Exception {
        final Dependant dependant = mock(Dependant.class);
        assertNotNull(ApplicationGroupAdapter.createDependant(Optional.of(dependant)));
        // 2 times - title and gender
        verify(dependant, times(2)).getTitle();
        verify(dependant, times(1)).getFirstname();
        verify(dependant, times(1)).getLastname();
        verify(dependant, times(1)).getDob();
        verify(dependant, times(1)).getSchool();
        verify(dependant, times(1)).getSchoolDate();
        verify(dependant, times(1)).getSchoolID();
        verify(dependant, times(1)).getFulltime();
    }

}
