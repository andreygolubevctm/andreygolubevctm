<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<session:new verticalCode="HOME" />

<%-- DONT Start fresh quote, on refresh - because otherwise we could kill a data bucket in another tab! --%>
<%--
<c:if test="${empty param.action}">
	<go:setData dataVar="data" value="*DELETE" xpath="quote" />
	<go:setData dataVar="data" value="*DELETE" xpath="ranking" />
</c:if>
--%>

<c:set var="xpath" value="quote" />
<c:set var="quoteType" value="home" />


<c:set var="xpath" value="car" scope="session" />
<c:set var="name" value="${go:nameFromXpath(xpath)}" />

<core:doctype />
<go:html>

<core:head quoteType="${quoteType}" title="Home Quote Capture"/>

<div style="display:none">
<form:reference_number quoteType="HOME" />
</div>

<%--
Example:
<iframe width="100%" name="ql" src="http://nxi.secure.comparethemarket.com.au/ctm/home_contents_quote_quicklaunch.jsp" frameborder="0" allowtransparency="true" scrolling="no"></iframe>
<style>
.homebanner iframe { height: 127px; }
.homebanner { padding-bottom: 0; }
.homebanner:after { top: 290px; }
@media only screen and (min-width: 320px) and (max-width: 480px){
	.homebanner iframe { height: 197px; }
	.homebanner { padding-bottom: 30px; }
	.homebanner:after { top: 408px }
}
</style>
--%>

<%--
	On submit a quicklaunch	action type (param.action == 'ql') is used
	and then once in the propper home_contents_quote.jsp we load the cover type & commencement date
	params into the data bucket.

	Enjoy!
--%>
<!--[if lt IE 7]> <body STYLE="background-color:transparent" class="${xpath} is-ie lt-ie10 lt-ie9 lt-ie8 lt-ie7"> <![endif]-->
<!--[if IE 7]> <body STYLE="background-color:transparent" class="${xpath} is-ie lt-ie10 lt-ie9 lt-ie8"> <![endif]-->
<!--[if IE 8]> <body STYLE="background-color:transparent" class="${xpath} is-ie lt-ie10 lt-ie9"> <![endif]-->
<!--[if IE 9]> <body STYLE="background-color:transparent" class="${xpath} is-ie lt-ie10"> <![endif]-->
<!--[if gt IE 9]><!--> <body STYLE="background-color:transparent" class="${xpath}"> <!--<![endif]-->
	<form:form action="home_contents_quote.jsp?action=ql&transactionId=${data.current.transactionId}" method="POST" id="mainform" name="frmMain" target="_top">
		<div id="content">
			<form:row label="Type of Cover" id="${xpath}_coverType_row">
			<field:import_select xpath="${xpath}/coverType"
				required="true"
				title="the type of cover"
				url="/WEB-INF/option_data/home_contents_cover_type.html"/>
			</form:row>

			<form:row label="Start Date" id="${xpath}_startDate_row" helpId="500">
				<field:commencement_date xpath="${xpath}/startDate" required="true" title="start date for your policy"/>
			</form:row>
		</div>
	</form:form>

	<%-- Dialog for rendering fatal errors --%>
	<form:fatal_error />
</body>

</go:html>