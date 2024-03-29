<%@ tag description="Reset Password Fields" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<div id="reset-password-container">
    <form_v2:fieldset legend="Reset Your Password">
        <form_v2:row label="Password">
            <field_v2:input xpath="reset/password" required="true" type="password" additionalAttributes=" data-rule-minlength='6' data-msg-minlength='Please enter a password that is at least 6 characters long' " />
        </form_v2:row>

        <form_v2:row label="Confirm Password">
            <field_v2:input xpath="reset/confirm" type="password" required="true" additionalAttributes=" data-rule-equalTo='#reset_password' data-msg-equalTo='The text you entered for the confirmation password did not match your password, please try again' " />
        </form_v2:row>

        <form_v2:row label="">
            <a href="javascript:;" id="reset-password" class="btn btn-secondary">Reset Password</a>
        </form_v2:row>
    </form_v2:fieldset>
</div>