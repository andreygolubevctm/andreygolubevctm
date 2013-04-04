package com.disc_au.web.go.tags;

import java.io.IOException;

import javax.servlet.jsp.JspException;
import javax.servlet.jsp.PageContext;

import com.disc_au.web.go.TokenReplaceUtils;

public class ArrayToTokenTemplateTag extends BaseTag {

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
			xml = TokenReplaceUtils.getXML(array , template, startElementIndex, endElementIndex);
		} catch (IOException e1) {
			e1.printStackTrace();
			try {
				pageContext.getOut().write(e1.getMessage());
			} catch (IOException e) {
				e.printStackTrace();
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
			}
		}

		return EVAL_PAGE;
	}

}
