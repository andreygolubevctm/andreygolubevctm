package com.ctm.web.health.apply.model;

import com.ctm.web.health.apply.model.request.application.ApplicationGroup;
import com.ctm.web.health.apply.model.request.application.Emigrate;
import com.ctm.web.health.apply.model.request.application.applicant.Applicant;
import com.ctm.web.health.apply.model.request.application.applicant.healthCover.EverHadCover;
import com.ctm.web.health.apply.model.request.application.situation.Situation;
import com.ctm.web.health.model.form.*;
import org.junit.Test;

import java.util.ArrayList;
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
        final GovtRebateDeclaration govtRebateDeclaration = mock(GovtRebateDeclaration.class);
        final com.ctm.web.health.model.form.PreviousFund previousFund = mock(com.ctm.web.health.model.form.PreviousFund.class);
        when(healthQuote.getApplication()).thenReturn(application);
        when(healthQuote.getPreviousfund()).thenReturn(previousFund);
        when(application.getHif()).thenReturn(hif);
        when(application.getQch()).thenReturn(qch);
        when(application.getGovtRebateDeclaration()).thenReturn(govtRebateDeclaration);
        final ApplicationGroup applicationGroup = ApplicationGroupAdapter.createApplicationGroup(Optional.ofNullable(healthQuote));
        assertNotNull(applicationGroup);
        assertNull(applicationGroup.getSituation());
        assertNull(applicationGroup.getDependants());
        verify(application, times(1)).getPrimary();
        verify(previousFund, times(1)).getPrimary();
        verify(application, times(1)).getPartner();
        verify(application, times(1)).getDependants();
        verify(healthQuote, times(1)).getSituation();
        //verify(hif, times(1)).getEmigrate();
        verify(qch, times(1)).getEmigrate();
        verify(govtRebateDeclaration, times(1)).getApplicantCovered();
        verify(govtRebateDeclaration, times(1)).getDeclarationDate();
        verify(govtRebateDeclaration, times(1)).getEntitledToMedicare();
        verify(govtRebateDeclaration, times(1)).getDeclaration();
    }


    @Test
    public void testCreateApplicantEmpty() throws Exception {
        final Applicant applicant = ApplicationGroupAdapter.createApplicant(Optional.empty(), Optional.empty(), Optional.empty(), Optional.empty(), Emigrate.Y);
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
        verify(situation, times(1)).getHealthCvr();
    }

    @Test
    public void testCreateApplicant() throws Exception {
        final Person person = mock(Person.class);
        final Fund previousFund = mock(Fund.class);
        final Integer certifiedAge = 1;
        final Insured insured = mock(Insured.class);

        when(insured.getEverHadCover()).thenReturn("Y");

        final Applicant applicant = ApplicationGroupAdapter.createApplicant(Optional.of(person), Optional.of(previousFund),
                Optional.of(certifiedAge), Optional.of(insured),Emigrate.Y);
        assertNotNull(applicant);
        assertEquals(applicant.getHealthCover().getEverHadCover(), EverHadCover.Y);
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
        verify(insured, times(1)).getEverHadCover();
        verify(person, times(1)).getAuthority();
    }

    @Test
    public void testCreateApplicantEmptyExceptPerson() throws Exception {
        final Person person = mock(Person.class);
        final Applicant applicant = ApplicationGroupAdapter.createApplicant(Optional.of(person), Optional.empty(),
                Optional.empty(), Optional.empty(), Emigrate.Y);
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
        verify(fund, times(1)).getMemberID();
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
        when(dependant.getLastname()).thenReturn("x");
        List<Dependant> dependantList = new ArrayList<>();
        when(dependants.getDependant()).thenReturn(dependantList);
        dependantList.add(dependant);
        final List<com.ctm.web.health.apply.model.request.application.dependant.Dependant> result = ApplicationGroupAdapter.createDependants(Optional.of(dependants));
        assertNotNull(result);
        assertEquals(1, result.size());
    }

    @Test
    public void testCreateDependants12Dependant() throws Exception {
        final Dependants dependants = mock(Dependants.class);
        final Dependant dependant = mock(Dependant.class);
        when(dependant.getLastname()).thenReturn("x");
        List<Dependant> dependantList = new ArrayList<>();
        when(dependants.getDependant()).thenReturn(dependantList);
        dependantList.add(dependant);
        dependantList.add(dependant);
        dependantList.add(dependant);
        dependantList.add(dependant);
        dependantList.add(dependant);
        dependantList.add(dependant);
        dependantList.add(dependant);
        dependantList.add(dependant);
        dependantList.add(dependant);
        dependantList.add(dependant);
        dependantList.add(dependant);
        dependantList.add(dependant);
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
        verify(dependant, times(1)).getFirstName();
        verify(dependant, times(1)).getLastname();
        verify(dependant, times(1)).getDob();
        verify(dependant, times(1)).getSchool();
        verify(dependant, times(1)).getSchoolDate();
        verify(dependant, times(1)).getSchoolID();
        verify(dependant, times(1)).getFulltime();
    }

}
