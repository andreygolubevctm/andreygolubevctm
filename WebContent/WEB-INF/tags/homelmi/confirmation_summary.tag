<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Life Contact Details group"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="first_name"	required="true"	rtexprvalue="true"	description="The clients first name (provided from AFG)" %>

<%-- HTML --%>
<h1>Thanks ${data['homelmi/signup/firstname']},</h1>
<p>You're now registered to receive Home and Contents Insurance communications from <br/><strong>comparethemarket.com.au</strong>.</p>
<p>Keep an eye on your inbox for our emails!</p>