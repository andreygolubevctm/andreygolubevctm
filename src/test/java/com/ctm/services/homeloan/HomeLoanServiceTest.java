package com.ctm.services.homeloan;

import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.times;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.verifyZeroInteractions;
import static org.mockito.Mockito.when;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import com.ctm.model.homeloan.HomeLoanContact;
import org.junit.Before;
import org.junit.Test;

import com.ctm.web.core.dao.transaction.TransactionDetailsDao;
import com.ctm.web.homeloan.dao.HomeloanUnconfirmedLeadsDao;
import com.ctm.exceptions.DaoException;
import com.ctm.model.homeloan.HomeLoanModel;

public class HomeLoanServiceTest {

	private HomeloanUnconfirmedLeadsDao homeloanUnconfirmedLeadsDao;
	private TransactionDetailsDao transactionDetailsDao;
	private HomeLoanService service;
	private HomeLoanOpportunityService opportunityService;
	private long transactionId = 1;

	@Before
	public void setUp() throws Exception {
		homeloanUnconfirmedLeadsDao = mock(HomeloanUnconfirmedLeadsDao.class);
		transactionDetailsDao =  mock(TransactionDetailsDao.class);
		opportunityService =  mock(HomeLoanOpportunityService.class);
		service = new HomeLoanService(transactionDetailsDao, homeloanUnconfirmedLeadsDao, opportunityService);
	}

	@Test
	public void shouldNotSubmitIfFirstNameIsNull() throws DaoException {
		List<HomeLoanModel> value = new ArrayList<>();
		HomeLoanModel modelWithoutFirstName = new HomeLoanModel();
		modelWithoutFirstName.setTransactionId(transactionId);
		modelWithoutFirstName.setState("QLD");
		modelWithoutFirstName.contact = new HomeLoanContact();
		modelWithoutFirstName.contact.firstName = null;
		modelWithoutFirstName.contact.lastName = "Orlov";
		modelWithoutFirstName.setContactPhoneNumber("0402111111");
		modelWithoutFirstName.setEmailAddress("preload.testing@comparethemarket.com.au");
		modelWithoutFirstName.setAddressCity("Toowong");
		modelWithoutFirstName.setAddressPostcode("4066");
		modelWithoutFirstName.setAdditionalInformation("OUTBOUND LEAD");
		value.add(modelWithoutFirstName);
		when(homeloanUnconfirmedLeadsDao.getUnconfirmedTransactionIds()).thenReturn(value);
		HttpServletRequest request = mock(HttpServletRequest.class);

		service.scheduledLeadGenerator(request);

		// verify service.submitOpportunity was never called
		verifyZeroInteractions(opportunityService);
	}

	@Test
	public void shouldNotSubmitIfLastNameIsEmpty() throws DaoException {
		List<HomeLoanModel> value = new ArrayList<>();
		HomeLoanModel modelWithoutFirstName = new HomeLoanModel();
		modelWithoutFirstName.setTransactionId(transactionId);
		modelWithoutFirstName.setState("QLD");
		modelWithoutFirstName.contact = new HomeLoanContact();
		modelWithoutFirstName.contact.firstName = "Aleksandr";
		modelWithoutFirstName.contact.lastName = "";
		modelWithoutFirstName.setContactPhoneNumber("0402111111");
		modelWithoutFirstName.setEmailAddress("preload.testing@comparethemarket.com.au");
		modelWithoutFirstName.setAddressCity("Toowong");
		modelWithoutFirstName.setAddressPostcode("4066");
		modelWithoutFirstName.setAdditionalInformation("OUTBOUND LEAD");
		value.add(modelWithoutFirstName);
		when(homeloanUnconfirmedLeadsDao.getUnconfirmedTransactionIds()).thenReturn(value);
		HttpServletRequest request = mock(HttpServletRequest.class);

		service.scheduledLeadGenerator(request);

		// verify service.submitOpportunity was never called
		verifyZeroInteractions(opportunityService);
	}

	@Test
	public void shouldNotSubmitIfPhoneNumberIsEmpty() throws DaoException {
		List<HomeLoanModel> value = new ArrayList<>();
		HomeLoanModel modelWithoutFirstName = new HomeLoanModel();
		modelWithoutFirstName.setTransactionId(transactionId);
		modelWithoutFirstName.setState("QLD");
		modelWithoutFirstName.contact = new HomeLoanContact();
		modelWithoutFirstName.contact.firstName = "Aleksandr";
		modelWithoutFirstName.contact.lastName = "Orlov";
		modelWithoutFirstName.setContactPhoneNumber("");
		modelWithoutFirstName.setEmailAddress("preload.testing@comparethemarket.com.au");
		modelWithoutFirstName.setAddressCity("Toowong");
		modelWithoutFirstName.setAddressPostcode("4066");
		modelWithoutFirstName.setAdditionalInformation("OUTBOUND LEAD");
		value.add(modelWithoutFirstName);
		when(homeloanUnconfirmedLeadsDao.getUnconfirmedTransactionIds()).thenReturn(value);
		HttpServletRequest request = mock(HttpServletRequest.class);

		service.scheduledLeadGenerator(request);

		// verify service.submitOpportunity was never called
		verifyZeroInteractions(opportunityService);
	}

	@Test
	public void shouldSubmitIfAllRequiredFieldsExist() throws DaoException {
		List<HomeLoanModel> value = new ArrayList<>();
		HomeLoanModel model = new HomeLoanModel();
		model.setTransactionId(transactionId);
		model.setState("QLD");
		model.contact = new HomeLoanContact();
		model.contact.firstName = "Aleksandr";
		model.contact.lastName = "Orlov";
		model.setContactPhoneNumber("0402111111");
		model.setEmailAddress("preload.testing@comparethemarket.com.au");
		model.setAddressCity("Toowong");
		model.setAddressPostcode("4066");
		model.setAdditionalInformation("OUTBOUND LEAD");
		value.add(model);
		when(homeloanUnconfirmedLeadsDao.getUnconfirmedTransactionIds()).thenReturn(value);
		HttpServletRequest request = mock(HttpServletRequest.class);

		service.scheduledLeadGenerator(request);

		// verify service.submitOpportunity was called once
		verify(opportunityService, times(1)).submitOpportunity(request, model);

	}
}
