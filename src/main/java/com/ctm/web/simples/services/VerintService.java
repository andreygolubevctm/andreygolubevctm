package com.ctm.web.simples.services;

import com.ctm.web.core.connectivity.SimpleConnection;
import com.ctm.web.core.exceptions.ConfigSettingException;
import com.ctm.exceptions.EnvironmentException;
import com.ctm.exceptions.ServiceException;
import com.ctm.model.session.AuthenticatedData;
import com.ctm.model.settings.PageSettings;
import com.ctm.services.SessionDataService;
import com.disc_au.web.go.xml.XmlNode;
import com.disc_au.web.go.xml.XmlParser;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.xml.sax.SAXException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class VerintService {

    private static final Logger logger = LoggerFactory.getLogger(VerintService.class.getName());

    /**
     * Get Response from Verint' RIS (Recorder Integration Service) from either its Master or Slave (failover) server
     * @param settings
     * @param paramUrl
     * @return
     * @throws EnvironmentException
     * @throws ConfigSettingException
     */
    private static String getVerintResponse(PageSettings settings, String paramUrl) throws EnvironmentException, ConfigSettingException {
        String resultMaster,resultSlave, result;
        String masterUrl = settings.getSetting("verintMaster");
        String slaveUrl = settings.getSetting("verintSlave");
        SimpleConnection simpleConn = new SimpleConnection();
        resultMaster = simpleConn.get(masterUrl + paramUrl);
        logger.info("Verint API call : Read master URL : "+ masterUrl + paramUrl);
        logger.info("Verint API call : Read master Response : "+ resultMaster);
        if (resultMaster == null || resultMaster.contains("<isMaster>false</isMaster>")) {
            resultSlave = simpleConn.get(slaveUrl + paramUrl);
            logger.info("Read slave URL : "+ slaveUrl + paramUrl);
            logger.info("Read slave Response : "+ resultSlave);
            if ( resultSlave  != null) {
                result = resultSlave;
            }else{
                result = resultMaster;
            }
        }else{
            result = resultMaster;
        }
        return result;


    }

    /**
     *
     * @param request
     * @param settings
     * @return
     * @throws ServiceException
     */
    public String pauseResumeRecording(HttpServletRequest request,HttpServletResponse response,PageSettings settings) throws  ServletException {
        XmlNode xmlNode;
        String result;
        try {
            SessionDataService sessionDataService = new SessionDataService();
            AuthenticatedData authenticatedData = sessionDataService.getAuthenticatedSessionData(request);
            String action = request.getParameter("action");
            if (authenticatedData == null || authenticatedData.get("login/user/uid")==null) {
                throw new ServletException("Failed: Please login to perform action " + action);
            }
            String agentId = (String) authenticatedData.get("login/user/agentId");
            String paramUrl = "servlet/eQC6?&" +
                    "interface=IContactManagement&" +
                    "method=deliverevent&" +
                    "contactevent=" + action + "&" +
                    "agent.agent=" + agentId + "&" +
                    "responseType=XML&" +
                    "attribute.key=Contact.ContentType&" +
                    "attribute.value=Audio&" +
                    "attribute.key=Contact.Requestor&" +
                    "attribute.value=CTM";
            result  = getVerintResponse(settings, paramUrl);
            if(result==null){
                throw new ServletException("Problem while communicating to the server ");
            }
            if(result.contains("")){
                XmlParser parser = new XmlParser();
                xmlNode = parser.parse(result);
                if(xmlNode.get("success/text()")==null ||  !xmlNode.get("success/text()").toString().equalsIgnoreCase("true") ){
                    throw new ServletException( xmlNode.get("errorMessage/text()").toString());
                }
                if(xmlNode.get("isMaster/text()")==null ||  !xmlNode.get("isMaster/text()").toString().equalsIgnoreCase("true") ){
                    throw new ServletException("Failed: Can not find Master server" + action);
                }
            }
        }catch(SAXException se){
            logger.info("Failed response while calling Verint API");
            throw new ServletException("Invalid Response.",se);
        }catch ( ConfigSettingException | ServletException | RuntimeException se){
            logger.info("Failed response while calling Verint API"+se.getMessage());
            throw new ServletException(se.getMessage(),se);
        }
        return result;
    }
}