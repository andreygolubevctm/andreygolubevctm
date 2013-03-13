package com.disc_au.web.go.xml;

import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.UnsupportedEncodingException;
import java.util.ArrayList;

import javax.xml.parsers.ParserConfigurationException;
import javax.xml.parsers.SAXParser;
import javax.xml.parsers.SAXParserFactory;

import org.xml.sax.Attributes;
import org.xml.sax.SAXException;
import org.xml.sax.helpers.DefaultHandler;

// TODO: Auto-generated Javadoc
/**
 * The Class XmlParser.
 * 
 * @author aransom
 * @version 1.0
 */

public class XmlParser {

	/**
	 * The Class XmlNodeHandler.
	 */
	public class XmlNodeHandler extends DefaultHandler {

		/** The always append. */
		boolean alwaysAppend = true;

		/** The node. */
		XmlNode node = null;

		/**
		 * Instantiates a new xml node handler.
		 */
		public XmlNodeHandler() {
			super();
		}

		/**
		 * Instantiates a new xml node handler.
		 *
		 * @param alwaysAppend the always append
		 */
		public XmlNodeHandler(boolean alwaysAppend) {
			super();
			this.alwaysAppend = alwaysAppend;
		}

		/**
		 * Instantiates a new xml node handler.
		 *
		 * @param alwaysAdd the always add
		 * @param node the node
		 */
		public XmlNodeHandler(boolean alwaysAdd, XmlNode node) {
			this(alwaysAdd);
			this.node = node;
		}

		/* (non-Javadoc)
		 * @see org.xml.sax.helpers.DefaultHandler#characters(char[], int, int)
		 */
		@Override
		public void characters(char[] ch, int start, int length)
				throws SAXException {
			node.setText(node.getText() + new String(ch, start, length));
		}

		/* (non-Javadoc)
		 * @see org.xml.sax.helpers.DefaultHandler#endElement(java.lang.String, java.lang.String, java.lang.String)
		 */
		@Override
		public void endElement(String uri, String localName, String qName)
				throws SAXException {
			XmlNode p = node.getParent();
			if (p != null) {
				node = p;
			}
		}

		/* (non-Javadoc)
		 * @see org.xml.sax.helpers.DefaultHandler#startElement(java.lang.String, java.lang.String, java.lang.String, org.xml.sax.Attributes)
		 */
		@Override
		public void startElement(String uri, String localName, String qName,
				Attributes attributes) throws SAXException {

			XmlNode child = null;
			boolean addChild = false;

			if (!alwaysAppend && node != null) {
				child = node.getFirstChild(qName);
			}

			if (child == null) {
				child = new XmlNode(qName);
				addChild = true;
			}
			for (int i = 0; i < attributes.getLength(); i++) {
				child.setAttribute(attributes.getQName(i), attributes
						.getValue(i));
			}
			if (addChild && node != null) {
				node.addChild(child);
			}
			node = child;
		}
	}

	/**
	 * Log.
	 *
	 * @param data the data
	 */
	public static void log(String data) {
		System.out.println(data);
	}

	/**
	 * The main method.
	 *
	 * @param args the arguments
	 */
	public static void main(String[] args) {

		String testData = "<request><maxDemerits count=\"0\" /></request>";
		
		try {
			XmlParser p = new XmlParser();
			XmlNode n = p.parse(testData);
			System.out.println(n.getXML());
			
			
			XmlNode d  = (XmlNode) n.getFirstChild("maxDemerits");
			//String  x  = (String) n.get("maxDemerits/@count");
			
			System.out.print(d);
			//System.out.print(x);
			
		} catch (SAXException e) {
			e.printStackTrace();
		}
	}

	/**
	 * Test.
	 *
	 * @param n the n
	 * @param xpath the xpath
	 */
	@SuppressWarnings("unchecked")
	public static void test(XmlNode n, String xpath) {
		log("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~");
		log("  xpath: " + xpath);

		Object o = n.get(xpath);
		if (o instanceof String) {
			log(" result: STRING:" + (String) o);

		} else if (o instanceof XmlNode) {
			log("         NODEXML:" + ((XmlNode) o).getXML());

		} else {
			ArrayList<XmlNode> result = (ArrayList<XmlNode>) o;
			if (result != null) {
				for (Object c : result) {
					if (c instanceof XmlNode) {
						log("         NODE:" + ((XmlNode) c).getXML());
					} else {
						log("         STRING:" + (String) c);
					}
				}
			} else {
				log("         NULL");
			}
		}
	}

	/** The sax parser. */
	private SAXParser saxParser;

	/**
	 * Instantiates a new xml parser.
	 */
	public XmlParser() {
		SAXParserFactory factory = SAXParserFactory.newInstance();
		factory.setValidating(false);
		;

		try {
			this.saxParser = factory.newSAXParser();

		} catch (ParserConfigurationException e) {
			e.printStackTrace();
		} catch (SAXException e) {
			e.printStackTrace();
		}
	}

	/**
	 * Parses the.
	 *
	 * @param inStream the in stream
	 * @return the xml node
	 * @throws SAXException the sAX exception
	 */
	public XmlNode parse(InputStream inStream) throws SAXException {
		return parse(inStream, true);
	}

	/**
	 * Parses the.
	 *
	 * @param inStream the in stream
	 * @param alwaysAppend the always append
	 * @return the xml node
	 * @throws SAXException the sAX exception
	 */
	public XmlNode parse(InputStream inStream, boolean alwaysAppend)
			throws SAXException {
		XmlNodeHandler handler = new XmlNodeHandler(alwaysAppend);
		try {
			saxParser.parse(inStream, handler);
		} catch (IOException e) {
			e.printStackTrace();
		}
		return handler.node;
	}

	/**
	 * Parses the.
	 *
	 * @param xml the xml
	 * @return the xml node
	 * @throws SAXException the sAX exception
	 */
	public XmlNode parse(String xml) throws SAXException {
		return parse(xml, true);
	}

	/**
	 * Parses the.
	 *
	 * @param xml the xml
	 * @param alwaysAdd the always add
	 * @return the xml node
	 * @throws SAXException the sAX exception
	 */
	public XmlNode parse(String xml, boolean alwaysAdd) throws SAXException {
		try {
			return parse(new ByteArrayInputStream(xml.getBytes("UTF-8")),
					alwaysAdd);
		} catch (UnsupportedEncodingException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return null;
	}
}
