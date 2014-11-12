<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Filter to enable/disable certain providers."%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<c:set var="styleCodeId">${pageSettings.getBrandId()}</c:set>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" 				required="false" rtexprvalue="true"	 description="(optional) Filter's xpath" %>
<%@ attribute name="fundType"			required="false" rtexprvalue="true"	 description="(optional) Which type of funds to output ('restricted', 'notRestricted' or 'all' - default)" %>

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

<sql:setDataSource dataSource="jdbc/ctm"/>

<%-- Get providers that have Health products --%>
<sql:query var="result">
	SELECT a.ProviderId, pp.Text AS FundCode, pp2.Status AS isRestricted, a.Name
	FROM stylecode_providers a
	LEFT JOIN provider_properties pp
	ON pp.providerId = a.ProviderId AND pp.PropertyId = 'FundCode'
	LEFT JOIN provider_properties pp2
	ON pp2.providerId = a.ProviderId AND pp2.PropertyId = 'RestrictedFund'
	WHERE a.styleCodeId = ?
	AND a.providerid
	NOT IN (SELECT spe.providerId FROM
	ctm.stylecode_provider_exclusions spe
	WHERE spe.verticalId = 4
	AND spe.styleCodeId = a.styleCodeId
	AND now() between spe.excludeDateFrom AND spe.excludeDateTo)
	AND a.providerid = (
	SELECT pm.providerid FROM ctm.product_master pm
	WHERE pm.providerid = a.providerid
	AND pm.productCat = 'HEALTH'
	LIMIT 1)
	GROUP BY a.ProviderId, a.Name
	ORDER BY a.Name;
	<sql:param value="${styleCodeId}" />
</sql:query>

<c:forEach var="row" items="${result.rows}" varStatus='idx'>

	<c:choose>
		<c:when test="${row.isRestricted eq 1}">
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
				value="${row.FundCode}"
				xpath="${xpath}/${fn:toLowerCase(row.FundCode)}"
				label="${row.FundCode}"
				title='<div class="filterProviderLogo"><img src="common/images/logos/health/${row.FundCode}.png" alt="${row.FundCode}"/><span>${row.Name}</span></div>' />
		</div>
	</c:if>

</c:forEach>