/**  =========================================   */
/**  Gadget Object Framework: Core Class
 *   $Id$
 * ©2012 Auto & General Holdings Pty Ltd         */

package com.disc_au.web.go;

import java.io.BufferedWriter;
import java.io.ByteArrayInputStream;
import java.io.FileWriter;
import java.io.IOException;
import java.io.InputStream;
import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.Enumeration;

import net.lingala.zip4j.core.ZipFile;
import net.lingala.zip4j.model.ZipParameters;
import net.lingala.zip4j.util.Zip4jConstants;
import net.lingala.zip4j.io.ZipOutputStream;

import com.jcraft.jsch.Channel;
import com.jcraft.jsch.ChannelSftp;
import com.jcraft.jsch.JSch;
import com.jcraft.jsch.Session;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.codec.binary.Base64;
import org.json.JSONException;
import org.json.JSONObject;
import org.json.XML;

import com.disc_au.web.go.xml.XmlNode;

// TODO: Auto-generated Javadoc
/**
 * The Class Gadget.
 *
 * @author aransom
 * @version 1.0
 */

@SuppressWarnings("unchecked")
public class Gadget {

	/**
	 * Adds the document.
	 *
	 * @param data the data
	 * @param xml the xml
	 */
	public static void addDocument(Data data, String xml) {
		data.parse(xml);
	}

	/**
	 * Gets the name from xpath.
	 *
	 * @param xmlPath the xml path
	 * @return the name from xpath
	 */
	public static String getNameFromXpath(String xmlPath) {
		xmlPath = xmlPath.replace("[@idx=", "");
		xmlPath = xmlPath.replace("]", "");
		return xmlPath.replace('/', '_');
	}

	/**
	 * Gets the type.
	 *
	 * @param obj the obj
	 * @return the type
	 */
	public static String getType(Object obj) {
		if (obj instanceof String) {
			return "text";
		} else if (obj instanceof XmlNode) {
			return "node";
		} else if (obj instanceof ArrayList) {
			return "array";
		}
		//return obj.getClass().getName();
		return null;
	}

	/**
	 * Gets the xml.
	 *
	 * @param obj the obj
	 * @return the xml
	 */
	public static String getXml(Object obj) {
		return (String) Data.ensureXml(obj);
	}
	/**
	 * Gets the xml escaping any entities in the content.
	 *
	 * @param obj the obj
	 * @return the xml
	 */
	public static String getEscapedXml(Object obj) {
		return (String) Data.ensureXml(obj,true);
	}

	/**
	 * Gets the xml old.
	 *
	 * @param data the data
	 * @param xpath the xpath
	 * @return the xml old
	 */
	public static String getXmlOLD(Data data, String xpath) {
		Object o = data.get(xpath);

		if (o instanceof XmlNode) {
			return ((XmlNode) o).getXML();

			// If it is an array list, work out if it is an array of nodes
			// If it is .. return all there xml, back to back
			// Otherwise it must be an array of strings
			// In that case just return comma delimitered
		} else if (o instanceof ArrayList) {

			StringBuffer sb = new StringBuffer();
			for (Object item : ((ArrayList) o)) {

				if (item instanceof String) {
					sb.append("<string>").append((String) item).append(
							"</string>");

				} else if (item instanceof XmlNode) {
					sb.append(((XmlNode) item).getXML());

				} else {
					sb.append("<object>").append(item.toString()).append(
							"</object>");
				}

			}
			return sb.toString();

		} else if (o instanceof String) {
			return "<string>" + (String) o + "</string>";
		} else {
			return "<object>" + o.toString() + "</object>";
		}

	}

	/**
	 * Gets the xpath from name.
	 *
	 * @param name the name
	 * @return the xpath from name
	 */
	public static String getXpathFromName(String name) {
		return name.replace('_', '/');
	}

	/**
	 * Checks if is array.
	 *
	 * @param obj the obj
	 * @return the string
	 */
	public static String isArray(Object obj) {
		return (obj instanceof ArrayList) ? "true" : "false";
	}

	/**
	 * Checks if is node.
	 *
	 * @param obj the obj
	 * @return the string
	 */
	public static String isNode(Object obj) {
		return (obj instanceof XmlNode) ? "true" : "false";
	}

	/**
	 * Checks if is text.
	 *
	 * @param obj the obj
	 * @return the string
	 */
	public static String isText(Object obj) {
		return (obj instanceof String) ? "true" : "false";
	}

	/**
	 * Write data.
	 *
	 * @param request the request
	 * @param data the data
	 */
	public static void writeData(HttpServletRequest request, Data data) {

		// Loop through the variables in the request and update data objects
		// accordingly
		Enumeration<String> parmNames = request.getParameterNames();
		while (parmNames.hasMoreElements()) {
			String name = parmNames.nextElement();
			String[] values = request.getParameterValues(name);
			for (String value : values) {
				data.put(getXpathFromName(name), value);
			}
		}
	}

	/**
	 * Write to file.
	 *
	 * @param filepath the filepath
	 * @param data the data
	 */
	public static void writeToFile(String filepath, String data) {
		try {
			BufferedWriter out = new BufferedWriter(new FileWriter(filepath));
			out.write(data);
			out.flush();
			out.close();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
	public static String XMLtoJSON(String xml){
		try {
			JSONObject json = XML.toJSONObject(xml);
			return json.toString();

		} catch (JSONException e) {
			e.printStackTrace();
		}
		return "";
	}
	public static String JSONtoXML(String jsonData){
		try {
			JSONObject json = new JSONObject(jsonData);
			return XML.toString(json);

		} catch (JSONException e) {
			e.printStackTrace();
		}
		return "";
	}
	/**
	 * Convert string to Title case
	 *
	 * @param text String to convert
	 *
	 */
	public static String TitleCase(String text){
		StringBuilder ff = new StringBuilder();

		for(String f: text.split(" ")) {
			if(ff.length()>0) {
				ff.append(" ");
			}
			ff.append(f.substring(0,1).toUpperCase()).append(f.substring(1,f.length()).toLowerCase());
		}
		return ff.toString();
	}
	/**
	 * Convert string to Sentence case
	 *
	 * @param text String to convert
	 *
	 */
	public static String SentenceCase(String text){
		StringBuilder ff = new StringBuilder();

		for(String f: text.split(". ")) {
			if(ff.length()>0) {
				ff.append(". ");
			}
			ff.append(f.substring(0,1).toUpperCase()).append(f.substring(1,f.length()).toLowerCase());
		}
		return ff.toString();
	}

	public static StringBuilder getStringBuilder() {
		return new StringBuilder();
	}

	public static String appendString(StringBuilder sb , String text) {
		sb.append(text);
		return "";
	}

	public static Date AddDays(Date date, int days){
		Calendar cal = Calendar.getInstance();
		cal.setTime (date);
		cal.add (Calendar.DATE, days);
		return cal.getTime();
	}

	public static String replaceAll(String string, String pattern, String replacement) {
		return string.replaceAll(pattern, replacement);
	}

	public static String urlEncode(String value) throws UnsupportedEncodingException {
		return URLEncoder.encode(value, "UTF-8");
	}

	public static String base64Encode(String value) {
		return new String(Base64.encodeBase64(value.getBytes()));
	}

	public static String hexToDec(String value) {
		return Integer.toString(Integer.parseInt(value, 16));
	}

	public static String decToHex(String value) {
		return Integer.toString(Integer.parseInt(value, 10));
	}

	/**
	 * Write to encrypted zip file.
	 *
	 * @param Filepath to save ZIP file
	 * @param Data to store inside ZIP
	 * @param Filename to store inside ZIP
	 * @param Password to encrypt and unlock ZIP
	 */
	public static boolean writeToEncZipFile(String zipFilepath, String data, String internalFilename, String password) {
		boolean success = false;

		InputStream is = null;

		try {
			is = new ByteArrayInputStream(data.getBytes("UTF-8"));

			ZipFile zipFile = new ZipFile(zipFilepath);

			ZipParameters parameters = new ZipParameters();
			parameters.setCompressionMethod(Zip4jConstants.COMP_DEFLATE);

			parameters.setFileNameInZip(internalFilename);
			parameters.setSourceExternalStream(true);
			parameters.setEncryptFiles(true);
			parameters.setEncryptionMethod(Zip4jConstants.ENC_METHOD_AES);
			parameters.setAesKeyStrength(Zip4jConstants.AES_STRENGTH_256);
			parameters.setPassword(password);
			parameters.setCompressionLevel(Zip4jConstants.DEFLATE_LEVEL_NORMAL);

			zipFile.addStream(is, parameters);
			success = true;

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			if (is != null) {
				try {
					is.close();
				} catch (IOException e) {
					e.printStackTrace();
				}
			}
		}
		return success;
	}

	/**
	 * Write to encrypted zip and stream into an SFTP server.
	 *
	 * @param Filename of ZIP file (without path)
	 * @param Data to store inside ZIP
	 * @param Filename to store inside ZIP
	 * @param Password to encrypt and unlock ZIP
	 * @param SFTP host (ip)
	 * @param SFTP username
	 * @param SFTP password
	 */
	public static boolean writeToEncZipToSftp(String zipFilename, String zipData, String zipInternalFilename, String zipPassword, String sftpHost, String sftpUSer, String sFtpPassword) {
		boolean success = false;

		InputStream inputStream = null;
		java.io.ByteArrayOutputStream outStream = null;
		ZipOutputStream zipOutputStream = null;

		Session ftpsession = null;
		Channel channel = null;
		ChannelSftp channelSftp = null;

		int SFTPPORT = 22;
		int TIMEOUT = 20000;
		String SFTPWORKINGDIR = "/";

		try {
			//// Connect to SFTP ////
			JSch jsch = new JSch();
			ftpsession = jsch.getSession(sftpUSer, sftpHost, SFTPPORT);
			ftpsession.setPassword(sFtpPassword);
			java.util.Properties ftpconfig = new java.util.Properties();
			ftpconfig.put("StrictHostKeyChecking", "no");
			ftpsession.setConfig(ftpconfig);

			System.out.println("writeToEncZipToSftp: Connecting...");
			ftpsession.connect(TIMEOUT);
			channel = ftpsession.openChannel("sftp");
			channel.connect(TIMEOUT);

			System.out.println("writeToEncZipToSftp: Connected");
			channelSftp = (ChannelSftp) channel;
			channelSftp.cd(SFTPWORKINGDIR);

			//// Create ZIP stream ////
			outStream = new java.io.ByteArrayOutputStream();
			zipOutputStream = new ZipOutputStream(outStream);

			ZipParameters parameters = new ZipParameters();
			parameters.setFileNameInZip(zipInternalFilename);
			parameters.setSourceExternalStream(true);
			parameters.setPassword(zipPassword);
			parameters.setEncryptFiles(true);
			parameters.setEncryptionMethod(Zip4jConstants.ENC_METHOD_AES);
			parameters.setAesKeyStrength(Zip4jConstants.AES_STRENGTH_256);
			parameters.setCompressionMethod(Zip4jConstants.COMP_DEFLATE);
			parameters.setCompressionLevel(Zip4jConstants.DEFLATE_LEVEL_NORMAL);

			zipOutputStream.putNextEntry(null, parameters);

			//// Read data and write into ZIP ////
			inputStream = new ByteArrayInputStream(zipData.getBytes("UTF-8"));
			byte[] readBuff = new byte[4096];
			int readLen = -1;
			while ((readLen = inputStream.read(readBuff)) != -1) {
				zipOutputStream.write(readBuff, 0, readLen);
			}
			inputStream.close();
			zipOutputStream.closeEntry();
			zipOutputStream.finish();

			//// Write to SFTP ////
			System.out.println("writeToEncZipToSftp: Streaming data into SFTP...");
			InputStream is = new ByteArrayInputStream(outStream.toByteArray());
			channelSftp.put(is, zipFilename);
			System.out.println("writeToEncZipToSftp: Streaming done");

			//// Finished and successful ////
			success = true;
		}
		catch (Exception e) {
			e.printStackTrace();
		} finally {
			// Close SFTP channel //
			if (channelSftp != null) {
				try {
					channelSftp.exit();
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
			// Close Jsch session //
			if (ftpsession != null) {
				try {
					ftpsession.disconnect();
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
		}

		return success;
	}

	/*
	 * Escape a string to make it safe for use in a json value
	 * Escape quotes, \, /, \r, \n, \b, \f, \t and other control characters (U+0000 through U+001F).
	 */
	public static String jsEscape(String value) {
		return org.json.simple.JSONObject.escape(value);
}

	/*
	 *
	 */
	public static String htmlEscape(String value) {
		return XML.escape(value);
	}


}
