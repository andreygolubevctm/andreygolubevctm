<%@ page language="java" contentType="text/json; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- Variables --%>
<c:set var="vertical" value="${param.vertical}"/>

<session:get settings="true" authenticated="true" verticalCode="${fn:toUpperCase(vertical)}" />

<sql:setDataSource dataSource="jdbc/test"/>




<%-- Set Security --%>
<c:choose>
	<c:when test="${not empty param.action and param.action == 'latest'}">
		<c:set var="writeQuoteOverride" value="N" />
	</c:when>
	<c:otherwise>
		<security:populateDataFromParams rootPath="${vertical}" />
		<c:set var="writeQuoteOverride" value="" />
	</c:otherwise>
</c:choose>

<%-- RECOVER: if things have gone pear shaped --%>
<c:if test="${empty data.current.transactionId}">
			<error:recover origin="ajax/json/features/results.jsp" quoteType="${vertical}" />
</c:if>


<%-- Save data --%>
<core:transaction touch="R" noResponse="true" writeQuoteOverride="Y" />
<%-- Fetch and store the transaction id --%>
<c:set var="tranId" value="${data['current/transactionId']}" />

<go:setData dataVar="data" xpath="${vertical}/transactionId" value="${tranId}" />

<c:set var="brands" value="${paramValues['brand']}" />




<%-- Set Quote type for SQL --%>
<c:choose>
	<c:when test="${vertical eq 'carlmi'}">
		<c:set var="quoteType" value="CAR"/>
	</c:when>
	<c:when test="${vertical eq 'homelmi'}">
		<c:set var="quoteType" value="HOME"/>
	</c:when>
	<c:otherwise></c:otherwise>
</c:choose>

<%-- Get Results --%>
<sql:query var="featureResult">
	SELECT
		fd.id AS featureId,
		fp.id AS productId,
		fp.name AS productName,
		fb.displayName AS brandName,
		fm.val AS value,
		fm.description AS extra,
		fd.name AS `desc`,
		fpm.ctm_productId AS ctmProductId,
		fg.id AS categoryId,
		fg.name AS categoryName,
		fg.sequence AS categoryOrder,
		fd.type AS type
	FROM test.features_main AS fm
	LEFT JOIN test.features_details AS fd
		ON fm.fid = fd.id
	LEFT JOIN test.features_category AS fg
		ON fd.categoryId = fg.id
	LEFT JOIN test.features_products AS fp
		ON fm.pid = fp.id
	LEFT JOIN test.features_brands AS fb
		ON fb.id = fp.brandId
	LEFT JOIN test.features_product_mapping AS fpm
		ON fpm.lmi_ref = fp.ref
	WHERE fd.status = true
	AND fp.vertical = '${quoteType}'
	AND fb.id IN (<c:forEach items="${brands}" var="selectedValue" varStatus="status">?<c:if test="${status.last==false}">,</c:if></c:forEach>)
	ORDER BY brandName, productName, productId, categoryOrder, categoryName, type, `desc`


	<c:forEach items="${brands}" var="selectedValue">
		<sql:param value="${selectedValue}"/>
	</c:forEach>
</sql:query>

<c:set var="currentProduct" value="" />
<c:set var="products">
	<c:if test="${featureResult.rowCount ne 0}">
		<c:forEach items="${featureResult.rows}" var="feature" varStatus="status">
			<c:if test="${!status.first and feature.productId ne currentProduct}">
					</features>
				</product>
			</c:if>
			<c:if test="${feature.productId ne currentProduct}">
				<product>
					<policyId>${fn:escapeXml(feature.productId)}</policyId>
					<brandName>${fn:escapeXml(feature.brandName)}</brandName>
					<policyName>${fn:escapeXml(feature.productName)}</policyName>
					<fullName>${fn:escapeXml(feature.brandName)} - ${fn:escapeXml(feature.productName)}</fullName>
					<ctmProductId>${fn:escapeXml(feature.ctmProductId)}</ctmProductId>
					<logo>
						<c:choose>
							<c:when test="${not empty feature.ctmProductId}">${fn:escapeXml(feature.ctmProductId)}</c:when>
							<c:otherwise>default</c:otherwise>
						</c:choose>
					</logo>
					<features>

				<c:set var="currentProduct" value="${feature.productId}" />
			</c:if>
						<feature featureId="${feature.featureId}" desc="${go:htmlEscape(feature.desc)}" extra="${go:htmlEscape(feature.extra)}" value="${go:htmlEscape(feature.value)}" categoryId="${feature.categoryId}"  categoryName="${go:htmlEscape(feature.categoryName)}" />

		</c:forEach>

					</features>
				</product>
	</c:if>
</c:set>

<c:set var="resultXml">
	<results>
		<transactionId>${tranId}</transactionId>
		<sessionId>${pageContext.session.id}</sessionId>
		<clientIp>${pageContext.request.remoteAddr}</clientIp>
		<browser>${clientUserAgent}</browser>
		<products>
			${products}
		</products>
	</results>
</c:set>

<agg:write_stats rootPath="${vertical}" tranId="${tranId}" debugXml="${resultXml}" />
<%-- Add the results to the current session data --%>
<go:setData dataVar="data" xpath="soap-response" value="*DELETE" />
<go:setData dataVar="data" xpath="soap-response" xml="${resultXml}" />

<%-- Return the results as json --%>
${go:XMLtoJSON(go:getEscapedXml(data['soap-response/results']))}