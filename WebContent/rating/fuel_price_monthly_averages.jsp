<%@page import="java.util.Date"%>
<%@ page language="java" contentType="text/xml; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@page import="java.util.Calendar"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>
<jsp:useBean id="data" class="com.disc_au.web.go.Data" scope="session" />

<%--
	The data will arrive in a single parameter called QuoteData
	Containing the xml for the request in the structure:
	request
	|--fuels
	|--postcode
--%>

<c:import url="../brand/ctm/settings_fuel.xml" var="settingsXml" />
<go:setData dataVar="data" value="*DELETE" xpath="settings" />
<go:setData dataVar="data" xml="${settingsXml}" />

<c:set var="current_year"><%= String.format("%4d",Calendar.getInstance().get(Calendar.YEAR)) %></c:set>
<c:set var="current_month"><%= String.format("%02d",Calendar.getInstance().get(Calendar.MONTH) + 1) %></c:set>
<c:set var="previous_year"><%= String.format("%4d",Calendar.getInstance().get(Calendar.YEAR) - 1) %></c:set>

<x:parse var="fuel" xml="${param.QuoteData}" />
<c:set var="fuels"><x:out select="$fuel/request/fuels" /></c:set>
<c:set var="postcode"><x:out select="$fuel/request/postcode" /></c:set>

<sql:setDataSource dataSource="jdbc/aggregator"/>

<%-- Retrieve the list of sites for the postcodes provided --%>
<c:catch var="error">
	<%-- GET: all the Post Codes from the search criteria --%>
	<sql:query var="PostcodeListResults" >
		SELECT PostcodeList FROM aggregator.postcode_relations WHERE FIND_IN_SET(PostcodeId, ?);
		<sql:param value="${postcode}" />
	</sql:query>

	<%-- PARSE: them into a single-string --%>
	<c:forEach var="row" varStatus="status" items="${PostcodeListResults.rows}">
		<c:set var="PostcodeList">${PostcodeList} ${row.PostCodeList}<c:if test="${!status.last}">, </c:if></c:set>
	</c:forEach>
	<c:set var="PostcodeList">${postcode}<c:if test="${not empty PostcodeList}">,${PostcodeList}</c:if></c:set>

	<%-- Locate fuel sites for the postcodes --%>
	<sql:query var="fuelsites">
		SELECT s.SiteId FROM `aggregator`.`fuel_sites` AS s
		WHERE s.PostCode IN (${PostcodeList});
	</sql:query>
</c:catch>


<results>
<c:choose>
	<c:when test="${empty error}">
		<c:choose>
			<c:when test="${fuelsites.rowCount > 0}">
				<c:set var="siteids" value="" />
				<c:forEach var="site" varStatus="status" items="${fuelsites.rows}">
					<c:set var="siteids"><c:if test="${not empty siteids}">${siteids},</c:if>${site.SiteId}</c:set>
				</c:forEach>
					<go:log>
						SELECT AVG(r.Price) AS amount, r.FuelId AS type, CAST(CONCAT_WS('-', YEAR(u.Time), LPAD(MONTH(u.time), 2, '0')) AS CHAR(7)) AS period
						FROM `aggregator`.`fuel_results` AS r
						LEFT JOIN `aggregator`.`fuel_updates` AS u
							ON u.UpdateId = r.UpdateId
						WHERE
							u.Status = 200 AND
							u.Type = 'M' AND
							r.SiteId IN (${siteids}) AND
							CAST(CONCAT_WS('', YEAR(u.Time), LPAD(MONTH(u.time), 2, '0')) AS UNSIGNED) > ${previous_year}${current_month} AND
							r.FuelId IN (${fuels})
						GROUP BY period, r.FuelId
						ORDER BY u.UpdateId DESC, FuelId DESC;
					</go:log>

				<c:catch var="error">
					<sql:query var="fuelprices">
						SELECT AVG(r.Price) AS amount, r.FuelId AS type, CAST(CONCAT_WS('-', YEAR(u.Time), LPAD(MONTH(u.time), 2, '0')) AS CHAR(7)) AS period
						FROM `aggregator`.`fuel_results` AS r
						LEFT JOIN `aggregator`.`fuel_updates` AS u
							ON u.UpdateId = r.UpdateId
						WHERE
							u.Status = 200 AND
							u.Type = 'M' AND
							r.SiteId IN (${siteids}) AND
							CAST(CONCAT_WS('', YEAR(u.Time), LPAD(MONTH(u.time), 2, '0')) AS UNSIGNED) > ${previous_year}${current_month} AND
							r.FuelId IN (${fuels})
						GROUP BY period, r.FuelId
						ORDER BY u.UpdateId DESC, FuelId DESC;
					</sql:query>
				</c:catch>
				<c:choose>
					<c:when test="${empty error}">
						<c:choose>
							<c:when test="${fuelprices.rowCount > 0}">
								<fuels>${fuels}</fuels>
								<c:forEach var="price" varStatus="status" items="${fuelprices.rows}">
									<prices>
										<type>${price.type}</type>
										<amount>${price.amount}</amount>
										<period>${price.period}</period>
									</prices>
								</c:forEach>
							</c:when>
							<c:otherwise>
								<error>No historical fuel prices located for selected fuel types.</error>
							</c:otherwise>
						</c:choose>
					</c:when>
					<c:otherwise>
						<error>Database error while locating historical fuel prices.</error>
					</c:otherwise>
				</c:choose>
			</c:when>
			<c:otherwise>
				<error>No fuel sites located for the selected postcode/suburb.</error>
			</c:otherwise>
		</c:choose>
	</c:when>
	<c:otherwise>
		<error>Database error while locating fuel sites for the selected postcode/suburb.${error.rootCause}</error>
	</c:otherwise>
</c:choose>
</results>