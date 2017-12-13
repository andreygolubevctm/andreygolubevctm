<%@ tag description="Redemption template" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
{{ var currentCampaign = data.eligibleCampaigns[0] || {}; }}

<%-- Form Structure - initalise with CRUD.js --%>
<form class="redemptionForm form-horizontal">
    <fieldset class="qe-window fieldset">
        <div class="row">
            <div class="col-sm-12">
                <h1>Claim your Meerkat toy</h1>
                <p class="toy-subtitle">Congratulations, you will soon be the owner of your very own Meerkat toy. Please
                    complete the following details to claim.</p>
            </div>
        </div>

        {{ var orderLine = data.orderForm.orderHeader.orderLine || {}; }}
        <div class="form-group row fieldrow clear required_input rewardType">
            <label for="order_rewardType" class="col-sm-4 col-xs-10 control-label">Please select your reward</label>
            <div class="col-sm-8 col-xs-12 row-content">
                <div class="btn-tile toy-radio-tiles" data-toggle="radio">
                    {{ var rewards = currentCampaign.rewards.filter(function(reward) { }}
                    {{ return reward.active === true; }}
                    {{ }); }}
                    {{ orderLine.rewardType = orderLine.rewardType || {} }}

                    {{ _.each(rewards, function(reward) { }}
                    <label class="btn {{= reward.rewardType}} {{= reward.stockLevel == 'NO_STOCK' ? 'disabled' : '' }} {{= reward.stockLevel == 'NO_STOCK' ? 'disabled' : '' }} {{= orderLine.rewardType.rewardTypeId == reward.rewardTypeId ? 'active' : '' }}"
                           data-analytics="reward type {{= reward.rewardType}}">
                        <input type="radio" name="order_rewardType" id="order_rewardType_{{= reward.rewardType}}"
                               value="{{= reward.rewardTypeId}}"
                               data-msg-required="Please choose the Toy you'd like to redeem"
                               required="required" {{=reward.stockLevel == 'NO_STOCK' ? 'disabled' : '' }} {{=
                        orderLine.rewardType.rewardTypeId == reward.rewardTypeId ? 'checked' : '' }} />
                    </label>
                    {{ }); }}
                </div>
            </div>
        </div>

        <div class="form-group row fieldrow clear required_input">
            <label for="order_firstName" class="col-sm-4 col-xs-10 control-label">First name</label>
            <div class="col-sm-6 col-xs-12 row-content">
                <input type="text" name="order_firstName" id="order_firstName" class="form-control"
                       data-rule-personname="true" required="required" data-msg-required="Please enter First Name"
                       value="{{= orderLine.firstName}}"/>
            </div>
        </div>

        <div class="form-group row fieldrow clear required_input">
            <label for="order_lastName" class="col-sm-4 col-xs-10 control-label">Last name</label>
            <div class="col-sm-6 col-xs-12 row-content">
                <input type="text" name="order_lastName" id="order_lastName" class="form-control"
                       data-rule-personname="true" required="required" data-msg-required="Please enter Last Name"
                       value="{{= orderLine.lastName}}"/>
            </div>
        </div>

        {{ var orderAddress = orderLine.orderAddresses.filter(function(address){ }}
        {{ return address.addressType === 'P' }}
        {{ })[0] || {} }}
        <div class="form-group row fieldrow clear">
            <label for="order_address_businessName" class="col-sm-4 col-xs-10 control-label">Business name</label>
            <div class="col-sm-6 col-xs-12 row-content">
                <input type="text" name="order_address_businessName" id="order_address_businessName"
                       class="form-control" value="{{= orderAddress.businessName }}" placeholder="Optional"/>
            </div>
        </div>

        <reward:redemption_form_address/>

        <div class="form-group row fieldrow clear required_input">
            <label for="order_phoneNumber" class="col-sm-4 col-xs-10 control-label">Phone number</label>
            <div class="col-sm-6 col-xs-12 row-content">
                <input type="text" name="order_phoneNumber" id="order_phoneNumber" title=""
                       class="form-control contact_telno phone  placeholder flexiphone" pattern="[0-9]*"
                       placeholder="(0x) xxxx xxxx or 04xx xxx xxx" required="required"
                       data-msg-required="Please enter the phone number" data-rule-validateflexitelno="true"
                       data-msg-validateflexitelno="Please enter the phone number in the format (0x)xxxx xxxx for landline or 04xx xxx xxx for mobile"
                       maxlength="20" value="{{= orderLine.phoneNumber}}"/>
            </div>
        </div>

        <div class="form-group row fieldrow clear required_input">
            <label for="order_contactEmail" class="col-sm-4 col-xs-10 control-label">Email address</label>
            <div class="col-sm-6 col-xs-12 row-content">
                <span>
                    <input name="order_contactEmail" id="order_contactEmail" class="form-control email" size="50"
                           required="required" type="email" data-msg-required="Please enter your email address"
                           value="{{= orderLine.contactEmail}}"/>
                </span>
            </div>
        </div>

        <div class="form-group row fieldrow clear required_input signature">
            <label for="order_signOnReceipt" class="col-sm-4 col-xs-10 control-label">Signature on delivery?</label>
            <div class="col-sm-6 col-xs-12 row-content">
                <div class="btn-group btn-group-justified btn-group-wrap" data-toggle="radio">
                    <label class="btn btn-form-inverse {{= orderLine.signOnReceipt === true ? 'active' : '' }}">
                        <input type="radio" name="order_signOnReceipt" id="order_signOnReceipt_Y" value="Y"
                               data-msg-required="Please tell us if want signature on delivery" required="required"
                               {{=orderLine.signOnReceipt === true ? "checked" : "" }}>Yes</label>
                    <label class="btn btn-form-inverse {{= orderLine.signOnReceipt === false ? 'active' : '' }}">
                        <input type="radio" name="order_signOnReceipt" id="order_signOnReceipt_N" value="N"
                               data-msg-required="Please tell us if want signature on delivery" required="required"
                               {{=orderLine.signOnReceipt === false ? "checked" : "" }}>No</label>
                </div>
                <span class="fieldrow_legend"><small>If you choose this option, you accept full responsibility upon the delivery of your reward and acknowledge it will not be replaced under any circumstances.</small></span>
            </div>
        </div>

        <div class="form-group row fieldrow clear">
            <div class="col-sm-4 col-xs-10"></div>
            <div class="col-sm-6 col-xs-12">
                <p class="error-message text-warning"></p>
            </div>
        </div>

        <div class="row text-right">
            <div class="col-sm-10">
                <button id="redemption-submit-button" type="button" class="btn btn-secondary">Submit</button>
            </div>
        </div>
    </fieldset>
</form>