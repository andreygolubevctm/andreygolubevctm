<%@page import="java.util.Date"%>
<%@ page language="java" contentType="application/json; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<c:set var="logger" value="${log:getLogger('jsp.ajax.write.competition')}" />

<core_v1:transaction touch="P" noResponse="true" />

<security:populateDataFromParams rootPath="competition" />

<c:set var="styleCodeId">2</c:set>
<c:set var="styleCode">meer</c:set>


<%-- Variables --%>
<c:set var="competition_id" value="${competition_id}" />
<c:set var="competition_email" value="${email}" />
<c:set var="brand" value="${styleCode}" />
<c:set var="vertical" value="COMPETITION" />
<c:set var="source" value="Meerkat" />
<c:set var="errorPool" value="" />
<c:set var="promoCode" value="" />

<%-- STEP 1: Check if the email exists in the DB. If not, then write email data to aggregator.email_master and get the EmailID --%>
<c:catch var="error">
<sql:setDataSource dataSource="${datasource:getDataSource()}"/>
<sql:query var="email_exist">
SELECT emailId, hashedEmail
FROM aggregator.email_master
WHERE emailAddress = ?
AND styleCodeId = ?
LIMIT 1;
<sql:param value="${competition_email}" />
<sql:param value="${styleCodeId}" />
</sql:query>
<sql:query var="entry_exist">
SELECT entry_id
FROM ctm.competition_master
WHERE email_id = ?
LIMIT 1;
<sql:param>${email_exist.rows[0].emailId}</sql:param>
</sql:query>
</c:catch>

<c:choose>
<c:when test="${empty entry_exist or entry_exist.rowCount == 0}">
<c:catch var="error">
<agg_v1:write_email
    source="${source}"
    brand="${brand}"
    vertical="${vertical}"
    emailAddress="${competition_email}"
    firstName="${first_name}"
    lastName="${last_name}"
    items="marketing=${marketing},okToCall=N" />

<sql:setDataSource dataSource="${datasource:getDataSource()}"/>
<sql:query var="emailMaster">
SELECT emailId, hashedEmail
FROM aggregator.email_master
WHERE emailAddress = ?
AND styleCodeId = ?
LIMIT 1;
<sql:param value="${competition_email}" />
<sql:param value="${styleCodeId}" />
</sql:query>
</c:catch>
</c:when>
</c:choose>

<%-- STEP 2: Write competition details to ctm.competition_data --%>
<c:choose>
<c:when test="${empty error and not empty emailMaster and emailMaster.rowCount > 0}">

<c:set var="email_id">
<c:if test="${not empty emailMaster and emailMaster.rowCount > 0}">${emailMaster.rows[0].emailId}</c:if>
</c:set>

<c:choose>
<c:when test="${empty email_id}">
<c:set var="errorPool" value="{error:'Failed to retrieve the emailId to make the entry.'}" />
</c:when>
<c:otherwise>
<c:set var="items">firstname=${first_name}::lastname=${last_name}::email=${email}::postcode=${post_code}::phone=${phone_number}::name1=${name_1}::name2=${name_2}::name3=${name_3}::name4=${name_4}::reason=${reason}::age18=${age_18}</c:set>

<c:set var="entry_result">
<agg_v1:write_competition
    competition_id="${competition_id}"
    email_id="${email_id}"
    items="${items}"
/>
</c:set>

<c:if test="${entry_result eq false}">
<c:set var="errorPool" value="{error:'Failed to create entry in database.'}" />
</c:if>
</c:otherwise>
</c:choose>

<%-- STEP 3: Return results to the client --%>

</c:when>
<c:when test="${not empty email_exist and email_exist.rowCount > 0}">
<c:set var="errorPool" value='{"error":"Email address already present in database."}' />
</c:when>
<c:when test="${empty error and (empty emailMaster or emailMaster.rowCount == 0)}">
${logger.warn('Failed to locate emailId. {}' , log:kv('email', competition_email))}
<c:set var="errorPool" value='{"error":"Failed to locate registered user."}' />
</c:when>
<c:otherwise>
${logger.error('Database error querying aggregator.email_master. {}', log:kv('email', competition_email) , error)}
<c:set var="errorPool" value="{error:'${error}'}" />
</c:otherwise>
</c:choose>

<%-- JSON RESPONSE --%>
<c:choose>
<c:when test="${not empty errorPool}">
${logger.info('Returning errors to the browser', log:kv('errorPool', errorPool))}
${errorPool}

<c:import var="fatal_error" url="/ajax/write/register_fatal_error.jsp">
<c:param name="transactionId" value="${data.current.transactionId}" />
<c:param name="page" value="${pageContext.request.servletPath}" />
<c:param name="message" value="Competition error" />
<c:param name="description" value="${errorPool}" />
<c:param name="data" value="competition_id:${competition_id} email:${competition_email} firstname:${first_name} lastname:${last_name} email:${email} postcode:${post_code} phone:${phone_number} name1:${name_1} name2:${name_2} name3:${name_3} name4:${name_4} reason:${reason} age18:${age_18}" />
</c:import>
</c:when>
<c:otherwise>
{
"result": "New entry created in the database."
}
</c:otherwise>
</c:choose>