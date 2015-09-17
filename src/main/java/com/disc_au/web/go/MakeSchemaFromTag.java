package com.disc_au.web.go;

import com.disc_au.web.go.xml.XmlNode;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.IOException;
import java.util.ArrayList;

import static com.ctm.logging.LoggingArguments.kv;

// TODO: Auto-generated Javadoc
/**
 * The Class MakeSchemaFromTag.
 *
 * @author aransom
 * @version 1.0
 */

public class MakeSchemaFromTag {

	private static final Logger LOGGER = LoggerFactory.getLogger(MakeSchemaFromTag.class.getName());

	/** The Constant TAG_SUFFIX. */
	public static final String TAG_SUFFIX = ".tag";

	/**
	 * Gets the attrib.
	 *
	 * @param line the line
	 * @param attribName the attrib name
	 * @return the attrib
	 */
	public static String getAttrib(String line, String attribName) {
		int attribPos = line.indexOf(attribName);
		int equalPos = line.indexOf("=", attribPos);

		if (attribPos > -1 && equalPos > -1) {
			StringBuffer attrib = new StringBuffer();
			boolean fin = false;
			for (int i = equalPos + 1; i < line.length() && !fin; i++) {
				char c = line.charAt(i);
				switch (c) {
				case '\'':
				case '"':
					fin = (attrib.length() > 0);
					break;
				default:
					attrib.append(c);
				}
			}
			return attrib.toString();
		}
		return "";
	}

	/**
	 * Gets the tag attributes.
	 *
	 * @param file the file
	 * @return the tag attributes
	 */
	public static ArrayList<String[]> getTagAttributes(File file) {
		ArrayList<String[]> attribs = new ArrayList<String[]>();
		StringBuffer sb = new StringBuffer();

		// Load the file line by line
		try {
			BufferedReader in = new BufferedReader(new FileReader(file));
			String str;
			while ((str = in.readLine()) != null) {
				sb.append(str);
			}
			in.close();
		} catch (IOException e) {
			LOGGER.error("Failed to read file. {}", kv("file",file) , e);
		}

		// Search for <%@ attribute ... %>
		int startPos = sb.indexOf("<%@");
		while (startPos > -1) {

			int endPos = sb.indexOf("%>", startPos);
			String line = sb.substring(startPos + 3, endPos).trim()
					.toLowerCase();
			if (line.startsWith("attribute")) {

				String[] a = new String[3];
				a[0] = getAttrib(line, "name");
				a[1] = getAttrib(line, "required");
				a[2] = getAttrib(line, "description");
				attribs.add(a);
			}
			startPos = sb.indexOf("<%@", endPos + 1);
		}
		return attribs;
	}

	/**
	 * Gets the tag rules.
	 *
	 * @param tagFile the tag file
	 * @return the tag rules
	 */
	public static XmlNode getTagRules(File tagFile) {

		String nodeName = tagFile.getName();
		if (nodeName.endsWith(TAG_SUFFIX)) {
			nodeName = nodeName.substring(0, nodeName.length()
					- TAG_SUFFIX.length());
		}

		XmlNode node = new XmlNode("xs:element");
		node.setAttribute("name", nodeName);
		node.setAttribute("maxOccurs", "unbounded");

		ArrayList<String[]> attribs = getTagAttributes(tagFile);
		for (String[] attrib : attribs) {

			XmlNode attribNode = new XmlNode("xs:attribute");
			attribNode.setAttribute("name", attrib[0]);

			if (attrib[1].equals("required")) {
				attribNode.setAttribute("required", attrib[1]);
			}

			// Set the type
			if (attrib[0].equals("required")) {
				attribNode.setAttribute("type", "boolean");

			} else if (attrib[0].equals("rtexpvalue")) {
				attribNode.setAttribute("type", "boolean");
			}

			XmlNode anno = new XmlNode("xs:annotation");
			anno.addChild(new XmlNode("xs:documentation", "Doc: " + attrib[2]));
			anno.addChild(new XmlNode("xs:appinfo", "AppInfo: " + attrib[2]));

			attribNode.addChild(anno);
			node.addChild(attribNode);
		}

		return node;
	}

}
