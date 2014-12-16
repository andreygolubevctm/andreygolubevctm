<%@ tag description="Travel Single Signup Form"%>
<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>
<security:populateDataFromParams rootPath="travel" delete="false"/>
<jsp:useBean id="splitTests" class="com.ctm.services.tracking.SplitTestService" />
<%-- HTML --%>

<c:set var="fieldXpath" value="travel/policyType" />
<c:choose>
	<c:when test="${splitTests.isActive(pageContext.getRequest(), data.current.transactionId, 2)}">
		<form_new:row label="What type of cover are you looking for?" fieldXpath="${fieldXpath}" className="clear">
			<field_new:array_radio xpath="${fieldXpath}" required="true"
					className="" items="S=Single Trip,A=Annual Multi-Trip"
					id="${go:nameFromXpath(xpath)}" title="your cover type." />
		</form_new:row>
	</c:when>
	<c:when test="${splitTests.isActive(pageContext.getRequest(), data.current.transactionId, 3)}">
		<form_new:row label="How many times do you plan on travelling in the next 12 months?" fieldXpath="${fieldXpath}" className="clear">
			<field_new:array_radio xpath="${fieldXpath}" required="true"
					className="" items="S=Once,A=Multiple Times"
					id="${go:nameFromXpath(xpath)}" title="your cover type." />
		</form_new:row>
	</c:when>
	<c:otherwise>
		<form_new:row label="What type of cover are you looking for?" fieldXpath="${fieldXpath}" className="clear">
			<field_new:array_radio xpath="${fieldXpath}" required="true"
					className="" items="S=Single Trip,A=Multi-Trip"
					id="${go:nameFromXpath(xpath)}" title="your cover type." />
		</form_new:row>
	</c:otherwise>
</c:choose>