/**  =========================================== */
/**  ===  AIH Compare The Market Aggregator  === */
/**  CallServlet Class with iSeries env variable support
 *   $Id$
 * (c)2012 Australian Insurance Holdings Pty Ltd */

package com.disc_au.web.go;

import java.io.IOException;
import java.util.Hashtable;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.disc_au.web.ISeriesConfig;
import com.disc_au.web.go.bridge.Bridge;
import com.disc_au.web.go.bridge.messages.Message;
import com.disc_au.web.go.bridge.messages.EcomMessageHeader;
import com.disc_au.web.go.xml.HttpRequestHandler;
import com.disc_au.web.go.xml.XmlNode;

/**
 * The Class CallServlet with iSeries env variable support.
 *
 * @author aransom
 * @version 1.2
 */
@SuppressWarnings("serial")
public class CallServlet extends HttpServlet {

	/** The Constant SETTINGS_ISERIES_NAME. */
	public final static String SETTINGS_ISERIES_NAME = "settings/iSeries/name/text()";

	/** The Constant SETTINGS_ISERIES_PORT. */
	public final static String SETTINGS_ISERIES_PORT = "settings/iSeries/port/text()";

	/** The Constant INITPARAM_ISERIES_NAME. */
	public final static String INITPARAM_ISERIES_NAME = "iSeries_name";

	/** The Constant INITPARAM_ISERIES_PORT. */
	public final static String INITPARAM_ISERIES_PORT = "iSeries_port";

	/** The Constant PARM_PAGE_ID. */
	public final static String PARM_PAGE_ID = "pageId";

	/** The Constant PARM_TRAN_ID. */
	public final static String PARM_TRAN_ID = "tranId";

	/** The Constant PARM_STYLE. */
	public final static String PARM_STYLE = "style";

	/** The Constant PARM_MODE. */
	public final static String PARM_MODE = "mode";

	/** The bridge. */
	private Bridge bridge;

	/** Variable for last used bridge connection iSeries name. */
	private String lastISeriesName = null;

	/** Variable for last used bridge connection iSeries port. */
	private int lastISeriesPort = 0;


	/* (non-Javadoc)
	 * @see javax.servlet.http.HttpServlet#doGet(javax.servlet.http.HttpServletRequest, javax.servlet.http.HttpServletResponse)
	 */
	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp)
			throws ServletException, IOException {

		// Fetch the pageId and style from the request
		String pageId = req.getParameter(PARM_PAGE_ID);
		String style = req.getParameter(PARM_STYLE);
		String tranId = req.getParameter(PARM_TRAN_ID);
		String mode = req.getParameter(PARM_MODE);
		String clientIp = req.getRemoteAddr();

		String iSeries = null;
		int port = 0;

		// If the bridge is null, try to fetch from the request's settings
		if (this.bridge == null) {
			Data data = (Data) req.getSession().getAttribute("data");
			if (data != null) {
				iSeries = (String) data.get(SETTINGS_ISERIES_NAME);
				String portName = (String) data.get(SETTINGS_ISERIES_PORT);
				try {
					port = Integer.parseInt(portName);
				} catch (Exception e) {
				}
			}
		}

		// Attempt to retrieve iSeries connection information from relevant server environment variable
		Hashtable<String, String> envConn = null;
		try {
System.out.println("CallServlet doGet: attempting to get environment details for " + this.getServletName() + " / " + style + " / " + this.getServletContext());
			envConn = ISeriesConfig.getEnvironmentConfig(this.getServletContext(), style, this.getServletName());
			if ( envConn != null ) {
				iSeries = envConn.get("serverName");
				port = Integer.parseInt(envConn.get("serverPort"));
System.out.println("CallServlet doGet: environment details result: " + envConn + " / using server " + iSeries + ", port " + port);
			}
		} catch (Exception e) {}

		if ( iSeries != null && port > 0 && ( this.lastISeriesName == null || !iSeries.equals(this.lastISeriesName) || port != this.lastISeriesPort ) ) {
			this.bridge = new Bridge(iSeries, port);
			this.lastISeriesName = iSeries;
			this.lastISeriesPort = port;
		}

		// If the bridge is still null - throw an exception
		if (this.bridge == null) {
			throw new IOException(
					"Unable to determine bridge (iSeries name/port not set in initParms or settings)");
		}

		XmlNode node = HttpRequestHandler.createXmlNode(req);

		EcomMessageHeader header = new EcomMessageHeader(tranId, pageId, clientIp, style, mode);
		Message outbound = new Message(header , node.getXML());
		Message inbound = bridge.sendReceive(outbound);

		resp.getOutputStream().write(inbound.getData().getBytes());
	}

	/* (non-Javadoc)
	 * @see javax.servlet.GenericServlet#init()
	 */
	@Override
	public void init() throws ServletException {
		super.init();

		String iSeries = this.getInitParameter(INITPARAM_ISERIES_NAME);

		String portName = this.getInitParameter(INITPARAM_ISERIES_PORT);
		int port = 0;
		try {
			port = Integer.parseInt(portName);
		} catch (Exception e) {
		}

		// Attempt to retrieve iSeries connection information from relevant server environment variable
		Hashtable<String, String> envConn = null;
		try {
System.out.println("CallServlet init: attempting to get environment details for " + this.getServletName() + " / " + this.getServletContext());
			envConn = ISeriesConfig.getEnvironmentConfig(this.getServletContext(), this.getServletName());
			if ( envConn != null ) {
				iSeries = envConn.get("serverName");
				port = Integer.parseInt(envConn.get("serverPort"));
System.out.println("CallServlet init: environment details result: " + envConn + " / using server " + iSeries + ", port " + port);
			}
		} catch (Exception e) {}

		if (iSeries != null && port > 0) {
			this.bridge = new Bridge(iSeries, port);
			this.lastISeriesName = iSeries;
			this.lastISeriesPort = port;
		}
	}

}
