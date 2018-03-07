package com.ctm.web.core.constants;

/**
 * Collection of personally identifiable information constants
 */

public final class PrivacyBlacklist {

	/**
	 * These fields should NEVER be stored in any logs or transaction details.
	 * It is a PCI Compliance issue to store certain credit card fields.
	 * It is a OWASP Security issue to store passwords in plain text.
	 */
	public static final String[] COMPLIANCE_BLACKLIST  = new String[]{
			"credit/ccv",
			"maskedNumber", // payment_ipp
			"credit/number",
			//"bank/number",
			//"claim/number",
			"password",
			"save/confirm",
			// necessary for write quote lite, but don't want to save.
			"hasPrivacyOptin"
	};

	/**
	 * These fields should must be encrypted when stored in any logs or transaction details.
	 */
	public static final String[] MANDATORY_ENCRYPTION_BLACKLIST  = new String[]{
			"medicare/number",
			"bank/number",
			"claim/number",
			"gateway/number",
			"gateway/nab/cardNumber",
			"credit/ipp/tokenisation"
	};

	/**
	 * Fields in the journey that contain personally identifiable information.
	 * This should be updated as part of journey development.
	 */
	public static final String[] PERSONALLY_IDENTIFIABLE_INFORMATION_BLACKLIST = new String[]{
			/**
			 * Retrieve quote passwords.
			 */
			"save/password",
			"save/confirm",
			/**
			 * Callback details
			 */
			"CrClientName",
			"CrClientTel",
			/**
			 * Names, Addresses, phone numbers, emails, dob
			 */
			"firstName",
			"firstname",
			"contactDetails/name",
			"middleName",
			// Simples users will not be able to search for names.
			//"lastname",
			//"surname",
			"email",
			"phone",
			"mobile",
			"contactNumber",
			"/other", // other phone number
			"/dob",
			"nonStdStreet",
			"streetName",
			"streetNum",
			"houseNoSel",
			"unitShop",
			"unitSel",
			"dpId",
			"streetId",
			"fullAddress",
			"streetSearch",
			"autofilllessSearch", // Elastic search input
			"lastSearch",
			/**
			 * Bank details
			 */
			"/account",
			"/bsb",
			"/number",
			/**
			 * School
			 */
			"/school",
			"/number",
			/**
			 * Fund membership Id
			 */
			"/memberID"
	};


	// PRIVATE //

	/**
	 * The caller references the constants using <tt>Consts.EMPTY_STRING</tt>,
	 * and so on. Thus, the caller should be prevented from constructing objects
	 * of this class, by declaring this private constructor.
	 */
	private PrivacyBlacklist() {
		// this prevents even the native class from
		// calling this constructor as well :
		throw new AssertionError();
	}
}