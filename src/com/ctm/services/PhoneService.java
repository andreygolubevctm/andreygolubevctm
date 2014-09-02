package com.ctm.services;

import org.apache.log4j.Logger;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
import org.xml.sax.SAXException;

import com.ctm.connectivity.SimpleConnection;
import com.ctm.connectivity.JsonConnection;
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

public class PhoneService {

	private static Logger logger = Logger.getLogger(PhoneService.class.getName());

	/**
	 * Get Response from Verint' RIS (Recorder Integration Service) from either its Master or Slave (failover) server
	 * @param pageSettings
	 * @param paramUrl
	 * @return
	 * @throws ConfigSettingException
	 * @throws EnvironmentException
	 * @throws Exception
	 */
	public static XmlNode getVerintResponse(PageSettings settings, String paramUrl) throws EnvironmentException, ConfigSettingException {

		String masterUrl = settings.getSetting("verintMaster");
		String slaveUrl = settings.getSetting("verintSlave");

		SimpleConnection simpleConn =  new SimpleConnection();
		String result = simpleConn.get(masterUrl + paramUrl);

		if (result.contains("<isMaster>false</isMaster>")) {
			result = simpleConn.get(slaveUrl + paramUrl);
		}

		try {
			XmlParser parser = new XmlParser();
			XmlNode xmlNode = parser.parse(result);
			return xmlNode;
		} catch (SAXException e) {
			logger.error(e);
		}

		return null;
	}

	/**
	 * Uses Verint's RIS (Recorder Integration Service) to pause / resume recording of audio / video
	 * @param pagesettings
	 * @param agentId
	 * @param contentType
	 * @param action
	 * @return
	 * @throws ConfigSettingException
	 * @throws EnvironmentException
	 * @throws Exception
	 */
	public static XmlNode pauseResumeRecording(PageSettings settings, String agentId, String contentType, String action) throws EnvironmentException, ConfigSettingException {

		String paramUrl = "servlet/eQC6?&" +
						"interface=IContactManagement&" +
						"method=deliverevent&" +
						"contactevent=" + action + "&" +
						"agent.agent=" + agentId + "&" +
						"responseType=XML&" +
						"attribute.key=Contact.ContentType&" +
						"attribute.value=" + contentType + "&" +
						"attribute.key=Contact.Requestor&" +
						"attribute.value=CTM";

		XmlNode xmlNode = getVerintResponse(settings, paramUrl);
		return xmlNode;
	}

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

		logger.debug("AgentId " + agentId + ": " + json.toString());

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
			logger.error(e);
		}

		return null;
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

		logger.debug("Extension " + extension + ": " + json.toString());

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
				callInfo.setState(CallInfo.STATE_INACTIVE);
			}

		}
		catch (JSONException e) {
			logger.error(e);
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
				}else{
					logger.debug("Unable to get extension for agent id: "+agentId);
				}
			}

			if(extension != null){
				String vdn = PhoneService.getVdnByExtension(settings, extension);
				if(vdn != null){
					return getInboundPhoneDetailsByVdn(vdn);
				}
			}

		}else{
			logger.debug("Unable to find agent id for uid: "+authData.getUid());
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


}
