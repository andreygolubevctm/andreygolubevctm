<%--
	Retrieve Quotes Page
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- Set authenticatedData to scope of request --%>
<session:new verticalCode="GENERIC" authenticated="${true}"/>

<c:set var="callCentreNumber" scope="request">${(contentService.getContent("callCentreNumber", 1, 4, null, false)).contentValue}</c:set>
<c:set var="openingHoursTimeZone" scope="request">${(contentService.getContent("openingHoursTimeZone", 1, 4, null, false)).contentValue}</c:set>
<c:set var="contentHeaderHtml" scope="request">${(contentService.getContent("callMeNowStandaloneHeader", 1, 4, null, false)).contentValue}</c:set>
<c:set var="xpath" value="callmeback/sa"/>

<c:set var="logger" value="${log:getLogger('jsp.call_me_back')}" />
<layout_v1:journey_engine_page title="Call Me Back" ignorePageHeader="${true}" body_class_name="call-me-back-stand-alone">

    <jsp:attribute name="head">
        <link rel="stylesheet" href="${assetUrl}assets/brand/${pageSettings.getBrandCode()}/css/call_me_back${pageSettings.getSetting('minifiedFileString')}.css?${revision}" media="all">
    </jsp:attribute>

    <jsp:attribute name="head_meta">
    </jsp:attribute>

    <jsp:attribute name="header">
    </jsp:attribute>

    <jsp:attribute name="navbar">
    </jsp:attribute>


    <jsp:attribute name="form_bottom">
    </jsp:attribute>

    <jsp:attribute name="footer">
        <%-- I believe we still will want the footer for the terms links and McCafe protection --%>
        <core_v1:whitelabeled_footer />
    </jsp:attribute>

    <jsp:attribute name="vertical_settings">
        <call_me_back:settings />
    </jsp:attribute>

    <jsp:attribute name="body_end"></jsp:attribute>

    <jsp:attribute name="additional_meerkat_scripts">
        <script src="${assetUrl}assets/js/bundles/call_me_back${pageSettings.getSetting('minifiedFileString')}.js?${revision}"></script>
    </jsp:attribute>

    <jsp:body>
        <div class="cmbSaOpeningHoursTimeZone hidden">${openingHoursTimeZone}</div>

<%-- fetch Header content from DB --%>
${contentHeaderHtml}

        <div class="row">
            <div class="col-sm-12 call-us-today">
                <span class="boldtext">Call today</span> on <a href="tel:${callCentreNumber}" class="callCentreNumber"><c:out value="${callCentreNumber}"/></a>
            </div>
        </div>

        <div class="callmeNowStandaloneContent">

            <div class="call-now-contact-details">
                <form id="standalone-callback-form">
                    <c:set var="fieldXpath" value="${xpath}/name" />
                    <form_v3:row label="Your name" fieldXpath="${fieldXpath}" className="clear required_input">
                        <field_v3:person_name xpath="${fieldXpath}" title="name" required="true" />
                    </form_v3:row>


                    <c:set var="fieldXPath" value="${xpath}/mobile" />
                    <form_v3:row label="Your mobile number" fieldXpath="${fieldXPath}" className="clear cbContactNumber" hideHelpIconCol="true">
                        <field_v1:flexi_contact_number xpath="${fieldXPath}"
                                                       maxLength="20"
                                                       required="true"
                                                       className="contactField sessioncamexclude"
                                                       labelName="mobile number"
                                                       phoneType="Mobile"
                                                       requireOnePlusNumber="true"/>
                    </form_v3:row>

                </form>
            </div>

            <div class="call-later-panel">

                <div class="col-xs-12 time-and-date-form-fields">

                    <div class="schedule-call-group-label">Schedule call</div>

                    <form_v3:row label=" " id="cmb-sa-pickADayLabel" className="col-xs-6">
                        <field_v2:array_select xpath="${xpath}/day" required="true" className="cmb-sa-callbackDayDD col-xs-6"
                                               items="Today=,Tomorrow=,NextDay=,LastDay="
                                               title="" />
                    </form_v3:row>



                    <form_v3:row label=" " id="cmb-sa-pickATimeLabel" className="col-xs-6">
                        <field_v2:array_select xpath="${xpath}/time" required="true" className="callbackTime cmb-sa-callbackTime"
                                               items=""
                                               title="" />
                    </form_v3:row>
                </div>

                <div class="col-xs-12 call-me-later">
                    <div class="col-xs-12">
                        <c:set var="analyticsAttr"><field_v1:analytics_attr analVal="Call Request" quoteChar="\"" /></c:set>
                        <button id="cmb-sa-callBackLater"  class="btn btn-secondary btn-lg btn-block" ${analyticsAttr}>Call me later...</button>
                    </div>
                </div>
                <div class="text-center"><small>within 30 mins, during call centre opening hours</small></div>
            </div>
            <br />
        </div>

        <div class="cmb-sa-thankyou hidden">
            <div class="row">
                <div class="col-xs-12 center">
                    <h4 class="text-center">Thanks <span class="callme-sa-contact-name-thanks"></span></h4>
                    <p class="text-center">One of our experts will call you <br />back on <span class="callme-sa-contact-phone-thanks boldtext"></span></p>

                </div>
                <div class="col-xs-12 callDate text-center">
                    <h4><span class="returnCallDate"></span>,<br />
                        <span class="text-center returnCallTime"></span>
                    </h4>
                </div>
            </div>
        </div>

        <div class="cmb-sa-error hidden">
            <div class="row">
                <div class="col-xs-12 error">
                    <h2 class="text-center">Unfortunately we are unable to process your request at the moment - Please call us on <c:out value="${callCentreNumber}"/></h2>
                </div>
            </div>
        </div>

    </jsp:body>

</layout_v1:journey_engine_page>