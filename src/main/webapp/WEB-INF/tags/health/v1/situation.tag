<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="About you group"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" 		required="true"	 rtexprvalue="true"	 description="field group's xpath" %>

<%-- VARIABLES --%>
<c:set var="name" 			value="${go:nameFromXpath(xpath)}" />

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
                        <field_v2:array_radio xpath="health/simples/contactType" items="outbound=Outbound quote,inbound=Inbound quote" required="true" title="contact type (outbound/inbound)" />
                    </div>
                </div>
            </simples:dialogue>
            <simples:dialogue id="19" vertical="health" className="simples-dialog-inbound"/>
            <simples:dialogue id="20" vertical="health" className="simples-dialog-outbound"/>
            <simples:dialogue id="47" vertical="health" />
            <simples:dialogue id="48" vertical="health" />
            <simples:dialogue id="22" vertical="health" />
            <simples:dialogue id="21" vertical="health" mandatory="true" /> <%-- 3 Point Security Check --%>
            <simples:dialogue id="36" vertical="health" mandatory="true" className="simples-dialog-inbound" />

            <form_v3:fieldset id="healthAboutYou" legend="About you" postLegend="Tell us about yourself, so we can find the right cover for you" className="health-about-you">

                <c:set var="fieldXpath" value="${xpath}/healthCvr" />
                <form_v3:row label="You are a" fieldXpath="${fieldXpath}" className="health-cover">
                    <field_v2:general_select xpath="${fieldXpath}" type="healthCvr" className="health-situation-healthCvr" required="true" title="situation you are in" />
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

                <%-- Medicare card question --%>
                <c:if test="${callCentre}">
                    <c:set var="fieldXpath" value="${xpath}/cover" />
                    <form_v3:row label="Private Health Insurance works in conjunction with Medicare, so just to confim that you are covered by a Blue or Green Medicare Card?" fieldXpath="${fieldXpath}" className="health_situation_medicare text-danger">
                        <field_v2:array_radio items="Y=Yes,N=No" style="group" xpath="${fieldXpath}" title="your Medicare card cover" required="true" className="health-medicare_details-card" id="${name}_cover" additionalAttributes="data-rule-isCheckedYes='true' data-msg-isCheckedYes='Unfortunately we cannot continue with your quote'" />
                    </form_v3:row>
                </c:if>

                <%-- health situation used be radio buttons, hidden in call centre as requested --%>
                <field_v1:hidden xpath="${xpath}/healthSitu" defaultValue="LC" />
                <field_v1:hidden xpath="${xpath}/addExtrasCover" />

            </form_v3:fieldset>

            <simples:dialogue id="37" vertical="health" mandatory="true" className="hidden" />

        </jsp:body>
    </form_v2:fieldset_columns>
</div>