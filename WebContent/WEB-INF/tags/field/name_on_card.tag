<%@ tag language="java" pageEncoding="ISO-8859-1" %>
<%@ tag description="Represents a person's name on credit card."%>

<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" 		required="true"	 rtexprvalue="true"	 description="variable's xpath" %>
<%@ attribute name="required" 	required="true"	 rtexprvalue="true"  description="is this field required?" %>
<%@ attribute name="className" 	required="false" rtexprvalue="true"	 description="additional css class attribute" %>
<%@ attribute name="title" 		required="true"	 rtexprvalue="true"	 description="The subject of the field (e.g. 'regular driver')"%>

<%-- VARIABLES --%>
<c:set var="nameoncard" value="${go:nameFromXpath(xpath)}" />

<%-- HTML --%>
<input type="text" name="${nameoncard}" id="${nameoncard}" class="credit_card_name ${className}" value="${data[xpath]}" size="30" maxlength="50">

<%-- VALIDATION --%>
<go:validate selector="${nameoncard}" rule="required" parm="${required}" message="Please enter ${title}"/>

