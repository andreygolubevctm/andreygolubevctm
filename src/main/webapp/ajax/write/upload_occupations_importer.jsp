<%@ page language="java" contentType="text/xml; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>
<%@ page language="java" import="com.ctm.utils.LoadExternalFile" %>
<%

/**
 * LoadExternalFile loads the content of a url into a string. Provide a username and password
 * when authorisation is required.  
 *
 * This process assumes that you don't have a proxy preventing access to external sites. In that
 * case add applicable setting to your setup (eclipse, server... wherever)
 */

LoadExternalFile file_loader = new LoadExternalFile();
	
%>

<%=file_loader.getContent("https://enterpriseapi.lifebroker.com.au/occupation/list", "compthemkt", "lI9hW2qIlx2f4G")%>