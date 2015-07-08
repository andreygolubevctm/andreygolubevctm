<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>

<%@ include file="/WEB-INF/tags/taglib.tagf" %>
<html>
<head>
<title>AGG-1505</title>
</head>
<body>

	<sql:setDataSource dataSource="jdbc/ctm"/>

	<%--Fetch all records that have been affected --%>
	<sql:query var="result">
		select * from ctm.competition_data where property_id ='firstname' and value like'%|%';
	</sql:query>

	<table border="1" width="60%">
		<tr>
			<th>Entry ID</th>
			<th>Property ID</th>
			<th>Value</th>
		</tr>
			<c:forEach var="row" items="${result.rows}" >

			<%-- Get the last name --%>
			<c:set var="entry_id" value="${row.entry_id}"/>

			<%-- Split the string firstname||lastname=??||phone=<multiple values> -> preference mobile/other/otherinput --%>
			<c:set var="raw" value="${row.value}"/>
			<c:set var="splitString" value="${fn:split(raw, '|')}" />

					<c:forEach var="strValue" items="${splitString}" varStatus="i">
						<tr>
							<td><c:out value="${entry_id}"/></td>
							<td>
								<c:choose>
									<c:when test="${i.index == 0}">
										<c:out value="Firstname"/>
									</c:when>
									<c:when test="${i.index == 1}">
										<c:out value="Lastname"/>
									</c:when>
									<c:when test="${i.index == 2}">
										<c:out value="Phone"/>
									</c:when>
								</c:choose>

							</td>
							<td>
							<c:choose>
								<c:when test="${i.index == 0}">
									<c:set var="property_id" value="firstname"/>
									<c:set var="value" value="${splitString[i.index]}"/>
								</c:when>
									<c:when test="${i.index == 1}">
								<%-- Last name. Replace lastname= with "" --%>

								<c:set var="lastname" value="${splitString[i.index]}"/>
									<c:set var="property_id" value="lastname"/>
									<c:set var="value" value="${fn:replace(lastname,'lastname=','') }"/>
								</c:when>
								<c:when test="${i.index == 2}">
								<%-- Phone Number - XML parse to see which is the best one to use --%>
									<c:set var="property_id" value="phone"/>

								<c:set var="theXML" value="${splitString[i.index]}"/>
								<c:set var="theFinalXML" value="${fn:replace(theXML,'phone=','')}"/>


								<x:parse var="output" doc="${theFinalXML}" scope="page"/>

								<c:set var="value" scope="page">
									<x:choose>
										<x:when select="$output/contactNumber/mobile">
											<x:out  select="$output/contactNumber/mobile"/>
										</x:when>
										<x:otherwise>
											<x:out  select="$output/contactNumber/other"/>
										</x:otherwise>
									</x:choose>
								</c:set>
							</c:when>
				</c:choose>

			<%-- Update the records --%>
				<c:catch var="error">
					<sql:transaction>
							<c:if test="${not empty property_id}">
									<sql:update var="results">
												INSERT INTO ctm.competition_data
												(entry_id, property_id, value)
												VALUES (?,?,?)
												ON DUPLICATE KEY UPDATE
													value = ?;
												<sql:param value="${entry_id}" />
												<sql:param value="${property_id}" />
												<sql:param value="${value}" />
												<sql:param value="${value}" />
									</sql:update>
								</c:if>
					</sql:transaction>
				</c:catch>

				<c:choose>
					<c:when test="${not empty error}">
						<go:log>Error adding to competition_master: ${error}</go:log>
					</c:when>
					<c:otherwise>
						Done!
					</c:otherwise>
				</c:choose>
							</td>
						</tr>
					</c:forEach>
			</c:forEach>

		</table>
	</body>
</html>