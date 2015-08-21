<%@ tag description="Reset Password Slide" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<layout:slide formId="resetPasswordForm">
    <layout:slide_columns>
        <jsp:attribute name="rightColumn">

        </jsp:attribute>
        <jsp:body>
            <layout:slide_center xsWidth="12" mdWidth="10" className="roundedContainer">
                <resetpassword:fields />
            </layout:slide_center>
        </jsp:body>
    </layout:slide_columns>
</layout:slide>

<core:js_template id="reset-success-modal-template">
    <p>Your password was successfully changed!</p>
    <p>Click the button below to return the "Retrieve Your Insurance Quotes" page and login using your new password, to gain access to your previous quotes.</p>
</core:js_template>

<core:js_template id="reset-fail-modal-template">
    <p>Your password was not changed</p>
    <p>{{= obj.message }}</p>
    <p>Please click the button below to return to the "Reset Your Password" page, to request an email with a new reset password link.</p>
</core:js_template>