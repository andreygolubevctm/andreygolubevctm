<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Filter to enable/disable certain providers."%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<c:set var="styleCodeId">${pageSettings.getBrandId()}</c:set>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" 		required="false" rtexprvalue="true"	 description="(optional) Filter's xpath" %>

<%--
	Note if changing these providers:
	Remember this also maps in:
		* ProviderNameToId template in PHIO_outbound.xsl
		* <brandFilter> section in PHIO_outbound.xsl
--%>

<sql:setDataSource dataSource="jdbc/ctm"/>

<%-- Get providers that have Health products --%>
<sql:query var="result">
	SELECT a.ProviderId, pp.Text AS FundCode, a.Name
	FROM stylecode_providers a
	LEFT JOIN provider_properties pp
		ON pp.providerId = a.ProviderId AND PropertyId = 'FundCode'
	WHERE a.styleCodeId = ?	AND EXISTS (SELECT productId FROM stylecode_products b
		WHERE b.providerid = a.providerid
		AND b.productCat = 'HEALTH'
		AND b.styleCodeId = ? LIMIT 1)
	GROUP BY a.ProviderId, a.Name
	ORDER BY a.Name
	<sql:param value="${styleCodeId}" />
	<sql:param value="${styleCodeId}" />
</sql:query>

<div class="col-xs-12">
	<c:forEach var="row" items="${result.rows}" varStatus='idx'>
		<div class="col-md-3 col-sm-6">
			<field_new:checkbox required="false" value="${row.FundCode}" xpath="${xpath}/${fn:toLowerCase(row.FundCode)}"
					label="${row.FundCode}"
					title='<img src="common/images/logos/health/${row.FundCode}.png" alt="${row.FundCode}" data-content="${row.Name}" data-toggle="popover" data-trigger="mouseenter" /><span>${row.Name}</span>' />
		</div>
	</c:forEach>
</div>