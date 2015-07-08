<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Stamp an action in the database"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<c:set var="styleCodeId">${pageSettings.getBrandId()}</c:set>
<c:set var="brand">${pageSettings.getBrandCode()}</c:set>

<sql:setDataSource dataSource="jdbc/ctm" />

<%@ attribute name="items"			required="true"	 rtexprvalue="true"	 description="Set of properties and values to record in the database delimited by ," %>
<%@ attribute name="emailId"			required="true"	 rtexprvalue="true"	 description="Which emailId to record the properties against" %>
<%@ attribute name="email"			required="true"	 rtexprvalue="true"	 description="Which email to record the properties against" %>
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
				(emailId,emailAddress,propertyId,brand,vertical,value)
				VALUES (?,?,?,?,?,?) ON DUPLICATE KEY UPDATE
					value = ?;
				<sql:param value="${emailId}" />
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
					SELECT emailId
					FROM aggregator.email_properties
					WHERE emailId=?
					AND propertyId=?
					AND brand=?;

					<sql:param value="${emailId}" />
					<sql:param value="${propertyId}" />
					<sql:param value="${brand}" />
				</sql:query>

				<go:log level="INFO" source="agg:write_email_properties">
					propertyId value="${propertyId}" />
					emailId value="${emailId}" />
					brand value="${brand}" />
				</go:log>

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
						(emailId,emailAddress,brand,propertyId,value)
						VALUES (?,?,?,?,?);

						<sql:param value="${emailId}" />
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
						WHERE emailId=?
						AND propertyId=?
						AND brand=?;

						<sql:param value="${value}" />
						<sql:param value="${emailId}" />
						<sql:param value="${propertyId}" />
						<sql:param value="${brand}" />
					</sql:update>
				</c:otherwise>
			</c:choose>

		</c:otherwise>
	</c:choose>

	<%-- Only need to stamp the email for the marketing action (we don't have a phone number to stamp the okToCall action) [HLT-1034] --%>
	<%-- Add stamp for okToCall for all other verticals except health as health using health:write_optins [AGG-1912] --%>

	<c:if test="${propertyId eq 'marketing' or fn:toLowerCase(vertical) ne 'health'}">
		<agg:write_stamp
			action="toggle_${propertyId}"
			vertical="${fn:toLowerCase(vertical)}"
			target="${email}"
			value="${value}"
			comment="${stampComment}" />
	</c:if>
</c:forTokens>