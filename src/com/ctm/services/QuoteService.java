package com.ctm.services;

import javax.servlet.http.HttpServletRequest;

import org.apache.log4j.Logger;
import org.json.JSONException;
import org.json.JSONObject;

import com.ctm.dao.TransactionDetailsDao;
import com.disc_au.web.go.Data;
import com.disc_au.web.go.xml.HttpRequestHandler;
/**
 * A service to write quote data from the journey.
 * @author bthompson
 *
 */
public class QuoteService {

	private static Logger logger = Logger.getLogger(QuoteService.class.getName());
	/**
	 * Constructor
	 */
	public QuoteService() {
	}
	/**
	 * Write the lite version of the quote. This is only fields that have been changed since the last save.
	 * @param request HttpServletRequest
	 * @param transactionId long
	 * @param data Data
	 * @return
	 */
	public JSONObject writeLite(HttpServletRequest request, long transactionId , Data data) {

		// Update the data bucket.
		if(data != null) {
			HttpRequestHandler.updateXmlNode(data, request, true, false);
		}

		TransactionDetailsDao transactionDetailsDao = new TransactionDetailsDao();
		Boolean isSuccessful = transactionDetailsDao.insertOrUpdate(request, transactionId);

		JSONObject json = new JSONObject();
		try {
			JSONObject result = new JSONObject();
			json.put("result" , result);
			result.put("success", isSuccessful);
			result.put("transactionId", transactionId);
		} catch (JSONException e) {
			logger.error(e);
		}
		return json;
	}
	/**
	 * TODO: For another ticket - this will handle all the normal write quote stuff.
	 * @param request
	 * @param transactionId
	 * @param dataBucket
	 * @return
	 */
	public JSONObject write(HttpServletRequest request, Long transactionId,
			Data dataBucket) {
		// TODO: For another ticket - this will handle all the normal write quote stuff.
		return null;
	}

}
