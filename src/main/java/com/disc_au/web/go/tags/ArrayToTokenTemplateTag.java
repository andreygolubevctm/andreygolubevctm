package com.disc_au.web.go.tags;

import com.disc_au.web.go.TokenReplaceUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.servlet.jsp.JspException;
import javax.servlet.jsp.PageContext;
import java.io.IOException;

public class ArrayToTokenTemplateTag extends BaseTag {

	private static final Logger LOGGER = LoggerFactory.getLogger(ArrayToTokenTemplateTag.class.getName());

	/**
	 *
	 */
	private static final long serialVersionUID = 1L;

	private String[] array;
	private String template;
	private String value;

	private int startElementIndex = 0;
	
	public void setStartElementIndex(int startElementIndex) {
		this.startElementIndex = startElementIndex;
	}

	public void setEndElementIndex(int endElementIndex) {
		this.endElementIndex = endElementIndex;
	}

	private int endElementIndex = 0;

	public void setArray(String[] array) {
		this.array = array;
	}

	public void setTemplate(String template) {
		this.template = template;
	}

	public void setValue(String value) {
		this.value = value;
	}

	@Override
	public int doEndTag() throws JspException {

		String xml;
		try {
			if(endElementIndex == 0) endElementIndex = array.length;
			xml = TokenReplaceUtils.getXML(array , template, startElementIndex, endElementIndex, false);
		} catch (IOException e1) {
			LOGGER.error("Failed to get xml", e1);
			try {
				pageContext.getOut().write(e1.getMessage());
			} catch (IOException e) {
				LOGGER.error("Failed to output error" , e);
			}
			return EVAL_PAGE;
		}

		// If result var was passed - put the resulting xml in the pagecontext's
		// variable
		if (this.value != null) {
			this.pageContext
					.setAttribute(value, xml, PageContext.PAGE_SCOPE);
			// Otherwise - just splat it to the page
		} else {
			try {
					pageContext.getOut().write(xml);
			} catch (IOException e) {
				e.printStackTrace();
				LOGGER.error("Failed to output to page.", e);
			}
		}

		return EVAL_PAGE;
	}

}
