<%@ tag description="Simples template" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="isSimplesAdmin" required="false" rtexprvalue="true" description="Boolean to indicate if to use the form in simples admin area" %>

<form id="redemptionForm" class="form-horizontal">
    <fieldset class="qe-window fieldset">
        <div class="row form-heading">
            <c:choose>
                <c:when test="${isSimplesAdmin eq true}">
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
                    <p>Congratulations, you can now be the owner of your very own handsome Meerkat toy (or Sergei!)</p>
                </c:otherwise>
            </c:choose>
        </div>
        <div class="row">
            <div class="col-sm-12">
                <ul class="error-list"></ul>
            </div>
        </div>
        <div class="form-group row fieldrow clear required_input rewardType">
            <label for="orderHeader_orderLine_rewardTypeId" class="col-sm-4 col-xs-10 control-label">Please select your reward</label>
            <div class="col-sm-8 col-xs-12 row-content">
                <div class="btn-tile" data-toggle="radio">
                    <%--{{ for(var i in providers) { }}--%>
                    <label class="btn aleks" data-analytics="reward type aleks">
                        <input type="radio" name="orderHeader_orderLine_rewardTypeId" id="orderHeader_orderLine_rewardTypeId_aleks" value="aleks" data-msg-required="Please choose the reward you'd like to redeem" required="required" />
                    </label>
                    <label class="btn sergei" data-analytics="reward type sergei">
                        <input type="radio" name="orderHeader_orderLine_rewardTypeId" id="orderHeader_orderLine_rewardTypeId_sergei" value="sergei" data-msg-required="Please choose the reward you'd like to redeem" required="required" />
                    </label>
                    <%--{{ } }}--%>
                </div>
            </div>
        </div>

        <div class="form-group row fieldrow clear required_input">
            <label for="orderHeader_orderLine_firstName" class="col-sm-4 col-xs-10 control-label">First name</label>
            <div class="col-sm-6 col-xs-12 row-content">
                <input type="text" name="orderHeader_orderLine_firstName" id="orderHeader_orderLine_firstName" class="form-control" data-rule-personname="true" required="required" data-msg-required="Please enter First Name" />
            </div>
        </div>

        <div class="form-group row fieldrow clear required_input">
            <label for="orderHeader_orderLine_lastName" class="col-sm-4 col-xs-10 control-label">Last name</label>
            <div class="col-sm-6 col-xs-12 row-content">
                <input type="text" name="orderHeader_orderLine_lastName" id="orderHeader_orderLine_lastName" class="form-control" data-rule-personname="true" required="required" data-msg-required="Please enter Last Name" />
            </div>
        </div>

        <div class="form-group row fieldrow clear">
            <label for="orderHeader_orderLine_orderAddresses_businessName" class="col-sm-4 col-xs-10 control-label">Business name</label>
            <div class="col-sm-6 col-xs-12 row-content">
                <input type="text" name="orderHeader_orderLine_orderAddresses_businessName" id="orderHeader_orderLine_orderAddresses_businessName" class="form-control" />
            </div>
        </div>

        <group_v2:elastic_address
                xpath="orderHeader/orderLine/orderAddresses"
                type="P"
                suburbNameAdditionalAttributes=" autocomplete='false'"
                suburbAdditionalAttributes=" autocomplete='false'"
                postCodeNameAdditionalAttributes=" autocomplete='false'"
                postCodeAdditionalAttributes=" autocomplete='false'"
                addRequiredAsterisk="true"
        />

        <div class="form-group row fieldrow clear required_input">
            <label for="orderHeader_orderLine_phoneNumber" class="col-sm-4 col-xs-10 control-label">Phone number</label>
            <div class="col-sm-6 col-xs-12 row-content">
                <input type="text" name="orderHeader_orderLine_phoneNumber" id="orderHeader_orderLine_phoneNumber" title="" class="form-control contact_telno phone  placeholder flexiphone" pattern="[0-9]*" placeholder="(0x) xxxx xxxx or 04xx xxx xxx" required="required" data-msg-required="Please enter the phone number" data-rule-validateflexitelno="true" data-msg-validateflexitelno="Please enter the phone number in the format (0x)xxxx xxxx for landline or 04xx xxx xxx for mobile" maxlength="20" />
            </div>
        </div>

        <c:choose>
            <c:when test="${isSimplesAdmin eq true}">
                <div class="form-group row fieldrow clear required_input">
                    <label for="orderHeader_orderLine_contactEmail" class="col-sm-4 col-xs-10 control-label">Email address</label>
                    <div class="col-sm-6 col-xs-12 row-content">
                <span>
                    <input name="orderHeader_orderLine_contactEmail" id="orderHeader_orderLine_contactEmail" class="form-control email" size="50" required="required" type="email" data-msg-required="Please enter your email address">
                </span>
                    </div>
                </div>
            </c:when>
            <c:otherwise>
                <input type="hidden" name="orderHeader_orderLine_contactEmail" value="{{= data.email }}">
            </c:otherwise>
        </c:choose>


        <div class="form-group row fieldrow clear required_input">
            <label for="orderHeader_orderLine_signOnReceipt" class="col-sm-4 col-xs-10 control-label">Signature on delivery?</label>
            <div class="col-sm-6 col-xs-12 row-content">
                <div class="btn-group btn-group-justified btn-group-wrap" data-toggle="radio">
                    <label class="btn btn-form-inverse">
                        <input type="radio" name="orderHeader_orderLine_signOnReceipt" id="orderHeader_orderLine_signOnReceipt_Y" value="Y" data-msg-required="Please tell us if want signature on delivery" required="required">Yes</label>
                    <label class="btn btn-form-inverse">
                        <input type="radio" name="orderHeader_orderLine_signOnReceipt" id="orderHeader_orderLine_signOnReceipt_N" value="N" data-msg-required="Please tell us if want signature on delivery" required="required">No</label>
                </div>
            </div>
        </div>

        <div class="form-group row fieldrow clear">
            <div class="col-sm-6 col-xs-10 col-sm-offset-4 row-content">
                <div class="checkbox">
                    <input type="checkbox" name="orderHeader_orderLine_trackerOptIn" id="orderHeader_orderLine_trackerOptIn" class="checkbox-custom checkbox" value="Y">
                    <label for="orderHeader_orderLine_trackerOptIn">Please tick if you would like to receive update on the toy's delivery progress</label>
                </div>
            </div>
        </div>

        <div class="form-group row fieldrow clear required_input">
            <div class="col-sm-6 col-xs-10 col-sm-offset-4 row-content">
                <div class="checkbox">
                    <input type="checkbox" name="orderHeader_orderLine_privacyOptin" id="orderHeader_orderLine_privacyOptin" class="checkbox-custom checkbox" value="Y" required="required" data-msg-required="Please agree to the Terms & Conditions">
                    <label for="orderHeader_orderLine_privacyOptin">Please tick to confirm you have read and agree to <a href="https://www.comparethemarket.com.au/terms-and-conditions/" target="_blank">Terms &amp; Conditions and Privacy Policy</a></label>
                </div>
            </div>
        </div>

        <c:if test="${isSimplesAdmin ne true}">
            <div class="form-group row fieldrow clear">
                <div class="col-sm-6 col-xs-10 col-sm-offset-4 row-content">
                    <div class="checkbox">
                        <input type="checkbox" name="orderHeader_orderLine_orderStatus" id="orderHeader_orderLine_orderStatus" class="checkbox-custom checkbox" value="Declined">
                        <label for="orderHeader_orderLine_orderStatus">I don't want to claim a toy</label>
                    </div>
                </div>
            </div>
        </c:if>

        <div class="row text-right">
            <div class="col-sm-10">
                <button type="button" class="crud-save-entry btn btn-secondary">Submit</button>
            </div>
        </div>
    </fieldset>
</form>