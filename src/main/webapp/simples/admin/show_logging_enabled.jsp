<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>
<%@ include file="/WEB-INF/security/core.jsp" %>

<settings:setVertical verticalCode="SIMPLES" />

<%-- Clear auth data --%>
<go:setData dataVar="authenticatedData" xpath="login" value="*DELETE" />
<go:setData dataVar="authenticatedData" xpath="messages" value="*DELETE" />

<%-- Log in / authenticate user --%>
<c:set var="login"><core:login uid="${param.uid}" /></c:set>
<c:set var="callCentre" scope="session"><simples:security key="callCentre" /></c:set>
<c:set var="isRoleSupervisor" scope="session"><simples:security key="supervisor" /></c:set>
<c:set var="isRoleIT" scope="session"><simples:security key="IT" /></c:set>

<c:choose>
	<c:when test="${ sessionScope != null and not empty(sessionScope.isLoggedIn) and sessionScope.isLoggedIn == 'true' }">
		<c:set var="logoutText" value="Log Out" />
		<c:set var="userInfo" value="${sessionScope.userDetails['displayName']} (${pageContext.request.remoteUser})" />
	</c:when>
	<c:otherwise>
		<c:set var="logoutText" value="Clear Session Details" />
		<c:set var="userInfo" value="" />
	</c:otherwise>
</c:choose>

<c:set var="environment" value="${environmentService.getEnvironmentAsString()}" />

<%-- Disable for production --%>

<c:if test="${environment == 'localhost' ||
			environment == 'NXI'  ||
			environment == 'NXS' ||
			environment == 'NXQ'}">
	<sql:setDataSource dataSource="jdbc/ctm"/>

	<sql:query  var="ServicePropertiesLocal">
		SELECT sm.serviceCode , vm.verticalName,  environmentCode , servicePropertyValue , 
		effectiveStart , effectiveEnd 
		FROM ctm.service_master sm
		INNER JOIN ctm.service_properties sp
		ON sp.serviceMasterId = sm.serviceMasterId
		AND servicePropertyKey = 'isWriteToFile'
		INNER JOIN ctm.vertical_master vm
		ON vm.verticalId  = sm.verticalId
		WHERE (environmentCode = '0' OR environmentCode = 'LOCALHOST')
		AND now() > effectiveStart;
	</sql:query>

	<sql:query  var="ServicePropertiesNXI">
		SELECT sm.serviceCode , vm.verticalName,  environmentCode , servicePropertyValue , 
		effectiveStart , effectiveEnd 
		FROM ctm.service_master sm
		INNER JOIN ctm.service_properties sp
		ON sp.serviceMasterId = sm.serviceMasterId
		AND servicePropertyKey = 'isWriteToFile'
		
		INNER JOIN ctm.vertical_master vm
		ON vm.verticalId  = sm.verticalId
		WHERE (environmentCode = '0' OR environmentCode = 'NXI')
		AND now() > effectiveStart;
	</sql:query>

	<sql:query  var="ServicePropertiesNXQ">
		SELECT sm.serviceCode , vm.verticalName,  environmentCode , servicePropertyValue , 
		effectiveStart , effectiveEnd 
		FROM ctm.service_master sm
		INNER JOIN ctm.service_properties sp
		ON sp.serviceMasterId = sm.serviceMasterId
		AND servicePropertyKey = 'isWriteToFile'
		
		INNER JOIN ctm.vertical_master vm
		ON vm.verticalId  = sm.verticalId
		WHERE (environmentCode = '0' OR environmentCode = 'NXQ')
		AND now() > effectiveStart;
	</sql:query>

	<sql:query  var="ServicePropertiesProd">
		SELECT sm.serviceCode , vm.verticalName,  environmentCode , servicePropertyValue , 
		effectiveStart , effectiveEnd 
		FROM ctm.service_master sm
		INNER JOIN ctm.service_properties sp
		ON sp.serviceMasterId = sm.serviceMasterId
		AND servicePropertyKey = 'isWriteToFile'
		INNER JOIN ctm.vertical_master vm
		ON vm.verticalId  = sm.verticalId
		WHERE (environmentCode = '0' OR environmentCode = 'PRO')
		AND now() > effectiveStart;
	</sql:query>


	<%-- HTML --%>
	<layout:simples_page fullWidth="true" >

		<jsp:attribute name="head">
			<link rel="stylesheet" href="framework/jquery/plugins/jquery.nouislider/jquery.nouislider-6.2.0.css">
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

		<jsp:body>
			<h5>Local</h5>
			<table>
			<tr>
			<th>Service Name</th><th>Vertical</th><th>Logging Enabled</th><th>Start</th><th>End</th>
			</tr>
				<c:forEach var="row" items="${ServicePropertiesLocal.rows}">
				<tr>
					<td>${row.serviceCode}</td><td>${row.verticalName}</td><td>${row.servicePropertyValue}</td><td>${row.effectiveStart}</td><td>${row.effectiveEnd}</td>
				</tr>
				</c:forEach>
			</table>

			<h5>NXI</h5>
						<table>
			<tr>
				<th>Service Name</th><th>Vertical</th><th>Logging Enabled</th><th>Start</th><th>End</th>
			</tr>
				<c:forEach var="row" items="${ServicePropertiesLocal.rows}">
				<tr>
					<td>${row.serviceCode}</td><td>${row.verticalName}</td><td>${row.servicePropertyValue}</td><td class="lastRow">${row.effectiveStart}</td><td class="lastRow">${row.effectiveEnd}</td>
				</tr>
				</c:forEach>
			</table>

			<h5>NXQ</h5>
						<table>
			<tr>
				<th>Service Name</th><th>Vertical</th><th>Logging Enabled</th><th>Start</th><th>End</th>
			</tr>
				<c:forEach var="row" items="${ServicePropertiesLocal.rows}">
				<tr>
					<td>${row.serviceCode}</td><td>${row.verticalName}</td><td>${row.servicePropertyValue}</td><td class="lastRow">${row.effectiveStart}</td><td class="lastRow">${row.effectiveEnd}</td>
				</tr>
				</c:forEach>
			</table>

			
			<h5>Production</h5>
			<table>
			<tr>
				<th>Service Name</th><th>Vertical</th><th>Logging Enabled</th><th>Start</th><th>End</th>
			</tr>
				<c:forEach var="row" items="${ServicePropertiesLocal.rows}">
				<tr>
					<td>${row.serviceCode}</td><td>${row.verticalName}</td><td>${row.servicePropertyValue}</td><td class="lastRow">${row.effectiveStart}</td><td class="lastRow">${row.effectiveEnd}</td>
				</tr>
				</c:forEach>
			</table>
			
		</jsp:body>

	</layout:simples_page>
</c:if>