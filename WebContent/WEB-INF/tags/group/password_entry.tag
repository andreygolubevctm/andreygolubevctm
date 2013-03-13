<%@ tag language="java" pageEncoding="ISO-8859-1" %>
<%@ tag description="Group containing password and confirmation password"%>

<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" 		required="true"	 rtexprvalue="true"	 description="variable's xpath" %>
<%@ attribute name="required" 	required="true"	 rtexprvalue="false" description="is this field required?" %>
<%@ attribute name="className" 	required="false" rtexprvalue="true"	 description="additional css class attribute" %>

<%-- VARIABLES --%>
<c:set var="name" value="${go:nameFromXpath(xpath)}" />

<%-- HTML --%>	
<form:row label="Password">
	<field:password xpath="${xpath}/password" required="${required}" title="Password"/>
</form:row>
<form:row label="Confirm Password">
	<field:password xpath="${xpath}/confirm" required="${required}" title="the confirmation password"/>
</form:row>	

<%-- VALIDATION --%>
<%-- ensure password and confirm match --%>
<c:set var="parm">'#${name}_password'</c:set>
<go:validate selector="${name}_confirm" rule="equalTo" parm="${parm}" message="The text you entered for the confirmation password did not match your password, please try again"/>