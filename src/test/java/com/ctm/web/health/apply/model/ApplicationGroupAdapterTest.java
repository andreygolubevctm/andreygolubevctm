package com.ctm.web.health.apply.model;

import com.ctm.web.health.apply.model.request.application.ApplicationGroup;
import com.ctm.web.health.apply.model.request.application.Emigrate;
import com.ctm.web.health.apply.model.request.application.applicant.Applicant;
import com.ctm.web.health.apply.model.request.application.applicant.healthCover.EverHadCover;
import com.ctm.web.health.apply.model.request.application.applicant.previousFund.CancelOption;
import com.ctm.web.health.apply.model.request.application.applicant.previousFund.CoverType;
import com.ctm.web.health.apply.model.request.application.situation.Situation;
import com.ctm.web.health.apply.model.request.fundData.HealthFund;
import com.ctm.web.health.model.form.Application;
import com.ctm.web.health.model.form.Dependant;
import com.ctm.web.health.model.form.Dependants;
import com.ctm.web.health.model.form.Fund;
import com.ctm.web.health.model.form.Cover;
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
import static org.junit.Assert.assertNotNull;
import static org.junit.Assert.assertNull;
import static org.junit.Assert.assertTrue;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.times;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;


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
        final ApplicationGroup applicationGroup = ApplicationGroupAdapter.createApplicationGroup(Optional.ofNullable(healthQuote));
        assertNotNull(applicationGroup);
        assertNull(applicationGroup.getSituation());
        assertNull(applicationGroup.getDependants());
        verify(application, times(1)).getPrimary();
        verify(previousFund, times(1)).getPrimary();
        verify(application, times(2)).getPartner();
        verify(application, times(1)).getDependants();
        verify(healthQuote, times(3)).getSituation();

        verify(healthQuote, times(1)).getPrimaryLHC();
        verify(healthQuote, times(1)).getPartnerLHC();

        //verify(hif, times(1)).getEmigrate();
        verify(qch, times(1)).getEmigrate();
        verify(govtRebateDeclaration, times(1)).getApplicantCovered();
        verify(govtRebateDeclaration, times(1)).getDeclarationDate();
        verify(govtRebateDeclaration, times(1)).getEntitledToMedicare();
        verify(govtRebateDeclaration, times(1)).getDeclaration();
        verify(govtRebateDeclaration, times(1)).getChildOnlyPolicy();
        verify(govtRebateDeclaration, times(1)).getVoiceConsent();
    }


    @Test
    public void testCreateApplicantEmpty() throws Exception {
        final Applicant applicant = ApplicationGroupAdapter.createApplicant(Optional.empty(), Optional.empty(), Optional.empty(), Optional.empty(), Emigrate.Y, Optional.empty(), Optional.empty());
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
        final Integer lhcPercentage = 8;
        final com.ctm.web.health.model.form.Situation situation = mock(com.ctm.web.health.model.form.Situation.class);

        when(insured.getEverHadCover()).thenReturn("Y");

        final Applicant applicant = ApplicationGroupAdapter.createApplicant(Optional.of(person), Optional.of(previousFund),
                Optional.of(certifiedAge), Optional.of(insured), Emigrate.Y, Optional.of(lhcPercentage), Optional.of(situation));
        assertNotNull(applicant);
        assertEquals(applicant.getHealthCover().getEverHadCover(), EverHadCover.Y);
        assertNotNull(applicant.getHealthCover());
        assertNull(applicant.getPreviousFund());

        assertNotNull(applicant.getCertifiedAgeEntry());
        assertEquals(applicant.getLhcPercentage(), (Integer) 8);

        verify(person, times(1)).getTitle();
        verify(person, times(1)).getFirstname();
        verify(person, times(1)).getSurname();
        verify(person, times(1)).getGender();
        verify(person, times(1)).getDob();
        verify(person, times(1)).getCover();
        verify(insured, times(1)).getCover();
        verify(insured, times(1)).getHealthCoverLoading();
        verify(insured, times(1)).getEverHadCover();
        verify(person, times(1)).getAuthority();

    }

    @Test
    public void testCreateApplicantEmptyExceptPerson() throws Exception {
        final Person person = mock(Person.class);
        final Applicant applicant = ApplicationGroupAdapter.createApplicant(Optional.of(person), Optional.empty(),
                Optional.empty(), Optional.empty(), Emigrate.Y, Optional.empty(), Optional.empty());
        assertNotNull(applicant);
        assertNull(applicant.getHealthCover());
        assertNull(applicant.getPreviousFund());
        assertNull(applicant.getCertifiedAgeEntry());
        assertEquals(applicant.getLhcPercentage(), (Integer) 0);

        verify(person, times(1)).getTitle();
        verify(person, times(1)).getFirstname();
        verify(person, times(1)).getSurname();
        verify(person, times(1)).getGender();
        verify(person, times(1)).getDob();
    }

    @Test
    public void testPreviousFundEmpty() throws Exception {
        final com.ctm.web.health.apply.model.request.application.applicant.previousFund.PreviousFund previousFund = ApplicationGroupAdapter.createPreviousFund(Optional.empty(), Optional.empty(), Optional.empty(), Optional.empty());
        assertNull(previousFund);
    }

    @Test
    public void testPreviousFund() throws Exception {
        final Fund fund = mock(Fund.class);
        when(fund.getFundName()).thenReturn("BUPA");
        final com.ctm.web.health.apply.model.request.application.applicant.previousFund.PreviousFund previousFund = ApplicationGroupAdapter.createPreviousFund(Optional.ofNullable(fund), Optional.empty(), Optional.empty(), Optional.empty());
        assertNotNull(previousFund);
        verify(fund, times(1)).getFundName();
        verify(fund, times(1)).getMemberID();
    }

    @Test
    public void testPreviousFundUHF() throws Exception {
        final Fund fund = mock(Fund.class);
        when(fund.getFundName()).thenReturn("UHF");
        final HealthFund healthFund = HealthFund.UHF;
        final com.ctm.web.health.apply.model.request.application.applicant.previousFund.PreviousFund previousFund = ApplicationGroupAdapter.createPreviousFund(Optional.ofNullable(fund), Optional.empty(), Optional.empty(), Optional.empty());
        assertNotNull(previousFund);
        verify(fund, times(1)).getFundName();
        verify(fund, times(1)).getMemberID();
        assertEquals(healthFund.getDescription(), previousFund.getFundName().getDescription());
    }

    @Test
    public void testPreviousFundExtraInfo() throws Exception {
        // Instantiate the fund form, making sure it has a fund name of "BUPA" and a cancellation option of "E"
        final Fund fund = new Fund();
        fund.setFundName("BUPA");
        fund.setFundCancellationType("E");

        // Instantiate the cover form, again making sure it has a cover type of "C"
        final Cover cover = new Cover();
        cover.setType("C");

        // Try creating the previousFund object
        final com.ctm.web.health.apply.model.request.application.applicant.previousFund.PreviousFund previousFund = ApplicationGroupAdapter.createPreviousFund(Optional.ofNullable(fund), Optional.ofNullable(cover), Optional.empty(), Optional.ofNullable("Y"));
        assertNotNull(previousFund);    // Fail if it's null

        // Check the previous fund's cancellation option and cover type properties
        assertNotNull(previousFund.getFundName());
        assertNotNull(previousFund.getConfirmCover());
        assertEquals(CancelOption.EXTRAS, previousFund.getCancel().get());
        assertEquals(CoverType.COMBINED, previousFund.getCoverType().get());
    }

    @Test
    public void testCancelOption() throws Exception {
        // Asserting equals for when the user is prompted to select a cancel option
        assertEquals(CancelOption.COMBINED, CancelOption.fromCancellationType("C"));
        assertEquals(CancelOption.HOSPITAL, CancelOption.fromCancellationType("H"));
        assertEquals(CancelOption.EXTRAS, CancelOption.fromCancellationType("E"));
        assertEquals(CancelOption.NOTHING, CancelOption.fromCancellationType("KH"));
        assertEquals(CancelOption.NOTHING, CancelOption.fromCancellationType("KE"));

        // When the user is not prompted to select a cancellation option, the CancelOption is derived from the xpath `health/situation/coverType`
        assertEquals(CancelOption.COMBINED, CancelOption.fromPurchaseType("C"));
        assertEquals(CancelOption.HOSPITAL, CancelOption.fromPurchaseType("H"));
        assertEquals(CancelOption.EXTRAS, CancelOption.fromPurchaseType("E"));

        // Finally, make sure we'll get a null if we try to use an invalid code
        assertNull(CancelOption.fromCancellationType("A"));
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

    @Test
    public void testNonMockedCreateDependant() throws Exception {
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
        com.ctm.web.health.apply.model.request.application.dependant.Dependant appDependant =
                ApplicationGroupAdapter.createDependant(Optional.of(dependant));
        // Then
        assertNotNull(appDependant);
        assertEquals(appDependant.getDateOfBirth(), LocalDate.of(1999, 1, 1));
        assertEquals(appDependant.getFirstName().get(), "Abe");
        assertEquals(appDependant.getGender().name(), "M");
        assertEquals(appDependant.getLastName().get(), "Simpson");
        assertEquals(appDependant.getSchool().get(), "Queensland University of Technology");
        assertEquals(appDependant.getSchoolDate(), LocalDate.of(2000, 1, 1));
        assertEquals(appDependant.getRelationship().name(), "NONE");
        assertEquals(appDependant.getGraduationDate().get(), "2004-08-15");
        assertEquals(appDependant.getSchoolID().get(), "QUT");
        assertEquals(appDependant.getFullTimeStudent(), null);
        assertEquals(appDependant.getTitle().getName(), "MR");
    }
}
