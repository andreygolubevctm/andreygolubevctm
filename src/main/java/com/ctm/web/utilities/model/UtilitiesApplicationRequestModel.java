package com.ctm.web.utilities.model;

import com.ctm.model.AbstractJsonModel;
import com.ctm.model.Address;
import com.ctm.utils.FormAddressUtils;
import com.ctm.utils.FormDateUtils;
import com.ctm.utils.NGram;
import org.json.JSONException;
import org.json.JSONObject;

import javax.servlet.http.HttpServletRequest;
import java.util.Date;


public class UtilitiesApplicationRequestModel extends AbstractJsonModel {

	public enum IdType {
		Passport, Medicare, DriversLicence;
	}

	public enum StateCode {
		VIC, NSW, SA, QLD, NT, WA, TAS, ACT;
	}

	// Mandatory

	private String title;
	private String firstName;
	private String lastName;
	private Date dateOfBirth;

	private String primaryPhone;
	private String email;

	private String uniqueCustomerId;
	private boolean isConnection;
	private int productId;

	private Date moveInDate;

	private String supplyUnitNumber;
	private String supplyStreetNumber;
	private String supplyStreetName;
	private String supplyStreetType;
	private String supplySuburb;
	private String supplyState;
	private String supplyPostcode;


	// Optional

	private String secondaryPhone;

	private IdType idType;
	private String idNumber;
	private String idExpiry;

	private Boolean billingSame;

	private String billingUnitNumber;
	private String billingStreetNumber;
	private String billingStreetName;
	private String billingStreetType;
	private String billingSuburb;
	private String billingState;
	private String billingPostcode;


	public String getTitle() {
		return this.title;
	}

	public void setTitle(String title) {
		this.title = title;
	}

	public String getFirstName() {
		return this.firstName;
	}

	public void setFirstName(String firstName) {
		this.firstName = firstName;
	}

	public String getLastName() {
		return this.lastName;
	}

	public void setLastName(String lastName) {
		this.lastName = lastName;
	}

	public Date getDateOfBirth() {
		return this.dateOfBirth;
	}

	public void setDateOfBirth(Date dateOfBirth) {
		this.dateOfBirth = dateOfBirth;
	}

	public IdType getIdType() {
		return this.idType;
	}

	public void setIdType(IdType idType) {
		this.idType = idType;
	}

	public String getIdNumber() {
		return this.idNumber;
	}

	public void setIdNumber(String idNumber) {
		this.idNumber = idNumber;
	}

	public String getIdExpiry() {
		return this.idExpiry;
	}
	public void setIdExpiry(String idExpiry) {
		this.idExpiry = idExpiry;
	}

	public String getPrimaryPhone() {
		return this.primaryPhone;
	}

	public void setPrimaryPhone(String primaryPhone) {
		this.primaryPhone = primaryPhone;
	}

	public Integer getPrimaryPhoneRating() {
		NGram ngram = new NGram(primaryPhone,3);
			
		return ngram.score();
	}

	public String getSecondaryPhone() {
		return this.secondaryPhone;
	}

	public void setSecondaryPhone(String secondaryPhone) {
		this.secondaryPhone = secondaryPhone;
	}

	public Integer getSecondaryPhoneRating() {
		NGram ngram = new NGram(secondaryPhone,3);
			
		return ngram.score();
	}

	public String getEmail() {
		return this.email;
	}

	public void setEmail(String email) {
		this.email = email;
	}

	public Date getMoveInDate() {
		return this.moveInDate;
	}

	public void setMoveInDate(Date moveInDate) {
		this.moveInDate = moveInDate;
	}

	public String getSupplyUnitNumber() {
		return this.supplyUnitNumber;
	}

	public void setSupplyUnitNumber(String supplyUnitNumber) {
		this.supplyUnitNumber = supplyUnitNumber;
	}

	public String getSupplyStreetNumber() {
		return this.supplyStreetNumber;
	}

	public void setSupplyStreetNumber(String supplyStreetNumber) {
		this.supplyStreetNumber = supplyStreetNumber;
	}

	public String getSupplyStreetName() {
		return this.supplyStreetName;
	}

	public void setSupplyStreetName(String supplyStreetName) {
		this.supplyStreetName = supplyStreetName;
	}

	public String getSupplyStreetType() {
		return this.supplyStreetType;
	}

	public void setSupplyStreetType(String supplyStreetType) {
		this.supplyStreetType = supplyStreetType;
	}

	public String getSupplySuburb() {
		return this.supplySuburb;
	}

	public void setSupplySuburb(String supplySuburb) {
		this.supplySuburb = supplySuburb;
	}

	public String getSupplyState() {
		return this.supplyState;
	}

	public void setSupplyState(String supplyState) {
		this.supplyState = supplyState;
	}

	public String getSupplyPostcode() {
		return this.supplyPostcode;
	}

	public void setSupplyPostcode(String supplyPostcode) {
		this.supplyPostcode = supplyPostcode;
	}

	public Boolean isbillingSame() {
		return billingSame;
	}

	public void setBillingSame(Boolean billingSame) {
		this.billingSame = billingSame;
	}

	public String getBillingUnitNumber() {
		return this.billingUnitNumber;
	}

	public void setBillingUnitNumber(String billingUnitNumber) {
		this.billingUnitNumber = billingUnitNumber;
	}

	public String getBillingStreetNumber() {
		return this.billingStreetNumber;
	}

	public void setBillingStreetNumber(String billingStreetNumber) {
		this.billingStreetNumber = billingStreetNumber;
	}

	public String getBillingStreetName() {
		return this.billingStreetName;
	}

	public void setBillingStreetName(String billingStreetName) {
		this.billingStreetName = billingStreetName;
	}

	public String getBillingStreetType() {
		return this.billingStreetType;
	}

	public void setBillingStreetType(String billingStreetType) {
		this.billingStreetType = billingStreetType;
	}

	public String getBillingSuburb() {
		return this.billingSuburb;
	}

	public void setBillingSuburb(String billingSuburb) {
		this.billingSuburb = billingSuburb;
	}

	public String getBillingState() {
		return this.billingState;
	}

	public void setBillingState(String billingState) {
		this.billingState = billingState;
	}

	public String getBillingPostcode() {
		return this.billingPostcode;
	}

	public void setBillingPostcode(String billingPostcode) {
		this.billingPostcode = billingPostcode;
	}

	public String getUniqueCustomerId() {
		return uniqueCustomerId;
	}

	public void setUniqueCustomerId(String uniqueCustomerId) {
		this.uniqueCustomerId = uniqueCustomerId;
	}

	public boolean isConnection() {
		return isConnection;
	}

	public void setConnection(boolean isConnection) {
		this.isConnection = isConnection;
	}

	public int getProductId() {
		return productId;
	}

	public void setProductId(int productId) {
		this.productId = productId;
	}

	public Boolean getBillingSame() {
		return billingSame;
	}

	public void populateFromRequest(HttpServletRequest request){

		setTitle(request.getParameter("utilities_application_details_title"));
		setFirstName(request.getParameter("utilities_application_details_firstName"));
		setLastName(request.getParameter("utilities_application_details_lastName"));
		//
		Date date = FormDateUtils.parseDateFromForm(request.getParameter("utilities_application_details_dob"));
		setDateOfBirth(date);

		String mobile = request.getParameter("utilities_application_details_mobileNumberinput");
		String otherPhone = request.getParameter("utilities_application_details_otherPhoneNumberinput");

		if(mobile != null && mobile.equals("") == false){
			setPrimaryPhone(mobile);
			setSecondaryPhone(otherPhone);
		}else{
			setPrimaryPhone(otherPhone);
		}

		setEmail(request.getParameter("utilities_application_details_email"));


		Address address = FormAddressUtils.parseAddressFromForm(request, "utilities_application_details_address");

		setSupplyPostcode(address.getPostCode());
		setSupplySuburb(address.getSuburb());
		setSupplyState(address.getState());

		setSupplyStreetNumber(address.getHouseNo());
		String streetName = address.getStreet();
		if(streetName == null) streetName = "";
		String[] streetComponents = streetName.split(" ");
		if(streetComponents.length > 1){
			String newStreetName = streetComponents[0];
			for(int i = 1; i < streetComponents.length-1; i++){
				newStreetName +=  " " + streetComponents[i];
			}
			setSupplyStreetName(newStreetName);
			setSupplyStreetType(streetComponents[streetComponents.length-1]);
		}else{
			setSupplyStreetName(address.getStreet());
		}

		setSupplyUnitNumber(address.getUnitNo());

		String billingSame = request.getParameter("utilities_application_details_postalMatch");
		if(billingSame == null || billingSame.equals("Y") == false){
			setBillingSame(false);
		}else{
			setBillingSame(true);
		}


		if(isbillingSame()==false){
			Address billingAddress = FormAddressUtils.parseAddressFromForm(request, "utilities_application_details_postal");

			setBillingPostcode(billingAddress.getPostCode());
			setBillingSuburb(billingAddress.getSuburb());
			setBillingState(billingAddress.getState());

			setBillingStreetNumber(billingAddress.getHouseNo());
			String billingStreetName = billingAddress.getStreet();
			if(billingStreetName == null) billingStreetName = "";
			String[] billingStreetComponents = billingStreetName.split(" ");
			if(billingStreetComponents.length > 1){
				String newBillingStreetName = billingStreetComponents[0];
				for(int i = 1; i < billingStreetComponents.length-1; i++){
					newBillingStreetName +=  " " + billingStreetComponents[i];
				}
				setBillingStreetName(newBillingStreetName);
				setBillingStreetType(billingStreetComponents[billingStreetComponents.length-1]);
			}else{
				setBillingStreetName(billingAddress.getStreet());
			}

			setBillingUnitNumber(billingAddress.getUnitNo());

		}

		if(request.getParameter("utilities_application_details_movingDate")!= null){
			setMoveInDate(FormDateUtils.parseDateFromForm(request.getParameter("utilities_application_details_movingDate")));
		}

		setUniqueCustomerId(request.getParameter("utilities_partner_uniqueCustomerId"));
		setProductId(Integer.parseInt(request.getParameter("utilities_application_thingsToKnow_hidden_productId")));

	}


	@Override
	protected JSONObject getJsonObject() throws JSONException {
		JSONObject json = new JSONObject();

		json.put("title", getTitle());
		json.put("first_name", getFirstName());
		json.put("last_name", getLastName());
		json.put("dob", FormDateUtils.convertDateToString(getDateOfBirth(), "yyyy-MM-dd"));
		json.put("phone1", getPrimaryPhone());
		json.put("phone1_rating", getPrimaryPhoneRating());

		json.put("unique_customer_id", getUniqueCustomerId());
		json.put("product_id", getProductId());
		json.put("is_connection", isConnection());

		if(getSecondaryPhone() != null){
			json.put("phone2", getSecondaryPhone());
			json.put("phone2_rating", getSecondaryPhoneRating());
		}

		json.put("email", getEmail());
		if(getMoveInDate() != null){
			json.put("moveindate", FormDateUtils.convertDateToString(getMoveInDate(), "yyyy-MM-dd"));
		}

		json.put("sup_unit_number", getSupplyUnitNumber());
		json.put("sup_street_number", getSupplyStreetNumber());
		json.put("sup_street_name", getSupplyStreetName());
		json.put("sup_street_type", getSupplyStreetType());
		json.put("sup_suburb", getSupplySuburb());
		json.put("sup_state", getSupplyState());
		json.put("postcode", getSupplyPostcode());

		json.put("is_billing_same", isbillingSame());

		if(isbillingSame() == false){
			json.put("is_billing_same", "N");
			json.put("bill_unit_number", getBillingUnitNumber());
			json.put("bill_street_number", getBillingStreetNumber());
			json.put("bill_street_name", getBillingStreetName());
			json.put("bill_street_type", getBillingStreetType());
			json.put("bill_suburb", getBillingSuburb());
			json.put("bill_state", getBillingState());
			json.put("bill_postcode", getBillingPostcode());
		}else{
			json.put("is_billing_same", "Y");
		}

		if(getIdType() != null){
			json.put("id_type", getIdType());
			json.put("id_number", getIdNumber());
			json.put("id_expiry", getIdExpiry());
		}

		return json;
	}
}
