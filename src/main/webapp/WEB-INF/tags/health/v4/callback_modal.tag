<%@ tag description="Call back form"%>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<jsp:useBean id="openingHoursService" class="com.ctm.web.core.openinghours.services.OpeningHoursService" scope="page" />
<c:set var="todayOpeningHours" scope="request" value="${openingHoursService.getOpeningHoursForDisplay(pageContext.getRequest(),'today')}" />
<c:set var="callCentreNumber" scope="request"><content:get key="callCentreNumber"/></c:set>
<c:set var="callCentreAppNumber" scope="request"><content:get key="callCentreAppNumber"/></c:set>
<c:set var="xpath" value="${pageSettings.getVerticalCode()}/callback" />
<c:set var="openingHoursTimeZone"><content:get key="openingHoursTimeZone" /></c:set>

<jsp:useBean id="now" class="java.util.Date" />
<fmt:formatDate var="todays_day" pattern="EEEE" value="${now}" />

<%-- HTML --%>
<core_v1:js_template id="view_all_hours_cb">
    <div id="health-callback" callbackModal="true">
        <div class="row">
            <%--Mobile (xs) modal Layout --%>
            <div class="col-sm-12 visible-xs">
                <h3 class="hidden-xs">Talk to our experts</h3>
                <div class="quote-ref hidden-xs">Quote Ref: <c:out value="${data['current/transactionId']}"/></div>
                <h3 class="quote-ref-xs text-center visible-xs">Quote Ref: <c:out value="${data['current/transactionId']}"/></h3>
            </div>
            <div class="call-details col-sm-4 text-center visible-xs" data-padding-pos="all" >
                <div class="row">
                    <div class="col-sm-12">
                        <c:if test="${not empty todayOpeningHours}">
                            <div class="today-hours-callback-modal">Today, ${todays_day}: <span class="opening-hours-label">${todayOpeningHours}</span></div>
                        </c:if>
                        <div class="all-times-callback-modal hidden">
                            <c:forEach var="hoursOfDay"
                                       items="${openingHoursService.getAllOpeningHoursForDisplay(pageContext.getRequest(),false)}">

                                <c:set var="matchClass" value="" />
                                <c:if test="${hoursOfDay.description eq todays_day}">
                                    <c:set var="matchClass" value="currentCCDay" />
                                </c:if>
                                <div class="row day_row <c:out value="${matchClass}"/>">
                                    <div class="day-description col-md-4 col-xs-4 text-right"> ${hoursOfDay.description}</div>
                                    <div class="col-md-8 col-xs-8">
                                        <c:choose>
                                            <c:when test="${empty hoursOfDay.startTime}">
                                                <c:out value="Closed"/>
                                            </c:when>
                                            <c:otherwise>
                                                <c:out value="${hoursOfDay.startTime} - ${hoursOfDay.endTime}"/>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                        <a href="Javascript:;" class="view-all-times center">View All Times <span class="caret"></span></a>
                        <p>All Australian based call centre hours are ${openingHoursTimeZone}</p>
                    </div>
                </div>
                <div class="row">
                    <a href="tel:${fn:replace(callCentreNumber, ' ', '')}" class="btn btn-primary btn-lg call-details-button">
                        <span class="call-details-button-label"><span class="icon icon-phone"></span> Call </span>
                        ${callCentreNumber}
                    </a>
                </div>

                <div class="row">
                    <a href="Javascript:;" class="request-call-back center">Request a Call Back <span class="caret"></span></a>
                </div>
            </div>

            <div class="col-sm-8 main request-call-panel hidden" data-padding-pos="all" data-hover-bg="" data-delay="0">
                <div class="row">
                    <%--<div class="col-sm-12">--%>
                        <%--<h4>Let one of our experts call you!</h4>--%>
                    <%--</div>--%>
                    <div id="health-callback-form-mobile" class="col-sm-12"><%-- populated dynamically --%></div>
                </div>
                <div class="row">
                    <div class="col-sm-6">
                        <a href="javascript:;" class="switch call-type">Choose another time for a call?</a>
                    </div>
                    <div class="col-sm-5">
                        <c:set var="analyticsAttr"><field_v1:analytics_attr analVal="Call Request" quoteChar="\"" /></c:set>
                        <button id="callBackNow" class="btn btn-secondary btn-lg btn-block" ${analyticsAttr}><span>Call me now</span></button><small>within 30 mins, during call centre opening hours</small>
                    </div>
                </div>
                <div class="row hidden">
                    <div class="col-sm-6 hidden-xs">
                        <a href="javascript:;" class="switch call-type">Cancel, I prefer a call right now</a>
                    </div>
                    <div class="col-sm-5">
                        <c:set var="analyticsAttr"><field_v1:analytics_attr analVal="Call Request" quoteChar="\"" /></c:set>
                        <button id="callBackLater" class="btn btn-secondary btn-lg btn-block" ${analyticsAttr}>Call me later...</button>
                    </div>
                    <div class="col-sm-12 outline">
                        <form_v4:row label=" ">
                            <field_v2:array_radio xpath="${xpath}/day" required="true" className="callbackDay"
                                                  items="Today=,Tomorrow=,NextDay=,LastDay="
                                                  title="" wrapCopyInSpan="true" />
                        </form_v4:row>
                        <form_v4:row label="Pick a time for " id="pickATimeLabel">
                            <field_v2:array_select xpath="${xpath}/time" required="true" className="callbackTime"
                                                   items="="
                                                   title="" />
                        </form_v4:row>
                    </div>
                    <div class="col-sm-6 visible-xs">
                        <a href="javascript:;" class="switch call-type">Cancel</a>
                    </div>
                </div>
            </div>
            <div class="col-sm-8 confirmation-content-panel hidden visible-xs">
            </div>

            <%-- >= Tablet (sm) modal Layout --%>
            <div class="col-sm-12 hidden-xs">
                <h3 class="hidden-xs">Talk to our experts</h3>
                <div class="quote-ref hidden-xs">Quote Ref: <c:out value="${data['current/transactionId']}"/></div>
                <h3 class="quote-ref-xs text-center visible-xs">Quote Ref: <c:out value="${data['current/transactionId']}"/></h3>
            </div>
            <div class="col-sm-8 main hidden-xs" data-padding-pos="all" data-hover-bg="" data-delay="0">
                <div class="row">
                    <div class="col-sm-12">
                        <h4>Let one of our experts call you!</h4>
                    </div>
                    <div id="health-callback-form-normal" class="col-sm-12"><%-- populated dynamically --%></div>
                </div>
                <div class="row">
                    <div class="col-sm-6">
                        <a href="javascript:;" class="switch call-type">Choose another time for a call?</a>
                    </div>
                    <div class="col-sm-5">
                        <c:set var="analyticsAttr"><field_v1:analytics_attr analVal="Call Request" quoteChar="\"" /></c:set>
                        <button id="callBackNow" class="btn btn-secondary btn-lg btn-block" ${analyticsAttr}><span>Call me now</span></button><small>within 30 mins, during call centre opening hours</small>
                    </div>
                </div>
                <div class="row hidden">
                    <div class="col-sm-6 hidden-xs">
                        <a href="javascript:;" class="switch call-type">Cancel, I prefer a call right now</a>
                    </div>
                    <div class="col-sm-5">
                        <c:set var="analyticsAttr"><field_v1:analytics_attr analVal="Call Request" quoteChar="\"" /></c:set>
                        <button id="callBackLater" class="btn btn-secondary btn-lg btn-block" ${analyticsAttr}>Call me later...</button>
                    </div>
                    <div class="col-sm-12 outline">
                        <form_v4:row label=" ">
                            <field_v2:array_radio xpath="${xpath}/day" required="true" className="callbackDay"
                                                  items="Today=,Tomorrow=,NextDay=,LastDay="
                                                  title="" wrapCopyInSpan="true" />
                        </form_v4:row>
                        <form_v4:row label="Pick a time for " id="pickATimeLabel">
                            <field_v2:array_select xpath="${xpath}/time" required="true" className="callbackTime"
                                                   items="="
                                                   title="" />
                        </form_v4:row>
                    </div>
                    <div class="col-sm-6 visible-xs">
                        <a href="javascript:;" class="switch call-type">Cancel</a>
                    </div>
                </div>
            </div>
            <div class="col-sm-8 confirmation-content-panel hidden hidden-xs">
            </div>
            <div class="call-details col-sm-4 text-center hidden-xs" data-padding-pos="all" >
                <div class="row">
                    <div class="col-sm-12">
                        <h4>Call us on </h4>
                        <h1>
                            <a href="tel:${callCentreNumber}" class="callCentreNumber">${callCentreNumber}</a>
                            <a href="tel:${callCentreAppNumber}" class="callCentreAppNumber">${callCentreAppNumber}</a>
                        </h1>
                    </div>
                </div>
                <div class="row">
                    <div class="col-sm-12">
                        <c:if test="${not empty todayOpeningHours}">
                            <div class="today-hours-callback-modal">Today, ${todays_day}: ${todayOpeningHours} </div>
                        </c:if>
                        <div class="all-times-callback-modal hidden">
                            <c:forEach var="hoursOfDay"
                                       items="${openingHoursService.getAllOpeningHoursForDisplay(pageContext.getRequest(),false)}">

                                <c:set var="matchClass" value="" />
                                <c:if test="${hoursOfDay.description eq todays_day}">
                                    <c:set var="matchClass" value="currentCCDay" />
                                </c:if>
                                <div class="row day_row <c:out value="${matchClass}"/>">
                                    <div class="day-description col-md-4 col-xs-4 text-right"> ${hoursOfDay.description}</div>
                                    <div class="col-md-8 col-xs-8">
                                        <c:choose>
                                            <c:when test="${empty hoursOfDay.startTime}">
                                                <c:out value="Closed"/>
                                            </c:when>
                                            <c:otherwise>
                                                <c:out value="${hoursOfDay.startTime} - ${hoursOfDay.endTime}"/>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                        <a href="Javascript:;" class="view-all-times center">View All Times <span class="caret"></span></a>
                        <br>
                        <p>All Australian based call centre hours are ${openingHoursTimeZone}</p>
                    </div>
                </div>
            </div>
        </div>
    </div>
</core_v1:js_template>

<core_v1:js_template id="thankyou-template">
    <div class="row">
        <div class="col-sm-12 center">
            <h4 class="text-center">Thanks {{= obj.name }}</h4>
            <p class="text-center">One of our experts will call you on the number <span class="text-center">{{= obj.contact_number }}</span></p>

        </div>
        <div class="col-sm-12 callDate text-center">
            <h2>{{= obj.selectedDate }},
                <span class="text-center">{{= obj.selectedTime }}</span>
            </h2>
            <div class="quote-ref">Quote Ref: <c:out value="${data['current/transactionId']}"/></div>
        </div>
    </div>
</core_v1:js_template>

<core_v1:js_template id="error-template">
    <div class="row">
        <div class="col-sm-12 error">
            <h2 class="text-center">Unfortunately we are unable to process your request at the moment - Please call us on 1800 777 712</h2>
        </div>
    </div>
</core_v1:js_template>

<core_v1:js_template id="callback-popup">
    <c:set var="hoursArray" value="${fn:split(todayOpeningHours, '-')}" />
    <c:set var="analyticsAttr"><field_v1:analytics_attr analVal="Call Request - Pop-Up" quoteChar="\"" /></c:set>
    <div id="health-callback-popup">
        <div class="row">
            <div class="col-sm-6">
                <h3>Need Assistance?</h3>
            </div>
            <div class="col-sm-6">
                <h3 class="request-callback"><a href="javascript:;" data-toggle="dialog"
                                                data-content="#view_all_hours_cb"
                                                data-dialog-hash-id="view_all_hours_cb"
                                                data-title="Request a Call" data-cache="true"
                    ${analyticsAttr}><i class="icon-callback" ${analyticsAttr}></i> Request a Call</a></h3>
            </div>
            <div class="col-sm-8">
                <p>Or call us before ${hoursArray[1]} AEST today (${todays_day}) to speak to one of our experts.</p>
            </div>
            <div class="col-sm-12">
                <h1>
                    <span class="callCentreNumber">${callCentreNumber}</span><span class="callCentreAppNumber" style="display:none">${callCentreAppNumber}</span>
                </h1>
            </div>
            <div class="col-sm-12">
                <a href="javascript:;" class="close-popup">continue online, close this</a>
            </div>
        </div>
    </div>
</core_v1:js_template>

<core_v1:js_template id="tmpl-health-callback-form">
    <form id="health-callback-form">
        <c:set var="fieldXpath" value="${xpath}/name" />
        <form_v4:row label="Your name" fieldXpath="${fieldXpath}" className="clear required_input">
            <field_v3:person_name xpath="${fieldXpath}" title="name" required="true" />
        </form_v4:row>

        <field_v4:contact_number mobileXpath="${xpath}/mobile" otherXpath="${xpath}/otherNumber" className="callback-contact-number" />
    </form>
</core_v1:js_template>