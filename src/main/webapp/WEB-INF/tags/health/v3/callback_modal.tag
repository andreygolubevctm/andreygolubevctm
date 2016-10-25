<%@ tag description="Call back form"%>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<jsp:useBean id="openingHoursService" class="com.ctm.web.core.openinghours.services.OpeningHoursService" scope="page" />
<c:set var="todayOpeningHours" scope="request" value="${openingHoursService.getOpeningHoursForDisplay(pageContext.getRequest(),'today')}" />
<c:set var="callCentreNumber" scope="request"><content:get key="callCentreNumber"/></c:set>
<c:set var="callCentreAppNumber" scope="request"><content:get key="callCentreAppNumber"/></c:set>
<c:set var="xpath" value="${pageSettings.getVerticalCode()}/callback" />

<%-- HTML --%>
<core_v1:js_template id="view_all_hours">
<div id="health-callback">
	<div class="row">
		<div class="col-sm-12">
			<h3>Talk to our experts</h3>
			<div class="quote-ref hidden-xs">Quote Ref: <c:out value="${data['current/transactionId']}"/></div>
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
					    <form_v3:row label="Your mobile number <a class='switch' href='#'>other number?</a>" fieldXpath="${fieldXPath}" className="clear" hideHelpIconCol="true">
					        <field_v1:flexi_contact_number xpath="${fieldXPath}"
					                                    maxLength="20"
					                                    required="true"
					                                    className="contactField sessioncamexclude"
					                                    labelName="mobile number"
					                                    phoneType="Mobile"
					                                    requireOnePlusNumber="true"/>
					    </form_v3:row>

					    <c:set var="fieldXPath" value="${xpath}/otherNumber" />
					    <form_v3:row label="Your other number <a class='switch' href='#'>mobile number?</a>" fieldXpath="${fieldXPath}" className="clear hidden" hideHelpIconCol="true">
					        <field_v1:flexi_contact_number xpath="${fieldXPath}"
					                                    maxLength="20"
					                                    required="true"
					                                    className="contactField sessioncamexclude"
					                                    labelName="other number"
					                                    phoneType="LandLine"
					                                    requireOnePlusNumber="true"/>
					    </form_v3:row>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-6">
					<a href="#" class="switch call-type">Choose another time for a call?</a>
				</div>
				<div class="col-sm-5">
				    <button id="callBackNow" class="btn btn-secondary btn-lg btn-block">Call me now</button><small>within 30 mins</small>
			    </div>
			</div>
			<div class="row hidden">
				<div class="col-sm-6">
					<a href="#" class="switch call-type">Cancel, I prefer a call right now?</a>
				</div>
				<div class="col-sm-5">
				    <button id="callBackLater" class="btn btn-secondary btn-lg btn-block">Call me later...</button>
			    </div>
				<div class="col-sm-12">
					<div class="outline">
					<form_v3:row label=" " hideHelpIconCol="true">
						<field_v2:array_radio xpath="${xpath}/day" required="true" className="callbackDay"
							items="Today=Today,Tomorrow=Tomorrow,NextDay=NextDay,LastDay=LastDay"
							title="" wrapCopyInSpan="true" />
					</form_v3:row>
					<form_v3:row label="Pick a time for call" hideHelpIconCol="true">
						<field_v2:array_select xpath="${xpath}/time" required="true" className="callbackTime"
							items="="
							title="" />
					</form_v3:row>
					</div>
			    </div>
			</div>
			<div class="row">
			    <div class="alert alert-success text-center hidden">Thanks <span class="thanks-name"></span>
					<p>One of our experts will call you on your number <span class="thanks-contact-number"></span></p>
				</div>
			    <div class="alert alert-danger text-center hidden" data-message="There has been an error saving your request.<br>Please try again later or call us on ${callCentreNumber}"></div>
				</form>
			</div>
		</div>
		<div class="call-details col-sm-4 text-center" data-padding-pos="all" >
			<div class="row">
				<div class="col-sm-12">
					<h4>Call us on </h4>
					<h1>
						<span class="callCentreNumber">${callCentreNumber}</span><span class="callCentreAppNumber" style="display:none">${callCentreAppNumber}</span>
					</h1>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-12">
				<c:if test="${not empty todayOpeningHours}">
					<div class="today-hours">Today: ${todayOpeningHours} </div>
				</c:if>

					<div class="center"><a href="#" class="view-all-times">view all times</a></div>
					<div class="all-times hidden">
					<c:forEach var="hoursOfDay"
						items="${openingHoursService.getAllOpeningHoursForDisplay(pageContext.getRequest(),false)}">

						<div class="row day_row">
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
				</div>
			</div>
		</div>
	</div>
</div>
</core_v1:js_template>


<core_v1:js_template id="callback-popup">
<div id="health-callback-popup">
	<div class="row">
		<div class="col-sm-6">
			<h3>Need Assistance?</h3>
		</div>
		<div class="col-sm-6">
			<h3 class="request-callback"><a href="javascript:;" data-toggle="dialog"
			data-content="#view_all_hours"
			data-dialog-hash-id="view_all_hours"
			data-title="Request a Call" data-cache="true"><i class="icon-callback"></i> Request a Call</a></h3>
		</div>
		<div class="col-sm-8">
			<p>Or call us ${todayOpeningHours} AEST today to speak to one of our experts.</p>
		</div>
		<div class="col-sm-12">
			<h1>
				<span class="callCentreNumber">${callCentreNumber}</span><span class="callCentreAppNumber" style="display:none">${callCentreAppNumber}</span>
			</h1>
		</div>
		<div class="col-sm-12">
			<a href=";:" class="close-popup">continue online, close this</a>
		</div>
	</div>
</div>
</core_v1:js_template>
