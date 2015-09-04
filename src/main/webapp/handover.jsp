<%-- For the Credit Cards Handover Page --%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<c:set var="logger" value="${log:getLogger(pageContext.request.servletPath)}" />

<session:new verticalCode="CREDITCARD" />
<core_new:quote_check quoteType="CREDITCARD" />

<jsp:useBean id="productService" class="com.ctm.services.creditcards.ProductService" scope="page" />
<c:set var="tmpProductCode">
	<c:out escapeXml="true" value="${param.productID}" />
</c:set>
<c:set var="trackingKey">
	<c:out value="${param.key}" escapeXml="true" />
</c:set>

<c:set var="product" value="" />
<c:choose>
	<c:when test="${not empty tmpProductCode}">
		<c:catch var="error">
			<c:set var="products" value="${productService.getProductsByCodeAsString(pageContext.getRequest(), tmpProductCode)}" />
			<c:if test="${not empty products and not empty products[0] and not empty products[0].code}">
				<c:set var="product" value ="${products[0]}" />
			</c:if>
		</c:catch>
		<if test="${error}">
			${logger.warn('Exception thrown getProductsByCodeAsString. {}', log:kv('tmpProductCode' , tmpProductCode),  error)}
		</if>
	</c:when>
	<c:otherwise>
		${logger.error('Credit Cards Handover error: No Product Passed. {},{}',log:kv('tmpProductCode',tmpProductCode ), log:kv('product',product ))}
		<%
		// Set error code and reason.
		response.sendError(500, "No Product Code Passed." );
		%>
	</c:otherwise>
</c:choose>
<c:choose>
	<c:when test="${not empty error}">
		${logger.error('Credit Cards Handover error. {},{}', log:kv('tmpProductCode', tmpProductCode), log:kv('product', product), error)}
		<%
		// Set error code and reason.
		response.sendError(500, "An error occurred." );
		%>
	</c:when>
	<c:when test="${empty product}">
		${logger.error('Credit Cards Handover error: Product Not Found. {},{}', log:kv('tmpProductCode',tmpProductCode ), log:kv('product',product ))}
		<%
		// Set error code and reason.
		response.sendError(500, "No Product Found." );
		%>
	</c:when>
	<c:otherwise>
		<c:set var="productName" value="${product.shortDescription}" scope="request" />
		<c:set var="productID" value="${product.code}" scope="request" />
		<c:set var="productBrand" value="${product.provider.name}" scope="request" />
		<c:set var="productBrandSlug" value="${fn:toLowerCase(fn:replace(go:replaceAll(productBrand, '[^a-zA-Z0-9- ]', ''), ' ', '-'))}" scope="request" />
		<c:set var="productBrandCode" value="${product.provider.code}" scope="request" />
		<c:set var="productHandoverUrl" value="${product.handoverUrl}" scope="request" />
		<%-- Set product id so straight handover records it --%>
		<go:setData xpath="creditcard/handover/productCode" dataVar="data" value="${productID}" />
		<go:setData xpath="creditcard/trackingKey" dataVar="data" value="${trackingKey}" />
	</c:otherwise>
</c:choose>

<layout:generic_page title="Transferring you to provider">

	<jsp:attribute name="head">
	</jsp:attribute>

	<jsp:attribute name="head_meta">
	</jsp:attribute>

	<jsp:attribute name="header">
	</jsp:attribute>

	<jsp:attribute name="navbar">
		<div class="row">
			<div class="col-xs-12">
				<p id="breadcrumbs">
				<span prefix="v: http://rdf.data-vocabulary.org/#">
					<span typeof="v:Breadcrumb">
						<a href="http://www.comparethemarket.com.au" rel="v:url" property="v:title">Home</a>
					</span> &raquo;
					<span typeof="v:Breadcrumb">
						<a href="http://www.comparethemarket.com.au/credit-cards/" rel="v:url" property="v:title">Credit Cards</a>
					</span>
					<c:if test="${not empty productBrandSlug}"> &raquo;
					<span typeof="v:Breadcrumb">
						<a href="http://www.comparethemarket.com.au/credit-cards/<c:out value="${productBrandSlug}/" />" rel="v:url" property="v:title"><c:out value="${productBrand}" /></a>
					</span> <span class="hidden-xs">&raquo;</span>
					<span typeof="v:Breadcrumb" class="hidden-xs">
						<strong class="breadcrumb_last" property="v:title"><c:out value="${productName}" escapeXml="false" /></strong>
					</span>
					</c:if>
				</span>
				</p>
			</div>
		</div>
		<h1><c:out value="${productName}" escapeXml="false" /></h1>
	</jsp:attribute>

	<jsp:attribute name="form_bottom">
	</jsp:attribute>

	<jsp:attribute name="footer">
		<core:whitelabeled_footer />
	</jsp:attribute>

	<jsp:attribute name="vertical_settings">
		<creditcard:settings />
	</jsp:attribute>

	<jsp:attribute name="body_end" />

	<jsp:body>
		<creditcard_layout:handover />
		<core_new:journey_tracking />
		<core_new:tracking_key />
		<div class="hiddenFields">
			<core:referral_tracking vertical="${pageSettings.getVerticalCode()}" />
			<field:hidden xpath="${pageSettings.getVerticalCode()}/handover/productCode" defaultValue="${productID}" />
		</div>
	</jsp:body>

</layout:generic_page>