<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Price Promise simples questions and dialogue" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" 		required="true"	 rtexprvalue="true"	 description="field group's xpath" %>

<c:set var="brand" value="${pageSettings.getBrandCode()}" />
<c:set var="fieldXpath" value="${xpath}/mentioned" />

<c:if test="${brand eq 'ctm'}">
    <form_v3:row label="&nbsp;" fieldXpath="${fieldXpath}">
        <field_v2:checkbox xpath="${fieldXpath}" value="Y" title="Tick here if customer mentions an external offer which relates to price promise." required="false" label="Tick here if customer mentions an external offer which relates to price promise." />
    </form_v3:row>


    <c:set var="fieldXpath" value="${xpath}/promotion" />

    <form_v3:row label="What was the promotion you saw?" fieldXpath="${fieldXpath}" className="healthPricePromisePromotionRow">
        <field_v2:array_select items="lower_headline_price=Lower headline price,discounts_off_headline_price=Discounts off headline price,offers_of_free_periods=Offers of 'free periods',cashback_offers='Casback' offers" xpath="${fieldXpath}" title="What was the promotion you saw?" required="true" />
    </form_v3:row>

    <c:set var="bppEligibilityQuestion"><content:get key="bppEligibilityQuestion" /></c:set>
    <c:set var="fieldXpath" value="${xpath}/bppEligible" />
    <form_v3:row label="${bppEligibilityQuestion}" fieldXpath="${fieldXpath}" className="healthPricePromisePromotionRow bppEligibilityQuestion" renderLabelAsSimplesDialog="black">
        <field_v2:array_radio items="Y=Yes,N=No" style="group" xpath="${fieldXpath}" title="Best Price Promise eligibility" required="true" />
    </form_v3:row>

    <c:set var="bppPolicyStartDateQuestion"><content:get key="bppPolicyStartDateQuestion" /></c:set>
    <c:set var="fieldXpath" value="${xpath}/bppPolicyStart" />
    <form_v3:row label="${bppPolicyStartDateQuestion}" fieldXpath="${fieldXpath}" className="healthPricePromisePromotionRow bppPolicyStartDateQuestion hidden" renderLabelAsSimplesDialog="true">
        <field_v2:array_radio items="Y=Yes,N=No" style="group" xpath="${fieldXpath}" title="if start date is within the offer dates" required="true" />
    </form_v3:row>

    <c:set var="offerNotBppEligible"><content:get key="offerNotBppEligible" /></c:set>
    <c:set var="fieldXpath" value="${xpath}/offerNotBppEligible" />
    <form_v3:row label="${offerNotBppEligible}" fieldXpath="${fieldXpath}" className="healthPricePromisePromotionRow offerNotBppEligible hidden" renderLabelAsSimplesDialog="black" />

    <simples:dialogue id="101" vertical="health" className="pricePromisePromotionDialogue hidden" />
    <simples:dialogue id="232" vertical="health" className="pricePromisePromotionFormDialogue healthPricePromisePromotionRow hidden" />

    <div id="bppAuthorisationGroup" class="hidden">
        <div class="bestPrisePromiseReasonAndApprovalGroup healthPricePromisePromotionRow">

            <c:set var="fieldXpath" value="${xpath}/bestPrisePromise/approvedby" />
            <form_v3:row fieldXpath="${fieldXpath}" label="Approved By?" className="healthbestPrisePromiseApprovedByRow" renderLabelAsSimplesDialog="true">
                <p id="healthbestPrisePromiseApprovedBy" class="display-only"></p>
                <field_v1:hidden xpath="${fieldXpath}" required="false" validationMessage="Offer much be approved" />  <%-- the required prop might need to be set dynamically  --%>
            </form_v3:row>

            <c:set var="fieldXpath" value="${xpath}/bestPrisePromise/authorisationcode" />
            <c:set var="wrapperClass" value="authorisation-column" />
            <form_v3:row fieldXpath="${fieldXpath}" label="Team Leader Authorisation?" className="healthBestPrisePromiseAuthorisationRow" isNestedField="${false}" hideHelpIconCol="${true}" smRowOverride="6" renderLabelAsSimplesDialog="true">
                <div class="best-price-promise-validation-messages"><!-- empty --></div>
                <div class="col-xs-12 col-sm-7 ${wrapperClass}">
                    <field_v1:password xpath="${fieldXpath}" required="false" title="authorisation code" placeHolder="authorisation code" />
                </div>
                <div class="col-xs-12 col-sm-5 ${wrapperClass} buttons">
                    <a href="javascript:;" class="btn btn-cta btn-authorise">AUTHORISE</a>
                    <a href="javascript:;" class="btn btn-save btn-reset">RESET</a>
                </div>
            </form_v3:row>
        </div>
    </div>

</c:if>