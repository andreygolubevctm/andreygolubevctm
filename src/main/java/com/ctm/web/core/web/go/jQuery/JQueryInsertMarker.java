package com.ctm.web.core.web.go.jQuery;

import com.ctm.web.core.web.go.InsertMarker;

// TODO: Auto-generated Javadoc
/**
 * The Class JQueryInsertMarker.
 * 
 * @author aransom
 * @version 1.0
 */

public class JQueryInsertMarker extends InsertMarker {
	
	/** The Constant MARKER_PREFIX. */
	public static final String MARKER_PREFIX = "jquery-val-";
	
	/** The Constant RULE_MARKER. */
	public static final String RULE_MARKER = "jquery-val-rules";
	
	/** The Constant MESSAGE_MARKER. */
	public static final String MESSAGE_MARKER = "jquery-val-messages";

	/** The rules. */
	private ValidationRules rules;
	
	/**
	 * Instantiates a new j query insert marker.
	 *
	 * @param name the name
	 * @param rules the rules
	 */
	public JQueryInsertMarker(String name, ValidationRules rules,Format format) {
		super(name,format);
		this.rules = rules;
		
	}

	/* (non-Javadoc)
	 * @see com.disc_au.web.go.InsertMarker#getData()
	 */
	@Override
	public StringBuffer getData() {
		if (name.equals(RULE_MARKER)) {
			return rules.getRuleJS();
		} else {
			return rules.getMessageJS();
		}
	}

}
