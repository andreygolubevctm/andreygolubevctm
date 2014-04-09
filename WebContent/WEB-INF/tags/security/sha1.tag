<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ tag description="Encrypts a string "%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<%@ attribute name="encrypt" required="true" rtexprvalue="true"
	description="The String to Encrypt"%>
${encrypt}