<%@ page language="java" contentType="text/json; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<session:get settings="true" />

<%-- Flag to indicate whether to bypass Switchwise and retrieve from MySQL by default --%>
<c:set var="force_src_mysql">
	<c:choose>
		<c:when test="${pageSettings.getSetting('useLocalDataSource') eq 'Y'}">${true}</c:when>
		<c:otherwise>${false}</c:otherwise>
	</c:choose>
</c:set>

<c:set var="retailerid" value="${param.retailerid}" />
<c:set var="postcode" value="${param.postcode}" />
<c:set var="state" value="${param.state}" />
<c:set var="packagetype" value="${param.packagetype}" />

<c:if test="${force_src_mysql eq false}">

	<go:log>Sourcing products from Switchwise service</go:log>

<c:set var="plansXML">
		<c:catch var="error">
	<utilities:utilities_get_providerplans postcode="${postcode}" providerid="${retailerid}"></utilities:utilities_get_providerplans>
		</c:catch>
</c:set>
</c:if>

<c:choose>
	<c:when test="${force_src_mysql eq true or empty plansXML}">

		<go:log>Sourcing products from mySQL</go:log>

		<sql:setDataSource dataSource="jdbc/ctm"/>

		<c:if test="${packagetype eq 'Electricity'}">
			<sql:query var="getEProducts">
				SELECT DISTINCT ProviderId, RetailerId, ProductId, ProductCode, Title, State, EffectiveStart, EffectiveEnd
				FROM ctm.utilities_active_products
				WHERE RetailerId = ? AND State = ? AND ClassType = ?
				ORDER BY Title ASC;
				<sql:param value="${retailerid}" />
				<sql:param value="${state}" />
				<sql:param value="Electricity" />
			</sql:query>
		</c:if>

		<c:if test="${packagetype eq 'Gas' }">
			<sql:query var="getGProducts">
				SELECT DISTINCT ProviderId, RetailerId, ProductId, ProductCode, Title, State, EffectiveStart, EffectiveEnd
				FROM ctm.utilities_active_products
				WHERE RetailerId = ? AND State = ? AND ClassType = ?
				ORDER BY Title ASC;
				<sql:param value="${retailerid}" />
				<sql:param value="${state}" />
				<sql:param value="Gas" />
			</sql:query>
		</c:if>
		<c:set var="response">
			<results>
				<result>OK</result>
			<c:if test="${packagetype eq 'Electricity'}">
				<electricity>
					<0>
						<ProductId></ProductId>
						<ProductCode></ProductCode>
						<Title>Please Choose...</Title>
					</0>
					<1>
						<ProductId>ignore</ProductId>
						<ProductCode>ignore</ProductCode>
						<Title>Other / Unknown</Title>
					</1>
				<c:set var="counter" value="${2}" />
				<c:forEach var="product" items="${getEProducts.rows}" varStatus="row">
					<${counter}>
						<ProductId>${product.ProductId}</ProductId>
						<ProductCode>${product.ProductCode}</ProductCode>
						<Title>${fn:escapeXml(product.Title)}</Title>
					</${counter}>
					<c:set var="counter" value="${counter + 1}" />
				</c:forEach>
				</electricity>
			</c:if>
			<c:if test="${packagetype eq 'Gas'}">
				<gas>
					<0>
						<ProductId></ProductId>
						<ProductCode></ProductCode>
						<Title>Please Choose...</Title>
					</0>
					<1>
						<ProductId>ignore</ProductId>
						<ProductCode>ignore</ProductCode>
						<Title>Other / Unknown</Title>
					</1>
				<c:set var="counter" value="${2}" />
				<c:forEach var="product" items="${getGProducts.rows}" varStatus="row">
					<${counter}>
						<ProductId>${product.ProductId}</ProductId>
						<ProductCode>${product.ProductCode}</ProductCode>
						<Title>${fn:escapeXml(product.Title)}</Title>
					</${counter}>
					<c:set var="counter" value="${counter + 1}" />
				</c:forEach>
				</gas>
			</c:if>
			</results>
		</c:set>
	</c:when>
	<c:otherwise>
		<x:parse doc="${plansXML}" var="plansOBJ" />
		<c:set var="response">
			<results>
				<result>OK</result>
			<c:if test="${packagetype eq 'Electricity'}">
				<electricity>
					<0>
						<ProductId></ProductId>
						<ProductCode></ProductCode>
						<Title>Please Choose...</Title>
					</0>
					<1>
						<ProductId>ignore</ProductId>
						<ProductCode>ignore</ProductCode>
						<Title>Other / Unknown</Title>
					</1>
				<c:set var="counter" value="${2}" />
				<x:set var="theNode" select="$plansOBJ//*[local-name()='Electricity']/*" />
				<x:forEach select="$theNode" var="plan">
					<${counter}>
						<ProductId><x:out select="$plan/value" /></ProductId>
						<ProductCode><x:out select="$plan/value" /></ProductCode>
						<Title><x:out select="$plan/description" /></Title>
					</${counter}>
					<c:set var="counter" value="${counter + 1}" />
				</x:forEach>
				</electricity>
			</c:if>
			<c:if test="${packagetype eq 'Gas'}">
				<gas>
					<0>
						<ProductId></ProductId>
						<ProductCode></ProductCode>
						<Title>Please Choose...</Title>
					</0>
					<1>
						<ProductId>ignore</ProductId>
						<ProductCode>ignore</ProductCode>
						<Title>Other / Unknown</Title>
					</1>
				<c:set var="counter" value="${2}" />
				<x:set var="theNode" select="$plansOBJ//*[local-name()='Gas']/*" />
				<x:forEach select="$theNode" var="plan">
					<${counter}>
						<ProductId><x:out select="$plan/value" /></ProductId>
						<ProductCode><x:out select="$plan/value" /></ProductCode>
						<Title><x:out select="$plan/description" /></Title>
					</${counter}>
					<c:set var="counter" value="${counter + 1}" />
				</x:forEach>
				</gas>
			</c:if>
			</results>
		</c:set>
	</c:otherwise>
</c:choose>

${go:XMLtoJSON(response)}