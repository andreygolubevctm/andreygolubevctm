<%@ tag description="save quotes pop up"%>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%@ attribute name="includeCallMeback"	required="false"	description="display call back after save quote"%>

<c:if test="${not empty data.userData && not empty data.userData.emailAddress}">
	<c:set var="savedEmail" value="${data.userData.emailAddress}" />
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
<%-- EMAIL RESULTS FORM --%>
<form id="email-results-component" class="form-horizontal">

	<div class="row scrollable">
		<%-- LEFT COLUMN --%>
		<div class="col-sm-8 ">

			<%-- INSTRUCTIONS TEXT PLACEHOLDER --%>
			<p class="text-tertiary text-bold emailResultsInstructions"></p>

			<div class="emailResultsFields">

				<%-- EMAIL --%>
				<div class="form-group row">
					<c:set var="fieldXpath" value="emailresults/email" />
					<field_new:label value="Email address" xpath="${fieldXpath}" className="col-lg-2 col-md-3 col-sm-4" />
					<div class="row-content col-lg-10 col-md-9 col-sm-8">
						<field_new:email xpath="${fieldXpath}" required="true" placeHolder="Your email address" />
					</div>
				</div>

				<%-- MARKETING CHECKBOX --%>
				<div class="form-group row">
					<div class="col-lg-offset-2 col-md-offset-3 col-sm-offset-4 col-lg-10 col-md-9 col-sm-8">
						<field_new:checkbox
							xpath="emailresults/marketing"
							value="Y"
							required="false"
							label="true"
							className="checkbox-custom"
							title="Stay up to date with news and offers direct to your inbox" />
					</div>
				</div>

				<%-- SUBMIT BTN --%>
				<div class="form-group row">
					<div class="col-lg-offset-2 col-md-offset-3 col-sm-offset-4 col-lg-10 col-md-9 col-sm-8">
						<a href="javascript:;" class="btn btn-cta disabled btn-email-results">Email Results</a>
					</div>
				</div>

			</div>

		</div>

	</div>

</form>


<%-- EMAIL RESULTS SUCCESS --%>
<form id="emailResultsSuccess" class="displayNone clearfix">
	<div class="col-xs-12 scrollable">
		<h4>The top 5 results have been sent...</h4>
		<p>To continue with your quote, <a href="javascript:;" class="btn-cancel saved-continue-link btn-link">click here</a>.</p>
	</div>
</form>