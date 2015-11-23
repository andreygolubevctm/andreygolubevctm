package com.ctm.web.core.web.go.tags;

import com.ctm.web.core.web.go.Data;
import com.ctm.web.core.web.go.xml.HttpRequestHandler;
import com.ctm.web.core.web.go.xml.SearchTerm;
import com.ctm.web.core.web.go.xml.XmlNode;
import com.ctm.web.core.web.go.xml.XmlParser;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.xml.sax.SAXException;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.jsp.JspException;
import java.util.ArrayList;

import static com.ctm.web.core.logging.LoggingArguments.kv;

// TODO: Auto-generated Javadoc
/**
 * The Class SetDataTag.
 *
 * @author aransom
 * @version 1.0
 */

@SuppressWarnings("serial")
public class SetDataTag extends BaseTag {
	
	private static final Logger LOGGER = LoggerFactory.getLogger(SetDataTag.class.getName());

	/** The VALU e_ params. */
	public static String VALUE_PARAMS = "*PARAMS";

	/** The VALU e_ delete. */
	public static String VALUE_DELETE = "*DELETE";

	/** The data var. */
	private String dataVar;

	/** The x path. */
	private String xPath;

	/** The xml. */
	private String xml;

	/** The value. */
	private String value;

	/** The data. */
	private Data data;

	/** The delete. */
	private boolean delete = false;

	/** The from request. */
	private boolean fromRequest = false;

	private boolean allowDuplicates = false;

	/* (non-Javadoc)
	 * @see javax.servlet.jsp.tagext.BodyTagSupport#doAfterBody()
	 */
	@Override
	public int doAfterBody() throws JspException {
		if (bodyContent != null) {
			this.xml = bodyContent.getString();
		}
		return SKIP_BODY;
	}

	/* (non-Javadoc)
	 * @see javax.servlet.jsp.tagext.BodyTagSupport#doEndTag()
	 */
	@Override
	public synchronized int doEndTag() throws JspException {

		// REMOVING... If we're removing a node.. The xpath may be a search term
		if (this.delete) {
			if (this.data == null) {
				throw new JspException(
						"setData: dataVar is null when attempting to remove. dataVar="
								+ dataVar + " xPath=" + xPath);
			}
			if (this.xPath == null) {
				throw new JspException(
						"setData: xPath is null when attempting to remove. dataVar="
								+ dataVar + " xPath=" + xPath);
			}

			this.data.remove(this.xPath);
			this.init();
			return EVAL_PAGE;
		}

		// UPDATING FROM REQUEST ...
		if (this.fromRequest) {

			XmlNode destNode;
			if (this.xPath != null) {
				Object elementFromXpath = this.data.get(this.xPath);
				if (elementFromXpath != null && ! (elementFromXpath instanceof XmlNode)) {
					this.data.remove(this.xPath);
					destNode = getAndAddNewNode();
				} else if (elementFromXpath == null){
					// if the destNode doesn't exist, create the root node
					// and add to the current data object
					destNode = getAndAddNewNode();
				} else {
					destNode = (XmlNode) elementFromXpath;
				}
			} else {
				destNode = this.data;
			}

			HttpRequestHandler.updateXmlNode(destNode,
					(HttpServletRequest) pageContext.getRequest(), true, allowDuplicates);

			// UPDATING A SINGLE VALUE ...
		} else if (this.value != null) {
			if (this.xPath == null) {
				throw new JspException(
						"setData: Value specified without xPath! value="
								+ this.value + " xPath=" + xPath);
			}

			// Ensure the xpath ends with text()
			if (!this.xPath.endsWith(XmlNode.TEXT)) {
				this.xPath = this.xPath + "/" + XmlNode.TEXT;
			}

			// Set the text value
			this.data.put(this.xPath, this.value);

			// PARSING SOME XML ...
		} else if (this.xml != null && !this.xml.isEmpty()) {

			XmlParser p = new XmlParser();
			try {
				XmlNode node = p.parse(xml, true);

				// If an xPath was passed - try and get a node at that path
				if (this.xPath != null) {
					Object o = this.data.get(xPath);

					// If we found a node at that path - add the generated node
					// to it
					if (o instanceof XmlNode) {
						XmlNode destNode = (XmlNode) o;
						if(destNode.hasChild(node.getNodeName()) && !this.allowDuplicates) {
							destNode.removeChild(node.getNodeName());
						}
						destNode.addChild(node);

						// We didn't find a node at that path .. create a new
						// one
					} else {
						this.data.put(this.xPath, node);
					}

					// No xPath specified, just add to data
				} else {
					if(this.allowDuplicates) {
						this.data.addChild(node);
					} else {
						this.data.replaceChild(node);
					}
				}

			} catch (SAXException e) {
				LOGGER.error("failed to setData. {}", kv("xml", xml), e);
			}
		}
		this.init();
		return EVAL_PAGE;
	}

	protected XmlNode getAndAddNewNode() {
		XmlNode destNode;
		ArrayList<SearchTerm> chain = SearchTerm.makeSearchChain(this.xPath);
		destNode = SearchTerm.nodeFromSearchTerm(chain.get(0));
		if(this.allowDuplicates) {
			this.data.addChild(destNode);
		} else {
			this.data.replaceChild(destNode);
		}

		// Now remove the first term from the chain, and
		// reform the xpath
		chain.remove(0);
		this.xPath = chain.toString();
		return destNode;
	}

	/**
	 * Inits the.
	 */
	public void init() {
		this.dataVar = null;
		this.xPath = null;
		this.xml = null;
		this.value = null;
		this.data = null;
		this.delete = false;
		this.fromRequest = false;
	}

	/**
	 * Sets the data var.
	 *
	 * @param dataVar the new data var
	 * @throws Exception the exception
	 */
	public void setDataVar(String dataVar) throws Exception {
		this.dataVar = dataVar;

		// Attempt to locate the Data object we're going to be playing with ..
		Object o = pageContext.findAttribute(dataVar);

		if (o instanceof Data) {
			this.data = (Data) o;

			// The dataVar they passed is the wrong type.
		} else {
			throw new Exception(
					"Variable is not a 'Data' object setData failed : "
							+ dataVar);
		}
	}

	/**
	 * Sets the value.
	 *
	 * @param value the new value
	 */
	public void setValue(String value) {

		// Setting values from the request query string params
		if (value.equals(VALUE_PARAMS)) {
			this.fromRequest = true;
			this.value = null;
			this.delete = false;

			// Deleting a value/node
		} else if (value.equals(VALUE_DELETE)) {
			this.delete = true;
			this.value = null;
			this.delete = true;

			// Setting a single text value
		} else {
			this.fromRequest = false;
			this.value = value;
			this.delete = false;
		}
	}

	/**
	 * Sets the xml.
	 *
	 * @param xml the new xml
	 */
	public void setXml(String xml) {
		this.xml = xml;
	}

	/* (non-Javadoc)
	 * @see com.disc_au.web.go.tags.BaseTag#setXpath(java.lang.String)
	 */
	@Override
	public void setXpath(String xPath) {
		this.xPath = xPath;
	}
}
