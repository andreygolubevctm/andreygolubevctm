<%@ page language="java" contentType="text/json; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>
<%@ page import="nl.captcha.Captcha" %>
<jsp:useBean id="data" class="com.disc_au.web.go.Data" scope="session" />

<%--
	check_captcha.jsp
	
	Checks that the passed captcha code is correct (matches the last captcha generated for this session)

	@param captcha_code	- The captcha code entered by the user, that we need to check 
	
	@returns a text string -   	true: captcha entered correctly
								false: captcha entered incorrectly
								timeout: session timed out
--%>

<%-- Unfortunately have to use a scriptlet here, because SimpleCaptcha doesn't expose a JSTL object --%>
<%
Captcha captcha = (Captcha) session.getAttribute(Captcha.NAME);
String answer = request.getParameter("captcha_code");
if (captcha == null) { %>
	<go:setData dataVar="data" xpath="captcha/result" value="INCORRECT" />
	<c:out value='{"result":"timeout"}' escapeXml="false" />	
<% } else if (captcha.isCorrect(answer)) { %>
	<go:setData dataVar="data" xpath="captcha/result" value="OK" />
	<c:out value='{"result":"ok"}' escapeXml="false" />
<% } else { %>
	<go:setData dataVar="data" xpath="captcha/result" value="INCORRECT" />
	<c:out value='{"result":"incorrect"}' escapeXml="false" />
<% } %>
