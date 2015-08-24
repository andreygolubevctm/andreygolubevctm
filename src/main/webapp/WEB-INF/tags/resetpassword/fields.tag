<%@ tag description="Reset Password Fields" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<div id="reset-password-container">
    <form_new:fieldset legend="Reset Your Password">
        <form_new:row label="Password">
            <field_new:input xpath="reset/password" required="true" type="password" additionalAttributes=" data-rule-minlength='6' data-msg-minlength='Please enter a password that is at least 6 characters long' " />
        </form_new:row>

        <form_new:row label="Confirm Password">
            <field_new:input xpath="reset/confirm" type="password" required="true" additionalAttributes=" data-rule-equalTo='#reset_password' data-msg-equalTo='The text you entered for the confirmation password did not match your password, please try again' " />
        </form_new:row>

        <form_new:row label="">
            <a href="javascript:;" id="reset-password" class="btn btn-secondary">Reset Password</a>
        </form_new:row>
    </form_new:fieldset>
</div>

<go:validate selector="reset_password" rule="validatePasswordLength" parm="true" message="" />