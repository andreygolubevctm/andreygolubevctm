<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Filter to enable/disable certain providers."%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" 				required="false" rtexprvalue="true"	 description="(optional) Filter's xpath" %>
<%@ attribute name="fundType"			required="false" rtexprvalue="true"	 description="(optional) Which type of funds to output ('restricted', 'notRestricted' or 'all' - default)" %>
<%@ attribute name="providersList"		type="java.util.ArrayList"	required="true" description="List of all available providers objects" %>

<%--
	Note if changing these providers:
	Remember this also maps in:
		* ProviderNameToId template in PHIO_outbound.xsl
		* <brandFilter> section in PHIO_outbound.xsl
--%>

<c:choose>
	<c:when test="${fundType eq 'restricted' or fundType eq 'notRestricted'}">
		<c:set var="fundTypesToDisplay" value="${fundType}" />
	</c:when>
	<c:otherwise>
		<c:set var="fundTypesToDisplay" value="restricted,notRestricted" />
	</c:otherwise>
</c:choose>

<c:forEach items="${providersList}" var="provider">
	<c:set var="FundCode"><c:out value="${provider.getCode()}" /></c:set>
	<c:set var="Name"><c:out value="${provider.getName()}" /></c:set>
	<c:set var="isRestricted" value="${provider.getPropertyDetail('isRestricted')}"/>
	<c:choose>
		<c:when test="${isRestricted eq 1}">
			<c:set var="isFundRestricted" value="restricted" />
		</c:when>
		<c:otherwise>
			<c:set var="isFundRestricted" value="notRestricted" />
		</c:otherwise>
	</c:choose>

	<c:if test="${fn:contains(fundTypesToDisplay, isFundRestricted)}">
		<div class="filterProviderCheckbox">
			<field_new:checkbox
				required="false"
				value="${FundCode}"
				xpath="${xpath}/${fn:toLowerCase(FundCode)}"
				label="${FundCode}"
				title='<div class="filterProviderLogo"><div class="companyLogo ${FundCode}"></div></div>' />
		</div>
	</c:if>
</c:forEach>