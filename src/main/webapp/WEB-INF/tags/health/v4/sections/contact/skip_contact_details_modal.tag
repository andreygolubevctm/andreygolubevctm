<%@ tag description="Container for various input fields used by dialogs" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" 		required="true"	 rtexprvalue="true"	 description="field group's xpath" %>

<%-- VARIABLES --%>
<c:set var="name" 			value="${go:nameFromXpath(xpath)}" />
<c:set var="contactDtlsExitBanTop"><content:get key="contactDtlsExitBannerTop" /></c:set>
<c:set var="contactDtlsExitBanBottom"><content:get key="contactDtlsExitBannerBottom" /></c:set>

<core_v1:js_template id="skip-contact-details-template">
    <div class="skip-contact-details-modal-content">
        ${contactDtlsExitBanTop}
        <div class="row">
            <div class="round-btns-with-outline">
                <field_v2:array_radio xpath="${xpath}/state"
                                      className="health-situation-state"
                                      required="true"
                                      items="NSW=NSW,VIC=VIC,QLD=QLD,ACT=ACT,WA=WA,SA=SA,TAS=TAS,NT=NT"
                                      title="you're living in"
                                      style="radio-rounded"
                                      wrapCopyInSpan="${true}"
                                      additionalLabelAttributes="${labelAttributes}" />
            </div>
        </div>
        ${contactDtlsExitBanBottom}
    </div>
</core_v1:js_template>