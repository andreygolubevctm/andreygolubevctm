/**  =========================================   */
/**  Gadget Object Framework: InsertMarkerCache Class
 *   $Id$
 * ©2012 Auto & General Holdings Pty Ltd         */

package com.ctm.web.core.web.go;

import java.util.HashMap;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import javax.servlet.jsp.PageContext;

import org.json.simple.JSONObject;

import com.ctm.web.core.web.go.jQuery.JQueryInsertMarker;
import com.ctm.web.core.web.go.jQuery.ValidationRules;

public class InsertMarkerCache {
	/** The Constant INSERT_MARKER_REGEX. */
	private static final String INSERT_MARKER_REGEX = "(<!|//|/\\*)\\-\\-INSERT:.*?\\-\\-(>|//|\\*/)";

	/** The Constant PATTERN_INSERT_MARKER. */
	private static final Pattern PATTERN_INSERT_MARKER = Pattern
			.compile(INSERT_MARKER_REGEX);

	/** The insert markers. */
	private HashMap<String, InsertMarker> insertMarkers;

	/** The validation rules. */
	private ValidationRules validationRules = new ValidationRules();

	@SuppressWarnings("unused")
	private boolean encodeQuotes = false;


	/**
	 * Adds the insert marker value.
	 *
	 * @param markerName the marker name
	 * @param value the value
	 * @param conditional
	 */
	public void addInsertMarkerValue(String markerName, String value) {
		this.getInsertMarker(markerName).addData(value);
	}


	public void reset() {
		this.insertMarkers = null;
	}
	/**
	 * Gets the insert marker.
	 *
	 * @param name the name
	 * @return the insert marker
	 */
	public InsertMarker getInsertMarker(String name) {
		return this.getInsertMarker(name,InsertMarker.Format.UNKNOWN);
	}

	/**
	 * Gets the insert marker.
	 *
	 * @param name the name
	 * @return the insert marker
	 */
	public InsertMarker getInsertMarker(String name, InsertMarker.Format format) {
		HashMap<String, InsertMarker> map = this.getInsertMarkers();

		InsertMarker marker;
		if (!map.containsKey(name)) {

			if (name.startsWith(JQueryInsertMarker.MARKER_PREFIX)) {
				marker = new JQueryInsertMarker(name, this.validationRules, format);
			} else {
				marker = new InsertMarker(name,format);
			}

			map.put(name, marker);
		} else {
			marker = map.get(name);
		}
		return marker;
	}

	/**
	 * Gets the insert markers.
	 *
	 * @return the insert markers
	 */
	private HashMap<String, InsertMarker> getInsertMarkers() {
		if (this.insertMarkers == null) {
			this.insertMarkers = new HashMap<String, InsertMarker>();
		}
		return this.insertMarkers;
	}


	/**
	 * Gets the validation rules.
	 *
	 * @return the validation rules
	 */
	public ValidationRules getValidationRules() {
		return validationRules;
	}


	/**
	 * Apply inserts.
	 *
	 * @param map the map
	 * @param body the body
	 * @return the string
	 */
	public String applyInserts(String body) {
		// public static String applyInserts(PageContext pageContext, String
		// body){
		// HashMap<String,StringBuffer> map = getInsertMarkerMap(pageContext);
		StringBuffer sb = new StringBuffer();

		// Find each insert marker
		Matcher m = PATTERN_INSERT_MARKER.matcher(body);
		int markerStart = 0;
		int prevStart = 0;

		while (m.find(markerStart)) {
			markerStart = m.start();

			int markerEnd = m.end();

			// Copy the contents up to and including the marker
			sb.append(body.substring(prevStart, markerEnd));

			// As html comments end with 3 chars "-->" rather than 4 e.g. "--//"
			// we need to only decrease by 2 .. not 3;
			int nameEnd = markerEnd - 4;

			// Test the 2nd character - it will tell us what format of comment
			// we're using
			if (body.charAt(markerStart + 1) == '!') {
				nameEnd++;
			}
			sb.append('\n');

			String markerName = body.substring(markerStart + 11, nameEnd);
			if (this.insertMarkers.containsKey(markerName)) {
				InsertMarker marker = this.getInsertMarker(markerName);

				if (marker.getFormat() == InsertMarker.Format.JSON){
					String chunk = this.getInsertMarker(markerName).getData().toString();
					chunk = JSONObject.escape(chunk);

					// remove the marker
					int markerLen = (markerEnd-markerStart)+1;
					int sbLen = sb.length();

					sb.delete(sbLen-markerLen, sbLen);
					sb.append(chunk);

				} else {
					sb.append( marker.getData());
				}


			} else {
				// + markerName+"' but doesn't actually set any values to it.");
			}
			markerStart = markerEnd;
			prevStart = markerEnd;
		}

		// Add any addition content required
		if (prevStart < body.length()) {
			sb.append(body.substring(prevStart));
		}

		return sb.toString();
	}
	public static InsertMarkerCache getInsertMarkerCache(PageContext pageContext){
		InsertMarkerCache cache;
		if (pageContext.findAttribute("insertMarkerCache") != null){
			cache = (InsertMarkerCache) pageContext.findAttribute("insertMarkerCache");
		} else {
			cache  = new InsertMarkerCache();
			pageContext.setAttribute("insertMarkerCache", cache,PageContext.REQUEST_SCOPE);
		}

		return cache;
	}
	public void setEncodeQuotes(boolean encode){
		this.encodeQuotes  = encode;
	}
}
