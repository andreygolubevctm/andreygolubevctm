package com.ctm.web.homeloan.dao;

import com.ctm.web.core.connectivity.SimpleDatabaseConnection;
import com.ctm.web.core.exceptions.DaoException;
import com.ctm.web.core.model.Touch;
import com.ctm.web.homeloan.model.HomeLoanContact;
import com.ctm.web.homeloan.model.HomeLoanModel;
import com.ctm.web.homeloan.model.HomeLoanModel.CustomerGoal;
import com.ctm.web.homeloan.model.HomeLoanModel.CustomerSituation;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.naming.NamingException;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class HomeloanUnconfirmedLeadsDao {

	private static final Logger LOGGER = LoggerFactory.getLogger(HomeloanUnconfirmedLeadsDao.class);

	public HomeloanUnconfirmedLeadsDao() {
	}
	/**
	 * Select all HOMELOAN, styleCodeId 1 transactionids that have a contactNumber that's not empty
	 * from a deduped list of unique phone/email for homeloans from the last 30 days. The earliest instance
	 * of a contact is selected so a contact is not resent as a lead.
	 * Of them, only select transactionIds that don't have preload.testing or gomez.testing values.
	 * Of them, only select those whose rootId doesn't have a C/CF touch.
	 */
	public List<HomeLoanModel> getUnconfirmedTransactionIds() throws DaoException {
		SimpleDatabaseConnection dbSource = new SimpleDatabaseConnection();
		List<HomeLoanModel> homeloanOpportunities = new ArrayList<>();

		try {
			PreparedStatement stmt;

			stmt = dbSource.getConnection().prepareStatement(
					"SELECT th.transactionId, th.rootId, xpath, textValue"
					+ " FROM aggregator.transaction_header th "
					+ " LEFT JOIN aggregator.transaction_details td USING(transactionId)"
					+ " WHERE productType = 'HOMELOAN'"
					+ "   AND previousId = 0"
					+ "   AND styleCodeId = 1"
					+ "   AND CONCAT(startDate, ' ', startTime) <= NOW() - INTERVAL 1 HOUR "
					+ "   AND startDate > CURDATE() - INTERVAL 7 DAY"
					+ "   AND th.transactionid IN("
					+ "   	SELECT MIN(ith.transactionId) "
					+ "   	FROM aggregator.transaction_header ith "
					+ "         INNER JOIN aggregator.transaction_details itd USING(transactionId) "
					+ "         LEFT OUTER JOIN aggregator.transaction_details itde ON ith.transactionId = itde.transactionid "
					+ "             AND itde.xpath = 'homeloan/contact/email' "
					+ "   	WHERE itd.xpath = 'homeloan/contact/contactNumber' "
					+ "   	AND itd.textValue != '' "
					+ "     AND ith.startDate > CURDATE() - INTERVAL 30 DAY "
					+ "   	GROUP BY itd.textValue, itde.textValue "
					+ "   ) "
					+ "   AND th.transactionid NOT IN( "
					+ "   	SELECT transactionId "
					+ "   	FROM aggregator.transaction_details "
					+ "   	WHERE textValue IN('0400000000', '0400123456', 'preload.testing@comparethemarket.com.au','gomez.testing@aihco.com.au','0411111111') "
					+ "   ) "
					+ "   AND td.xpath IN('homeloan/details/state', 'homeloan/contact/firstName', 'homeloan/contact/lastName', "
					+ "		'homeloan/contact/contactNumber','homeloan/contact/email','homeloan/details/suburb', 'homeloan/details/postcode', "
					+ "		'homeloan/details/situation', 'homeloan/details/goal', 'homeloan/loanDetails/loanAmount',"
					+ "		'homeloan/loanDetails/purchasePrice') "
					+ "   AND th.rootId NOT IN ( "
					+ "  	SELECT transaction_id "
					+ "  	FROM ctm.touches "
					+ "  	WHERE transaction_id IN(th.transactionId, th.rootId) "
					+ "  	AND type IN('"+Touch.TouchType.SOLD.getCode()+"','"+Touch.TouchType.CALL_FEED.getCode()+"') "
					+ "   ) "
					+ "   ORDER BY th.transactionId DESC"
			);

			ResultSet results = stmt.executeQuery();

			HomeLoanModel opportunity = null;
			while (results.next()) {

				try {
					String textValue = results.getString("textValue");
					String xPath = results.getString("xpath");

					if(opportunity == null || opportunity.getTransactionId() != results.getLong("transactionId")) {
						opportunity = new HomeLoanModel();
						opportunity.setTransactionId(results.getLong("transactionId"));
						opportunity.setAdditionalInformation("OUTBOUND LEAD");
						opportunity.contact = new HomeLoanContact();
						homeloanOpportunities.add(opportunity);
					}

					switch (xPath) {
						case "homeloan/contact/firstName":
							opportunity.contact.firstName = textValue;
							break;
						case "homeloan/contact/lastName":
							opportunity.contact.lastName = textValue;
							break;
						case "homeloan/contact/contactNumber":
							opportunity.setContactPhoneNumber(textValue);
							break;
						case "homeloan/contact/email":
							opportunity.setEmailAddress(textValue);
							break;
						case "homeloan/details/suburb":
							opportunity.setAddressCity(textValue);
							break;
						case "homeloan/details/postcode":
							opportunity.setAddressPostcode(textValue);
							break;
						case "homeloan/details/state":
							opportunity.setState(textValue);
							break;
						case "homeloan/details/situation":
							if (textValue != null && textValue.length() > 0) {
								opportunity.setCustomerSituation(CustomerSituation.findByCode(textValue));
							}
							break;
						case "homeloan/details/goal":
							if (textValue != null && textValue.length() > 0) {
								opportunity.setCustomerGoal(CustomerGoal.findByCode(textValue));
							}
							break;
						case "homeloan/loanDetails/purchasePrice":
							if (textValue != null && textValue.length() > 0) {
								opportunity.setPurchasePrice((int) Double.parseDouble(textValue));
							}
							break;
						case "homeloan/loanDetails/loanAmount":
							if (textValue != null && textValue.length() > 0) {
								opportunity.setLoanAmount((int) Double.parseDouble(textValue));
							}
							break;
					}

				} catch(Exception e) {
					LOGGER.error("Failed retrieving homeloan unconfirmed leads ", e);
				}
			}
		}
		catch (SQLException | NamingException e) {
			throw new DaoException(e);
		}
		finally {
			dbSource.closeConnection();
		}

		return homeloanOpportunities;
	}
}