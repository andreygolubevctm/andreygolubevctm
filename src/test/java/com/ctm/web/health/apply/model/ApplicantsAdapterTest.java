package com.ctm.web.health.apply.model;

import com.ctm.schema.health.v1_0_0.Applicant;
import com.ctm.schema.health.v1_0_0.Applicants;
import com.ctm.schema.health.v1_0_0.PreviousFund;
import com.ctm.schema.health.v1_0_0.HealthCoverHistory;
import com.ctm.schema.health.v1_0_0.PolicyType;
import com.ctm.web.health.apply.model.request.application.Emigrate;
import com.ctm.web.health.apply.model.request.fundData.HealthFund;
import com.ctm.web.health.model.form.Application;
import com.ctm.web.health.model.form.Cover;
import com.ctm.web.health.model.form.Dependant;
import com.ctm.web.health.model.form.Dependants;
import com.ctm.web.health.model.form.Fund;
import com.ctm.web.health.model.form.GovtRebateDeclaration;
import com.ctm.web.health.model.form.GradDate;
import com.ctm.web.health.model.form.HealthQuote;
import com.ctm.web.health.model.form.Hif;
import com.ctm.web.health.model.form.Insured;
import com.ctm.web.health.model.form.Person;
import com.ctm.web.health.model.form.Qch;
import org.junit.Test;

import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertFalse;
import static org.junit.Assert.assertNotNull;
import static org.junit.Assert.assertNull;
import static org.junit.Assert.assertTrue;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.times;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;


public class ApplicantsAdapterTest {

    @Test
    public void testCreateApplicantsEmpty() {
        final Applicants applicationGroup = ApplicantsAdapter.createApplicants(Optional.empty());
        assertNotNull(applicationGroup);
    }

    @Test
    public void testCreateApplicants() {
        final HealthQuote healthQuote = mock(HealthQuote.class);
        final Application application = mock(Application.class);
        final Person partner = mock(Person.class);

        final Hif hif = mock(Hif.class);
        final Qch qch = mock(Qch.class);
        final GovtRebateDeclaration govtRebateDeclaration = mock(GovtRebateDeclaration.class);
        final com.ctm.web.health.model.form.PreviousFund previousFund = mock(com.ctm.web.health.model.form.PreviousFund.class);
        when(healthQuote.getApplication()).thenReturn(application);
        when(application.getPartner()).thenReturn(partner);
        when(partner.getTitle()).thenReturn("Mrs");

        when(healthQuote.getPreviousfund()).thenReturn(previousFund);
        when(application.getHif()).thenReturn(hif);
        when(application.getQch()).thenReturn(qch);
        when(application.getGovtRebateDeclaration()).thenReturn(govtRebateDeclaration);
        final Applicants applicationGroup = ApplicantsAdapter.createApplicants(Optional.of(healthQuote));
        assertNotNull(applicationGroup);
        assertNull(applicationGroup.getMembershipType());
        assertNull(applicationGroup.getDependants());
        verify(application, times(1)).getPrimary();
        verify(previousFund, times(1)).getPrimary();
        verify(application, times(2)).getPartner();
        verify(application, times(1)).getDependants();
        verify(healthQuote, times(3)).getSituation();

        verify(healthQuote, times(1)).getPrimaryLHC();
        verify(healthQuote, times(1)).getPartnerLHC();

        verify(govtRebateDeclaration, times(1)).getApplicantCovered();
        verify(govtRebateDeclaration, times(1)).getDeclarationDate();
        verify(govtRebateDeclaration, times(1)).getEntitledToMedicare();
        verify(govtRebateDeclaration, times(1)).getDeclaration();
        verify(govtRebateDeclaration, times(1)).getChildOnlyPolicy();
        verify(govtRebateDeclaration, times(1)).getVoiceConsent();
    }


    @Test
    public void testCreateApplicantEmpty() {
        final com.ctm.schema.health.v1_0_0.Applicant applicant = ApplicantsAdapter.createApplicant(Optional.empty(), Optional.empty(), Optional.empty(), Optional.empty(), Emigrate.Y, Optional.empty(), Optional.empty(), Optional.empty());
        assertNull(applicant);
    }

    @Test
    public void testCreateApplicant() {
        final Person person = mock(Person.class);
        final Fund previousFund = mock(Fund.class);
        final Integer certifiedAge = 1;
        final Insured insured = mock(Insured.class);
        final Integer lhcPercentage = 8;
        final com.ctm.web.health.model.form.Situation situation = mock(com.ctm.web.health.model.form.Situation.class);
        when(insured.getCover()).thenReturn("N");
        when(insured.getEverHadCover()).thenReturn("Y");

        final com.ctm.schema.health.v1_0_0.Applicant applicant = ApplicantsAdapter.createApplicant(Optional.of(person), Optional.of(previousFund),
                Optional.of(certifiedAge), Optional.of(insured), Emigrate.Y, Optional.of(lhcPercentage), Optional.of(situation), Optional.empty());
        assertNotNull(applicant);
        assertNotNull(applicant.getHealthCoverHistory());
        assertTrue(applicant.getHealthCoverHistory().getEverHadCover());
        assertNull(applicant.getHealthCoverHistory().getPreviousFund());

        assertNotNull(applicant.getCertifiedAgeEntry());
        assertEquals(applicant.getLhcPercentage(), (Integer) 8);

        verify(person, times(1)).getTitle();
        verify(person, times(1)).getFirstname();
        verify(person, times(1)).getSurname();
        verify(person, times(1)).getGender();
        verify(person, times(1)).getDob();
        verify(person, times(1)).getCover();
        verify(insured, times(2)).getCover();
        verify(insured, times(1)).getHealthCoverLoading();
        verify(insured, times(1)).getEverHadCover();
        verify(person, times(1)).getAuthority();

    }

    @Test
    public void testCreateApplicantWithPreviousCoverOnline() {
        final Cover cover = new Cover();
        cover.setType("H");
        final Person person = new Person();
        person.setEverHadCoverPrivateHospital1("Y");
        person.setEmail("test@test.com");
        person.setAuthority("Y");
        person.setCover(cover);
        final Fund previousFund = mock(Fund.class);
        final Integer certifiedAge = 1;
        final Insured insured = mock(Insured.class);
        final Integer lhcPercentage = 8;
        final com.ctm.web.health.model.form.Situation situation = mock(com.ctm.web.health.model.form.Situation.class);

        when(insured.getEverHadCover()).thenReturn("N");
        when(previousFund.getMemberID()).thenReturn("123456");
        when(previousFund.getFundName()).thenReturn("NAB");
        when(insured.getCover()).thenReturn("N");

        final com.ctm.schema.health.v1_0_0.Applicant applicant = ApplicantsAdapter.createApplicant(Optional.of(person), Optional.of(previousFund),
                Optional.of(certifiedAge), Optional.of(insured), Emigrate.Y, Optional.of(lhcPercentage), Optional.of(situation), Optional.empty());
        assertNotNull(applicant);
        assertNotNull(applicant.getHealthCoverHistory());
        assertFalse(applicant.getHealthCoverHistory().getEverHadCover());
        assertEquals(PolicyType.HOSPITAL, applicant.getHealthCoverHistory().getPreviousFund().getPolicyType());
    }

    @Test
    public void testCreateApplicantWithPreviousCoverSimples() {
        final Person person = mock(Person.class);
        final Fund previousFund = mock(Fund.class);
        final Cover cover = mock(Cover.class);
        final Integer certifiedAge = 1;
        final Insured insured = mock(Insured.class);
        final Integer lhcPercentage = 8;
        final com.ctm.web.health.model.form.Situation situation = mock(com.ctm.web.health.model.form.Situation.class);

        when(insured.getEverHadCover()).thenReturn("N");
        when(insured.getHealthEverHeld()).thenReturn("Y");
        when(previousFund.getMemberID()).thenReturn("123456");
        when(previousFund.getFundName()).thenReturn("NAB");
        when(insured.getCover()).thenReturn("N");
        when(person.getCover()).thenReturn(cover);
        when(cover.getType()).thenReturn("H");

        final com.ctm.schema.health.v1_0_0.Applicant applicant = ApplicantsAdapter.createApplicant(Optional.of(person), Optional.of(previousFund),
                Optional.of(certifiedAge), Optional.of(insured), Emigrate.Y, Optional.of(lhcPercentage), Optional.of(situation), Optional.empty());
        assertNotNull(applicant);
        assertNotNull(applicant.getHealthCoverHistory());
        assertFalse(applicant.getHealthCoverHistory().getEverHadCover());
        assertEquals(PolicyType.HOSPITAL, applicant.getHealthCoverHistory().getPreviousFund().getPolicyType());
    }

    @Test
    public void testCreateApplicantEmptyExceptPerson() {
        final Person person = mock(Person.class);
        final Applicant applicant = ApplicantsAdapter.createApplicant(Optional.of(person), Optional.empty(),
                Optional.empty(), Optional.empty(), Emigrate.Y, Optional.empty(), Optional.empty(), Optional.empty());
        assertNotNull(applicant);
        assertNotNull(applicant.getHealthCoverHistory());
        assertNull(applicant.getCertifiedAgeEntry());
        assertEquals(applicant.getLhcPercentage(), (Integer) 0);

        verify(person, times(1)).getTitle();
        verify(person, times(1)).getFirstname();
        verify(person, times(1)).getSurname();
        verify(person, times(1)).getGender();
        verify(person, times(1)).getDob();
    }

    @Test
    public void testPreviousFundEmpty() {
        final HealthCoverHistory healthCoverHistory = ApplicantsAdapter.createHealthCoverHistory(Optional.empty(), Optional.empty(), Optional.empty(), Optional.empty());
        assertNotNull(healthCoverHistory);
        assertFalse(healthCoverHistory.getEverHadCover());
        assertFalse(healthCoverHistory.getHasCurrentHealthCover());
        assertNull(healthCoverHistory.getDifferentProvidersForHospitalAndExtrasCover());
        assertNull(healthCoverHistory.getHasHadContinuousCover());
        assertFalse(healthCoverHistory.getIsLHCLoadingApplied());
        assertNull(healthCoverHistory.getPriorCoverPeriods());
    }

    @Test
    public void testPreviousFund() {
        final Fund fund = mock(Fund.class);
        when(fund.getFundName()).thenReturn("BUPA");
        final Insured insured = mock(Insured.class);
        when(insured.getCover()).thenReturn("Y");
        final PreviousFund PreviousFund = ApplicantsAdapter.createPreviousFund(Optional.ofNullable(fund), Optional.empty(), Optional.empty(), Optional.ofNullable(insured));
        assertNotNull(PreviousFund);
        verify(fund, times(1)).getFundName();
        verify(fund, times(1)).getMemberID();
    }

    @Test
    public void testPreviousFundUHF() {
        final Fund fund = mock(Fund.class);
        when(fund.getFundName()).thenReturn("UHF");
        final HealthFund healthFund = HealthFund.UHF;
        final Insured insured = mock(Insured.class);
        when(insured.getCover()).thenReturn("Y");
        final PreviousFund PreviousFund = ApplicantsAdapter.createPreviousFund(Optional.ofNullable(fund), Optional.empty(), Optional.empty(), Optional.ofNullable(insured));
        assertNotNull(PreviousFund);
        verify(fund, times(1)).getFundName();
        verify(fund, times(1)).getMemberID();
        assertEquals(healthFund.name(), PreviousFund.getProviderCode());
    }

    @Test
    public void testPreviousFundExtraInfo() {
        // Instantiate the fund form, making sure it has a fund name of "BUPA" and a cancellation option of "E"
        final Fund fund = new Fund();
        fund.setFundName("BUPA");
        fund.setFundCancellationType("E");

        // Instantiate the cover form, again making sure it has a cover type of "C"
        final Cover cover = new Cover();
        cover.setType("C");
        final Person person = mock(Person.class);
        final Insured insured = mock(Insured.class);
        when(insured.getCover()).thenReturn("Y");
        when(person.getCover()).thenReturn(cover);
        // Try creating the previousFund object
        final PreviousFund PreviousFund = ApplicantsAdapter.createPreviousFund(Optional.ofNullable(fund), Optional.ofNullable(person), Optional.empty(), Optional.ofNullable(insured));
        assertNotNull(PreviousFund);    // Fail if it's null

        // Check the previous fund's cancellation option and cover type properties
        assertNotNull(PreviousFund);
        assertFalse(PreviousFund.getHasAuthorityToContactFund());
        assertEquals(PolicyType.ANCILLARY, PreviousFund.getCancelOption());
        assertEquals(PolicyType.COMBINED, PreviousFund.getPolicyType());
    }

    @Test
    public void testCreateDependantsEmpty() {
        assertNull(ApplicantsAdapter.createDependants(Optional.empty()));
    }

    @Test
    public void testCreateDependantsEmpty1() {
        final Dependants dependants = mock(Dependants.class);
        final List<com.ctm.schema.health.v1_0_0.Dependant> result = ApplicantsAdapter.createDependants(Optional.of(dependants));
        assertNotNull(result);
        assertTrue(result.isEmpty());
    }

    @Test
    public void testCreateDependants1Dependant() {
        final Dependants dependants = mock(Dependants.class);
        final Dependant dependant = mock(Dependant.class);
        when(dependant.getLastname()).thenReturn("x");
        List<Dependant> dependantList = new ArrayList<>();
        when(dependants.getDependant()).thenReturn(dependantList);
        dependantList.add(dependant);
        final List<com.ctm.schema.health.v1_0_0.Dependant> result = ApplicantsAdapter.createDependants(Optional.of(dependants));
        assertNotNull(result);
        assertEquals(1, result.size());
    }

    @Test
    public void testCreateDependants12Dependant() {
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
        final List<com.ctm.schema.health.v1_0_0.Dependant> result = ApplicantsAdapter.createDependants(Optional.of(dependants));
        assertNotNull(result);
        assertEquals(12, result.size());
    }

    @Test
    public void testCreateDependantEmpty() {
        assertNull(ApplicantsAdapter.createDependant(Optional.empty()));
    }

    @Test
    public void testCreateDependant() {
        final Dependant dependant = mock(Dependant.class);
        assertNotNull(ApplicantsAdapter.createDependant(Optional.of(dependant)));
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

    @Test
    public void testNonMockedCreateDependant() {
        // Given
        Dependant dependant = new Dependant();
        dependant.setDob("01/01/1999");
        dependant.setFirstName("Abe");
        dependant.setGender("M");
        GradDate gradDate = new GradDate();
        gradDate.setCardExpiryMonth("08");
        gradDate.setCardExpiryYear("04");
        dependant.setGradDate(gradDate);
        dependant.setLastname("Simpson");
        dependant.setRelationship("NONE");
        dependant.setSchoolDate("01/01/2000");
        dependant.setSchool("Queensland University of Technology");
        dependant.setSchoolID("QUT");
        dependant.setTitle("MR");
        // When
        com.ctm.schema.health.v1_0_0.Dependant appDependant =
                ApplicantsAdapter.createDependant(Optional.of(dependant));
        // Then
        assertNotNull(appDependant);
        assertEquals(appDependant.getDateOfBirth(), LocalDate.of(1999, 1, 1));
        assertEquals(appDependant.getFirstName(), "Abe");
        assertEquals(appDependant.getGender().name(), "MALE");
        assertEquals(appDependant.getLastName(), "Simpson");
        assertEquals(appDependant.getSchoolName(), "Queensland University of Technology");
        assertEquals(appDependant.getSchoolStartDate(), LocalDate.of(2000, 1, 1));
        assertEquals(appDependant.getRelationship().name(), "NONE");
        assertEquals(appDependant.getGraduationDate(), LocalDate.of(2004, 8, 15));
        assertEquals(appDependant.getStudentID(), "QUT");
        assertFalse(appDependant.getIsFullTimeStudent());
        assertEquals(appDependant.getTitle().name(), "MR");
    }
}
