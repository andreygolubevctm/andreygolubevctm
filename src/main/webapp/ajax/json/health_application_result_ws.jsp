<%@ page language="java" contentType="text/json; charset=UTF-8"
         pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<c:set var="logger" value="${log:getLogger(pageContext.request.servletPath)}"/>

<session:get settings="true" authenticated="true" verticalCode="HEALTH" throwCheckAuthenticatedError="true"/>

<%-- Load the params into data --%>
<security:populateDataFromParams rootPath="health"/>

<%-- Adjust the base rebate using multiplier - this is to ensure the rebate applicable to the
					commencement date is sent to the provider --%>




                <c:choose>
                    <c:when test="${isValid || continueOnAggregatorValidationError}">
                        <c:if test="${!isValid}">
                            <c:forEach var="validationError" items="${validationErrors}">
                                <error:non_fatal_error origin="health_application.jsp"
                                                       errorMessage="${validationError.message} ${validationError.elementXpath}"
                                                       errorCode="VALIDATION"/>
                            </c:forEach>
                        </c:if>
                        <%-- //FIX: turn this back on when you are ready!!!!
                        <%-- Write to the stats database
                        <agg:write_stats tranId="${tranId}" debugXml="${debugXml}" />
                        --%>


                        <%-- Add the results to the current session data --%>
                        <go:setData dataVar="data" xpath="app-response" value="*DELETE"/>
                        <go:setData dataVar="data" xpath="app-response" xml="${resultXml}"/>

                        <x:parse doc="${resultXml}" var="resultOBJ"/>
                        <c:set var="errorMessage" value=""/>

                        <%-- Check for internal or provider errors and record the failed submission and add comments to the quote for call centre staff --%>
                        <x:if select="count($resultOBJ//*[local-name()='errors']/error) > 0 or local-name($resultOBJ)='error'">
                            <x:forEach select="$resultOBJ//*[local-name()='errors']/error" var="error" varStatus="pos">
                                <c:if test="${not empty errorMessage}">
                                    <c:set var="errorMessage" value="${errorMessage}; "/>
                                </c:if>
                                <c:set var="errorMessage">${errorMessage}[${pos.count}]
                                    <x:out select="$error/text"/>
                                </c:set>
                            </x:forEach>

                            <c:if test="${empty errorMessage}">
                                <x:if select="local-name($resultOBJ)='error'">
                                    <c:set var="errorMessage">
                                        <x:out select="$resultOBJ//message"/>
                                        (Please report to CTM IT before continuing)
                                    </c:set>
                                </x:if>
                            </c:if>

                            <%-- Collate fund error messages, add fail touch and add quote comment --%>
                            <c:if test="${not empty errorMessage}">
                                <health:set_to_pending errorMessage="${errorMessage}" resultXml="${resultXml}"
                                                       transactionId="${tranId}" productId="${productId}"/>
                            </c:if>
                        </x:if>

                        <%-- Set transaction to confirmed if application was successful --%>
                        <x:choose>
                            <x:when select="$resultOBJ//*[local-name()='success'] = 'true'">
                                <core:transaction touch="C" noResponse="true" productId="${productId}"/>

                                <c:set var="ignore">
                                    <jsp:useBean id="joinService" class="com.ctm.services.confirmation.JoinService"
                                                 scope="page"/>
                                    ${joinService.writeJoin(tranId,productId)}
                                </c:set>

                                <c:set var="allowedErrors" value=""/>
                                <c:catch var="writeAllowableErrorsException">
                                    <%-- Check any allowable errors and save to the database --%>
                                    <x:set var="allowAbleErrorCount"
                                           select="count($resultOBJ//*[local-name()='allowedErrors']/error)"/>
                                    <c:if test="${allowAbleErrorCount > 0}">
                                        <x:forEach select="$resultOBJ//*[local-name()='allowedErrors']/error"
                                                   var="error" varStatus="pos">
                                            <c:set var="allowedErrors">${allowedErrors}
                                                <x:out select="$error/code"/>
                                            </c:set>
                                            <c:if test="${status.count < allowAbleErrorCount - 1}">
                                                <c:set var="allowedErrors">${allowedErrors},</c:set>
                                            </c:if>
                                        </x:forEach>
                                        <jsp:useBean id="healthTransactionDao"
                                                     class="com.ctm.dao.health.HealthTransactionDao" scope="page"/>
                                        ${healthTransactionDao.writeAllowableErrors(tranId , allowedErrors)}
                                    </c:if>
                                </c:catch>
                                <c:if test="${not empty writeAllowableErrorsException}">
                                    ${logger.warn('Exception thrown writing allowable errors. {}', log:kv('resultOBJ', $resultOBJ), writeAllowableErrorsException)}
                                    <error:non_fatal_error origin="health_application.jsp"
                                                           errorMessage="failed to writeAllowableErrors tranId:${tranId} allowedErrors:${allowedErrors}"
                                                           errorCode="DATABASE"/>
                                </c:if>

                                <%-- Save confirmation record/snapshot --%>
                                <c:import var="saveConfirmation" url="/ajax/write/save_health_confirmation.jsp">
                                    <c:param name="policyNo">
                                        <x:out select="$resultOBJ//*[local-name()='policyNo']"/>
                                    </c:param>
                                    <c:param name="startDate" value="${data['health/payment/details/start']}"/>
                                    <c:param name="frequency" value="${data['health/payment/details/frequency']}"/>
                                    <c:param name="bccEmail">
                                        <x:out select="$resultOBJ//*[local-name()='bccEmail']"/>
                                    </c:param>
                                </c:import>

                                <%-- Check outcome was ok --%>
                                <x:parse doc="${saveConfirmation}" var="saveConfirmationXml"/>
                                <x:choose>
                                    <x:when select="$saveConfirmationXml/response/status = 'OK'">
                                        <c:set var="confirmationID">
                                            <x:out select="$saveConfirmationXml/response/confirmationID"/>
                                        </c:set>
                                    </x:when>
                                    <x:otherwise></x:otherwise>
                                </x:choose>
                                ${logger.info('Transaction has been set to confirmed. {},{}', log:kv('transactionId' , tranId), log:kv('confirmationID',confirmationID ))}
                                <c:set var="confirmationID"><confirmationID><c:out value="${confirmationID}"/>
                                    </confirmationID></result>
                                </c:set>
                                <c:set var="resultXml" value="${fn:replace(resultXml, '</result>', confirmationID)}"/>
                                ${go:XMLtoJSON(resultXml)}
                            </x:when>
                            <%-- Was not successful --%>
                            <%-- If no fail has been recorded yet --%>
                            <x:otherwise>
                                <c:choose>
                                    <%-- if online user record a join --%>
                                    <c:when test="${empty callCentre && empty errorMessage}">
                                        <health:set_to_pending errorMessage="${errorMessage}" resultXml="${resultXml}"
                                                               transactionId="${tranId}" productId="${productId}"/>
                                    </c:when>
                                    <%-- else just record a failure --%>
                                    <c:when test="${empty errorMessage}">
                                        <core:transaction touch="F" comment="Application success=false"
                                                          noResponse="true" productId="${productId}"/>
                                        ${go:XMLtoJSON(resultXml)}
                                    </c:when>
                                </c:choose>
                            </x:otherwise>
                        </x:choose>
                        ${logger.debug('Health application complete. {},{},{}', log:kv('transactionId',tranId), log:kv('resultXml', resultXml),log:kv( 'debugXml', debugXml))}
                    </c:when>
                    <c:otherwise>
                        <c:choose>
                            <c:when test="${empty callCentre }">
                                <c:set var="resultXml"><result><success>false</success><errors></c:set>
                                <c:forEach var="validationError" items="${validationErrors}">
                                    <c:set var="resultXml">${resultXml}
                                        <error>
                                            <code>${validationError.message}</code>
                                            <original>${validationError.elementXpath}</original>
                                        </error>
                                    </c:set>
                                </c:forEach>
                                <c:set var="resultXml">${resultXml}</errors></result></c:set>
                                <health:set_to_pending errorMessage="${errorMessage}" resultXml="${resultXml}"
                                                       transactionId="${tranId}" productId="${productId}"/>
                            </c:when>
                            <c:otherwise>
                                <agg:outputValidationFailureJSON validationErrors="${validationErrors}"
                                                                 origin="health_application.jsp"/>
                            </c:otherwise>
                        </c:choose>
                    </c:otherwise>
                </c:choose>
