<%@ tag description="Login Form" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<c:set var="xpath" value="login" />

<h3>Please log in to view your insurance quotes</h3>

<c:if test="${not empty param.email}">
    <c:set var="email"><c:out value="${param.email}" escapeXml="true" /></c:set>
    <go:setData dataVar="data" xpath="${xpath}/email" value="${email}" />
</c:if>

<form_new:row label="Your email address" className="clear email-row">
    <field_new:email xpath="${xpath}/email" title="your email address" required="true" size="40"/>
</form_new:row>
<form_new:row label="Your password" className="clear">
    <field:password xpath="${xpath}/password" title="your password" required="true"/>
</form_new:row>

<form_new:row className="clear" hideHelpIconCol="true">
    <div class="col-xs-12 col-md-6 loginButtonContainer">
        <a class="btn btn-block btn-login btn-block nav-next-btn show-loading journeyNavButton" data-slide-control="quotes" href="javascript:;">Login<span class="icon icon-arrow-right"></span></a>
    </div>
    <div class="col-xs-12 col-md-6">
        <a href="javascript:void(0);" class="forgot-password">forgot password?</a>
    </div>
</form_new:row>

<core:js_template id="forgot-password-template">
    <form action="#" id="forgot-password-form">
        <form_new:fieldset legend="Please enter your email address to reset your password">
            <form_new:row label="Your email address">
                <field_new:email xpath="${xpath}/forgotten/email" title="your email address" required="true" size="40" />
            </form_new:row>
        </form_new:fieldset>
    </form>
</core:js_template>

<core:js_template id="reset-password-success-template">
    <p>Your password reset email has been sent to <strong>{{= data.email }}</strong></p>
    <p>To reset your password click the link provided in that email and follow the process provided on our secure website.</p>
    <p>Once your password has been reset, follow the process to return to the "Retrieve Your Insurance Quotes" page and log in using your new password, to gain access to your previous quotes.</p>
</core:js_template>

<core:js_template id="reset-password-failure-template">
    <p>Unfortunately we were unable to send you a reset email.</p>
    {{ if(typeof message !== "undefined") { }}
        <p>{{= message }}.</p>
    {{ } }}
    <p>Click the button below to return to the "reset your password" page and try again.</p>
</core:js_template>