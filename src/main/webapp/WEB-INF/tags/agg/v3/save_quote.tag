<%@ tag description="save quotes pop up"%>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- VARIABLES --%>
<c:if test="${not empty authenticatedData.userData && not empty authenticatedData.userData.emailAddress}">
	<c:set var="savedEmail" value="${authenticatedData.userData.emailAddress}" />
</c:if>

<c:set var="isOperator">
	<c:choose>
		<c:when test="${not empty authenticatedData.login.user.uid}">true</c:when>
		<c:otherwise>false</c:otherwise>
	</c:choose>
</c:set>

<c:set var="emailPlaceHolder">
	<content:get key="emailPlaceHolder"/>
</c:set>

<c:set var="labelClasses" value="col-sm-4" />
<c:set var="contentClasses" value="col-sm-8" />

<c:set var="copyStart" value=""/>
<c:set var="copyReturn" value=""/>
<c:set var="copyNew" value=""/>
<c:set var="copySaved" value=""/>
<c:set var="copySubscribe" value=""/>
<c:set var="copyPwdHeading" value=""/>
<c:set var="copyBtnSignup" value=""/>
<c:set var="copyBtnSave" value=""/>
<c:set var="copySavedNote" value=""/>
<c:set var="copyPwdResete" value=""/>
<c:set var="formContent" value='${contentService.getContentWithSupplementary(pageContext.getRequest(), "saveQuoteCopy")}' />
<c:forEach items="${formContent.getSupplementary()}" var="item" >
	<c:choose>
		<c:when test="${item.getSupplementaryKey() eq 'copy-start'}">
			<c:set var="copyStart" value="${item.getSupplementaryValue()}" />
		</c:when>
		<c:when test="${item.getSupplementaryKey() eq 'copy-return'}">
			<c:set var="copyReturn" value="${item.getSupplementaryValue()}" />
		</c:when>
		<c:when test="${item.getSupplementaryKey() eq 'copy-new'}">
			<c:set var="copyNew" value="${item.getSupplementaryValue()}" />
		</c:when>
		<c:when test="${item.getSupplementaryKey() eq 'copy-saved'}">
			<c:set var="copySaved" value="${item.getSupplementaryValue()}" />
		</c:when>
		<c:when test="${item.getSupplementaryKey() eq 'copy-subscribe'}">
			<c:set var="copySubscribe" value="${item.getSupplementaryValue()}" />
		</c:when>
		<c:when test="${item.getSupplementaryKey() eq 'copy-pwd-heading'}">
			<c:set var="copyPwdHeading" value="${item.getSupplementaryValue()}" />
		</c:when>
		<c:when test="${item.getSupplementaryKey() eq 'btn-label-signup'}">
			<c:set var="copyBtnSignup" value="${item.getSupplementaryValue()}" />
		</c:when>
		<c:when test="${item.getSupplementaryKey() eq 'btn-label-save'}">
			<c:set var="copyBtnSave" value="${item.getSupplementaryValue()}" />
		</c:when>
		<c:when test="${item.getSupplementaryKey() eq 'copy-saved-note'}">
			<c:set var="copySavedNote" value="${item.getSupplementaryValue()}" />
		</c:when>
		<c:when test="${item.getSupplementaryKey() eq 'copy-pwd-reset'}">
			<c:set var="copyPwdReset" value="${item.getSupplementaryValue()}" />
		</c:when>
		<c:otherwise><%-- ignore --%></c:otherwise>
	</c:choose>
</c:forEach>

<%-- SAVE QUOTE FORM --%>
<script type="text/html" id="save-quote-component-template">
	<form id="save-quote-component" class="form-horizontal hidden start">

		<div class="scrollable">

			<%-- HEADINGS --%>
			<div class="saveQuoteHeadings col-xs-12">
				<h4 class="start"><c:out value="${copyStart}" escapeXml="false" /></h4>
				<h4 class="return"><c:out value="${copyReturn}" escapeXml="false" /></h4>
				<h4 class="new"><c:out value="${copyNew}" escapeXml="false" /></h4>
				<h4 class="saved"><c:out value="${copySaved}" escapeXml="false" /></h4>
			</div>

			<%-- LEFT COLUMN --%>
			<div class="col-xs-12 col-sm-8">

				<div class="saveQuoteFields">

					<%-- EMAIL --%>
					<div class="form-group row">
						<c:set var="fieldXpath" value="save/email" />
						<div class="${labelClasses}">
							<span>Email Address</span>
						</div>
						<div class="row-content ${contentClasses}">
							<field_v2:email xpath="${fieldXpath}" required="true" placeHolder="${emailPlaceHolder}" />
						</div>
					</div>

					<%-- PASSWORDS --%>
					<div class="saveQuotePasswords">
						<h5><c:out value="${copyPwdHeading}" escapeXml="false" /></h5>
						<p>Create a new password...</p>
						<div class="form-group row">
							<c:set var="fieldXpath" value="save/password" />
							<div class="${labelClasses}">
								<span>New Password</span>
								<span class="hidden-lg hidden-md hidden-sm"> - </span>
								<span class="sub">at least 6 characters</span>
							</div>
							<div class="row-content ${contentClasses}">
								<field_v1:password xpath="${fieldXpath}" required="false" title="your password" placeHolder="" minLength="${6}" className="sessioncamexclude" />
							</div>
						</div>

						<div class="form-group row">
							<c:set var="fieldXpath" value="save/confirm" />
							<div class="${labelClasses}">
								<span>Confirm Password</span>
								<span class="hidden-lg hidden-md hidden-sm"> - </span>
								<span class="sub">same as the new password</span>
							</div>
							<div class="row-content ${contentClasses}">
								<field_v1:password xpath="${fieldXpath}" required="false" title="your password for confirmation" placeHolder="" className="sessioncamexclude" minLength="${0}" additionalAttributes=" data-rule-equalTo='#save_password' data-msg-equalTo='Password and confirmation password must match' "/>
							</div>
						</div>

					</div>

					<%-- SUBMIT BTN --%>
					<div class="form-group row">
						<div class="hidden-xs ${labelClasses}"><!-- empty --></div>
						<div class="${contentClasses}">
							<a href="javascript:;" class="btn save btn-save-quote-trigger inverted disabled"><c:out value="${copyBtnSave}" escapeXml="false" /></a>
							<a href="javascript:;" class="btn signup btn-save-quote-trigger inverted disabled"><c:out value="${copyBtnSignup}" escapeXml="false" /></a>
						</div>
					</div>

				</div>

				<%-- SAVE QUOTE SUCCESS --%>
				<div class="saveQuoteSuccess">
					<h5><a href="javascript:;" class="btn-retrieve">Retrieve Quote(s)</a></h5>
					<p><c:out value="${copySavedNote}" escapeXml="false" /></p>
					<p><c:out value="${copyPwdReset}" escapeXml="false" /></p>
				</div>
			</div>

			<%-- SEPERATOR COLUMN --%>
			<div class="hidden-xs col-sm-1"><!-- empty --></div>

			<%-- RIGHT COLUMN --%>
			<div class="col-xs-12 col-sm-3">
				<div class="pic-box hidden-xs">
					<span class="icon-save-quote">
						<span class="path1"></span><span class="path2"></span><span class="path3"></span><span class="path4"></span>
					</span>
				</div>
				<%-- MARKETING CHECKBOX --%>
				<div class="form-group row optin-box">
					<field_v2:checkbox
							xpath="save/marketing"
							value="Y"
							required="false"
							label="true"
							className="checkbox-custom"
							title="${copySubscribe}" />
				</div>
			</div>

		</div>

	</form>
</script>