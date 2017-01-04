<%@ tag description="Simples template" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<form id="redemptionForm" class="form-horizontal">
    <fieldset class="qe-window fieldset">
        <div class="row">
            <c:choose>
                <c:when test="${callCentre}">
                    <div class="col-sm-12">
                        <br>
                        {{ if(data.modalAction === "edit") { }}
                        <h1>Edit Record</h1>
                        <input type="hidden" name="providerId" value="{{= data.providerId }}">
                        <input type="hidden" name="sequenceNo" value="{{= data.sequenceNo }}">
                        <input type="hidden" name="status" value="{{= data.status }}">
                        {{ } else { }}
                        <h1>New Record</h1>
                        {{ } }}
                    </div>
                </c:when>
                <c:otherwise>
                    <%--TODO: get content from BE --%>
                    <h2>Claim your simples reward</h2>
                    <p>Congratulations, you will soon be the owner of our very own Meerkat toy. Please complete the following details to claim.</p>
                </c:otherwise>
            </c:choose>
        </div>
        <div class="row">
            <div class="col-sm-12">
                <ul class="error-list"></ul>
            </div>
        </div>
        <div class="form-group row fieldrow clear required_input">
            <label for="redemption_gift" class="col-sm-4 col-xs-10 control-label">Please select your reward</label>
            <div class="col-sm-6 col-xs-12 row-content">
                <div class="btn-tile btn-group btn-group-justified" data-toggle="radio">
                    <%--{{ for(var i in providers) { }}--%>
                    <label class="btn btn-form-inverse" data-analytics="redemption_gift">
                        <input type="radio" name="redemption_gift" id="redemption_gift_sergei" value="sergei" data-msg-required="Please choose the reward you'd like to redeem" required="required" />
                        <span>Sergei</span>
                    </label>
                    <label class="btn btn-form-inverse" data-analytics="redemption_gift">
                        <input type="radio" name="redemption_gift" id="redemption_gift_aleksandr" value="aleksandr" data-msg-required="Please choose the reward you'd like to redeem" required="required" />
                        <span>Aleksandr</span>
                    </label>
                    <%--{{ } }}--%>
                </div>
            </div>
        </div>

        <div class="form-group row fieldrow clear required_input">
            <label for="redemption_firstname" class="col-sm-4 col-xs-10 control-label">First name</label>
            <div class="col-sm-6 col-xs-12 row-content">
                <input type="text" name="redemption_firstname" id="redemption_firstname" class="form-control" data-rule-personname="true" required="required" data-msg-required="Please enter First Name" />
            </div>
        </div>

        <div class="form-group row fieldrow clear required_input">
            <label for="redemption_lastname" class="col-sm-4 col-xs-10 control-label">Last name</label>
            <div class="col-sm-6 col-xs-12 row-content">
                <input type="text" name="redemption_lastname" id="redemption_lastname" class="form-control" data-rule-personname="true" required="required" data-msg-required="Please enter Last Name" />
            </div>
        </div>

        <div class="form-group row fieldrow clear">
            <label for="redemption_businessname" class="col-sm-4 col-xs-10 control-label">Business name</label>
            <div class="col-sm-6 col-xs-12 row-content">
                <input type="text" name="redemption_businessname" id="redemption_businessname" class="form-control" />
            </div>
        </div>

        <group_v2:elastic_address
                xpath="redemption/address"
                type="P"
                suburbNameAdditionalAttributes=" autocomplete='false'"
                suburbAdditionalAttributes=" autocomplete='false'"
                postCodeNameAdditionalAttributes=" autocomplete='false'"
                postCodeAdditionalAttributes=" autocomplete='false'"
                addRequiredAsterisk="true"
        />

        <div class="form-group row fieldrow clear required_input">
            <label for="redemption_phonenumber" class="col-sm-4 col-xs-10 control-label">Phone number</label>
            <div class="col-sm-6 col-xs-12 row-content">
                <input type="text" name="redemption_phonenumber" id="redemption_phonenumber" title="" class="form-control contact_telno phone  placeholder flexiphone" pattern="[0-9]*" placeholder="(0x) xxxx xxxx or 04xx xxx xxx" required="required" data-msg-required="Please enter the phone number" data-rule-validateflexitelno="true" data-msg-validateflexitelno="Please enter the phone number in the format (0x)xxxx xxxx for landline or 04xx xxx xxx for mobile" maxlength="20" />
            </div>
        </div>

        <div class="form-group row fieldrow clear required_input">
            <label for="redemption_email" class="col-sm-4 col-xs-10 control-label">Email address</label>
            <div class="col-sm-6 col-xs-12 row-content">
                <span>
                    <input name="redemption_email" id="redemption_email" class="form-control email" size="50" required="required" type="email" data-msg-required="Please enter your email address" data-loadinganimation="after">
                </span>
            </div>
        </div>

        <div class="form-group row fieldrow clear required_input">
            <label for="redemption_signature" class="col-sm-4 col-xs-10 control-label">Signature on delivery?</label>
            <div class="col-sm-6 col-xs-12 row-content">
                <div class="btn-group btn-group-justified btn-group-wrap" data-toggle="radio">
                    <label class="btn btn-form-inverse">
                        <input type="radio" name="redemption_signature" id="redemption_signature_Y" value="Y" data-msg-required="Please tell us if want signature on delivery" required="required">Yes</label>
                    <label class="btn btn-form-inverse">
                        <input type="radio" name="redemption_signature" id="redemption_signature_N" value="N" data-msg-required="Please tell us if want signature on delivery" required="required">No</label>
                </div>
            </div>
        </div>

        <div class="row text-right">
            <div class="col-sm-10">
                <button type="button" class="crud-save-entry btn btn-secondary">Save</button>
            </div>
        </div>
    </fieldset>
</form>