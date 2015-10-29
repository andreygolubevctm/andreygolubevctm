package com.ctm.web.core.web.go.tags;

import com.ctm.web.core.web.go.InsertMarkerCache;
import com.ctm.web.core.web.go.jQuery.ValidationRules;

import javax.servlet.jsp.JspException;

// TODO: Auto-generated Javadoc
/**
 * The Class ValidateTag.
 * 
 * @author aransom
 * @version 1.0
 */

@SuppressWarnings("serial")
public class ValidateTag extends BaseTag {

	/** The selector. */
	private String selector;
	
	/** The rule. */
	private String rule;
	
	/** The rule parm. */
	private String ruleParm;
	
	/** The message. */
	private String message;

	/* (non-Javadoc)
	 * @see javax.servlet.jsp.tagext.BodyTagSupport#doStartTag()
	 */
	@Override
	public int doStartTag() throws JspException {
		InsertMarkerCache cache = InsertMarkerCache.getInsertMarkerCache(this.pageContext);

		// Get the insert marker for rules:
		ValidationRules v = cache.getValidationRules();
		if (message != null) {
			v.addRule(selector, rule, ruleParm, message);
		} else {
			v.addRule(selector, rule, ruleParm);
		}

		this.init();
		return SKIP_BODY;
	}

	/**
	 * Inits the.
	 */
	public void init() {
		this.selector = null;
		this.rule = null;
		this.ruleParm = null;
		this.message = null;
	}

	/**
	 * Sets the message.
	 *
	 * @param message the new message
	 */
	public void setMessage(String message) {
		this.message = message;
	}

	/**
	 * Sets the parm.
	 *
	 * @param parm the new parm
	 */
	public void setParm(String parm) {
		this.ruleParm = parm;
	}

	/**
	 * Sets the rule.
	 *
	 * @param rule the new rule
	 */
	public void setRule(String rule) {
		this.rule = rule;
	}

	/**
	 * Sets the selector.
	 *
	 * @param selector the new selector
	 */
	public void setSelector(String selector) {
		this.selector = selector;
	}
}
