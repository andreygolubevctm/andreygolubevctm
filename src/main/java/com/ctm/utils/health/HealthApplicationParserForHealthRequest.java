package com.ctm.utils.health;

import com.ctm.model.health.Frequency;
import com.ctm.model.health.PaymentType;
import com.ctm.model.health.form.*;
import com.ctm.model.request.Person;
import com.ctm.model.request.health.Address;
import com.ctm.model.request.health.Application;
import com.ctm.model.request.health.Bank;
import com.ctm.model.request.health.Credit;
import com.ctm.model.request.health.Dependant;
import com.ctm.model.request.health.Dependants;
import com.ctm.model.request.health.*;
import com.ctm.model.request.health.Medicare;
import com.ctm.model.request.health.Payment;
import com.ctm.utils.FormDateUtils;

import java.util.List;
import java.util.Optional;

public class HealthApplicationParserForHealthRequest {

	public static HealthApplicationRequest parseRequest(com.ctm.model.health.form.HealthRequest healthRequest) {
		HealthApplicationRequest request = new HealthApplicationRequest();
		final Optional<HealthQuote> quote = Optional.ofNullable(healthRequest.getQuote());
		quote.map(HealthQuote::getRebate)
				.ifPresent(v -> request.rebateValue = v);
		quote.map(HealthQuote::getLoading)
				.ifPresent(v -> {
					request.loadingValue = v.doubleValue();
					request.loading = v.toString();
				});
		quote.map(HealthQuote::getSituation)
				.map(Situation::getHealthCvr)
				.ifPresent(v -> request.membership = v);

		// logic to load the correct rebate when select future product that after the rate rise
		// TODO: rebateChangeOver

		quote.map(HealthQuote::getHealthCover)
				.map(HealthCover::getRebate)
				.ifPresent(v -> request.hasRebate = "Y".equals(v));
		quote.map(HealthQuote::getHealthCover)
				.map(HealthCover::getIncome)
				.ifPresent(v -> request.income = v);

		request.application = parseApplication(quote.map(HealthQuote::getApplication), request);
		request.payment = parsePayment(quote.map(HealthQuote::getPayment), request);
		return request;
	}

	private static Payment parsePayment(final Optional<com.ctm.model.health.form.Payment> formPayment, HealthApplicationRequest request) {
		Payment payment = new Payment();
		payment.details = parseDetails(formPayment.map(com.ctm.model.health.form.Payment::getDetails));

		parseBank(formPayment.map(com.ctm.model.health.form.Payment::getBank), payment.bank);
		payment.credit = parseCredit(formPayment.map(com.ctm.model.health.form.Payment::getCredit));
		if(!request.application.provider.equals("HIF")) {
			parseBank(formPayment.map(com.ctm.model.health.form.Payment::getBank)
					.map(com.ctm.model.health.form.Bank::getClaim), payment.claim);
		}
		formPayment.map(com.ctm.model.health.form.Payment::getGateway)
				.map(Gateway::getNumber)
				.ifPresent(v -> payment.gatewayNumber = v);
		formPayment.map(com.ctm.model.health.form.Payment::getGateway)
				.map(Gateway::getName)
				.ifPresent(v -> payment.gatewayName = v);
		formPayment.map(com.ctm.model.health.form.Payment::getCredit)
				.map(com.ctm.model.health.form.Credit::getName)
				.ifPresent(v -> payment.creditName = v.replaceAll("[^\\dA-Za-z ]", ""));

		payment.medicare = parseMedicare(formPayment.map(com.ctm.model.health.form.Payment::getMedicare));
		return payment;
	}

	private static Details parseDetails(final Optional<PaymentDetails> formDetails) {
		Details details = new Details();
		formDetails.map(PaymentDetails::getFrequency)
				.ifPresent(v -> details.frequency = Frequency.findByDescription(v));
		formDetails.map(PaymentDetails::getType)
				.ifPresent(v -> details.paymentType = PaymentType.findByCode(v));
		formDetails.map(PaymentDetails::getStart)
				.ifPresent(v -> details.start = FormDateUtils.parseDateFromForm(v));
		return details;
	}

	private static Medicare parseMedicare(Optional<com.ctm.model.health.form.Medicare> formMedicare) {
		Medicare medicare =  new Medicare();
		formMedicare.map(com.ctm.model.health.form.Medicare::getNumber)
				.ifPresent(v -> medicare.number = v);
		formMedicare.map(com.ctm.model.health.form.Medicare::getMiddleInitial)
				.ifPresent(v -> medicare.middleInitial = v);
		formMedicare.map(com.ctm.model.health.form.Medicare::getFirstName)
				.ifPresent(v -> medicare.firstName = v);
		formMedicare.map(com.ctm.model.health.form.Medicare::getSurname)
				.ifPresent(v -> medicare.surname = v);
		formMedicare.map(com.ctm.model.health.form.Medicare::getCover)
				.ifPresent(v -> medicare.cover = v);
		formMedicare.map(com.ctm.model.health.form.Medicare::getExpiry)
				.map(Expiry::getCardExpiryYear)
				.ifPresent(v -> medicare.cardExpiryYear = v);
		formMedicare.map(com.ctm.model.health.form.Medicare::getExpiry)
				.map(Expiry::getCardExpiryMonth)
				.ifPresent(v -> medicare.cardExpiryMonth = v);
		return medicare;
	}

	private static Application parseApplication(Optional<com.ctm.model.health.form.Application> formApplication, HealthApplicationRequest request) {
		Application application = new Application();

		formApplication.map(com.ctm.model.health.form.Application::getDependants)
				.map(com.ctm.model.health.form.Dependants::getIncome)
				.ifPresent(v -> application.income = v);
		formApplication.map(com.ctm.model.health.form.Application::getProvider)
				.ifPresent(v -> application.provider = v);
		formApplication.map(com.ctm.model.health.form.Application::getProductId)
				.ifPresent(v -> application.selectedProductId = v.replace("PHIO-HEALTH-", ""));

		parsePerson(formApplication.map(com.ctm.model.health.form.Application::getPrimary), application.primary);
		parsePerson(formApplication.map(com.ctm.model.health.form.Application::getPartner), application.partner);

		if(request.membership.equals("SPF") || request.membership.equals("F")) {
			application.dependants = parseDependents(formApplication.map(com.ctm.model.health.form.Application::getDependants));
		}

		formApplication.map(com.ctm.model.health.form.Application::getPostalMatch)
				.ifPresent(v -> application.postalMatch = "Y".equals(v));
		parseAddress(formApplication.map(com.ctm.model.health.form.Application::getAddress), application.address);

		if(!application.postalMatch){
			parseAddress(formApplication.map(com.ctm.model.health.form.Application::getPostal), application.postal);
		}
		return application;
	}

	private static Dependants parseDependents(final Optional<com.ctm.model.health.form.Dependants> formDependants) {
		Dependants dependants = new Dependants();

		addDependant(formDependants.map(com.ctm.model.health.form.Dependants::getDependant1), dependants.dependants);
		addDependant(formDependants.map(com.ctm.model.health.form.Dependants::getDependant2), dependants.dependants);
		addDependant(formDependants.map(com.ctm.model.health.form.Dependants::getDependant3), dependants.dependants);
		addDependant(formDependants.map(com.ctm.model.health.form.Dependants::getDependant4), dependants.dependants);
		addDependant(formDependants.map(com.ctm.model.health.form.Dependants::getDependant5), dependants.dependants);
		addDependant(formDependants.map(com.ctm.model.health.form.Dependants::getDependant6), dependants.dependants);
		addDependant(formDependants.map(com.ctm.model.health.form.Dependants::getDependant7), dependants.dependants);
		addDependant(formDependants.map(com.ctm.model.health.form.Dependants::getDependant8), dependants.dependants);
		addDependant(formDependants.map(com.ctm.model.health.form.Dependants::getDependant9), dependants.dependants);
		addDependant(formDependants.map(com.ctm.model.health.form.Dependants::getDependant10), dependants.dependants);
		addDependant(formDependants.map(com.ctm.model.health.form.Dependants::getDependant11), dependants.dependants);
		addDependant(formDependants.map(com.ctm.model.health.form.Dependants::getDependant12), dependants.dependants);
		formDependants.map(com.ctm.model.health.form.Dependants::getIncome)
				.ifPresent(v -> dependants.income = v);
		return dependants;
	}

	private static void addDependant(Optional<com.ctm.model.health.form.Dependant> formDependant, List<Dependant> dependants) {
		if (formDependant.isPresent()) {
			dependants.add(parseDependent(formDependant));
		}
	}

	private static void parseAddress(final Optional<com.ctm.model.health.form.Address> formAddress, Address address) {
		formAddress.map(com.ctm.model.health.form.Address::getType)
				.ifPresent(v -> address.type = v);
		formAddress.map(com.ctm.model.health.form.Address::getHouseNoSel)
				.ifPresent(v -> address.houseNoSel = v);
		formAddress.map(com.ctm.model.health.form.Address::getSuburbName)
				.ifPresent(v -> address.suburbName = v);
		formAddress.map(com.ctm.model.health.form.Address::getStreetName)
				.ifPresent(v -> address.streetName = v);
		formAddress.map(com.ctm.model.health.form.Address::getUnitSel)
				.ifPresent(v -> address.unitSel = v);
		formAddress.map(com.ctm.model.health.form.Address::getStreetNum)
				.ifPresent(v -> address.streetNum = v);
		formAddress.map(com.ctm.model.health.form.Address::getUnitShop)
				.ifPresent(v -> address.unitShop = v);
		formAddress.map(com.ctm.model.health.form.Address::getSuburb)
				.ifPresent(v -> address.suburb = v);
	}

	private static void parseBank(final Optional<com.ctm.model.health.form.BankDetails> formBank, Bank bank) {
		formBank.map(BankDetails::getNumber)
				.ifPresent(v -> bank.number = v);
		formBank.map(BankDetails::getAccount)
				.ifPresent(v -> bank.account = v);
		formBank.map(BankDetails::getName)
				.ifPresent(v -> bank.name = v);
	}

	private static Credit parseCredit(final Optional<com.ctm.model.health.form.Credit> formCredit) {
		Credit credit = new Credit();
		formCredit.map(com.ctm.model.health.form.Credit::getNumber)
				.ifPresent(v -> credit.number = v);
		formCredit.map(com.ctm.model.health.form.Credit::getName)
				.ifPresent(v -> credit.name = v);
		return credit;
	}

	private static void parsePerson(final Optional<com.ctm.model.health.form.Person> formPerson, Person person) {
		formPerson.map(com.ctm.model.health.form.Person::getFirstname)
				.ifPresent(v -> person.firstname = v);
		formPerson.map(com.ctm.model.health.form.Person::getSurname)
				.ifPresent(v -> person.surname = v);
	}

	private static Dependant parseDependent(final Optional<com.ctm.model.health.form.Dependant> formDependant) {
		Dependant person = new Dependant();
		formDependant.map(com.ctm.model.health.form.Dependant::getFirstname)
				.ifPresent(v -> person.firstname = v);
		formDependant.map(com.ctm.model.health.form.Dependant::getLastname)
				.ifPresent(v -> person.lastname = v);
		return person;
	}

}
