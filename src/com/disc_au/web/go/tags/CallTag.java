/**  =========================================== */
/**  ===  AIH Compare The Market Aggregator  === */
/**  <go:call> Tag Class with iSeries env variable support
 *   $Id: CallTag.java 1293 2013-01-09 05:19:26Z xplooy $
 * (c)2012 Australian Insurance Holdings Pty Ltd */

package com.disc_au.web.go.tags;

import java.io.IOException;
import java.util.Hashtable;

import javax.servlet.jsp.JspException;
import javax.servlet.jsp.PageContext;

import org.xml.sax.SAXException;

import com.disc_au.web.ISeriesConfig;
import com.disc_au.web.go.Data;
import com.disc_au.web.go.bridge.Bridge;
import com.disc_au.web.go.bridge.messages.EcomMessageHeader;
import com.disc_au.web.go.bridge.messages.Message;
import com.disc_au.web.go.xml.XmlNode;
import com.disc_au.web.go.xml.XmlParser;

/**
 * The Class CallTag with iSeries env variable support.
 *
 * @author aransom
 * @version 1.2
 */

@SuppressWarnings("serial")
public class CallTag extends BaseTag {

	/**
	 * The Class CallThread.
	 */
	private class CallThread implements Runnable {

		/** The bridge. */
		private Bridge bridge;

		/** The message. */
		private Message message;

		/**
		 * Instantiates a new call thread.
		 *
		 * @param bridge the bridge
		 * @param message the message
		 */
		public CallThread(Bridge bridge, Message message) {
			this.bridge = bridge;
			this.message = message;
		}

		/* (non-Javadoc)
		 * @see java.lang.Runnable#run()
		 */

		public void run() {
			bridge.sendReceive(message);
		}

	}

	/** The Constant TRUE. */
	public static final String TRUE = "true";

	/** The page id. */
	private String pageId = "COREER";

	/** The style. */
	private String style = "";

	/** The Transaction ID. */
	private String transactionId = "";

	/** The wait. */
	private String wait = TRUE;

	/** The result var. */
	private String resultVar = "";

	/** The xml var. */
	private String xmlVar = "";

	/** The i series. */
	private String iSeries = "";

	/** The port. */
	private int port = 0;

	/** The mode. */
	private String mode = "D";

	/** The feature. */
	private String feature = "";


	/* (non-Javadoc)
	 * @see javax.servlet.jsp.tagext.BodyTagSupport#doAfterBody()
	 */

	public int doAfterBody() throws JspException {
		// If xml not specified, get the xml data from the body
		if (this.xmlVar.equals("")) {
			this.xmlVar = bodyContent.getString();
		}
		return SKIP_BODY;
	}

	/* (non-Javadoc)
	 * @see javax.servlet.jsp.tagext.BodyTagSupport#doEndTag()
	 */

	public int doEndTag() throws JspException {

		// Attempt to fetch the iSeries from the page's settings
		if (this.iSeries == null || this.port == 0) {
			Data data = (Data) pageContext.getSession().getAttribute("data");
			if (this.iSeries == null || this.iSeries.equals("")) {
				this.iSeries = (String) data.get("settings/iSeries/name/text()");
			}
			if (this.port == 0) {
				try {
					this.port = Integer.parseInt((String) data.get("settings/iSeries/port/text()"));
				} catch (Exception e) {}
			}
		}

		// Attempt to retrieve iSeries connection information from relevant server environment variable
		Hashtable<String, String> envConn = null;
		try {
System.out.println("CallTag: attempting to get environment details for " + this.feature + " / " + this.style + " / "+ pageContext.getRequest().getServletContext());
			envConn = ISeriesConfig.getEnvironmentConfig(pageContext.getRequest().getServletContext(), this.style, this.feature);
			if ( envConn != null ) {
				this.iSeries = envConn.get("serverName");
				this.port = Integer.parseInt(envConn.get("serverPort"));
System.out.println("CallTag: environment details result: " + envConn + " / using server " + this.iSeries + ", port " + this.port);
			}
		} catch (Exception e) {}

		System.err.println("Call has: " + this.iSeries + ":" + this.port);
		String clientIpAddress = pageContext.getRequest().getRemoteAddr();

		EcomMessageHeader header = new EcomMessageHeader(this.transactionId, this.pageId, clientIpAddress, this.style, this.mode);
		Message req = new Message(header, this.xmlVar);
		Bridge b = new Bridge(this.iSeries, this.port);

		// If we are to wait for a response, call inline
		if (this.wait.equals(TRUE) || !this.resultVar.equals("")) {
			Message resp = b.sendReceive(req);
			String resultData = resp.getData();

			if (!this.resultVar.equals("")) {
				Object o = pageContext.findAttribute(this.resultVar);
				// Unable to locate object .. skip
				if (o == null) {
					pageContext.setAttribute(this.resultVar, resultData,
							PageContext.PAGE_SCOPE);
					return EVAL_PAGE;

					// Load the response into a String
				} else if (o instanceof String) {
					o = resultData;
					return EVAL_PAGE;

					// Load the response into an XmlNode
				} else if (o instanceof XmlNode) {

					try {
						o = (new XmlParser()).parse(resultData);
						return EVAL_PAGE;
					} catch (SAXException e) {
						e.printStackTrace();
					}
					// Unknown result type
				} else {
					System.err.println("Unkown type for resultVar: "
							+ o.getClass().getName());
				}
			}

			try {
				pageContext.getOut().write(resultData);
			} catch (IOException e) {
				e.printStackTrace();
			}

			// Otherwise submit the thread and return
		} else {
			Thread t = new Thread(new CallThread(b, req), req.getName());
			t.start();
		}
		this.init();
		return EVAL_PAGE;
	}

	/* (non-Javadoc)
	 * @see javax.servlet.jsp.tagext.BodyTagSupport#doStartTag()
	 */

	public int doStartTag() throws JspException {
		if (!this.xmlVar.equals("")) {
			return SKIP_BODY;
		} else {
			return EVAL_PAGE;
		}
	}

	/**
	 * Inits the.
	 */
	public void init() {
		this.pageId = "COREER";
		this.style = "";
		this.wait = TRUE;
		this.resultVar = "";
		this.xmlVar = "";
		this.iSeries = "";
		this.port = 0;
		this.mode="D";
		this.feature = "";
	}

	/**
	 * Sets the i series.
	 *
	 * @param iSeries the new i series
	 */
	public void setiSeries(String iSeries) {
		this.iSeries = iSeries;
	}

	/**
	 * Sets the page id.
	 *
	 * @param pageId the new page id
	 */
	public void setPageId(String pageId) {
		this.pageId = pageId;
	}

	/**
	 * Sets the port.
	 *
	 * @param port the new port
	 */
	public void setPort(String port) {
		try {
			this.port = Integer.parseInt(port);
		} catch (Exception e) {
		}
	}

	/**
	 * Sets the feature.
	 *
	 * @param feature the new feature
	 */
	public void setFeature(String feature) {
		this.feature = feature;
	}

	/**
	 * Sets the result var.
	 *
	 * @param resultVar the new result var
	 */
	public void setResultVar(String resultVar) {
		this.resultVar = resultVar;
	}

	/**
	 * Sets the style.
	 *
	 * @param style the new style
	 */
	public void setStyle(String style) {
		this.style = style;
	}

	/**
	 * Sets the Transaction ID.
	 *
	 * @param Transaction Id to send
	 */
	public void setTransactionId(String transactionId) {
		this.transactionId = transactionId;
	}

	/**
	 * Sets the wait.
	 *
	 * @param wait the new wait
	 */
	public void setWait(String wait) {
		this.wait = wait.toLowerCase();
	}
	/**
	 * Sets the mode.
	 *
	 * @param mode the new mode
	 */
	public void setMode(String mode) {
		this.mode = mode.substring(0,1);
	}
	/**
	 * Sets the xml var.
	 *
	 * @param xmlVar the new xml var
	 */
	public void setXmlVar(String xmlVar) {
		if (xmlVar.trim().startsWith("<")) {
			this.xmlVar = xmlVar;
		} else {

			Object node = this.pageContext.findAttribute(xmlVar);
			if (node == null) {
			} else if (node instanceof String) {
				this.xmlVar = (String) node;
			} else if (node instanceof XmlNode) {
				this.xmlVar = ((XmlNode) node).getXML();
			}
		}
	}

}
