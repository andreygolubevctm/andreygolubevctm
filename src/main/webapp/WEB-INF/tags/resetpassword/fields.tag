<%@ tag description="Reset Password Fields" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<div id="reset-password-container">
    <form_new:fieldset legend="Reset Your Password">
        <form_new:row label="Password">
            <field_new:input xpath="reset/password" required="true" type="password" />
        </form_new:row>

        <form_new:row label="Confirm Password">
            <field_new:input xpath="reset/confirm" type="password" required="true" />
        </form_new:row>

        <form_new:row label="">
            <a href="javascript:;" id="reset-password" class="btn btn-secondary">Reset Password</a>
        </form_new:row>
    </form_new:fieldset>
</div>

<go:validate selector="reset_confirm" rule="validateMatchingPassword" parm="true" message="The text you entered for the confirmation password did not match your password, please try again" />
<go:validate selector="reset_password" rule="validatePasswordLength" parm="true" message="Please enter a password that is at least 6 characters long" />