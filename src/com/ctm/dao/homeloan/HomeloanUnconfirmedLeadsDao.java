package com.ctm.dao.homeloan;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import javax.naming.NamingException;

import com.ctm.connectivity.SimpleDatabaseConnection;
import com.ctm.exceptions.DaoException;
import com.ctm.model.Touch;
import com.ctm.model.homeloan.HomeLoanContact;
import com.ctm.model.homeloan.HomeLoanModel;
import com.ctm.model.homeloan.HomeLoanModel.CustomerGoal;
import com.ctm.model.homeloan.HomeLoanModel.CustomerSituation;

public class HomeloanUnconfirmedLeadsDao {

	public HomeloanUnconfirmedLeadsDao() {
	}
	/**
	 * Select all HOMELOAN, styleCodeId 1 transactionids that have a contactNumber that's not empty
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
					+ "   AND CONCAT(startDate, ' ', startTime) <= NOW() - INTERVAL 3 HOUR "
					+ "   AND startDate > CURDATE() - INTERVAL 7 DAY"
					+ "   AND th.transactionid IN("
					+ "   	SELECT transactionId "
					+ "   	FROM aggregator.transaction_details "
					+ "   	WHERE transactionId = th.transactionId "
					+ "   	AND xpath = 'homeloan/contact/contactNumber' "
					+ "   	AND textValue != '' "
					+ "   ) "
					+ "   AND th.transactionid NOT IN( "
					+ "   	SELECT transactionId "
					+ "   	FROM aggregator.transaction_details "
					+ "   	WHERE textValue IN('0400000000', '0400123456', 'preload.testing@comparethemarket.com.au','gomez.testing@aihco.com.au','0411111111') "
					+ "   ) "
					+ "   AND td.xpath IN('homeloan/details/state', 'homeloan/contact/firstName', 'homeloan/contact/lastName', "
					+ "		'homeloan/contact/contactNumber','homeloan/contact/email','homeloan/details/suburb', 'homeloan/details/postcode', "
					+"		'homeloan/details/situation', 'homeloan/details/goal', 'homeloan/loanDetails/loanAmount',"
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

				String textValue = results.getString("textValue");
				String xPath = results.getString("xpath");

				if(opportunity == null || opportunity.getTransactionId() != results.getLong("transactionId")) {
					opportunity = new HomeLoanModel();
					opportunity.setTransactionId(results.getLong("transactionId"));
					opportunity.setAdditionalInformation("OUTBOUND LEAD");
					opportunity.contact = new HomeLoanContact();
					homeloanOpportunities.add(opportunity);
				}


				if(xPath.equals("homeloan/contact/firstName")) {
					opportunity.contact.firstName = textValue;
				} else if(xPath.equals("homeloan/contact/lastName")) {
					opportunity.contact.lastName = textValue;
				} else if(xPath.equals("homeloan/contact/contactNumber")) {
					opportunity.setContactPhoneNumber(textValue);
				} else if(xPath.equals("homeloan/contact/email")) {
					opportunity.setEmailAddress(textValue);
				} else if(xPath.equals("homeloan/details/suburb")) {
					opportunity.setAddressCity(textValue);
				} else if(xPath.equals("homeloan/details/postcode")) {
					opportunity.setAddressPostcode(textValue);
				} else if(xPath.equals("homeloan/details/state")) {
					opportunity.setState(textValue);
				} else if(xPath.equals("homeloan/details/situation")) {
					if (textValue != null && textValue.length() > 0) {
						opportunity.setCustomerSituation(CustomerSituation.findByCode(textValue));
					}
				} else if(xPath.equals("homeloan/details/goal")) {
					if (textValue != null && textValue.length() > 0) {
						opportunity.setCustomerGoal(CustomerGoal.findByCode(textValue));
					}
				} else if(xPath.equals("homeloan/loanDetails/purchasePrice")) {
					if (textValue != null && textValue.length() > 0) {
						opportunity.setPurchasePrice(Math.abs(Integer.parseInt(textValue)));
					}
				} else if(xPath.equals("homeloan/loanDetails/loanAmount")) {
					if (textValue != null && textValue.length() > 0) {
						opportunity.setLoanAmount(Math.abs(Integer.parseInt(textValue)));
					}
				}
			}
		}
		catch (SQLException | NamingException e) {
			throw new DaoException(e.getMessage(), e);
		}
		finally {
			dbSource.closeConnection();
		}

		return homeloanOpportunities;
	}
}