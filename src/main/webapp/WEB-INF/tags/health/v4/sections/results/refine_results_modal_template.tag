<%@ tag description="Results refine for mobile modal"%>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<jsp:useBean id="openingHoursService" class="com.ctm.web.core.openinghours.services.OpeningHoursService" scope="page" />
<c:set var="todayOpeningHours" scope="request" value="${openingHoursService.getOpeningHoursForDisplay(pageContext.getRequest(),'today')}" />
<c:set var="callCentreNumber" scope="request"><content:get key="callCentreNumber"/></c:set>
<c:set var="callCentreAppNumber" scope="request"><content:get key="callCentreAppNumber"/></c:set>

<jsp:useBean id="now" class="java.util.Date" />
<fmt:formatDate var="todays_day" pattern="EEEE" value="${now}" />

<core_v1:js_template id="refine-results-modal-template">
    <div class="refine-results-container">
        <field_v2:checkbox
                xpath="health_refine_results_discount"
                className="refine-results-discount"
                value="Y"
                required="true"
                label="${true}"
                title="Apply all available discounts to show me the lowest possible price"
        />

        <h3>My Insurance Preferences</h3>

        <div class="refine-results-sub-heading">Hospital</div>
        <div class="refine-results-by-container">
            {{ if (isHospitalOn) { }}
                <div class="refine-results-hospital-type">{{= hospitalType }} Cover</div>
                <div class="refine-results-count-text">{{= hospitalCountText }}</div>
            {{ } else { }}
                <div class="refine-results-no-hospital">No Hospital</div>
            {{ } }}
            <a href="javascript:;" class="refine-results-redirect-btn" data-benefit="hospital">{{= hospitalBtnText }}</a>
        </div>

        <div class="refine-results-sub-heading">Extras</div>
        <div class="refine-results-by-container">
            {{ if (isExtrasOn) { }}
                <div class="refine-results-count-text">{{= extrasCountText }}</div>
            {{ } else { }}
                <div class="refine-results-no-extras">No Extras</div>
            {{ } }}
            <a href="javascript:;" class="refine-results-redirect-btn" data-benefit="extras">{{= extrasBtnText }}</a>
        </div>

        <hr />

        <div class="refine-results-call-back">
            <div class="refine-results-call-text">
                Can't seem to find the right product?
                <br>
                Call our experts on
            </div>

            <a href="tel: ${callCentreNumber}" class="refine-results-call-number">
                <span class="icon icon-phone"></span>
                ${callCentreNumber}
            </a>

            <c:if test="${not empty todayOpeningHours}">
                <div class="refine-results-today-hours">Today, ${todays_day}: ${todayOpeningHours} </div>
            </c:if>
            <div class="refine-results-all-times hidden">
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

            <a href="javascript:;" class="refine-results-view-all-times">View All Times <span class='caret'></span></a>
        </div>
    </div>
</core_v1:js_template>