<%@ page language="java" contentType="text/xml; charset=ISO-8859-1" pageEncoding="ISO-8859-1" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<jsp:useBean id="data" class="com.disc_au.web.go.Data" scope="session" />

<sql:setDataSource dataSource="jdbc/test"/>

<%-- XML --%>
<?xml version="1.0" encoding="UTF-8"?>
<data>

	<c:forEach var="row" items="${param.products}" varStatus='vs'>	

		<product>
			<code><c:out value='${row}' escapeXml="false"/></code>   
	
			<sql:query var="featureResult">
				SELECT general.description, features.description FROM test.features 
					INNER JOIN test.general ON general.code = features.code 
					WHERE features.productId = '${row}' 
			  		ORDER BY general.orderSeq 		
			</sql:query>
					
			<c:forEach var="feature" items="${featureResult.rowsByIndex}" varStatus='vs'>
			
				<feature desc="${feature[0]}">${fn:escapeXml(feature[1])}</feature>  
			
			</c:forEach>
		</product>

	</c:forEach>

</data>