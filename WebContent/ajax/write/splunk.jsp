<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="java.net.*,java.io.*,java.util.*" %>
<%

	StringBuffer sb = new StringBuffer();
	Enumeration<String> keys = request.getParameterNames();  
	while (keys.hasMoreElements() ) {  
   		String key = (String)keys.nextElement();  
		String value = request.getParameter(key); 
		
		sb.append(key).append("=").append(value).append(" ");
	}
	
	Socket s = new Socket("localhost", 7979);

	try {
		OutputStream output = s.getOutputStream();
		output.write(sb.toString().getBytes());
		output.close();
		
	} catch(Exception e){
		e.printStackTrace();
	} finally {
		s.close();
	}



%>