<%@ tag description="save quotes pop up"%>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%@ attribute name="includeCallMeback"	required="false"	description="display call back after save quote"%>

<jsp:useBean id="openingHoursService" class="com.ctm.web.core.openinghours.services.OpeningHoursService" scope="page" />

<c:if test="${not empty authenticatedData.userData && not empty authenticatedData.userData.emailAddress}">
	<c:set var="savedEmail" value="${authenticatedData.userData.emailAddress}" />
</c:if>

<c:set var="isOperator">
	<c:choose>
		<c:when test="${not empty authenticatedData.login.user.uid}">true</c:when>
		<c:otherwise>false</c:otherwise>
	</c:choose>
</c:set>

<c:if test="${empty includeCallMeback || isOperator}">
	<c:set var="includeCallMeback" value="false" />
</c:if>

<c:set var="emailPlaceHolder">
	<content:get key="emailPlaceHolder"/>
</c:set>



<%-- SAVE QUOTE FORM --%>
<form id="email-quote-component" class="form-horizontal">

	<div class="row scrollable">
		<%-- LEFT COLUMN --%>
		<div class="col-sm-8 ">

			<%-- INSTRUCTIONS TEXT PLACEHOLDER --%>
			<p class="text-tertiary text-bold saveQuoteInstructions"></p>

			<div class="saveQuoteFields">

				<%-- EMAIL --%>
				<div class="form-group row">
					<c:set var="fieldXpath" value="save/email" />
					<field_v2:label value="Email address" xpath="${fieldXpath}" className="col-lg-2 col-md-3 col-sm-4" />
					<div class="row-content col-lg-10 col-md-9 col-sm-8">
						<field_v2:email xpath="${fieldXpath}" required="true" placeHolder="${emailPlaceHolder}" />
						<span class="createLoginInfo small"></span>
					</div>
				</div>

				<%-- PASSWORDS --%>
				<c:if test="${!isOperator}">
					<div class="displayNone saveQuotePasswords">
						<div class="form-group row">
							<c:set var="fieldXpath" value="save/password" />
							<field_v2:label value="Password" xpath="${fieldXpath}" className="col-lg-2 col-md-3 col-sm-4" />
							<div class="row-content col-lg-10 col-md-9 col-sm-8">
								<field_v1:password xpath="${fieldXpath}" required="false" title="your password" placeHolder="" minLength="${6}" className="sessioncamexclude" />
							</div>
						</div>

						<div class="form-group row">
							<c:set var="fieldXpath" value="save/confirm" />
							<field_v2:label value="Confirm password" xpath="${fieldXpath}" className="col-lg-2 col-md-3 col-sm-4" />
							<div class="row-content col-lg-10 col-md-9 col-sm-8">
								<field_v1:password xpath="${fieldXpath}" required="false" title="your password for confirmation" placeHolder="" className="sessioncamexclude" minLength="${0}" additionalAttributes=" data-rule-equalTo='#save_password' data-msg-equalTo='Password and confirmation password must match' "/>
							</div>
						</div>

					</div>
				</c:if>

				<%-- MARKETING CHECKBOX --%>
				<div class="form-group row">
					<div class="col-lg-offset-2 col-md-offset-3 col-sm-offset-4 col-lg-10 col-md-9 col-sm-8">
						<field_v2:checkbox
							xpath="save/marketing"
							value="Y"
							required="false"
							label="true"
							className="checkbox-custom"
							title="Stay up to date with news and offers direct to your inbox" />
					</div>
				</div>

				<%-- SUBMIT BTN --%>
				<div class="form-group row">
					<div class="col-lg-offset-2 col-md-offset-3 col-sm-offset-4 col-lg-3 col-sm-4">
						<a href="javascript:;" class="btn btn-save btn-block disabled btn-save-quote"><c:choose><c:when test="${isOperator}">Save Quote</c:when><c:otherwise>Email Quote</c:otherwise></c:choose></a>
					</div>
				</div>

			</div>

		</div>

		<%-- RIGHT COLUMN --%>
		<c:if test="${not empty callCentreNumber}">
			<div class="col-sm-4 hidden-xs">
				<ui:bubble variant="chatty" className="callCentreNumberSection">
					<p>Please be aware that product availability may change from time to time, so buy today to ensure you lock in your first choice!</p>
					<p><strong>Buy online or call us on <span class="noWrap callCentreNumber">${callCentreNumber}</span></strong></p>
					<c:if test="${not empty openingHoursService.getAllOpeningHoursForDisplay(pageContext.getRequest())}">
						<div class="opening-hours">
							<a href="javascript:;" data-toggle="dialog"
								data-content="#view_all_hours"
								data-dialog-hash-id="view_all_hours"
								data-title="Call Centre Hours" data-cache="true">View our Australian based call centre hours
							</a>
						</div>
					</c:if>
				</ui:bubble>
			</div>
		</c:if>

	</div>

</form>


<%-- SAVE QUOTE SUCCESS --%>
<form id="saveQuoteSuccess" class="displayNone clearfix">
	<div class="col-xs-12 scrollable">
		<h4>Your login details have been saved.</h4>
		<p>In future, you can retrieve your quote by clicking on the link in the email we have just sent you.</p>
		<p>To continue with your quote, <a href="javascript:;" class="btn-cancel saved-continue-link btn-link">click here</a>.</p>
	</div>
</form>

<div class="hidden-xs">
	<%-- CALL BACK FORM --%>
	<c:if test="${includeCallMeback eq true}">

		<agg_v2:call_me_back_form id="callmeback-save-quote-dropdown" displayBubble="true" />

	</c:if>
</div>
