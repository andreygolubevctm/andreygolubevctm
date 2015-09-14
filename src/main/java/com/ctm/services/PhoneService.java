package com.ctm.services;

import com.ctm.connectivity.JsonConnection;
import com.ctm.connectivity.SimpleConnection;
import com.ctm.dao.InboundPhoneNumberDao;
import com.ctm.exceptions.ConfigSettingException;
import com.ctm.exceptions.DaoException;
import com.ctm.exceptions.EnvironmentException;
import com.ctm.model.session.AuthenticatedData;
import com.ctm.model.settings.PageSettings;
import com.ctm.model.simples.CallInfo;
import com.ctm.model.simples.InboundPhoneNumber;
import com.disc_au.web.go.xml.XmlNode;
import com.disc_au.web.go.xml.XmlParser;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
import org.xml.sax.SAXException;

import java.util.IllegalFormatException;

import static com.ctm.logging.LoggingArguments.kv;
import static com.ctm.model.simples.CallInfo.STATE_INACTIVE;
import static java.lang.String.format;

public class PhoneService {
	private static final Logger LOGGER = LoggerFactory.getLogger(PhoneService.class);
	public static final String CTI_MAKE_CALL = "/dataservices/makeCall?accessToken=&extension=%s&numberToCall=%s";

	/**
	 * Uses the CTI service from Auto&General to get the extension for the specified agentId.
	 *
	 * NOTE: AgentIds must be registered in DISC for this to work.
	 *
	 * Sample response:
	 * Valid AgentId and has Extension: {"service":{"response":{"extensionType":"A","deviceExtension":9511,"accessToken":"","status":"OK"}}}
	 * or
	 * Valid AgentId but no Extension:	{"service":{"response":{"extensionType":"A","deviceExtension":9592,"accessToken":"","status":"OK","messages":""}}}
	 * or
	 * Passing parameter as Extension or anything invalid:	{"service":{"response":{"extensionType":"P","deviceExtension":1234,"accessToken":"","status":"OK"}}}
	 *
	 * @param settings
	 * @param agentId
	 * @return extension
	 */
	public static String getExtensionByAgentId(PageSettings settings, String agentId) throws EnvironmentException, ConfigSettingException {


		String serviceUrl = settings.getSetting("ctiUrl");

		JsonConnection jsonConn = new JsonConnection();
		JSONObject json = jsonConn.get(serviceUrl+"maintenance/cti/getAgentDetails.jsp?extension="+agentId);

		if (json == null) {
			return null;
		}

		LOGGER.debug("Determining extension for agentId {}", kv("agentId", agentId), kv("json", json.toString()));

		try {
			JSONObject service = json.getJSONObject("service");
			JSONObject response = service.getJSONObject("response");
			String extensionType = response.getString("extensionType");
			String extension = Integer.toString(response.getInt("deviceExtension"));

			/* The current CTI service from A&G has no way to tell if the returned value is a valid extension or not
			 * Alex says for now we can only rely on the returned extension has to be different than the agentId passed
			*/
			if (extensionType.equals("A") && !extension.equals(agentId)) {
				return extension;
			}
		}
		catch (JSONException e) {
			LOGGER.error("Error determining extension {},{},{}", kv("agentId", agentId), kv("json", json), kv("serviceUrl", serviceUrl), e);
		}

		return null;
	}

	/**
     * Function saves call information of supplied extension against supplied transaction ID into transaction_details table
     * @param settings
     * @param extension
     * @param transactionId
     * @param xpath
     * @return
     * @throws EnvironmentException
     * @throws ConfigSettingException
     */
    public static CallInfo saveCallInfoForTransaction(PageSettings settings, String extension, Long transactionId, String xpath) throws ConfigSettingException {
        CallInfo callInfo = getCallInfoByExtension(settings, extension);
        if(callInfo.getCallId()!=null && !callInfo.getCallId().equals("") && !callInfo.getCallId().equals("0")) {
            QuoteService quoteService = new QuoteService();
            quoteService.writeSingle(transactionId, xpath + "/callId", callInfo.getCallId());
            quoteService.writeSingle(transactionId, xpath + "/direction", callInfo.getDirection());
            quoteService.writeSingle(transactionId, xpath + "/customerPhoneNo", callInfo.getCustomerPhoneNo());
            if (!callInfo.getVdns().isEmpty() && callInfo.getVdns().get(0) != null && !callInfo.getVdns().get(0).equals("")) {
                quoteService.writeSingle(transactionId, xpath + "/VDN", callInfo.getVdns().get(0));
            }
        }

        return callInfo;
    }

    /**
	 * Uses the CTI service from Auto&General to get the top level VDN for the specified extension.
	 * Technically there can be multiple VDNs but we are interested in the top level VDN as that is where the call first hit our call centre.
	 *
	 * NOTE: VDNs must be registered in DISC for this to work.
	 *
	 * Because of the use of an xml to json function in the external service, the json structure may be inconsistent when there are one or more vdns.
	 *
	 * Sample response:
	 * {"service":{"response":{"information":{"vdnCount":1,"direction":"I","state":1,"callId":2104211397094514,"vdns":{"vdn":8886},"otherParty":{"telephoneNumber":405737645,"state":1}},"accessToken":"","status":"OK"}}}
	 * or
	 * {"service":{"response":{"information":{"vdnCount":2,"direction":"I","state":1,"callId":2104211397094514,"vdns":[{"vdn":8886},{"vdn":1234}],"otherParty":{"telephoneNumber":405737645,"state":1}},"accessToken":"","status":"OK"}}}
	 *
	 * @param settings
	 * @param extension
	 * @return
	 */
	public static CallInfo getCallInfoByExtension(PageSettings settings, String extension) throws EnvironmentException, ConfigSettingException {

		CallInfo callInfo = new CallInfo();

		String serviceUrl = settings.getSetting("ctiUrl");

		JsonConnection jsonConn = new JsonConnection();
		JSONObject json = jsonConn.get(serviceUrl+"maintenance/cti/getCallInfo.jsp?extension="+extension);

		// TEST MODE - because it will be unlikely to get a real response from a test box.
		/*
		try {
			json = new JSONObject("{\"service\":{\"response\":{\"information\":{\"vdnCount\":1,\"direction\":\"I\",\"state\":1,\"callId\":2104211397094514,\"vdns\":{\"vdn\":8886},\"otherParty\":{\"telephoneNumber\":405737645,\"state\":1}},\"accessToken\":\"\",\"status\":\"OK\"}}}");
			//json = new JSONObject("{\"service\":{\"response\":{\"information\":{\"vdnCount\":2,\"direction\":\"I\",\"state\":1,\"callId\":2104211397094514,\"vdns\":[{\"vdn\":8886},{\"vdn\":1234}],\"otherParty\":{\"telephoneNumber\":405737645,\"state\":1}},\"accessToken\":\"\",\"status\":\"OK\"}}}");
		} catch (JSONException e) {
			e.printStackTrace();
		}
		*/

		if (json == null) {
			return null;
		}

		LOGGER.debug("Getting call info {}", kv("extension", extension), kv("json", json));

		try {
			JSONObject service = json.getJSONObject("service");
			JSONObject response = service.getJSONObject("response");
			JSONObject information = response.getJSONObject("information");
			int count = information.getInt("vdnCount");
			if (count == 0) {
				// no VDNs
			}
			else if (count == 1) {
				JSONObject vdns = information.getJSONObject("vdns");
				callInfo.addVdn(vdns.getString("vdn"));
			}
			else {
				JSONArray vdns = information.getJSONArray("vdns");
				JSONObject originalVdn = (JSONObject) vdns.get(0);
				callInfo.addVdn(originalVdn.getString("vdn"));
			}

			String direction = information.getString("direction");
			if (direction.equals("I")) {
				callInfo.setDirection(CallInfo.DIRECTION_INBOUND);
			}
			else if (direction.equals("O")) {
				callInfo.setDirection(CallInfo.DIRECTION_OUTBOUND);
			}
			else if (direction.equals("N")) {
				callInfo.setDirection(CallInfo.DIRECTION_INTERNAL);
			}

			String state = information.getString("state");
			if (state.equals("1")) {
				callInfo.setState(CallInfo.STATE_ACTIVE);
			}
			else if (state.equals("4")) {
				callInfo.setState(CallInfo.STATE_RINGING);
			}
			else {
				callInfo.setState(STATE_INACTIVE);
			}
			callInfo.setCallId(information.getString("callId"));

			JSONObject otherParty = information.getJSONObject("otherParty");
			callInfo.setCustomerPhoneNo(otherParty.getString("telephoneNumber"));
		}
		catch (JSONException e) {
			LOGGER.error("Error getting call info {}", kv("extension", extension), e);
		}

		return callInfo;
	}

	public static String getVdnByExtension(PageSettings settings, String extension) throws EnvironmentException, ConfigSettingException {

		if (extension == null || extension.length() == 0) return null;

		CallInfo callInfo = getCallInfoByExtension(settings, extension);
		String vdn = null;

		if (callInfo != null) {
			// Get the first VDN in the list
			if (callInfo.getVdns().size() > 0) {
				vdn = callInfo.getVdns().get(0);
			}
		}

		return vdn;
	}

	/**
	 * Get the current details for the inbound call details for the logged in user.
	 *
	 * @param settings
	 * @param authData
	 * @return
	 * @throws ConfigSettingException
	 * @throws EnvironmentException
	 * @throws DaoException
	 * @throws Exception
	 */
	public static InboundPhoneNumber getCurrentInboundCallDetailsForAgent(PageSettings settings, AuthenticatedData authData) throws EnvironmentException, ConfigSettingException, DaoException {

		String agentId = authData.getAgentId();

		if(agentId != null){

			// Look for extension on session object, if not found, get it from special service, then save it to session for next time.
			String extension = authData.getExtension();
			if(extension == null){
				extension = PhoneService.getExtensionByAgentId(settings, agentId);
				if(extension != null){
					authData.setExtension(extension);
				} else {
					LOGGER.info("Unable to get extension {}", kv("agentId", agentId));
				}
			}

			if(extension != null){
				String vdn = PhoneService.getVdnByExtension(settings, extension);
				if(vdn != null){
					return getInboundPhoneDetailsByVdn(vdn);
				}
			}

		}else{
			LOGGER.debug("Unable to get call details {}", kv("uid", authData.getUid()));
		}

		return null;
	}

	/**
	 * Look up the database to work out what the VDN from the inbound phone number refers to.
	 * @param vdn
	 * @return
	 * @throws DaoException
	 */
	public static InboundPhoneNumber getInboundPhoneDetailsByVdn(String vdn) throws DaoException {

		InboundPhoneNumberDao phoneDao = new InboundPhoneNumberDao();
		InboundPhoneNumber inboundPhoneNumber = phoneDao.getByVdn(vdn);
		return inboundPhoneNumber;

	}

	public static boolean makeCall(final PageSettings settings, final String extension, final String phone) {
		try {
			final CallInfo callInfo = getCallInfoByExtension(settings, extension);
			if (callInfo == null) {
				LOGGER.error("Error retrieving call status {},{}", kv("extension", extension), kv("phone", phone));
				return false;
			} else if (callInfo.getState() == STATE_INACTIVE) {
				final String url = callUrl(settings, extension, phone);
				final SimpleConnection conn = new SimpleConnection();
				conn.setConnectTimeout(10000);
				conn.setReadTimeout(10000);
				final String result = conn.get(url);
				return callReturnStatus(result);
			} else {
				LOGGER.info("Already on phone {}", kv("extension", extension));
				return false;
			}
		} catch (Exception e) {
			LOGGER.error("Error retrieving call status", kv("extension", extension), kv("phone", phone));
			return false;
		}
	}

	public static String callUrl(final PageSettings settings, final String extension, final String phone) throws ConfigSettingException {
		try {
			final String ctiBaseUrl = settings.getSetting("ctiMakeCallUrl");
			return format(ctiBaseUrl + CTI_MAKE_CALL, extension, phone);
		} catch (final IllegalFormatException e) {
			LOGGER.error("Error retrieving cti make call server url {},{}", kv("extension", extension), kv("phone", phone));
		}
		return null;
	}

	public static boolean callReturnStatus(final String xml) {
		if (xml != null) {
			try {
				final XmlParser parser = new XmlParser();
				final XmlNode node = parser.parse(xml);
				return node.get("response/status").toString().equalsIgnoreCase("OK");
			} catch (final SAXException e) {
				LOGGER.error("Unable parse call status {}", kv("xml", xml), e);
				return false;
			}
		}
		return false;
	}
}
