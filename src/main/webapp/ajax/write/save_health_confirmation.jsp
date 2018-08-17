<%@ page language="java" contentType="text/xml; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<c:set var="logger" value="${log:getLogger('jsp.ajax.write.save_health_confirmation')}" />

<session:get />
<jsp:useBean id="providerContentService" class="com.ctm.web.health.services.ProviderContentService" scope="page" />

<%--
SAVING A SUCCESSFUL HEALTH APPLICATION
======================================
Creates a historical snapshot of a confirmed health policy in XML with certain JSON and HTML objects.
- the about, whatsnext data
- the policy start date & policy Number
- the product information
--%>
<c:set var="tranId" value="${data.current.transactionId}" />

<c:set var="xmlData">
	<?xml version="1.0" encoding="UTF-8"?>
	<data>
		<transID>${tranId}</transID>
		<status>OK</status>
		<vertical>CTMH</vertical>
		<startDate>${param.startDate}</startDate>
		<frequency>${param.frequency}</frequency>
		<about><![CDATA[ ${providerContentService.getProviderContentText(pageContext.getRequest(), data.health.application.providerName, data.current.brandCode, "ABT")} ]]></about>
		<whatsNext><![CDATA[ ${providerContentService.getProviderContentText(pageContext.getRequest(), data.health.application.providerName, data.current.brandCode, "NXT")} ]]></whatsNext>
		<product>${data.confirmation.health}</product>
		<policyNo>${param.policyNo}</policyNo>
	</data>
</c:set>

<sql:setDataSource dataSource="${datasource:getDataSource()}"/>
<c:catch var="detailsError">
	<sql:update>
 		INSERT INTO aggregator.transaction_details 
 		(transactionId,sequenceNo,xpath,textValue,numericValue,dateValue) 
 		values (?, ?, ?, ?,	default, now());
		<sql:param value="${tranId}" />
    	<sql:param value="${-2}" />
    	<sql:param value="health/policyNo" />
    	<sql:param value="${param.policyNo}" />						 		
	</sql:update>
</c:catch>
				
<%-- Save the form information to the database  --%>	
<c:catch var="error">
	 <sql:update var="result">
		INSERT INTO ctm.`confirmations`
		(TransID, KeyId, Time, XMLdata) VALUES (?, ?, NOW(), ?);
		<sql:param value="${tranId}" />
		<sql:param value="${pageContext.session.id}-${tranId}" />
		<sql:param value="${xmlData}" />
	 </sql:update>
</c:catch>

<%-- COMPETITION APPLICATION START --%>
<c:set var="competitionApplicationEnabledSetting"><content:get key="competitionApplicationEnabled"/></c:set>
<c:if test="${competitionApplicationEnabledSetting eq 'Y' and not callCentre}">
	<c:choose>
		<c:when test="${not empty data['health/application/mobile']}">
			<c:set var="contactPhone" value="${data['health/application/mobile']}"/>
		</c:when>
		<c:otherwise>
			<c:set var="contactPhone" value="${data['health/application/other']}"/>
		</c:otherwise>
	</c:choose>

	<%-- ENTER FEB 2015 JEEP COMPETITION - HLT-1737 --%>
	<c:if test="${empty jeepCompetitionEnabledFlag}">
		<jsp:useBean id="competitionService" class="com.ctm.web.core.competition.services.CompetitionService" />
		<c:set var="jeepCompetitionEnabledFlag" scope="session" value="${competitionService.isActive(pageContext.getRequest(), 15)}" />
	</c:if>
	<c:if test="${jeepCompetitionEnabledFlag eq true}">
	<c:import var="response" url="/ajax/write/competition_entry.jsp">
			<c:param name="secret">1F6F87144375AD8BAED4D53F8CF5B</c:param>
		<c:param name="competition_email" value="${fn:trim(data['health/application/email'])}" />
		<c:param name="competition_firstname" value="${fn:trim(data['health/application/primary/firstname'])}" />
		<c:param name="competition_lastname" value="${fn:trim(data['health/application/primary/surname'])}" />
		<c:param name="competition_phone" value="${contactPhone}" />
		<c:param name="transactionId" value="${tranId}" />
	</c:import>
</c:if>
</c:if>
<%-- COMPETITION APPLICATION END --%>

<%-- Generate the Response --%>
<c:choose>
	<c:when test="${not empty error}">
		<c:set var="response">
			<status>ERROR</status>
			<error sql='save'>${error.rootCause}</error>
		</c:set>
	</c:when>
	<c:otherwise>
		<c:set var="response">
			<status>OK</status>
			<confirmationID>${pageContext.session.id}-${tranId}</confirmationID>
		</c:set>

		<jsp:useBean id="tokenServiceFactory" class="com.ctm.web.core.email.services.token.EmailTokenServiceFactory"/>
		<c:set var="tokenService" value="${tokenServiceFactory.getEmailTokenServiceInstance(pageSettings)}" />
		<c:set var="hashedEmail"><security:hashed_email email="${data['health/application/email']}" brand="${pageSettings.getBrandCode()}" /></c:set>

		<c:if test="${pageSettings.getSetting('emailTokenEnabled')}">
			<c:set var="unsubscribeTokenVar" value="${tokenService.generateToken(tranId, hashedEmail, pageSettings.getBrandId(), 'app', 'unsubscribe', null, null, pageSettings.getVerticalCode(), null, true)}" />
		</c:if>

		<c:set var="emailResponse">
			<c:import url="/ajax/json/send.jsp">
				<c:param name="vertical" value="HEALTH" />
				<c:param name="mode" value="app" />
				<c:param name="emailAddress" value="${data['health/application/email']}" />
				<c:param name="bccEmail" value="${param.bccEmail}" />
				<c:param name="unsubscribeToken" value="${unsubscribeTokenVar}"/>
				<c:param name="createUnsubscribeEmailToken" value="${true}"/>
			</c:import>
		</c:set>
		
		<%-- Store the emailResponse's ID against the transaction to know it was emailed --%>
		<%-- emailResponseXML is created as a session variable inside send.jsp and send.jsp under dreammail (one imports the other) --%>
		<c:catch var="storeEmailResponse">
			<c:if test="${not empty emailResponseXML}">
				
				<x:parse xml="${emailResponseXML}" var="confirmationXML" />

				<%-- //FIX: handle the error and force it into the --%>
				<c:set var="confirmationCode">
					<x:choose>
						<%-- For ExactTarget style responses: --%>
						<x:when select="$confirmationXML//*[local-name()='Body']/*[name()='CreateResponse']/*[name()='RequestID']"><x:out select="$confirmationXML//*[local-name()='Body']/*[name()='CreateResponse']/*[name()='RequestID']" /></x:when>
						<%-- For old (Permission???) based responses: --%>
						<%-- 
						<x:when select="$confirmationXML/DMResponse/ResultData/TransactionID"><x:out select="$confirmationXML/DMResponse/ResultData/TransactionID" /></x:when>
						--%>
						<x:otherwise>0</x:otherwise>
					</x:choose>
				</c:set>
				
				<sql:setDataSource dataSource="${datasource:getDataSource()}"/>
				<sql:update>
			 		INSERT INTO aggregator.transaction_details 
			 		(transactionId,sequenceNo,xpath,textValue,numericValue,dateValue) 
			 		values (?, ?, ?, ?,	default, now());
					<sql:param value="${tranId}" />
			    	<sql:param value="${-1}" />
			    	<sql:param value="health/confirmationEmailCode" />
			    	<sql:param value="${confirmationCode}" />						 		
				</sql:update>
			</c:if>
		</c:catch>
		<c:choose>
			<c:when test="${empty storeEmailResponse}">
				${logger.info('Updated transaction details with record of email provider\'s confirmation code. {}', log:kv('confirmationCode',confirmationCode ))}
			</c:when>
			<c:otherwise>
				${logger.info('Failed to Update transaction details with record of confirmation code. {}', log:kv('storeEmailResponse',storeEmailResponse ))}
			</c:otherwise>
		</c:choose>
	</c:otherwise>
</c:choose>

<?xml version="1.0" encoding="UTF-8"?>
<response>
	${response}
</response>