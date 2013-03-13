package com.disc_au.soap;

import com.disc_au.web.go.xml.XmlNode;

public class SOAPError extends XmlNode{

	public static final int TYPE_TIMEOUT = 0;
	public static final int TYPE_HTTP = 1;
	public static final int TYPE_PARSING = 2;
	
	private static final String XML_DOC_HEADER = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>";
	
	public SOAPError(int type, int code, String message, String serviceName){
		this(type, code, message, serviceName, "");
	}
	public SOAPError(int type, int code, String message, String serviceName, String data){
		super("error");
		
		String typeDes;
		switch(type){
		case TYPE_TIMEOUT: 	typeDes = "timeout"; 	break; 
		case TYPE_HTTP: 	typeDes = "http"; 		break;
		case TYPE_PARSING: 	typeDes = "parsing"; 	break;
		default: typeDes = "unknown";
		}
		setAttribute("type",typeDes); 
		setAttribute("service",serviceName);
		
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
