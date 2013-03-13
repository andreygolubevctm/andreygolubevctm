<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<jsp:useBean id="data" class="com.disc_au.web.go.Data" scope="session" />

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<go:html>
	<core:head title="XML from MySQL test" />
	<body>
		<sql:setDataSource dataSource="jdbc/aggregator"/>

		<sql:query var="results">
			SELECT * FROM aggregator.email_master
			WHERE emailSource = 'CTFA'
		</sql:query>
		
		<c:set var="myXML">
			<jsp:element name="data">
				<c:forEach var="row" items="${results.rows}">
					<jsp:element name="row">
						<c:forEach var="columnName" items="${results.columnNames}">
							<jsp:element name="${columnName}">
								<c:out value="${row[columnName]}" escapeXml="true" />
							</jsp:element>	
						</c:forEach>
					</jsp:element>
				</c:forEach>
			</jsp:element>
		</c:set>
		
		<%--
		<c:out value="${myXML}" escapeXml="true" /> 
			<hr>
		--%>
		
		<c:choose>
			<c:when test="${results.rowCount != 0}">
			
				<c:import var="myXSL" url="fuel.xsl" />
				<c:set var="myResult">
					<x:transform doc="${myXML}" xslt="${myXSL}"/>
				</c:set>
				
				<c:out value="${myResult}" escapeXml="true"/>
				
			</c:when>
			<c:otherwise>
				No Data to display
			</c:otherwise>
		</c:choose>

	<%--		
		<c:import var="config" url="/WEB-INF/aggregator/health_application/hcf_config.xml" />
		<go:soapAggregator config = "${config}"
						transactionId = "1234" 
						xml = "${testXML}" 
					    var = "resultXml"
					    debugVar="debugXml" />
--%>	
	</body>
</go:html>