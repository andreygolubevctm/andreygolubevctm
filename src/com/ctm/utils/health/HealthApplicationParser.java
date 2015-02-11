package com.ctm.utils.health;

import java.util.List;

import com.ctm.model.health.Frequency;
import com.ctm.model.health.PaymentType;
import com.ctm.model.request.Person;
import com.ctm.model.request.health.Address;
import com.ctm.model.request.health.Application;
import com.ctm.model.request.health.Bank;
import com.ctm.model.request.health.Credit;
import com.ctm.model.request.health.Dependants;
import com.ctm.model.request.health.Dependant;
import com.ctm.model.request.health.Details;
import com.ctm.model.request.health.HealthApplicationRequest;
import com.ctm.model.request.health.Medicare;
import com.ctm.model.request.health.Payment;
import com.ctm.utils.FormDateUtils;
import com.disc_au.web.go.Data;

public class HealthApplicationParser {
	
	public static final String PREFIX = "health/";
	
	public static HealthApplicationRequest parseRequest(Data data) {
		HealthApplicationRequest request = new HealthApplicationRequest();
		request.rebateValue = data.getDouble(PREFIX + "rebate"); 
		request.loadingValue = data.getDouble(PREFIX + "loading"); 
		request.loading = data.getString(PREFIX + "loading");
		request.membership =  data.getString(PREFIX + "situation/healthCvr");
		request.rebate  = data.getDouble(PREFIX + "rebate");
		request.hasRebate = parseBoolean(PREFIX + "healthCover/rebate" ,data);
		Integer income = data.getInteger(PREFIX + "healthCover/income");
		if(income != null){
			request.income = income;
		}
		request.application = parseApplication(data, request);
		request.payment = parsePayment(data, request);
		return request;
	}

	private static boolean parseBoolean(String xpath , Data data) {
		String value = data.getString(xpath);
		return value != null && value.equals("Y");
	}

	private static Payment parsePayment(final Data data, HealthApplicationRequest request) {
		Payment payment = new Payment();
		String prefix = PREFIX + "payment/";
		payment.details = parseDetails(data, prefix);
		
		String bankPrefix = prefix + "bank/";
		parseBank(data, bankPrefix, payment.bank);
		payment.credit = parseCredit(data, prefix + "credit/");
		if(!request.application.provider.equals("HIF")) {
			parseBank(data, bankPrefix + "claim/", payment.claim);
		}
		payment.gatewayNumber = data.getString(prefix + "gateway/number");
		payment.gatewayName = data.getString(prefix + "gateway/name");
		payment.creditName = data.getString(prefix + "credit/name");
		
		payment.medicare = parseMedicare(data, prefix);
		return payment;
	}

	private static Details parseDetails(final Data data, String basePrefix) {
		Details details = new Details();
		String prefix = basePrefix + "details/";
		String frequencyCode = data.getString(prefix + "frequency");
		
		details.frequency = Frequency.findByDescription(frequencyCode);
		details.paymentType = PaymentType.findByCode(data.getString(prefix + "type"));
		String start = data.getString(prefix + "start");
		if(start != null){
			details.start = FormDateUtils.parseDateFromForm(start);
		}
		return details;
	}

	private static Medicare parseMedicare(Data data, String prefix) {
		prefix = prefix + "medicare/";
		Medicare medicare =  new Medicare();
		medicare.number = data.getString(prefix + "number");
		medicare.middleInitial = data.getString(prefix + "middleInitial");
		medicare.firstName = data.getString(prefix + "firstName");
		medicare.surname = data.getString(prefix + "surname");
		medicare.cover = data.getString(prefix + "cover");
		medicare.cardExpiryMonth = data.getString(prefix + "cardExpiryMonth");
		medicare.cardExpiryYear = data.getString(prefix + "cardExpiryYear");
		return medicare;
	}

	private static Application parseApplication(final Data data, HealthApplicationRequest request) {
		String prefix = PREFIX + "application/";
		Application application = new Application();
		application.income = data.getInteger(prefix + "dependants/income");
		application.provider =  data.getString(prefix + "provider");
		application.selectedProductId = data.getString(prefix + "productId").replace("PHIO-HEALTH-", "");
		application.currentCustomer = data.getString(prefix + "currentCustomer");
		parsePerson(data, prefix + "primary/", application.primary);
		parsePerson(data, prefix + "partner/", application.partner);
		if(request.membership.equals("SPF") || request.membership.equals("F")) {
			application.dependants = parseDependents(data, prefix);
		}
		application.postalMatch = parseBoolean(PREFIX + "application/postalMatch" , data);
		parseAddress(data, prefix + "address", application.address);
		
		if(!application.postalMatch){
			parseAddress(data, prefix + "postal", application.postal);
		}
		return application;
	}

	private static Dependants parseDependents(final Data data, String prefix) {
		Dependants dependants = new Dependants();
		prefix = prefix + "dependants/";
		Integer income = data.getInteger(prefix + "income");
		if(income != null){
			dependants.income = income;
		}
		for(int i = 1; i <= 12; i++) {
			String dependentPrefix = prefix + "dependant" + i + "/";
			Object dependentObject = data.get(dependentPrefix);
			if(dependentObject != null && dependentObject instanceof List){
				dependants.dependants.add(parseDependent(data, dependentPrefix));
			}
		}
		return dependants;
	}

	private static void parseAddress(final Data data, String prefix, Address address) {
		address.type = data.getString(prefix + "type");
		address.houseNoSel = data.getString(prefix + "houseNoSel");
		address.suburbName = data.getString(prefix + "suburbName");
		address.streetName = data.getString(prefix + "streetName");
		address.unitSel = data.getString(prefix + "unitSel");
		address.streetNum = data.getString(prefix + "streetNum");
		address.unitShop = data.getString(prefix + "unitShop");
		address.suburb = data.getString(prefix + "suburb");
	}

	private static void parseBank(final Data data, String prefix, Bank bank) {
		bank.number = data.getString(prefix + "number");
		bank.account = data.getString(prefix + "account");
		bank.name = data.getString(prefix + "name");
	}
	
	private static Credit parseCredit(final Data data, String prefix) {
		Credit credit = new Credit();
		credit.number = data.getString(prefix + "number");
		credit.name = data.getString(prefix + "name");
		return credit;
	}

	private static void parsePerson(final Data data, String primaryPrefix, Person person) {
		person.firstname = data.getString(primaryPrefix + "firstname");
		person.surname = data.getString(primaryPrefix + "surname");
	}
	
	private static Dependant parseDependent(final Data data, String primaryPrefix) {
		Dependant person = new Dependant();
		person.firstname = data.getString(primaryPrefix + "firstname");
		person.lastname = data.getString(primaryPrefix + "lastname");
		return person;
	}

}
