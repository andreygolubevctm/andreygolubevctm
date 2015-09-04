<%@ page language="java" contentType="text/xml; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.util.GregorianCalendar" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>
<c:set var="logger" value="${log:getLogger(pageContext.request.servletPath)}" />

<jsp:useBean id="data" class="com.disc_au.web.go.Data" scope="request" />

<%--
	The data will arrive in a single parameter called QuoteData
	Containing the xml for the request in the structure:
	request
	|--fuels
	|--postcode
--%>

<jsp:useBean id="nowMinusSixWeeks" class="java.util.GregorianCalendar" />
<% nowMinusSixWeeks.add(GregorianCalendar.DAY_OF_YEAR, -42); %>
<fmt:formatDate var="nowMinusSixWeeks_Date" pattern="yyyyMMdd" value="${nowMinusSixWeeks.time}" />

<x:parse var="fuel" xml="${param.QuoteData}" />
<c:set var="fuels"><x:out select="$fuel/request/fuels" /></c:set>
<c:set var="postcode"><x:out select="$fuel/request/postcode" /></c:set>
<c:if test="${fn:contains(fuels, '3') and not fn:contains(fuels, '9')}">
	<c:set var="fuels"><c:out value="${fuels}" />,9</c:set>
</c:if>
<sql:setDataSource dataSource="jdbc/ctm"/>

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
				${logger.debug('Got list of site ids. {},{},{}',log:kv('siteids',siteids ),log:kv('nowMinusSixWeeks_Date',nowMinusSixWeeks_Date ),log:kv('fuels',fuels ))}

				<c:catch var="error">
					<sql:query var="fuelprices">
						SELECT ROUND(AVG(r.Price)) AS amount, r.FuelId AS type, CAST(CONCAT_WS('-', YEAR(u.Time), LPAD(MONTH(u.time), 2, '0'), LPAD(DAYOFMONTH(u.time), 2, '0') ) AS CHAR(10)) AS period
						FROM `aggregator`.`fuel_results` AS r
						LEFT JOIN `aggregator`.`fuel_updates` AS u
							ON u.UpdateId = r.UpdateId
						WHERE
							u.Status = 200 AND
							u.Type = 'M' AND
							r.SiteId IN (${siteids}) AND
						CAST(CONCAT(YEAR(u.Time), LPAD(MONTH(u.time), 2, '0'), LPAD(DAYOFMONTH(u.time), 2, '0')  ) AS UNSIGNED) > ${nowMinusSixWeeks_Date} AND
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
						${logger.error('Database error while locating historical fuel prices.{},{}', log:kv('siteids',siteids ), log:kv('fuels', fuels) , error)}
						<error>MK-20004</error>
					</c:otherwise>
				</c:choose>
			</c:when>
			<c:otherwise>
				<error>No fuel sites located for the selected postcode/suburb.</error>
			</c:otherwise>
		</c:choose>
	</c:when>
	<c:otherwise>
		${logger.error('Database error while locating historical fuel prices. {}', log:kv('postcode', postcode), error)}
		<error>MK-20004</error>
	</c:otherwise>
</c:choose>
</results>