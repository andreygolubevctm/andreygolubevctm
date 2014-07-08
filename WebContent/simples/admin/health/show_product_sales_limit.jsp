<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
	<%@ include file="/WEB-INF/tags/taglib.tagf" %>

	<%--

	WARNING!

	THIS IS FOR TESTING IN DEVELOPMENT ONLY AND HAS NOT BEEN TESTED IN PRODUCTION
	IF THIS IS ENABLED IN PRODUCTION THEN THE ACCESS WILL NEED TO BE REVIEWED
	AS WELL AS THE SQL STATEMENTS.

	--%>

<settings:setVertical verticalCode="GENERIC" />

<c:set var="environment" value="${environmentService.getEnvironmentAsString()}" />

<%-- Disable for production --%>

<c:if test="${environment == 'localhost' ||
			environment == 'NXI'  ||
			environment == 'NXS' ||
			environment == 'NXQ'}">
	<sql:setDataSource dataSource="jdbc/ctm"/>

	<sql:query  var="DailylimitsSet">
		SELECT pm.name , pp.PropertyId , pp.Text,
		pp.EffectiveStart ,  pp.EffectiveEnd
		FROM ctm.provider_properties pp
		INNER JOIN ctm.provider_master pm
		ON pp.providerId = pm.providerId
		WHERE PropertyId like '%DailyLimit%'
		AND pp.EffectiveStart <= CURDATE() AND pp.EffectiveEnd >= CURDATE();
	</sql:query>

	<sql:query  var="MonthlylimitsSet">
		SELECT pm.name , pp.PropertyId , pp.Text,
		pp.EffectiveStart ,  pp.EffectiveEnd
		FROM ctm.provider_properties pp
		INNER JOIN ctm.provider_master pm
		ON pp.providerId = pm.providerId
		WHERE PropertyId like '%MonthlyLimit%'
		AND pp.EffectiveStart <= CURDATE() AND pp.EffectiveEnd >= CURDATE();
	</sql:query>

	<sql:query  var="futureDailylimitsSet">
		SELECT pm.name , pp.PropertyId , pp.Text,
		pp.EffectiveStart ,  pp.EffectiveEnd
		FROM ctm.provider_properties pp
		INNER JOIN ctm.provider_master pm
		ON pp.providerId = pm.providerId
		WHERE PropertyId like '%DailyLimit%'
		AND pp.EffectiveStart > CURDATE();
	</sql:query>

		<sql:query  var="futureMonthlylimitsSet">
		SELECT pm.name , pp.PropertyId , pp.Text,
		pp.EffectiveStart ,  pp.EffectiveEnd
		FROM ctm.provider_properties pp
		INNER JOIN ctm.provider_master pm
		ON pp.providerId = pm.providerId
		WHERE PropertyId like '%MonthlyLimit%'
		AND pp.EffectiveStart > CURDATE();
	</sql:query>


	<sql:query  var="dailyLimit">
		SELECT pm.name , count.currentJoinCount, count.maxJoins, count.limitType,count.limitValue
		FROM ctm.dailySalesCount count
		INNER JOIN ctm.provider_master pm
		ON count.providerId = pm.providerId
		UNION
		SELECT
		pm.name , 0 as currentJoinCount, pp.Text as maxJoins,  pp.PropertyId as limitType, pp.PropertyId as limitValue
		FROM ctm.provider_properties pp
		INNER JOIN ctm.provider_master pm
		ON pp.providerId = pm.providerId
		WHERE PropertyId like '%DailyLimit%'
		AND pp.providerId NOT IN (
		SELECT count.providerId
		FROM ctm.dailySalesCount count
		)
		AND pp.EffectiveStart <= CURDATE() AND pp.EffectiveEnd >= CURDATE();
	</sql:query>

	<sql:query  var="monthlyLimit">
		SELECT pm.name , count.currentJoinCount, count.maxJoins, count.limitType,count.limitValue
		FROM ctm.monthlySalesCount count
		INNER JOIN ctm.provider_master pm
		ON count.providerId = pm.providerId
			UNION
		SELECT
		pm.name , 0 as currentJoinCount, pp.Text as maxJoins,  pp.PropertyId as limitType, pp.PropertyId as limitValue
		FROM ctm.provider_properties pp
		INNER JOIN ctm.provider_master pm
		ON pp.providerId = pm.providerId
		WHERE PropertyId like '%MonthlyLimit%'
		AND pp.providerId NOT IN (
		SELECT count.providerId
		FROM ctm.monthlySalesCount count
		)
		AND pp.EffectiveStart <= CURDATE() AND pp.EffectiveEnd >= CURDATE();
	</sql:query>

	<sql:query  var="lastTenJoins">
		SELECT
			j.rootId,
			provm.name ,
			pps.state,
			j.joinDate,
			th.StyleCode,
			j.rootId IN (
		SELECT rootId from ctm.touches t
		INNER JOIN aggregator.transaction_header th
		ON th.transactionId = t.transaction_Id
		WHERe type = 'C'
		) as joined
		FROM ctm.joins j
		INNER JOIN aggregator.transaction_header th
		ON th.rootId = j.rootId
		INNER JOIN ctm.product_properties_search pps
		on j.ProductId = pps.ProductId
		INNER JOIN ctm.product_master pm
		on j.ProductId = pm.ProductId
		INNER JOIN ctm.provider_master provm
		on provm.providerID = pm.providerID
		ORDER BY j.joinDate DESC
		LIMIT 10;
	</sql:query>

	<%-- HTML --%>
	<layout:generic_page title="Daily and monthly sales limits">

		<jsp:attribute name="head">
			<link rel="stylesheet" href="framework/jquery/plugins/jquery.nouislider/jquery.nouislider-5.0.0.css">
			<style>
				td, th {
					padding:0.5em;
				}

				.highlight {
				background-color: yellow;
				}

				.lastRow {
					text-align: right;
				}
			</style>
		</jsp:attribute>

		<jsp:attribute name="head_meta">
			<%-- <base href="http://a01961.budgetdirect.com.au:8080/ctm/" /> --%>
			<base href="${pageSettings.getBaseUrl()}" />
		</jsp:attribute>

		<jsp:attribute name="header">
		</jsp:attribute>

		<jsp:attribute name="form_bottom">
		</jsp:attribute>

		<jsp:attribute name="footer">
		</jsp:attribute>

		<jsp:attribute name="body_end">
			<script>
				$('#mainform').submit(function(event) {
					event.preventDefault();
				});
			</script>
		</jsp:attribute>

		<jsp:body>
			<h3>Current Limits</h3>
			<h5>Daily</h5>
			<table>
			<tr>
				<th>Provider</th><th>PropertyId</th><th>Limit Value</th><th>Start Date</th><th class="lastRow">End Date</th>
			</tr>
				<c:forEach var="row" items="${DailylimitsSet.rows}">
				<tr>
					<td>${row.name}</td><td>${row.PropertyId}</td><td>${row.Text}</td><td>${row.EffectiveStart}</td><td class="lastRow">${row.EffectiveEnd}</td>
				</tr>
				</c:forEach>
			</table>

			<h5>Monthly</h5>
			<table>

			<tr>
				<th>Provider</th><th>PropertyId</th><th>Limit Value</th><th>Start Date</th><th class="lastRow">End Date</th>
			</tr>
				<c:forEach var="row" items="${MonthlylimitsSet.rows}">
				<tr>
					<td>${row.name}</td><td>${row.PropertyId}</td><td>${row.Text}</td><td>${row.EffectiveStart}</td><td class="lastRow">${row.EffectiveEnd}</td>
				</tr>
				</c:forEach>
			</table>

			<h3>Future Limits</h3>
			<h5>Daily</h5>
			<table>
			<tr>
				<th>Provider</th><th>PropertyId</th><th>Limit Value</th><th>Start Date</th><th class="lastRow">End Date</th>
			</tr>
				<c:forEach var="row" items="${futureMonthlylimitsSet.rows}">
				<tr>
					<td>${row.name}</td><td>${row.PropertyId}</td><td>${row.Text}</td><td>${row.EffectiveStart}</td><td>${row.EffectiveEnd}</td>
				</tr>
				</c:forEach>
			</table>

			<h5>Monthly</h5>
			<table>

			<tr>
				<th>Provider</th><th>Property</th><th>Limit Value</th><th>Start Date</th><th class="lastRow">End Date</th>
			</tr>
				<c:forEach var="row" items="${futureDailylimitsSet.rows}">
				<tr>
					<td>${row.name}</td><td>${row.PropertyId}</td><td>${row.Text}</td><td>${row.EffectiveStart}</td><td class="lastRow">${row.EffectiveEnd}</td>
				</tr>
				</c:forEach>
			</table>


			<h3>Limit Progress</h3>
			<h5>Daily</h5>
			<table>
			<tr>
				<th>Provider</th><th>Join Count</th><th>Join Limit</th><th>Joins Left</th><th>Limit Type</th><th>Limit Value</th><th class="lastRow">Limit reached</th>
			</tr>
				<c:forEach var="row" items="${dailyLimit.rows}">
				<c:set var="joinsLeft" value="${row.maxJoins - row.currentJoinCount}" />
				<c:set var="limitReached" value="${joinsLeft < 1}" />
				<c:choose>
					<c:when test="${limitReached}">
						<c:set var="className" value="highlight" />
						<c:set var="joinsLeft" value="0" />
					</c:when>
					<c:otherwise>
						<c:set var="className" value="" />
					</c:otherwise>
				</c:choose>

				<c:set var="limitValue" value="${row.limitValue}" />
				<c:set var="limitType" value="${row.limitType}" />
				<c:choose>
					<c:when test="${limitValue == 'DailyLimit'}">
						<c:set var="limitValue" value="" />
						<c:set var="limitType" value="GENERAL" />
					</c:when>

					<c:when test="${fn:contains(limitValue, 'DailyLimit')}">
						<c:set var="limitValue" value="${fn:replace(limitValue, 'DailyLimit' , '')}" />
						<c:set var="limitType" value="STATE" />
					</c:when>
				</c:choose>
				<tr class="${className}">
					<td>${row.name}</td><td>${row.currentJoinCount}</td><td>${row.maxJoins}</td><td>${joinsLeft}</td><td>${limitType}</td>
					<td>${limitValue}</td><td class="lastRow">${limitReached}</td>
				</tr>

				</c:forEach>
			</table>
			<h5>Monthly</h5>
			<table>
			<tr>
				<th>Provider</th><th>Join Count</th><th>Join Limit</th><th>Joins Left</th><th>Limit Type</th><th>Limit Value</th><th>Limit reached</th>
			</tr>
				<c:forEach var="row" items="${monthlyLimit.rows}">
				<c:set var="joinsLeft" value="${row.maxJoins - row.currentJoinCount}" />

				<c:set var="limitReached" value="${row.currentJoinCount >= row.maxJoins}" />
				<c:choose>
					<c:when test="${limitReached}">
						<c:set var="className" value="highlight" />
						<c:set var="joinsLeft" value="0" />
					</c:when>
					<c:otherwise>
						<c:set var="className" value="" />
					</c:otherwise>
				</c:choose>

				<c:set var="limitValue" value="${row.limitValue}" />
				<c:set var="limitType" value="${row.limitType}" />
					<c:choose>
					<c:when test="${limitValue == 'MonthlyLimit'}">
						<c:set var="limitValue" value="" />
						<c:set var="limitType" value="GENERAL" />
					</c:when>

					<c:when test="${fn:contains(limitValue, 'MonthlyLimit')}">
						<c:set var="limitValue" value="${fn:replace(limitValue, 'DailyLimit' , '')}" />
						<c:set var="limitType" value="STATE" />
					</c:when>
				</c:choose>
				<tr class="${className}">
					<td>${row.name}</td><td>${row.currentJoinCount}</td><td>${row.maxJoins}</td><td>${joinsLeft}</td><td>${limitType}</td>
					<td>${limitValue}</td><td class="lastRow">${limitReached}</td>
				</tr>

				</c:forEach>
			</table>


			<h3>Last 10 Joins</h3>

			<table>
			<tr>
				<th>Root Id</th><th>Brand</th><th>Provider</th><th>State</th><th>Join Date</th><th>confirmed</th>
			</tr>
				<c:forEach var="row" items="${lastTenJoins.rows}">
				<c:set var="confirmed" value="${row.joined == 1}" />
				<tr>
					<td>${row.rootId}</td><td>${row.StyleCode}</td><td>${row.name}</td><td>${row.state}</td>
					<td><fmt:formatDate value="${row.joinDate}" pattern="dd/MM/yyyy" /></td><td class="lastRow">${confirmed}</td>
				</tr>

				</c:forEach>
			</table>
		</jsp:body>

	</layout:generic_page>
</c:if>