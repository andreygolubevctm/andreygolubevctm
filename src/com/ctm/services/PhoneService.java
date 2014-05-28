package com.ctm.services;

import org.apache.log4j.Logger;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
import org.xml.sax.SAXException;

import com.ctm.connectivity.JsonConnection;
import com.ctm.connectivity.SimpleSocketConnection;
import com.ctm.dao.InboundPhoneNumberDao;
import com.ctm.exceptions.ConfigSettingException;
import com.ctm.exceptions.DaoException;
import com.ctm.exceptions.EnvironmentException;
import com.ctm.model.session.AuthenticatedData;
import com.ctm.model.settings.PageSettings;
import com.ctm.model.simples.InboundPhoneNumber;
import com.disc_au.web.go.xml.XmlNode;
import com.disc_au.web.go.xml.XmlParser;

public class PhoneService {

	private static Logger logger = Logger.getLogger(PhoneService.class.getName());

	/**
	 * Uses the phone recording service to get the extension for the specified agent id.
	 * @param settings
	 * @param agentId
	 * @return
	 * @throws ConfigSettingException
	 * @throws EnvironmentException
	 * @throws Exception
	 */
	public static String getExtensionByAgentId(PageSettings settings, String agentId) throws EnvironmentException, ConfigSettingException {

		String serviceUrl = settings.getSetting("verintUrl");

		String[] serviceUrlParts = serviceUrl.split(":");
		String serviceIP = serviceUrlParts[0];
		int servicePort = Integer.parseInt(serviceUrlParts[1]);

		// TODO: Refactor <core:verint_rcapi_extension /> to use this method.

		SimpleSocketConnection conn =  new SimpleSocketConnection(serviceIP, servicePort, "/Services/PSIntellilinkBasic");
		String xmlData = "<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:ilap=\"http://ps.verint/ilApi\">"
			+"<soapenv:Header/>"
			+"<soapenv:Body>"
				+"<ilap:GetExtensionByAgentId>"
					+"<ilap:switchNum>2</ilap:switchNum>"
					+"<ilap:agentID>" + agentId + "</ilap:agentID>"
				+"</ilap:GetExtensionByAgentId>"
			+"</soapenv:Body>"
			+"</soapenv:Envelope>";
		String[] headers = new String[] {"SOAPAction: \"http://ps.verint/ilApi/I_Intellilink/GetExtensionByAgentId\""};

		try {
			String result = conn.get(xmlData, headers);
			XmlParser parser = new XmlParser();
			XmlNode xmlNode = parser.parse(result);
			return (String) xmlNode.get("s:Body/GetExtensionByAgentIdResponse/extension");
		} catch (SAXException e) {
			e.printStackTrace();
		}

		return null;
	}

	/**
	 * Uses the CTI service from Auto&General to get the top level VDN for the specified extension.
	 * Technically there can be multiple VDNs but we are interested in the top level VDN as that is where the call first hit our call centre.
	 * FYI - VDNs must be registered in DISC for this to work.
	 *
	 * FYI - Because of the use of an xml to json function in the external service, the json structure may be inconsistent when there are one or more vdns.
	 *
	 * Sample response:
	 * {"service":{"response":{"information":{"vdnCount":1,"direction":"I","state":1,"callId":2104211397094514,"vdns":{"vdn":8886},"otherParty":{"telephoneNumber":405737645,"state":1}},"accessToken":"","status":"OK"}}}
	 * or
	 * {"service":{"response":{"information":{"vdnCount":2,"direction":"I","state":1,"callId":2104211397094514,"vdns":[{"vdn":8886},{"vdn":1234}],"otherParty":{"telephoneNumber":405737645,"state":1}},"accessToken":"","status":"OK"}}}
	 *
	 * @param settings
	 * @param extension
	 * @return
	 * @throws ConfigSettingException
	 * @throws EnvironmentException
	 */
	public static String getVdnByExtension(PageSettings settings, String extension) throws EnvironmentException, ConfigSettingException {

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

		if(json == null){
			return null;
		}

		logger.debug(json.toString());

		String vdn = null;

		try {
			JSONObject service = json.getJSONObject("service");
			JSONObject response = service.getJSONObject("response");
			JSONObject information = response.getJSONObject("information");
			int count = information.getInt("vdnCount");
			if(count == 1){
				JSONObject vdns = information.getJSONObject("vdns");
				vdn = vdns.getString("vdn");
			}else{
				JSONArray vdns = information.getJSONArray("vdns");
				JSONObject originalVdn = (JSONObject) vdns.get(0);
				vdn = originalVdn.getString("vdn");
			}

		} catch (JSONException e) {
			// This will cause an error if the path is not there, this is fine.
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
