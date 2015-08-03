package com.disc_au.web.go.jQuery;

import java.util.HashMap;

// TODO: Auto-generated Javadoc
/**
 * The Class ValidationRules.
 *
 * @author aransom
 * @version 1.0
 */

public class ValidationRules {

	/**
	 * The Class Rule.
	 */
	private class Rule {

		/** The parm. */
		private String parm = "";

		/** The message. */
		private String message;
	}

	// HashMap of rules, keyed by selector then by rule name
	/** The rules. */
	private HashMap<String, HashMap<String, Rule>> rules = new HashMap<String, HashMap<String, Rule>>();

	/** The rule js. */
	private StringBuffer ruleJs;

	/** The message js. */
	private StringBuffer messageJs;

	/**
	 * Adds the rule.
	 *
	 * @param selector the selector
	 * @param rule the rule
	 * @param ruleParm the rule parm
	 */
	public void addRule(String selector, String rule, String ruleParm) {
		addRule(selector, rule, ruleParm, "");
	}

	/**
	 * Adds the rule.
	 *
	 * @param selector the selector
	 * @param rule the rule
	 * @param ruleParm the rule parm
	 * @param message the message
	 */
	public void addRule(String selector, String rule, String ruleParm, String message) {

		HashMap<String, Rule> ruleSet = this.getRuleSet(selector);
		Rule r;
		if (ruleSet.containsKey(rule)) {
			r = ruleSet.get(rule);
		} else {
			r = new Rule();
			ruleSet.put(rule, r);
		}

		// Set the parm and message
		if (ruleParm != "") {
			r.parm = ruleParm;
		}
		if (message != "") {
			r.message = message;
		}

	}

	/**
	 * Builds the javascript.
	 */
	private void buildJavascript() {

		ruleJs = new StringBuffer();
		messageJs = new StringBuffer();

		for (String selector : this.rules.keySet()) {
			HashMap<String, Rule> ruleSet = this.rules.get(selector);

			StringBuffer tmpR = new StringBuffer();
			StringBuffer tmpM = new StringBuffer();
			for (String rule : ruleSet.keySet()) {
				Rule r = ruleSet.get(rule);
				rule = "\""+rule +"\"";
				if (r.parm.length() > 0){
					tmpR.append(rule)
						.append(":")
						.append(r.parm)
						.append(",");
				}
				if (r.message != null && r.message.length() > 0){
					tmpM.append(rule)
						.append(":\"")
						.append(r.message)
						.append("\",");
				}
			}

			selector = '"' + selector + '"';

			if (tmpR.length() > 0 ) {
				ruleJs.append(selector).append(":{").append(
						tmpR.substring(0, tmpR.length() - 1)).append("},\n");
			}
			if (tmpM.length() > 0) {
				messageJs.append(selector).append(":{").append(
						tmpM.substring(0, tmpM.length() - 1)).append("},\n");
			}
		}
		// remove any trailing commas
		if (ruleJs.length() > 0) {
			ruleJs.setLength(ruleJs.length() - 2);
		}
		if (messageJs.length() > 0) {
			messageJs.setLength(messageJs.length() - 2);
		}
	}

	/**
	 * Gets the message js.
	 *
	 * @return the message js
	 */
	public StringBuffer getMessageJS() {
		if (this.messageJs == null) {
			this.buildJavascript();
		}
		return messageJs;
	}

	/**
	 * Gets the rule js.
	 *
	 * @return the rule js
	 */
	public StringBuffer getRuleJS() {
		if (this.ruleJs == null) {
			this.buildJavascript();
		}
		return ruleJs;
	}

	/**
	 * Gets the rules.
	 *
	 * @return the rules
	 */
	public HashMap<String, HashMap<String, Rule>> getRules() {
		return rules;
	}

	/**
	 * Gets the rule set.
	 *
	 * @param selector the selector
	 * @return the rule set
	 */
	private HashMap<String, Rule> getRuleSet(String selector) {
		if (!this.rules.containsKey(selector)) {
			HashMap<String, Rule> ruleSet = new HashMap<String, Rule>();
			this.rules.put(selector, ruleSet);
			return ruleSet;
		} else {
			return this.rules.get(selector);
		}
	}
}
