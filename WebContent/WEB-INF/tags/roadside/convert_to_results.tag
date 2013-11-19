<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>
<%@ attribute name="rows" type="java.util.SortedMap[]" required="true" rtexprvalue="true"	 description="recordset" %>

<sql:setDataSource dataSource="jdbc/aggregator"/>

<results>
	<c:forEach var="row" items="${rows}">
		<result productId="${row.productCat}-${row.productid}">
			<provider>${row.provider}</provider>
			<name>${row.name}</name>
			<des>${row.des}</des>
			<premium>${row.premium}</premium>
			<premiumText>${row.premiumText}</premiumText>
			<c:set var="details" value="${priceService.getDetails(row.productid)}" />

			<sql:query var="details">
				SELECT
					b.label,
					b.longlabel,
					a.Value,
					a.propertyid,
					a.Text
				FROM aggregator.roadside_details a
					JOIN aggregator.property_master b on a.propertyid = b.propertyid
				WHERE a.productid = ?
				ORDER BY b.label;
				<sql:param>${row.productid}</sql:param>
			</sql:query>
			<c:forEach var="info" items="${details.rows}">
				<%-- TODO: add attributes to Data so that we can call
					<c:out value="${info.xml['productInfo']}" escapeXml="false" />
				--%>
				<productInfo propertyId="${info.propertyid}">
					<label>${info.label}</label>
					<desc>${info.longlabel}</desc>
					<value>${info.value}</value>
					<text>${info.text}</text>
				</productInfo>
			</c:forEach>
		</result>
	</c:forEach>
	<c:if test="result.rowCount == 0">
		<result>
				<provider></provider>
				<name></name>
				<des></des>
				<premium></premium>
		</result>
	</c:if>
</results>
