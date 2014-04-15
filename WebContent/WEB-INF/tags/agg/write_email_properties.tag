<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Stamp an action in the database"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<sql:setDataSource dataSource="jdbc/aggregator" />

<%@ attribute name="items"			required="true"	 rtexprvalue="true"	 description="Set of properties and values to record in the database delimited by ," %>
<%@ attribute name="email"			required="true"	 rtexprvalue="true"	 description="Which email to record the properties against" %>
<%@ attribute name="brand"		 	required="true"	 rtexprvalue="true"	 description="The brand (ie. ctm, cc, etc.)" %>
<%@ attribute name="vertical"	 	required="false" rtexprvalue="true"	 description="The vertical (ie. health, car, etc.)" %>
<%@ attribute name="stampComment"	required="false" rtexprvalue="true"	 description="The comment to add to the stamp action if any" %>

<c:forTokens items="${items}" delims="," var="itemValue">
	<c:set var="propertyId" value="${fn:substringBefore(itemValue,'=')}" />
	<c:set var="value" value="${fn:substringAfter(itemValue,'=')}" />

	<c:choose>
		<%-- VERTICAL IS SET, ONLY INSERT/UPDATE VALUE FOR THIS VERTICAL --%>
		<c:when test="${not empty vertical}">
			
			<sql:update var="results">
				INSERT INTO aggregator.email_properties
				(emailAddress,propertyId,brand,vertical,value)
				VALUES (?,?,?,?,?) ON DUPLICATE KEY UPDATE
					value = ?;
				<sql:param value="${email}" />
				<sql:param value="${propertyId}" />
				<sql:param value="${fn:toLowerCase(brand)}" />
				<sql:param value="${fn:toLowerCase(vertical)}" />
				<sql:param value="${value}" />
				<sql:param value="${value}" />
			</sql:update>
			
		</c:when>
		
		<%-- VERTICAL IS NOT SET, CHANGE VALUE FOR ALL VERTICALS --%>
		<c:otherwise>
			
			<%-- check if the property exists --%>
			<c:set var="property_result">
				<sql:query var="results">
					SELECT emailAddress 
					FROM aggregator.email_properties
					WHERE propertyId=?
					AND emailAddress=?
					AND brand=?;
					
					<sql:param value="${propertyId}" />
					<sql:param value="${email}" />
					<sql:param value="${brand}" />
				</sql:query>
				
				<c:choose>
					<c:when test="${results.rowCount > 0}">${true}</c:when>
					<c:otherwise>${false}</c:otherwise>		
				</c:choose>
			</c:set>
			
			<%--
			Not sure why they would try to change the property if there was no value saved for it
			in any case let's create the property and update the property value
			--%>
			<c:choose>
				<c:when test="${property_result eq false}">
					<sql:update>
						INSERT INTO aggregator.email_properties
						(emailAddress,brand,propertyId,value)
						VALUES (?,?,?,?);
						
						<sql:param value="${email}" />
						<sql:param value="${brand}" />
						<sql:param value="${propertyId}" />
						<sql:param value="${value}" />
					</sql:update>
				</c:when>
				<c:otherwise>
					<sql:update var="result">
						UPDATE aggregator.email_properties
						SET
						value=?
						WHERE propertyId=?
						AND emailAddress=?
						AND brand=?;
						
						<sql:param value="${value}" />
						<sql:param value="${propertyId}" />
						<sql:param value="${email}" />
						<sql:param value="${brand}" />
					</sql:update>
				</c:otherwise>
			</c:choose>
			
		</c:otherwise>
	</c:choose>

	<%-- Only need to stamp the email for the marketing action (we don't have a phone number to stamp the okToCall action) --%>
	<c:if test="${propertyId eq 'marketing'}">
		<agg:write_stamp
			action="toggle_${propertyId}"
			brand="${fn:toLowerCase(brand)}"
			vertical="${fn:toLowerCase(vertical)}"
			target="${email}"
			value="${value}"
			comment="${stampComment}" />
	</c:if>
</c:forTokens>