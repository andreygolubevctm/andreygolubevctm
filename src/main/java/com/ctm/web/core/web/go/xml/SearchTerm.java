package com.ctm.web.core.web.go.xml;

import java.io.Serializable;
import java.util.ArrayList;

/**
 * The Class SearchTerm.
 */
public class SearchTerm implements Serializable {
	
	/** The node name. */
	String nodeName;
	
	/** The attr name. */
	String attrName;
	
	/** The attr value. */
	String attrValue;
	
	/** The child idx. */
	int childIdx = -1;
	
	/** The has attribute. */
	boolean hasAttribute;

	/**
	 * Instantiates a new search term.
	 *
	 * @param searchWord the search word
	 */
	public SearchTerm(String searchWord) {
		int predStart = searchWord.indexOf('[');
		int predEnd = searchWord.indexOf(']');

		// Is there a predicate?
		if (predStart > -1 && predEnd > predStart) {

			// Retrieve the predicate and remove from the search word
			String predicate = searchWord.substring(predStart + 1, predEnd);
			searchWord = searchWord.substring(0, predStart);

			int atPos = predicate.indexOf('@');
			int eqPos = predicate.indexOf('=');
			if (atPos > -1 && eqPos > -1) {
				attrName = predicate.substring(atPos + 1, eqPos).trim();
				attrValue = predicate.substring(eqPos + 1).trim();

				attrValue = attrValue.replace('"', ' ').replace('\'', ' ')
						.trim();
				this.hasAttribute = true;

				// Assume the predicate is an index
			} else if (atPos > -1 && eqPos == -1) {
				attrName = predicate.substring(atPos + 1).trim();
				attrValue = "*";
				this.hasAttribute = true;
			} else {
				try {
					this.childIdx = Integer.valueOf(predicate);
				} catch (Exception e) {
				}

			}
		} else {
			this.hasAttribute = false;
		}
		nodeName = searchWord;
	}

	/* (non-Javadoc)
	 * @see java.lang.Object#toString()
	 */
	@Override
	public String toString() {

		StringBuffer sb = new StringBuffer();
		if (this.nodeName.length() > 0) {
			sb.append(this.nodeName);
		}
		if (this.hasAttribute) {
			sb.append('[').append(this.attrName).append('=').append(
					this.attrValue).append(']');
		}
		return sb.toString();
	}
	/**
	 * Node from search term.
	 *
	 * @param s the s
	 * @return the xml node
	 */
	public static XmlNode nodeFromSearchTerm(SearchTerm s) {
		XmlNode r = new XmlNode(s.nodeName);
		if (s.attrName != null && !s.attrName.equals("*")
				&& s.attrValue != null && !s.attrValue.equals("*")) {
			r.setAttribute(s.attrName, s.attrValue);
		}
		return r;
	}
	/**
	 * Make search chain.
	 *
	 * @param xpath the xpath
	 * @return the array list
	 */
	public static ArrayList<SearchTerm> makeSearchChain(String xpath) {
		ArrayList<SearchTerm> terms = null;

		terms = new ArrayList<SearchTerm>();
		for (String term : xpath.split("/")) {
			terms.add(new SearchTerm(term));
		}
		return terms;
	}	
}
