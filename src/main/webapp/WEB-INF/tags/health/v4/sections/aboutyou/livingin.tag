<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Living status row"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" 		required="true"	 rtexprvalue="true"	 description="field group's xpath" %>

<%-- VARIABLES --%>
<c:set var="name" 			value="${go:nameFromXpath(xpath)}" />

<%-- If the user is coming via a broucherware site where by a state is passed in instead of a postcode, then only show state selection --%>

<c:set var="fieldXpath" value="${xpath}/location" />
<c:set var="state" value="${data['health/situation/state']}" />

<form_v4:row label="You're living in" fieldXpath="${xpath}StateRow" className="health-state" subLabel="We've made an educated guess, correct us if we're wrong">

	<field_v2:array_radio xpath="${xpath}/state"
						  defaultValue="NSW"
						  required="true"
						  items="NSW=NSW,VIC=VIC,QLD=QLD,ACT=ACT,WA=WA,SA=SA,TAS=TAS,NT=NT"
						  title="you're living in"
						  style="radio-rounded" />

	<field_v1:hidden xpath="${xpath}/suburb" />

</form_v4:row>