<%@ tag description="Call back form"%>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<jsp:useBean id="openingHoursService" class="com.ctm.web.core.openinghours.services.OpeningHoursService" scope="page" />
<c:set var="todayOpeningHours" scope="request" value="${openingHoursService.getOpeningHoursForDisplay(pageContext.getRequest(),'today')}" />
<c:set var="callCentreNumber" scope="request"><content:get key="callCentreNumber"/></c:set>
<c:set var="callCentreAppNumber" scope="request"><content:get key="callCentreAppNumber"/></c:set>
<c:set var="xpath" value="${pageSettings.getVerticalCode()}/callback" />

<jsp:useBean id="now" class="java.util.Date" />
<fmt:formatDate var="todays_day" pattern="EEEE" value="${now}" />

<%-- HTML --%>
<core_v1:js_template id="view_all_hours_cb">
<div id="health-callback" callbackModal="true">
	<div class="row">
		<div class="col-sm-12">
			<h3 class="hidden-xs">Talk to our experts</h3>
			<div class="quote-ref hidden-xs">Quote Ref: <c:out value="${data['current/transactionId']}"/></div>
			<h3 class="quote-ref-xs text-center visible-xs">Quote Ref: <c:out value="${data['current/transactionId']}"/></h3>
		</div>
		<div class="col-sm-8 main" data-padding-pos="all" data-hover-bg="" data-delay="0">
			<div class="row">
				<div class="col-sm-12">
					<h4>Let one of our experts call you!</h4>
				</div>
				<div class="col-sm-12">
					<form id="health-callback-form">
						<c:set var="fieldXpath" value="${xpath}/name" />
			            <form_v3:row label="Your name" fieldXpath="${fieldXpath}" className="clear required_input">
			                <field_v3:person_name xpath="${fieldXpath}" title="name" required="true" />
			            </form_v3:row>

						 <c:set var="fieldXPath" value="${xpath}/mobile" />
					    <form_v3:row label="Your mobile number <a class='switch' href='javascript:;'>other number?</a>" fieldXpath="${fieldXPath}" className="clear cbContactNumber" hideHelpIconCol="true">
					        <field_v1:flexi_contact_number xpath="${fieldXPath}"
					                                    maxLength="20"
					                                    required="true"
					                                    className="contactField sessioncamexclude"
					                                    labelName="mobile number"
					                                    phoneType="Mobile"
					                                    requireOnePlusNumber="true"/>
					    </form_v3:row>

					    <c:set var="fieldXPath" value="${xpath}/otherNumber" />
					    <form_v3:row label="Your other number <a class='switch' href='javascript:;'>mobile number?</a>" fieldXpath="${fieldXPath}" className="clear hidden cbContactNumber" hideHelpIconCol="true">
					        <field_v1:flexi_contact_number xpath="${fieldXPath}"
					                                    maxLength="20"
					                                    required="true"
					                                    className="contactField sessioncamexclude"
					                                    labelName="other number"
					                                    phoneType="LandLine"
					                                    requireOnePlusNumber="true"/>
					    </form_v3:row>
					</form>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-6">
					<a href="javascript:;" class="switch call-type">Choose another time for a call?</a>
				</div>
				<div class="col-sm-5">
					<c:set var="analyticsAttr"><field_v1:analytics_attr analVal="Call Request" quoteChar="\"" /></c:set>
				    <button id="callBackNow" class="btn btn-secondary btn-lg btn-block" ${analyticsAttr}>Call me now</button><small>within 30 mins</small>
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
					<form_v3:row label=" " hideHelpIconCol="true">
						<field_v2:array_radio xpath="${xpath}/day" required="true" className="callbackDay"
							items="Today=,Tomorrow=,NextDay=,LastDay="
							title="" wrapCopyInSpan="true" />
					</form_v3:row>
					<form_v3:row label="Pick a time for " hideHelpIconCol="true" id="pickATimeLabel">
						<field_v2:array_select xpath="${xpath}/time" required="true" className="callbackTime"
							items="="
							title="" />
					</form_v3:row>
			    </div>
				<div class="col-sm-6 visible-xs">
					<a href="javascript:;" class="switch call-type">Cancel</a>
				</div>
			</div>
		</div>
		<div class="col-sm-8 confirmation-content-panel hidden">
		</div>
		<div class="call-details col-sm-4 text-center" data-padding-pos="all" >
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
					<a href="Javascript:;" class="view-all-times center">View All Times <span class='caret'></span></a>
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
