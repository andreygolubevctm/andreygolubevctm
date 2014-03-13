<%@ tag description="save quotes pop up"%>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>
<jsp:useBean id="data" class="com.disc_au.web.go.Data" scope="session" />

<%@ attribute name="includeCallMeback"	required="false"	description="display call back after save quote"%>

<c:if test="${not empty data.userData && not empty data.userData.emailAddress}">
	<c:set var="savedEmail" value="${data.userData.emailAddress}" />
</c:if>

<c:set var="isOperator">
	<c:choose>
		<c:when test="${not empty data.login.user.uid}">true</c:when>
		<c:otherwise>false</c:otherwise>
	</c:choose>
</c:set>

<c:if test="${empty includeCallMeback || isOperator}">
	<c:set var="includeCallMeback" value="false" />
</c:if>


<%-- SAVE QUOTE FORM --%>
<form id="email-quote-component" class="form-horizontal">

	<div class="row">
		<%-- LEFT COLUMN --%>
		<div class="col-sm-8">

			<%-- INSTRUCTIONS TEXT PLACEHOLDER --%>
			<p class="text-tertiary text-bold saveQuoteInstructions"></p>

			<div class="saveQuoteFields">

				<%-- EMAIL --%>
				<div class="form-group row">
					<c:set var="fieldXpath" value="save/email" />
					<field_new:label value="Email address" xpath="${fieldXpath}" className="col-lg-2 col-md-3 col-sm-4" />
					<div class="row-content col-lg-10 col-md-9 col-sm-8">
						<field_new:email xpath="${fieldXpath}" required="true" placeHolder="Your email address" />
					</div>
				</div>

				<%-- PASSWORDS --%>
				<c:if test="${!isOperator}">
					<div class="displayNone saveQuotePasswords">
						<div class="form-group row">
							<c:set var="fieldXpath" value="save/password" />
							<field_new:label value="Password" xpath="${fieldXpath}" className="col-lg-2 col-md-3 col-sm-4" />
							<div class="row-content col-lg-10 col-md-9 col-sm-8">
								<field:password xpath="${fieldXpath}" required="false" title="your password" placeHolder="set your password" minlength="6" />
							</div>
						</div>

						<div class="form-group row">
							<c:set var="fieldXpath" value="save/confirm" />
							<field_new:label value="Confirm password" xpath="${fieldXpath}" className="col-lg-2 col-md-3 col-sm-4" />
							<div class="row-content col-lg-10 col-md-9 col-sm-8">
								<field:password xpath="${fieldXpath}" required="false" title="your password for confirmation" placeHolder="confirm your password" />
							</div>
						</div>
						
					</div>
				</c:if>

				<%-- MARKETING CHECKBOX --%>
				<div class="form-group row">
					<div class="col-lg-offset-2 col-md-offset-3 col-sm-offset-4 col-lg-10 col-md-9 col-sm-8">
						<field_new:checkbox
							xpath="save/marketing"
							value="Y"
							required="false"
							label="true"
							className="checkbox-custom"
							title="Please keep me informed via email of news and other offers" />
					</div>
				</div>

				<%-- UNLOCK QUOTE --%>
				<c:if test="${isOperator}">
					<div id="operator-save-form">
						<p class="text-tertiary text-bold">Do you want to unlock this quote so the client can access it?</p>

						<div class="form-group row">
							<c:set var="fieldXpath" value="save/unlock" />
							<field_new:label value="Unlock Quote" xpath="${fieldXpath}" className="col-lg-2 col-md-3 col-sm-4" />
							<div class="row-content col-lg-10 col-md-9 col-sm-8">
								<field_new:array_radio items="Y=Yes,N=No" style="group" xpath="${fieldXpath}" title="Do you wish to unlock this quote?" required="true" id="operator-save-unlock" />
							</div>
						</div>

					</div>
				</c:if>

				<%-- SUBMIT BTN --%>
				<div class="form-group row">
					<div class="col-lg-offset-2 col-md-offset-3 col-sm-offset-4 col-lg-10 col-md-9 col-sm-8">
						<a href="javascript:;" class="btn btn-primary disabled btn-save-quote">Email Quote</a>
					</div>
				</div>
				
			</div>

		</div>

		<%-- RIGHT COLUMN --%>
		<div class="col-sm-4 hidden-xs">
			<ui:bubble variant="chatty">
				<p>Please be aware that product availability may change from time to time, so buy today to ensure you lock in your first choice!</p>
				<p><strong>Buy online or call us on 1800 77 77 12</strong></p>
				<p><small>Our Australian based call centre hours are <strong><form:scrape id='135'/></strong></small></p>
			</ui:bubble>
		</div>

	</div>

</form>

<%-- SAVE QUOTE SUCCESS --%>
<form id="saveQuoteSuccess" class="row displayNone">
	<div class="col-xs-12">
		<h5>Your quote has been saved!</h5>
		<p>To retrieve your quote <a href="${data['settings/root-url']}${data.settings.styleCode}/retrieve_quotes.jsp">click here</a>.</p>
	</div>
</form>

<%-- CALL BACK FORM --%>
<c:if test="${includeCallMeback eq true}">

	<agg_new:call_me_back_form id="callmeback-save-quote-dropdown" displayBubble="true" />

</c:if>