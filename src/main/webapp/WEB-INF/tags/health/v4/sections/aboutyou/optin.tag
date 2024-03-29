<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Optin row"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" 		required="true"	 rtexprvalue="true"	 description="field group's xpath" %>

<%-- VARIABLES --%>
<c:set var="name" 			value="${go:nameFromXpath(xpath)}" />

<c:set var="fieldXpath" value="${xpath}/healthCvr" />
<c:set var="analyticsAttr"><field_v1:analytics_attr analVal="about you" quoteChar="\"" /></c:set>

<c:set var="specialOptInKey" value="" />

<%-- Get current  --%>
<c:set var="websiteTermConfigToUse">
    <content:get key="websiteTermsUrlConfig"/>
</c:set>

<c:choose>
	<c:when test="${octoberComp}">
        <c:set var="optInText"><content:get key="octoberCompOptInText" /></c:set>
	</c:when>
    <c:when test="${africaComp}">
        <c:set var="optInText"><content:get key="africaCompOptInText" /></c:set>
        <agg_v1:safari_promo_terms_link />
        <c:set var="optInText" value="${fn:replace(optInText, '%winSafariPromoTermsPlaceHolder%', winSafariPromoTermsPlaceHolder)}" />
    </c:when>
	<c:otherwise>
        <c:set var="specialOptInText">
            <content:get key="specialOptInText" />
        </c:set>
        <c:set var="optInText">
            <c:choose>
                <c:when test="${specialOptInText ne ''}">
                    ${specialOptInText}
                    <c:set var="specialOptInKey">
                        <content:get key="specialOptInText" suppKey="specialOptInKey" />
                    </c:set>
                </c:when>
                <c:otherwise>
                    <content:get key="optInText" />
                </c:otherwise>
            </c:choose>
        </c:set>
    </c:otherwise>
</c:choose>

<c:if test="${not empty specialOptInKey and specialOptInKey ne ''}">
    <field_v1:hidden xpath="${pageSettings.getVerticalCode()}/contactDetails/optinLeadCopy" constantValue="${specialOptInKey}" />
</c:if>

<c:set var="websiteTermConfigPlaceHolder">${pageSettings.getSetting(websiteTermConfigToUse)}</c:set>
<c:set var="privacyStmtPlaceHolder"><form_v1:link_privacy_statement /></c:set>
<c:set var="brandNamePlaceHolder"><content:optin key="brandDisplayName" useSpan="true"/></c:set>

<c:set var="optInText" value="${fn:replace(optInText, '%websiteTermConfigPlaceHolder%', websiteTermConfigPlaceHolder)}" />
<c:set var="optInText" value="${fn:replace(optInText, '%privacyStmtPlaceHolder%', privacyStmtPlaceHolder)}" />
<c:set var="optInText" value="${fn:replace(optInText, '%brandNamePlaceHolder%', brandNamePlaceHolder)}" />

<%-- Override set in splittest_helper tag --%>
<c:if test="${showOptInOnSlide3 eq false}">
    <c:set var="termsAndConditions">
        ${optInText}
    </c:set>

    <%-- Optional question for users - mandatory if Contact Number is selected (Required = true as it won't be shown if no number is added) --%>
    <div class="health-contact-details-optin-group form-group">
        <div class="col-xs-12 fieldrow">
            <c:set var="analyticsAttr"><field_v1:analytics_attr analVal="combined optin" quoteChar="\"" /></c:set>
            <field_v2:checkbox
                    xpath="${pageSettings.getVerticalCode()}/contactDetails/optin"
                    value="Y"
                    className="validate row-content"
                    required="true"
                    label="${true}"
                    title="${termsAndConditions}"
                    errorMsg="Please agree to the Terms &amp; Conditions"
                    additionalLabelAttributes="${analyticsAttr}"
            />
        </div>
    </div>
</c:if>
