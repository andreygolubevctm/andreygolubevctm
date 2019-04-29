<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="About you group"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" 		required="true"	 rtexprvalue="true"	 description="field group's xpath" %>

<%-- VARIABLES --%>
<c:set var="name" 			value="${go:nameFromXpath(xpath)}" />
<c:set var="ovcScripting"><content:get key="simplesOVCCopy" /></c:set>
<c:set var="brandCode">${pageSettings.getBrandCode()}</c:set>

<%-- Dialog is not mandatory for callcentre chat users --%>
<c:set var="isRoleSimplesChatGroup" scope="session"><simples:security key="simplesChatGroup" /></c:set>

<c:set var="hideChatOption" value="true" />
<c:if test="${isRoleSimplesChatGroup and callCentre}">
	<c:set var="hideChatOption" value="false" />
</c:if>

<c:set var="excludeItemsContactType" value="" />
<c:set var="healthCvrExcludeItems" value="" />
<c:choose>
    <c:when test="${brandCode eq 'ctm'}">
        <c:set var="excludeItemsContactType" value="'trialcampaignMagpie','trialcampaign1','trialcampaign2','trialcampaign3'" />
        <c:if test="${hideChatOption}">
            <c:set var="excludeItemsContactType" value="'webchat','trialcampaignMagpie','trialcampaign1','trialcampaign2','trialcampaign3'" />
        </c:if>
    </c:when>
    <c:when test="${brandCode eq 'wfdd'}">
        <c:set var="excludeItemsContactType" value="'outbound','trialcampaignMagpie','trialcampaign1','trialcampaign2','trialcampaign3'" />
        <c:if test="${hideChatOption}">
            <c:set var="excludeItemsContactType" value="'outbound','webchat','trialcampaignMagpie','trialcampaign1','trialcampaign2','trialcampaign3'" />
        </c:if>
    </c:when>
    <c:when test="${brandCode eq 'bddd'}">
        <c:set var="healthCvrExcludeItems" value="'EF','ESP'" />
        <c:set var="excludeItemsContactType" value="'trialcampaign','trialcampaignBroadband','trialcampaignHealthEngine','trialcampaignJackMedia','trialcampaignFacebook','trialcampaignLifebrokerLnIP','trialcampaignTWE','trialcampaignXSellCar','trialcampaignXSellHnC','trialcampaignOmnilead'" />
        <c:if test="${hideChatOption}">
            <c:set var="excludeItemsContactType" value="'webchat','trialcampaign','trialcampaignBroadband','trialcampaignHealthEngine','trialcampaignJackMedia','trialcampaignFacebook','trialcampaignLifebrokerLnIP','trialcampaignTWE','trialcampaignXSellCar','trialcampaignXSellHnC','trialcampaignOmnilead'" />
        </c:if>
    </c:when>
    <c:otherwise>
        <c:if test="${hideChatOption}">
            <c:set var="excludeItemsContactType" value="'webchat'" />
        </c:if>
    </c:otherwise>
</c:choose>

<%-- HTML --%>
<div id="${name}-selection" class="health-situation">

    <form_v2:fieldset_columns sideHidden="true">

		<jsp:attribute name="rightColumn">
			<health_v2_content:sidebar />
		</jsp:attribute>

        <jsp:body>

            <simples:dialogue id="0" vertical="health" className="red">
                <div class="row">
                    <div class="col-sm-12">
                        <c:set var="fieldXpath" value="health/simples/contactTypeRadio" />
                        <form_v3:row label="Contact type (outbound/inbound)" fieldXpath="${fieldXpath}" className="health-contactType">
                            <field_v2:general_select xpath="${fieldXpath}" type="contactType" className="health-situation-contactType" required="true" title="Contact type (outbound/inbound)" excludeCodes="${excludeItemsContactType}" />
                        </form_v3:row>
                        <field_v1:hidden xpath="health/simples/contactType" />
                        <field_v1:hidden xpath="health/simples/contactTypeTrial" />
                    </div>
                </div>
            </simples:dialogue>
            <simples:dialogue id="68" vertical="health" />
            <simples:dialogue id="93" vertical="health" className="simples-dialog-referral" />
            <simples:dialogue id="69" vertical="health" />
            <simples:dialogue id="70" vertical="health" />
            <simples:dialogue id="19" vertical="health" className="simples-dialog-inbound"/>
            <simples:dialogue id="113" vertical="health" className="simples-dialog-nextgen"/>
            <simples:dialogue id="20" vertical="health" className="simples-dialog-outbound"/>
            <simples:dialogue id="115" vertical="health" className="simples-dialog-nextgenoutbound"/>
            <simples:dialogue id="121" vertical="health" className="simples-dialog-nextgencli"/>
            <simples:dialogue id="78" vertical="health" className="simples-dialog-cli"/>
            <simples:dialogue id="48" vertical="health" />
            <simples:dialogue id="63" vertical="health" />
            <simples:dialogue id="116" vertical="health" className="simples-dialog-nextgenoutbound" />
            <simples:dialogue id="122" vertical="health" className="simples-dialog-nextgencli" />
            <simples:dialogue id="49" vertical="health" />
            <simples:dialogue id="117" vertical="health" className="simples-dialog-nextgenoutbound" />
            <simples:dialogue id="123" vertical="health" className="simples-dialog-nextgencli" />
            <simples:dialogue id="21" vertical="health" mandatory="true" /> <%-- 3 Point Security Check --%>
            <simples:dialogue id="36" vertical="health" mandatory="true" className="simples-dialog-inbound show-nextgen" />

            <c:set var="subText" value="" />
            <c:if test="${not callCentre}">
                <c:set var="subText" value="Tell us about yourself, so we can find the right cover for you" />
            </c:if>

            <form_v3:fieldset id="healthAboutYou" legend="About you" postLegend="${subText}" className="health-about-you">

                <c:set var="fieldXpath" value="${xpath}/healthCvr" />
                <form_v3:row label="You are a" fieldXpath="${fieldXpath}" className="health-cover">
                    <field_v2:general_select xpath="${fieldXpath}" type="healthCvr" className="health-situation-healthCvr" required="true" title="situation you are in" excludeCodes="${healthCvrExcludeItems}" />
                </form_v3:row>

                <%-- If the user is coming via a broucherware site where by a state is passed in instead of a postcode, then only show state selection --%>

                <c:set var="fieldXpath" value="${xpath}/location" />
                <c:set var="state" value="${data['health/situation/state']}" />
                <c:set var="location" value="${data['health/situation/location']}" />

                <form_v3:row label="Living in" fieldXpath="${fieldXpath}" className="health-location">

                    <c:choose>
                        <c:when test="${not empty param.state || (not empty state && empty location && (param.action == 'amend' || param.action == 'load'))}">
                            <field_v1:state_select xpath="${xpath}/state" useFullNames="true" title="State" required="true" />
                        </c:when>
                        <c:otherwise>
                            <field_v2:lookup_suburb_postcode xpath="${fieldXpath}" required="true" placeholder="Suburb / Postcode" extraDataAttributes=" data-rule-validateLocation='true' " />
                            <field_v1:hidden xpath="${xpath}/state" />
                        </c:otherwise>
                    </c:choose>

                    <field_v1:hidden xpath="${xpath}/suburb" />
                    <field_v1:hidden xpath="${xpath}/postcode" />

                </form_v3:row>

                <%-- health situation used be radio buttons, hidden in call centre as requested --%>
                <field_v1:hidden xpath="${xpath}/healthSitu" defaultValue="LC" />
                <field_v1:hidden xpath="${xpath}/addExtrasCover" />

            </form_v3:fieldset>

        </jsp:body>
    </form_v2:fieldset_columns>
</div>