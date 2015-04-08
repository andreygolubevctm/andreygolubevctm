/**  =========================================   */
/**  <go:call> Tag Class with iSeries env variable support
 *   $Id$
 * (c)2012 Auto & General Holdings Pty Ltd       */

package com.disc_au.web.go.tags;

import java.io.IOException;

import javax.servlet.jsp.JspException;
import javax.servlet.jsp.PageContext;

import com.ctm.services.FatalErrorService;
import org.apache.log4j.Logger;
import org.xml.sax.SAXException;

import com.disc_au.web.go.ISeriesConnection;
import com.disc_au.web.go.bridge.Bridge;
import com.disc_au.web.go.bridge.messages.EcomMessageHeader;
import com.disc_au.web.go.bridge.messages.Message;
import com.disc_au.web.go.xml.XmlNode;
import com.disc_au.web.go.xml.XmlParser;

/**
 * The Class CallTag with iSeries env variable support.
 *
 * @author aransom
 * @version 1.3
 */

@SuppressWarnings("serial")
public class CallTag extends BaseTag {

	private static Logger logger = Logger.getLogger(CallTag.class.getName());

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
		@Override
		public void run() {
			try {
				bridge.sendReceive(message);
			} catch (IOException e) {
				logger.error("Failed to call disc message:" + message.getData(), e);
				FatalErrorService.logFatalError(e, 0, "CallTag:doEndTag", "Failed to call disc message", true, "");

			}
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

	/** The mode. */
	private String mode = "D";


	private ISeriesConnection iSeriesConnection;


	/* (non-Javadoc)
	 * @see javax.servlet.jsp.tagext.BodyTagSupport#doAfterBody()
	 */
	@Override
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
	@Override
	public int doEndTag() throws JspException {

		// Attempt to fetch the iSeries from the page's settings
		if (this.iSeriesConnection == null) {
			//Data data = (Data) pageContext.getSession().getAttribute("data");
			this.iSeriesConnection = new ISeriesConnection(pageContext);
			}
		String clientIpAddress = pageContext.getRequest().getRemoteAddr();

		EcomMessageHeader header = new EcomMessageHeader(this.transactionId, this.pageId, clientIpAddress, this.style, this.mode);
		Message req = new Message(header, this.xmlVar);
		logger.debug("iSeries " +this.iSeriesConnection.getISeries() +" getPort " +this.iSeriesConnection.getPort());
		Bridge b = new Bridge(iSeriesConnection.getISeries(), iSeriesConnection.getPort());

		// If we are to wait for a response, call inline
		if (this.wait.equals(TRUE) || !this.resultVar.equals("")) {
			try {
				Message resp = b.sendReceive(req);
				String resultData = "";
				if (!this.resultVar.equals("") && resp != null) {
					resultData = resp.getData();
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

				pageContext.getOut().write(resultData);
			} catch (IOException e) {
				logger.error("Failed to call disc message:" + req.getData(), e);
				FatalErrorService.logFatalError(e, 0, "CallTag:doEndTag", "", true, this.transactionId);
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
	@Override
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
		this.iSeriesConnection = null;
		this.mode="D";
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
