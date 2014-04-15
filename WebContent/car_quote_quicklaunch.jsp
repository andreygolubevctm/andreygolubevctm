<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<session:new verticalCode="CAR" />

<%-- DONT Start fresh quote, on refresh - because otherwise we could kill a data bucket in another tab! --%>
<%--
<c:if test="${empty param.action}">
	<go:setData dataVar="data" value="*DELETE" xpath="quote" />
	<go:setData dataVar="data" value="*DELETE" xpath="ranking" />
</c:if>
--%>

<c:set var="xpath" value="quote" />
<c:set var="quoteType" value="car" />


<c:set var="xpath" value="car" scope="session" />
<c:set var="name" value="${go:nameFromXpath(xpath)}" />

<core:doctype />
<go:html>

<core:head quoteType="${quoteType}" title="Car Quote Capture"/>

<form:reference_number quoteType="CAR" />

<%--
Example:
<iframe width="100%" name="ql" src="http://nxi.secure.comparethemarket.com.au/ctm/car_quote_quicklaunch.jsp" frameborder="0" allowtransparency="true" scrolling="no"></iframe>
<style>
.carbanner iframe { height: 127px; }
.carbanner { padding-bottom: 0; }
.carbanner:after { top: 290px; }
@media only screen and (min-width: 320px) and (max-width: 480px){
	.carbanner iframe { height: 197px; }
	.carbanner { padding-bottom: 30px; }
	.carbanner:after { top: 408px }
}
</style>
--%>

<%--
	On submit a quicklaunch	action type (param.action == 'ql') is used
	and then once in the propper car_quote.jsp we load the make,model,year
	params into the data bucket under vehicle as usual. The vehicle
	selector code will automatically handle pre-populating if it's in
	the data bucket	thanks to an ajax check it does.

	What is passed on form submit is:
		quote_vehicle_make:MITS
		quote_vehicle_makeDes:Mitsubishi
		quote_vehicle_model:380
		quote_vehicle_modelDes:380
		quote_vehicle_year:2007
		transcheck:1

	If you're wondering what i did to the body tag below...
	that's really better done on the HTML tag, but because we use
	the go:html tag, i didn't have that available right now.
	It sets appropriate IE classes, so we don't have to use
	*html hacks and things use real inheritance. Much better.

	Enjoy!
--%>
<!--[if lt IE 7]> <body STYLE="background-color:transparent" class="${xpath} is-ie lt-ie10 lt-ie9 lt-ie8 lt-ie7"> <![endif]-->
<!--[if IE 7]> <body STYLE="background-color:transparent" class="${xpath} is-ie lt-ie10 lt-ie9 lt-ie8"> <![endif]-->
<!--[if IE 8]> <body STYLE="background-color:transparent" class="${xpath} is-ie lt-ie10 lt-ie9"> <![endif]-->
<!--[if IE 9]> <body STYLE="background-color:transparent" class="${xpath} is-ie lt-ie10"> <![endif]-->
<!--[if gt IE 9]><!--> <body STYLE="background-color:transparent" class="${xpath}"> <!--<![endif]-->
	<form:form action="car_quote.jsp?action=ql&transactionId=${data.current.transactionId}" method="POST" id="mainform" name="frmMain" target="_top">
		<div id="content">
			<group:vehicle_selection_quicklaunch xpath="quote/vehicle" />
		</div>
	</form:form>

	<%-- Dialog for rendering fatal errors --%>
	<form:fatal_error />
</body>

</go:html>