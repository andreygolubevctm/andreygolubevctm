<%@ tag description="Travel Single Signup Form"%>
<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>
<security:populateDataFromParams rootPath="travel" delete="false"/>

<%-- HTML --%>
<c:set var="fieldXpath" value="travel/policyType" />
<form_v2:row label="What type of cover are you looking for?" fieldXpath="${fieldXpath}" className="clear cover-type">
	<field_v2:array_radio xpath="${fieldXpath}" required="true"
		className="policy-type " items="S=Single trip,A=Annual multi-trip"
		id="${go:nameFromXpath(xpath)}" title="your cover type." />
</form_v2:row>

<div class="row">
	<div class="col-xs-12 col-sm-10 policy-info">
		<content:get key="singleTripInfoText" />
		<c:choose>
			<c:when test="${not empty amtDisabledFlag and amtDisabledFlag eq 'Y'}">
				<content:get key="annualMultiTripDisabledInfoText" />
			</c:when>
			<c:otherwise>
				<content:get key="annualMultiTripInfoText" />
			</c:otherwise>
		</c:choose>
	</div>
</div>