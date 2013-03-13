package com.disc_au.web.go.xml;

import java.text.CharacterIterator;
import java.text.StringCharacterIterator;
import java.util.ArrayList;
import java.util.Collection;
import java.util.HashMap;
import java.util.Map;
import java.util.Set;

// TODO: Auto-generated Javadoc
/**
 * The Class XmlNode.
 * 
 * @author aransom
 * @version 1.0
 */

@SuppressWarnings("unchecked")
public class XmlNode implements Map {

	/** The text value of the node. */
	public static String TEXT = "text()";

	/** The node name. */
	public static String NODE_NAME = "name()";

	/**
	 * Escape chars.
	 *
	 * @param data the data
	 * @return the string
	 */
	public static String escapeChars(String data) {
		final StringBuffer result = new StringBuffer();
		final StringCharacterIterator iterator = new StringCharacterIterator(
				data);

		char c = iterator.current();
		while (c != CharacterIterator.DONE) {
			// Test for escapable chars
			switch (c) {
			case '<':
				result.append("&lt;");
				break;
			case '>':
				result.append("&gt;");
				break;
			case '\"':
				result.append("&quot;");
				break;
			case '\'':
				result.append("&#039;");
				break;
			case '\\':
				result.append("&#092;");
				break;
			case '&':
				result.append("&amp;");
				break;
			case 96:
				result.append("&quot;");
				break;
			case 180:
				result.append("&quot;");
				break;
			case 8220:
				result.append("&quot;");
				break;
			case 8221:
				result.append("&quot;");
				break;
			default:
				// Only add if in the "normal" character range
				// Basic chars (i.e. a-z, A-Z, 0-9 etc)
				if (c > 31 && c < 127) {
					result.append(c);
				} else {
					result.append(' ');
				}
			}
			c = iterator.next();
		}
		return result.toString();
	}

	/**
	 * The main method.
	 *
	 * @param args the arguments
	 */
	public static void main(String[] args) {
		/**
		XmlNode root = new XmlNode("root");

		XmlNode child1 = new XmlNode("child");
		child1.setAttribute("name", "One");

		XmlNode last1 = child1.addChild(new XmlNode("last"));
		last1.setText("With a value");

		root.addChild(child1);

		XmlNode child2 = root.addChild(new XmlNode("child"));
		child2.addChild(new XmlNode("last", "With another value"));
		child2.setAttribute("name", "Two");

		XmlNode child3 = root.addChild(new XmlNode("child"));
		child3.setAttribute("name", "Three");
		child3.addChild(new XmlNode("last", "Child 3 has 3 lasts (1 of 3)"));
		child3.addChild(new XmlNode("last", "Child 3 has 3 lasts (2 of 3)"));

		XmlNode fin = child3.addChild(new XmlNode("last",
				"Child 3 has 3 lasts (3 of 3)"));
		fin.setAttribute("colour", "green");

		System.out.println(root.getXML());

		System.out.println(root.get("child[2]/@name"));
		System.out.println(child2.get("@name"));

		for (XmlNode n : (ArrayList<XmlNode>) root.get("child")) {
			System.out.println(n.getXML());
		}

		System.out.println("--------------");
		System.out.println(root.get("child[2]/last/TEXT_ELEMENT"));
		System.out.println(root.get("child[2]/last[1]/TEXT_ELEMENT"));
		System.out.println(root.get("child[2]/last[2]"));
		System.out.println(root.get("child[2]/last[2]/@colour"));
		**/
		
		XmlNode n1 = new XmlNode("request");
		XmlNode n2 = new XmlNode("maxDemerits");
		//n2.addChild(child)
		n2.attributes.put("count", "0");
		//XmlNode n3 = new XmlNode("maxDemerit");
		
		n1.addChild(n2);
		System.out.println(n1);
		
		
	}

	/** The node name. */
	protected String nodeName; // This XmlNode's node name
	
	/** The attributes. */
	protected HashMap<String, String> attributes; // This XmlNode's Attributes

	/** The children. */
	protected ArrayList<XmlNode> children; // This XmlNode's children
	
	/** The text. */
	protected String text; // Any Text values for this XmlNode

	/** The parent. */
	protected XmlNode parent; // This XmlNode's parent

	/**
	 * Instantiates a new xml node.
	 *
	 * @param nodeName the node name
	 */
	public XmlNode(String nodeName) {
		this.nodeName = nodeName;
	}

	/**
	 * Instantiates a new xml node.
	 *
	 * @param nodeName the node name
	 * @param text the text
	 */
	public XmlNode(String nodeName, String text) {
		this.nodeName = nodeName;
		this.setText(text);
	}

	/**
	 * Adds the child.
	 *
	 * @param child the child to add
	 * @return the xml node
	 */
	public XmlNode addChild(XmlNode child) {
		if (this.children == null) {
			this.children = new ArrayList<XmlNode>();
		}
		this.children.add(child);
		child.setParent(this);
		return child;
	}

	/**
	 * Adds the element.
	 *
	 * @param name the name
	 * @param value the value
	 */
	public void addElement(String name, String value) {
		this.addChild(new XmlNode(name, value));
	}

	/* (non-Javadoc)
	 * @see java.util.Map#clear()
	 */

	public void clear() {
		this.attributes = null;
		this.children = null;
		this.text = null;
	}

	/* (non-Javadoc)
	 * @see java.util.Map#containsKey(java.lang.Object)
	 */

	public boolean containsKey(Object key) {
		return true;
	}

	/* (non-Javadoc)
	 * @see java.util.Map#containsValue(java.lang.Object)
	 */

	public boolean containsValue(Object value) {
		return false;
	}

	/* (non-Javadoc)
	 * @see java.util.Map#entrySet()
	 */
	public Set entrySet() {
		return null;
	}

	/* (non-Javadoc)
	 * @see java.util.Map#get(java.lang.Object)
	 */
	public Object get(Object key) {
		ArrayList<SearchTerm> chain = null;

		// Check .. was an xpath given?
		if (key instanceof String) {
			chain = SearchTerm.makeSearchChain((String) key);

			// otherwise assume a search chain was passed
		} else if (key instanceof ArrayList) {
			chain = (ArrayList<SearchTerm>) key;
		}

		// Get the first search term
		SearchTerm s = chain.get(0);
		chain.remove(0);

		// The search term is text() .. return this node's text
		if (s.nodeName.equals(TEXT)) {
			return this.getText();

			// The search term is name() .. return this node's name
		} else if (s.nodeName.equals(NODE_NAME)) {
			return this.nodeName;

			// Searching for an attribute
		} else if (s.nodeName.startsWith("@")) {
			if (this.attributes != null) {
				String attrName = s.nodeName.substring(1);
				return this.attributes.get(attrName);
			} else {
				return "";
			}

			// otherwise look for a child that matches the search term
		} else if (this.children != null) {

			// Create arraylist to hold any children that match
			ArrayList<Object> matches = new ArrayList<Object>();
			int idx = 0;

			// Iterate through the children looking for a match
			// if we find one, we'll add it to the arraylist
			for (XmlNode child : this.children) {
				if (child.matches(s)) {

					// If the search term doesn't have a child index specified,
					// or..
					// If the child's index matches the one we're searching for.
					if (s.childIdx == -1 || s.childIdx == idx) {

						// Are there any more levels on the chain?
						// If there are, we need to pass the remainder of the
						// chain down to all the children.
						if (!chain.isEmpty()) {
							Object childMatches = child.get(chain.clone());

							// We didn't match any children
							if (childMatches == null) {

							} else if (childMatches instanceof ArrayList) {
								matches.addAll((ArrayList) childMatches);

							} else {
								matches.add(childMatches);
							}

							// If this is the last level on the chain,
							// And this node has children - add the node
						} else if (child.hasChildren()) {
							matches.add(child);

							// Otherwise add the child's text value
						} else {
							matches.add(child.getText());
						}

					}

					idx++;
				}
			}

			// Check - did we only find a single match?
			// If so, just return the single item.
			if (matches.size() == 1) {
				return matches.get(0);
			} else if (matches.size() > 0) {
				return matches;
			}
		}
		return null;
	}

	/**
	 * Gets the attribute.
	 *
	 * @param attrName the attr name
	 * @return the attribute
	 */
	public String getAttribute(String attrName) {
		if (this.attributes != null && this.attributes.containsKey(attrName)) {
			return this.attributes.get(attrName);
		}
		return "";
	}

	/**
	 * Gets the child nodes.
	 *
	 * @param xpath the xpath
	 * @return the child nodes
	 */
	public ArrayList<XmlNode> getChildNodes(String xpath) {
		SearchTerm s = new SearchTerm(xpath);
		ArrayList<XmlNode> res = new ArrayList<XmlNode>();
		if (this.children != null) {
			for (XmlNode n : this.children) {
				if (n.matches(s)) {
					res.add(n);
				}
			}
		}
		return res;
	}

	/**
	 * Gets the first child.
	 *
	 * @param s the s
	 * @return the first child
	 */
	public XmlNode getFirstChild(SearchTerm s) {
		if (this.children != null) {
			for (XmlNode child : children) {
				if (child.matches(s)) {
					return child;
				}
			}
		}
		return null;
	}

	/**
	 * Gets the first child.
	 *
	 * @param nodeName the node name
	 * @return the first child
	 */
	public XmlNode getFirstChild(String nodeName) {
		return getFirstChild(new SearchTerm(nodeName));
	}

	/**
	 * Gets the node name.
	 *
	 * @return the node name
	 */
	public String getNodeName() {
		return this.nodeName;
	}

	/**
	 * Gets the parent.
	 *
	 * @return the parent
	 */
	public XmlNode getParent() {
		return this.parent;
	}

	/**
	 * Gets the text.
	 *
	 * @return the text
	 */
	public String getText() {
		return (this.text == null) ? "" : this.text;
	}

	/**
	 * Gets the XML.
	 *
	 * @return the XML
	 */
	public String getXML() {
		return getXML(false);
	}

	/**
	 * Gets the XML.
	 *
	 * @param escapeEntities the escape entities
	 * @return the XML
	 */
	public String getXML(boolean escapeEntities) {
		StringBuffer sb = new StringBuffer();
		sb.append("<").append(this.nodeName);
		// Add attributes
		if (this.attributes != null && !this.attributes.isEmpty()) {
			for (String k : this.attributes.keySet()) {
				sb.append(' ').append(k).append("=\"");

				String attribValue = this.attributes.get(k);
				if (escapeEntities) {
					sb.append(escapeChars(attribValue));
				} else {
					sb.append(attribValue);
				}
				sb.append("\"");

			}
		}

		// Add children
		if (this.text == null && this.children == null) {
			sb.append("/>");

		} else {
			sb.append(">");
			if (this.children != null) {
				for (XmlNode child : this.children) {
					sb.append(child.getXML(escapeEntities));
				}
			} else if (this.text != null && !this.text.matches("\\s")) {
				if (escapeEntities) {
					sb.append(escapeChars(this.getText()));
				} else {
					sb.append(this.getText());
				}
			}
			sb.append("</").append(this.nodeName).append('>');
		}
		return sb.toString();
	}

	/**
	 * Checks for child.
	 *
	 * @param searchTerm the searchTerm
	 * @return true, if successful
	 */
	public boolean hasChild(SearchTerm searchTerm) {
		if (this.children != null) {
			for (XmlNode child : children) {
				if (child.matches(searchTerm)) {
					return true;
				}
			}
		}
		return false;
	}
	/**
	 * Checks for child.
	 *
	 * @param searchTerm the searchTerm
	 * @return true, if successful
	 */
	public String childExists(String searchTerm) {
		if (this.hasChild(searchTerm)) {
			return "true";
		} else {
			return "false";
		}
	}

	/**
	 * Checks for child.
	 *
	 * @param nodeName the node name
	 * @return true, if successful
	 */
	public boolean hasChild(String nodeName) {
		return hasChild(new SearchTerm(nodeName));
	}

	/**
	 * Checks for children.
	 *
	 * @return true, if successful
	 */
	public boolean hasChildren() {
		return this.children != null;
	}

	/* (non-Javadoc)
	 * @see java.util.Map#isEmpty()
	 */

	public boolean isEmpty() {
		return (this.children == null);
	}

	/* (non-Javadoc)
	 * @see java.util.Map#keySet()
	 */

	public Set keySet() {
		return null;
	}


	/**
	 * Match attribute.
	 *
	 * @param search the search
	 * @return true, if successful
	 */
	public boolean matchAttribute(SearchTerm search) {
		if (this.attributes != null) {

			// If any attribute, and value is empty - return true if we have any
			// attributes
			if (search.attrName.equals("*") && search.attrValue.equals("")) {
				return (this.attributes != null);

				// Any attribute name, but matching a value
			} else if (search.attrName.equals("*")) {

				for (String attribVal : this.attributes.values()) {
					if (attribVal.equals(search.attrValue)) {
						return true;
					}
				}
				return false;

				// Specific attribute name specified, check if we have an
				// attribute by that name
			} else if (this.attributes.containsKey(search.attrName)) {

				// If we do, check if a value was specified
				if (search.attrValue.length() == 0
						|| search.attrValue.equals("*")
						|| this.attributes.get(search.attrName).equals(
								search.attrValue)) {
					return true;
				}

			}
		}
		return false;
	}

	/**
	 * Matches.
	 *
	 * @param search the search
	 * @return true, if successful
	 */
	public boolean matches(SearchTerm search) {
		if (search.nodeName != null) {
			if (search.nodeName.equals("") || search.nodeName.equals("*")
					|| search.nodeName.equals(this.nodeName)) {
				// Successful node name match
			} else {
				return false;
			}
		}

		// Now check attributes
		if (search.hasAttribute) {
			return this.matchAttribute(search);
		} else {
			return true;
		}
	}

	/* (non-Javadoc)
	 * @see java.util.Map#put(java.lang.Object, java.lang.Object)
	 */

	public Object put(Object key, Object value) {
		ArrayList<SearchTerm> chain = null;

		// Check .. was an xpath given?
		if (key instanceof String) {
			chain = SearchTerm.makeSearchChain((String) key);

			// otherwise assume a search chain was passed
		} else if (key instanceof ArrayList) {
			chain = (ArrayList<SearchTerm>) key;
		}

		// Get the first search term, and check if this node matches it.
		SearchTerm s = null;
		if (!chain.isEmpty()) {
			s = chain.get(0);
			chain.remove(0);

		} else if (value instanceof String) {
			this.setText((String) value);
			return this;

		} else if (value instanceof XmlNode) {
			this.addChild((XmlNode) value);
			return null;

		} else {
			return null;
		}

		// Setting the text for this node
		if (s.nodeName.equals(TEXT)) {
			this.setText((String) value);

			// Setting the node name for this node
		} else if (s.nodeName.equals(NODE_NAME)) {
			this.nodeName = (String) value;

			// Setting an attribute for this node
		} else if (s.nodeName.startsWith("@")) {
			String attrName = s.nodeName.substring(1);
			if (this.attributes == null) {
				this.attributes = new HashMap<String, String>();
			}
			this.attributes.put(attrName, (String) value);

			// Pass it to the first child
		} else {

			int idx = 0;
			XmlNode matchedChild = null;
			if (this.children != null) {
				for (XmlNode child : this.children) {
					if (matchedChild == null && child.matches(s)) {
						if (s.childIdx == -1 || idx == s.childIdx) {
							matchedChild = child;
						}
						idx++;
					}
				}
			}
			if (matchedChild == null) {
				matchedChild = this.addChild(SearchTerm.nodeFromSearchTerm(s));
			}
			matchedChild.put(chain, value);
		}

		return null;
	}

	/* (non-Javadoc)
	 * @see java.util.Map#putAll(java.util.Map)
	 */

	public void putAll(Map m) {
	}

	/* (non-Javadoc)
	 * @see java.util.Map#remove(java.lang.Object)
	 */

	public Object remove(Object key) {
		ArrayList<SearchTerm> chain = null;

		// Check .. was an xpath given?
		if (key instanceof String) {
			chain = SearchTerm.makeSearchChain((String) key);

			// otherwise assume a search chain was passed
		} else if (key instanceof ArrayList) {
			chain = (ArrayList<SearchTerm>) key;
		}

		// Get the first search term, and check if this node matches it.
		SearchTerm s = chain.get(0);
		chain.remove(0);

		// Removing the text for this node
		if (s.nodeName.equals(TEXT)) {
			this.setText("");

			// Removing an attribute for this node
		} else if (s.nodeName.startsWith("@")) {
			String attrName = s.nodeName.substring(1);
			if (this.attributes != null
					&& this.attributes.containsKey(attrName)) {
				this.attributes.remove(attrName);
				if (this.attributes.isEmpty()) {
					this.attributes = null;
				}
			}

			// Pass it to the first child
		} else if (this.children != null) {
			ArrayList<XmlNode> toRemove = new ArrayList<XmlNode>();
			for (XmlNode child : this.children) {
				if (child.matches(s)) {

					if (chain.isEmpty()) {
						toRemove.add(child);
					} else {
						child.remove(chain);
					}

				}
			}
			// Check if there are any children to remove
			if (!toRemove.isEmpty()) {
				for (XmlNode child : toRemove) {
					this.removeChild(child);
				}
			}
		}

		return null;
	}

	/**
	 * Removes the child.
	 *
	 * @param nodeName the node name
	 */
	public void removeChild(String nodeName) {
		if (this.children != null) {
			XmlNode toRemove = null;
			for (XmlNode n : this.children) {
				if (n.nodeName.equals(nodeName)) {
					toRemove = n;
				}
			}
			if (toRemove != null) {
				this.removeChild(toRemove);
			}
		}
	}

	/**
	 * Removes the child.
	 *
	 * @param child the child
	 * @return the xml node
	 */
	public XmlNode removeChild(XmlNode child) {
		if (this.children != null && this.children.contains(child)) {
			this.children.remove(child);
		}
		return child;
	}

	/**
	 * Sets the attribute.
	 *
	 * @param name the name
	 * @param value the value
	 */
	public void setAttribute(String name, String value) {
		if (this.attributes == null) {
			this.attributes = new HashMap<String, String>();
		}
		this.attributes.put(name, value);
	}

	/**
	 * Sets the parent.
	 *
	 * @param node the new parent
	 */
	public void setParent(XmlNode node) {
		this.parent = node;
	}

	/**
	 * Sets the text.
	 *
	 * @param text the new text
	 */
	public void setText(String text) {
		this.text = text;
	}

	/* (non-Javadoc)
	 * @see java.util.Map#size()
	 */

	public int size() {
		if (this.children != null) {
			return this.children.size();
		}
		return 0;
	}

	/* (non-Javadoc)
	 * @see java.lang.Object#toString()
	 */

	public String toString() {
		return this.getXML(false);
	}

	/* (non-Javadoc)
	 * @see java.util.Map#values()
	 */

	public Collection values() {
		return null;
	}
}
