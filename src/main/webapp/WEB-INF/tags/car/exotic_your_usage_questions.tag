<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<%@ attribute name="xpath" required="true" rtexprvalue="true" description="field group's xpath"%>

<%-- VARIABLES --%>
<c:set var="name"  value="${go:nameFromXpath(xpath)}" />

<form_v2:row label="What was the purchase price of the car?" >
		<field_v2:currency xpath="${xpath}_purchase_price"
						   required="true"
						   pattern="[0-9]*"
						   decimal="${false}"
						   title="The purchase price of the car"/>
</form_v2:row>

<form_v2:row label="Is the car registered?" >
	<field_v2:array_radio xpath="${xpath}_registered" required="true"
						  className="" items="Y=Yes,N=No"
						  id="${name}_registered" title="if the car is registered" />
</form_v2:row>