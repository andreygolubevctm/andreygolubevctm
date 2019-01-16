<%@ tag description="The Health Journey's 'All About You' Slide" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<jsp:useBean id="rememberMeService" class="com.ctm.web.core.rememberme.services.RememberMeService" />
<agg_v1:remember_me_settings vertical="health" />

<layout_v3:slide formId="startForm" firstSlide="true">

    <layout_v3:slide_content>

        <%-- PROVIDER TESTING --%>
        <%--<health_v4_aboutyou:provider_testing xpath="${pageSettings.getVerticalCode()}" />--%>

        <%-- COVER TYPE / SITUATION --%>
        <div id="${pageSettings.getVerticalCode()}_situation">

                <%-- VARIABLES --%>
            <c:set var="xpath" 			value="${pageSettings.getVerticalCode()}/situation" />
            <c:set var="name" 			value="${go:nameFromXpath(xpath)}" />

                <%-- HTML --%>
            <div id="${name}-selection" class="health-situation">
                <form_v3:fieldset_columns nextLabel="Insurance preferences" sideHidden="true">

                    <jsp:attribute name="rightColumn">
                        <competition:snapshot vertical="health" />
                        <reward:campaign_tile_container />
                        <health_v4_aboutyou:retrievequotes />
                        <health_v4_aboutyou:medicarecheck />
                        <health_v4:price_promise step="start" />
                    </jsp:attribute>
                    <jsp:body>

                        <%-- PROVIDER TESTING --%>
                        <health_v1:provider_testing xpath="${pageSettings.getVerticalCode()}" />

                        <c:set var="legend">
                            <c:choose>
                                <c:when test="${isRememberMe and hasUserVisitedInLast30Minutes}">
                                    <c:set var="firstname" value="${rememberMeService.getNameOfUser(pageContext.request, pageContext.response, 'health')}" />
                                    Hi ${firstname}, to make things easier we have filled out the details you entered last time. Review your quote and amend your details to compare products
                                </c:when>
                                <c:otherwise>
                                    Firstly, tell us a bit about yourself.
                                </c:otherwise>
                            </c:choose>
                        </c:set>

                        <form_v4:fieldset id="healthAboutYou"
                                          legend="${legend}"
                                          className="health-about-you">
                            <health_v4_aboutyou:youarea xpath="${xpath}" />
                            
                            <c:set var="xpath" value="${pageSettings.getVerticalCode()}/healthCover" />
                            
                            <c:set var="analyticsAttr"><field_v1:analytics_attr analVal="rebate income level" quoteChar="\"" /></c:set>
                            <c:set var="fieldXpath" value="${xpath}/income" />
                            <form_v4:row label="<span id='health_healthCover_situation_single'>What is your taxable income?</span><span id='health_healthCover_situation_hasPartner' class='hidden'>What is your, and your partners combined taxable income?</span><br />" id="${name}_income_field_row" className="lhcRebateCalcTrigger" smRowOverride="6">
                                <field_v2:array_select xpath="${fieldXpath}" title="your household income" required="true" items="=Please choose...||0=Tier 0||1=Tier 1||2=Tier 2||3=Tier 3" delims="||" className="income health_cover_details_income"/>
                            	<c:set var="income_label_xpath" value="${xpath}/incomelabel" />
                            	<div id="rebateLabel"><span></span></div>
                            	<div class="fieldrow_legend" id="health_healthCover_tier_row_legend">Depending on your taxable income, you may be eligible for a government discount on your premium.</div>
                            </form_v4:row>
                            <input type="hidden" name="${go:nameFromXpath(xpath)}_incomelabel" id="${go:nameFromXpath(xpath)}_incomelabel" value="${data[income_label_xpath]}" />

                            <h3 class="allow-margin-top">Your details</h3>
                            <health_v4_aboutyou:currentlyowninsurance xpath="${xpath}" />
                            <health_v4_aboutyou:current_health_fund xpath="${xpath}" />
                            <health_v4_aboutyou:dob xpath="${xpath}" />

                            <h3 id="health_insurance_preferences_additional_partner_title" class="allow-margin-top">Your partner's details</h3>

                            <health_v4_aboutyou:partner_cover xpath="${xpath}" />
                            <div id="health_insurance_preferences_additional_partner_fields">
                                <health_v4_aboutyou:partner_current_fund xpath="${xpath}" />
                            </div>
                            <health_v4_aboutyou:partner_dob xpath="${xpath}" />

                            <health_v4_aboutyou:applyrebate xpath="${xpath}" />
                            <health_v4_aboutyou:optin xpath="${xpath}" />

                        </form_v4:fieldset>

                    </jsp:body>
                </form_v3:fieldset_columns>
            </div>
        </div>

    </layout_v3:slide_content>

</layout_v3:slide>
