<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<%@ attribute name="xpath" required="true" rtexprvalue="true" description="field group's xpath"%>

<%-- VARIABLES --%>
<c:set var="name"  value="${go:nameFromXpath(xpath)}" />

<form_v2:row label="What was the purchase price of the car?" >
		<field_v2:currency xpath="${xpath}_purchase_price"
						   required="true"
						   decimal="${false}"
						   minValue="1"
						   title="The purchase price of the car"/>
</form_v2:row>

<form_v2:row label="How much would you like to insure the car for (agreed value)?" >
	<field_v2:currency xpath="${xpath}_agreedvalue"
					   required="true"
					   decimal="${false}"
					   minValue="1"
					   title="The agreed value of the car"/>
</form_v2:row>

<form_v2:row label="Enter the number of kilometers the car is driven per year" helpId="14">
	<field_v2:kilometers_travelled xpath="${xpath}_annualKilometres" id="annual_exotic_kilometres" className="annual_exotic_kilometres" placeHolder="Example: 20000" required="true" />
</form_v2:row>

<form_v2:row label="Is the car registered?" >
	<field_v2:array_radio xpath="${xpath}_registered" required="true"
						  className="" items="Y=Yes,N=No"
						  id="${name}_registeredBtns" title="if the car is registered" />
</form_v2:row>