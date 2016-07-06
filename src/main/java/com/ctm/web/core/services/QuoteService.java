package com.ctm.web.core.services;

import com.ctm.web.core.transaction.dao.TransactionDetailsDao;
import com.ctm.web.core.web.go.Data;
import com.ctm.web.core.web.go.xml.HttpRequestHandler;
import org.json.JSONException;
import org.json.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.servlet.http.HttpServletRequest;

import static com.ctm.commonlogging.common.LoggingArguments.kv;

/**
 * A service to write quote data from the journey.
 * @author bthompson
 *
 */
public class QuoteService {

	private static final Logger LOGGER = LoggerFactory.getLogger(QuoteService.class);
	private final TransactionDetailsDao transactionDetailsDao;

	/**
	 * Constructor
	 */
	@Deprecated
	public QuoteService() {
		transactionDetailsDao = new TransactionDetailsDao();
	}

	public QuoteService(TransactionDetailsDao transactionDetailsDao) {
		this.transactionDetailsDao = transactionDetailsDao;
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
		Boolean isSuccessful = transactionDetailsDao.insertOrUpdate(request, transactionId);

		JSONObject json = new JSONObject();
		try {
			JSONObject result = new JSONObject();
			json.put("result" , result);
			result.put("success", isSuccessful);
			result.put("transactionId", transactionId);
		} catch (JSONException e) {
			LOGGER.error("Error creating lite quote result {},{}", kv("transactionId", transactionId),
				kv("success", isSuccessful), e);
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


	/**
	 * Write the single xpath and value to transaction details for a quote
	 * @param transactionId long
	 * @param xpath String
	 * @param textValue String
	 * @return
	 */
	public void writeSingle(long transactionId, String xpath, String textValue) {
		TransactionDetailsDao transactionDetailsDao = new TransactionDetailsDao();
		transactionDetailsDao.insertOrUpdate(xpath, textValue, transactionId);
	}

}
