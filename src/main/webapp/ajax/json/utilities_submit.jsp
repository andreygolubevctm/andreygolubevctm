<%@ page language="java" contentType="text/json; charset=UTF-8"
         pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<c:set var="logger" value="${log:getLogger(pageContext.request.servletPath)}" />

<session:get settings="true" authenticated="true" verticalCode="UTILITIES"/>

<%-- VARIABLES --%>
<c:set var="brand" value="${pageSettings.getBrandCode()}"/>
<c:set var="vertical" value="${pageSettings.getVerticalCode()}"/>

<%-- Load the params into data --%>
<security:populateDataFromParams rootPath="${vertical}"/>

<%-- RECOVER: if things have gone pear shaped --%>
<c:if test="${empty data.current.transactionId}">
    <error:recover origin="ajax/json/utilities_submit_application.jsp" quoteType="${vertical}"/>
</c:if>

<c:if test="${empty data.utilities.application.details.address.streetNum && empty data.utilities.application.details.address.houseNoSel}">
    <go:setData dataVar="data" xpath="utilities/application/details/address/streetNum" value="0"/>
</c:if>

<c:choose>
    <c:when test="${empty data.utilities.application.thingsToKnow.termsAndConditions != 'Y'}">
        ERROR - NO TERMS AND CONDITIONS
    </c:when>
    <c:otherwise>

        <%-- REGISTER MARKETING OPTIN IF REQUIRED --%>
        <c:if test="${not empty data['utilities/application/details/email']}">
            <agg:write_email
                    brand="${brand}"
                    vertical="${vertical}"
                    source="QUOTE"
                    emailAddress="${data['utilities/application/details/email']}"
                    emailPassword=""
                    firstName="${data['utilities/application/details/firstName']}"
                    lastName="${data['utilities/application/details/lastName']}"
                    items="marketing=${data['utilities/application/thingsToKnow/receiveInfo']}"/>
        </c:if>

        <%-- Get the transaction ID (after recovery etc) --%>
        <c:set var="tranId" value="${data['current/transactionId']}"/>
        <c:set var="rootId" value="${data['current/rootId']}"/>
        <c:if test="${empty tranId}">
            <c:set var="tranId" value="0"/>
        </c:if>
        <c:if test="${empty rootId}">
            <c:set var="rootId" value="0"/>
        </c:if>
        ${logger.info('Utilities Tran Id. {}', log:kv('transactionId', tranId))}

        <%-- SUBMIT TO PARTNER --%>
        <jsp:useBean id="utilitiesApplicationService" class="com.ctm.services.utilities.UtilitiesApplicationService" scope="request"/>
        <c:set var="results" value="${utilitiesApplicationService.submitFromJsp(pageContext.getRequest(), data)}" scope="request" />

        <%-- TESTING IF REQUEST FAILED --%>
        <c:choose>
            <c:when test="${!utilitiesApplicationService.isValid()}">
                <c:set var="json" value='${results}' />
            </c:when>
            <c:when test="${empty results}">
                <% response.setStatus(500); /* Internal Server Error */ %>
                <c:set var="json" value='{"info":{"transactionId":${tranId}}},"errors":[{"message":"submitFromJsp returned empty"}]}'/>
            </c:when>
            <c:otherwise>
                <c:set var="json" value="${results}"/>

                <%-- CREATE CONFIRMATION KEY --%>
                <c:set var="confirmationkey" value="${pageContext.session.id}-${tranId}"/>
                <go:setData dataVar="data" xpath="${vertical}/confirmationkey" value="${confirmationkey}"/>

                <%-- Check that confirmation not already written --%>
                <sql:setDataSource dataSource="jdbc/ctm"/>
                <sql:query var="conf_entry">
                    SELECT KeyID FROM ctm.confirmations WHERE KeyID = ? AND TransID = ? LIMIT 1;
                    <sql:param value="${confirmationkey}"/>
                    <sql:param value="${tranId}"/>
                </sql:query>

                <%-- TESTING IF ALREADY CONFIRMED --%>
                <c:choose>
                    <%-- Already confirmed --%>
                    <c:when test="${conf_entry.rowCount > 0}">
                        <c:set var="json" value='{"confirmationkey":"${confirmationkey}"}'/>
                    </c:when>
                    <c:otherwise>

                        <c:catch var="error">
                            <c:set var="xmlData" value="<data>${go:JSONtoXML(json)}</data>"/>
                            <x:parse var="parsedXml" doc="${xmlData}"/>
                            <c:set var="uniquePurchaseId"><x:out select="$parsedXml/data/uniquePurchaseId" /></c:set>
                        </c:catch>
                        <%-- TESTING IF SERVICE RETURNED PROPERLY FORMED --%>
                        <c:choose>
                            <c:when test="${not empty error}">
                                <c:import var="fatal_error" url="/ajax/write/register_fatal_error.jsp">
                                    <c:param name="transactionId" value="${tranId}"/>
                                    <c:param name="page" value="${pageContext.request.servletPath}"/>
                                    <c:param name="message" value="Invalid json returned from UtilitiesApplicationService Call"/>
                                    <c:param name="description" value="${error}"/>
                                    <c:param name="data" value="confirmationId=${confirmationkey},data=${json.toString()}"/>
                                </c:import>

                                <% response.setStatus(500); /* Internal Server Error */ %>
                                <c:set var="json" value='{"info":{"transactionId":${tranId}}},"errors":[{"message":"${error}"}]}'/>
                            </c:when>
                            <c:otherwise>
                                <c:set var="xmlData">
                                    <confirmation>
                                        <firstName><c:out value="${data['utilities/application/details/firstName']}" /></firstName>
                                        <whatToCompare><c:out value="${data['utilities/householdDetails/whatToCompare']}" /></whatToCompare>
                                        <uniquePurchaseId><c:out value="${uniquePurchaseId}" /></uniquePurchaseId>
                                        <product>
                                            <id><c:out value="${data['utilities/application/thingsToKnow/hidden/productId']}" /></id>
                                            <retailerName><c:out value="${data['utilities/application/thingsToKnow/hidden/retailerName']}" /></retailerName>
                                            <planName><c:out value="${data['utilities/application/thingsToKnow/hidden/planName']}" /></planName>
                                        </product>
                                    </confirmation>
                                </c:set>

                                ${logger.debug('WRITE CONFIRM. {}', log:kv('xmlData', xmlData))}
                                <agg:write_confirmation transaction_id="${tranId}" confirmation_key="${confirmationkey}" vertical="${vertical}"
                                                        xml_data="${xmlData}" />
                                <agg:write_quote productType="UTILITIES" rootPath="utilities"/>
                                <agg:write_touch touch="C" transaction_id="${tranId}"/>
                                <c:if test="${tranId ne rootId}">
                                    <agg:write_touch transaction_id="${rootId}" touch="C" />
                                </c:if>
                                <c:set var="json" value="${fn:substringAfter(results.toString(), '{')}" />
                                <c:set var="json" value='{"confirmationkey":"${confirmationkey}",${json}' />
                            </c:otherwise>
                        </c:choose> <%-- / TESTING IF SERVICE RETURNED PROPERLY FORMED --%>
                    </c:otherwise>
                </c:choose> <%-- / TESTING IF ALREADY CONFIRMED --%>
            </c:otherwise>
        </c:choose> <%-- / TESTING IF REQUEST FAILED --%>
        <c:out value="${json}" escapeXml="false"/>
    </c:otherwise>
</c:choose>