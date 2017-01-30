<%@ tag description="Redemption template" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="isSimplesAdmin" required="false" rtexprvalue="true" description="Boolean to indicate if to use the form in simples admin area" %>

{{ var currentCampaign = data.eligibleCampaigns[0] || {}; }}

<form id="redemptionForm" class="form-horizontal">
    <fieldset class="qe-window fieldset">
        <div class="row form-heading">
            <c:choose>
                <c:when test="${isSimplesAdmin eq true}">
                    <div class="col-sm-12">
                        <br>
                        {{ if(data.modalAction === "edit") { }}
                        <h1>Edit Order</h1>
                        <input type="hidden" name="providerId" value="{{= data.providerId }}">
                        <input type="hidden" name="sequenceNo" value="{{= data.sequenceNo }}">
                        <input type="hidden" name="status" value="{{= data.status }}">
                        {{ } else { }}
                        <h1>Adhoc Order</h1>
                        {{ } }}
                    </div>
                </c:when>
                <c:otherwise>
                    {{= meerkat.modules.rewardConfirmation.getContentHtml().find('.reward-form-heading').html() }}
                </c:otherwise>
            </c:choose>
        </div>
        <div class="form-group row fieldrow clear required_input rewardType">
            <label for="order_rewardType" class="col-sm-4 col-xs-10 control-label">Please select your reward</label>
            <div class="col-sm-8 col-xs-12 row-content">
                <div class="btn-tile" data-toggle="radio">
                    {{ var rewards = currentCampaign.rewards.filter(function(reward) { }}
                    {{      return reward.active === true; }}
                    {{ }); }}

                    {{ _.each(rewards, function(reward) { }}
                    <label class="btn {{= reward.rewardType}} {{= reward.stockLevel == 'NO_STOCK' ? 'disabled' : '' }}" data-analytics="reward type {{= reward.rewardType}}">
                        <input type="radio" name="order_rewardType" id="order_rewardType_{{= reward.rewardType}}" value="{{= reward.rewardTypeId}}" data-msg-required="Please choose the reward you'd like to redeem" required="required" {{= reward.stockLevel == 'NO_STOCK' ? 'disabled' : '' }} />
                    </label>
                    {{ }); }}
                </div>
            </div>
        </div>

        <c:if test="${isSimplesAdmin ne true}">
        <div class="noDecline hidden">
        </c:if>
            {{ var orderLine = data.orderForm.orderHeader.orderLine || {}; }}
            <div class="form-group row fieldrow clear required_input">
                <label for="order_firstName" class="col-sm-4 col-xs-10 control-label">First name</label>
                <div class="col-sm-6 col-xs-12 row-content">
                    <input type="text" name="order_firstName" id="order_firstName" class="form-control" data-rule-personname="true" required="required" data-msg-required="Please enter First Name" value="{{= orderLine.firstName}}" />
                </div>
            </div>

            <div class="form-group row fieldrow clear required_input">
                <label for="order_lastName" class="col-sm-4 col-xs-10 control-label">Last name</label>
                <div class="col-sm-6 col-xs-12 row-content">
                    <input type="text" name="order_lastName" id="order_lastName" class="form-control" data-rule-personname="true" required="required" data-msg-required="Please enter Last Name" value="{{= orderLine.lastName}}" />
                </div>
            </div>

            {{ var orderAddress = orderLine.orderAddresses[0] || {}; }}
            <div class="form-group row fieldrow clear">
                <label for="order_address_businessName" class="col-sm-4 col-xs-10 control-label">Business name</label>
                <div class="col-sm-6 col-xs-12 row-content">
                    <input type="text" name="order_address_businessName" id="order_address_businessName" class="form-control" value="{{= orderAddress.businessName }}" />
                </div>
            </div>

            <reward:redemption_form_address />

            <div class="form-group row fieldrow clear required_input">
                <label for="order_phoneNumber" class="col-sm-4 col-xs-10 control-label">Phone number</label>
                <div class="col-sm-6 col-xs-12 row-content">
                    <input type="text" name="order_phoneNumber" id="order_phoneNumber" title="" class="form-control contact_telno phone  placeholder flexiphone" pattern="[0-9]*" placeholder="(0x) xxxx xxxx or 04xx xxx xxx" required="required" data-msg-required="Please enter the phone number" data-rule-validateflexitelno="true" data-msg-validateflexitelno="Please enter the phone number in the format (0x)xxxx xxxx for landline or 04xx xxx xxx for mobile" maxlength="20" value="{{= orderLine.phoneNumber}}" />
                </div>
            </div>

            <c:choose>
                <c:when test="${isSimplesAdmin eq true}">
                    <div class="form-group row fieldrow clear required_input">
                        <label for="order_contactEmail" class="col-sm-4 col-xs-10 control-label">Email address</label>
                        <div class="col-sm-6 col-xs-12 row-content">
                    <span>
                        <input name="order_contactEmail" id="order_contactEmail" class="form-control email" size="50" required="required" type="email" data-msg-required="Please enter your email address" value="{{= orderLine.contactEmail}}" />
                    </span>
                        </div>
                    </div>
                </c:when>
                <c:otherwise>
                    <input type="hidden" name="order_contactEmail" value="{{= orderLine.contactEmail}}">
                </c:otherwise>
            </c:choose>


            <div class="form-group row fieldrow clear required_input signature">
                <label for="order_signOnReceipt" class="col-sm-4 col-xs-10 control-label">Signature on delivery?</label>
                <div class="col-sm-6 col-xs-12 row-content">
                    <div class="btn-group btn-group-justified btn-group-wrap" data-toggle="radio">
                        <label class="btn btn-form-inverse {{= orderLine.signOnReceipt === true ? 'active' : '' }}">
                            <input type="radio" name="order_signOnReceipt" id="order_signOnReceipt_Y" value="Y" data-msg-required="Please tell us if want signature on delivery" required="required" {{= orderLine.signOnReceipt === true ? "checked" : "" }}>Yes</label>
                        <label class="btn btn-form-inverse {{= orderLine.signOnReceipt === false ? 'active' : '' }}">
                            <input type="radio" name="order_signOnReceipt" id="order_signOnReceipt_N" value="N" data-msg-required="Please tell us if want signature on delivery" required="required" {{= orderLine.signOnReceipt === false ? "checked" : "" }}>No</label>
                    </div>
                    <span class="fieldrow_legend"><small>{{= meerkat.modules.rewardConfirmation.getContentHtml().find('.reward-signature-warning').html() }}</small></span>
                </div>
            </div>

            <%--<div class="form-group row fieldrow clear">--%>
                <%--<div class="col-sm-6 col-xs-10 col-sm-offset-4 row-content">--%>
                    <%--<div class="checkbox">--%>
                        <%--<input type="checkbox" name="order_trackerOptIn" id="order_trackerOptIn" class="checkbox-custom checkbox" value="Y">--%>
                        <%--<label for="order_trackerOptIn">Please tick if you would like to receive update on the toy's delivery progress</label>--%>
                    <%--</div>--%>
                <%--</div>--%>
            <%--</div>--%>

            <div class="form-group row fieldrow clear required_input">
                <div class="col-sm-6 col-xs-10 col-sm-offset-4 row-content">
                    <div class="checkbox">
                        <input type="checkbox" name="order_privacyOptin" id="order_privacyOptin" class="checkbox-custom checkbox" value="Y" required="required" data-msg-required="Please agree to the Terms & Conditions">
                        <label for="order_privacyOptin">{{= meerkat.modules.rewardConfirmation.getContentHtml().find('.reward-optin-text').html() }}</label>
                    </div>
                </div>
            </div>

        <c:if test="${isSimplesAdmin ne true}">
        </div>
        </c:if>

        <c:if test="${isSimplesAdmin ne true}">

            <hr class="divider" />
            <div class="declineReward form-group row fieldrow clear">
                <div class="col-sm-6 col-xs-10 col-sm-offset-4 row-content">
                    <div class="checkbox">
                        <input type="checkbox" name="order_orderStatus" id="order_orderStatus" class="checkbox-custom checkbox" value="Declined">
                        <label for="order_orderStatus">I don't want to claim a toy</label>
                    </div>
                </div>
            </div>
        </c:if>

        <div class="row">
            <div class="col-sm-12">
                <p class="error-message text-warning"></p>
            </div>
        </div>

        <div class="row text-right">
            <div class="col-sm-10">
                <button type="button" class="crud-save-entry btn btn-secondary">Submit</button>
            </div>
        </div>
    </fieldset>
</form>