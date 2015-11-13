package com.ctm.web.core.soap;

import com.ctm.web.core.web.go.xml.XmlNode;

public class SOAPError extends XmlNode{

	public static final int TYPE_TIMEOUT = 0;
	public static final int TYPE_HTTP = 1;
	public static final int TYPE_PARSING = 2;
	public static final int TYPE_NO_BODY = 3;

	private static final String XML_DOC_HEADER = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>";

	public SOAPError(int type, int code, String message, String serviceName){
		this(type, code, message, serviceName, "", 0);
	}
	public SOAPError(int type, int code, String message, String serviceName, String data){
		this(type, code, message, serviceName, data, 0);
	}
	public SOAPError(int type, int code, String message, String serviceName, String data, long responseTime){
		super("error");

		String typeDes;
		switch(type){
		case TYPE_TIMEOUT: 	typeDes = "timeout"; 	break;
		case TYPE_HTTP: 	typeDes = "http"; 		break;
		case TYPE_PARSING: 	typeDes = "parsing"; 	break;
		case TYPE_NO_BODY: 	typeDes = "no_body"; 	break;
		default: typeDes = "unknown";
		}
		setAttribute("type", typeDes);
		setAttribute("service", serviceName);
		setAttribute("responseTime", String.valueOf(responseTime));

		addElement("code", String.valueOf(code));
		addElement("message", XmlNode.escapeChars(message));
		addElement("data", XmlNode.escapeChars(data.toString()));
	}
	public String getXMLDoc(){
		StringBuffer sb = new StringBuffer();
		sb.append(XML_DOC_HEADER);
		sb.append(super.getXML());
		return sb.toString();
	}
}
