<%@ page language="java" contentType="text/xml; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<session:get />

<sql:setDataSource dataSource="jdbc/aggregator"/>

<%-- XML --%>
<?xml version="1.0" encoding="UTF-8"?>
<data>

	<c:forEach var="row" items="${param.products}" varStatus='vs'>	

		<product>
			<code><c:out value='${row}' escapeXml="false"/></code>   
	
			<sql:query var="featureResult">
				SELECT general.description, features.description, features.field_value
				FROM aggregator.features
					INNER JOIN aggregator.general ON general.code = features.code
					WHERE features.productId = ?
			  		ORDER BY general.orderSeq 		
				<sql:param>${row}</sql:param>
			</sql:query>
					
			<c:forEach var="feature" items="${featureResult.rowsByIndex}" varStatus='vs'>
			
				<feature desc="${feature[0]}" value="${feature[2]}" >${fn:escapeXml(feature[1])}</feature>
			
			</c:forEach>
		</product>

	</c:forEach>

</data>