package com.disc_au.web.go.tags;

import javax.servlet.ServletRequest;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.jsp.JspException;
import javax.servlet.jsp.PageContext;

import org.xml.sax.SAXException;

import com.disc_au.web.file.SecureFileServlet;
import com.disc_au.web.go.xml.XmlNode;
import com.disc_au.web.go.xml.XmlParser;

// TODO: Auto-generated Javadoc
/**
 * The Class CallTag.
 * 
 * @author aransom
 * @version 1.0
 */

@SuppressWarnings("serial")
public class AddSecureFile extends BaseTag {
	
	private String filename = "";
	private String url = "";

	/* (non-Javadoc)
	 * @see javax.servlet.jsp.tagext.BodyTagSupport#doAfterBody()
	 */
	@Override
	public int doAfterBody() throws JspException {
		return SKIP_BODY;
	}

	/* (non-Javadoc)
	 * @see javax.servlet.jsp.tagext.BodyTagSupport#doEndTag()
	 */
	@Override
	public int doEndTag() throws JspException {
		if (filename.length() > 0) {
			SecureFileServlet.addSecureFile(this.pageContext.getSession(), filename);
			
			ServletRequest req = this.pageContext.getRequest();
			String contextPath = "http://localhost:8081/sar";
			if (req instanceof HttpServletRequest) {
				contextPath = req.getScheme() + "://" + req.getLocalName() + ":" + req.getLocalPort() + ((HttpServletRequest) req).getContextPath();
			}
			String url = contextPath + "/SecureFile?filename=" + filename;
			System.out.println("Secure File URL: " + url);
			
			if (!this.url.equals("")) {
				Object o = pageContext.findAttribute(this.url);
				// Unable to locate object .. skip
				if (o == null) {
					pageContext.setAttribute(this.url, url,
							PageContext.PAGE_SCOPE);
					return EVAL_PAGE;

					// Load the response into a String
				} else if (o instanceof String) {
					o = url;
					return EVAL_PAGE;

					// Load the response into an XmlNode
				} else if (o instanceof XmlNode) {

					try {
						o = (new XmlParser()).parse(url);
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
		}
		this.init();
		return EVAL_PAGE;
	}
	
	/* (non-Javadoc)
	 * @see javax.servlet.jsp.tagext.BodyTagSupport#doStartTag()
	 */
	@Override
	public int doStartTag() throws JspException {
		return SKIP_BODY;
	}

	public void init() {
		this.filename = "";
	}

	public void setFilename(String fileName) {
		this.filename = fileName;
	}
	
	public void setUrl(String url) {
		this.url = url;
	}

}
