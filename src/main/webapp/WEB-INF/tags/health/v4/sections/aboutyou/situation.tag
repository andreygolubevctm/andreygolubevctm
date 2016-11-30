<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Medicare details group"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" 		required="true"	 rtexprvalue="true"	 description="field group's xpath" %>

<%-- VARIABLES --%>
<c:set var="name" 			value="${go:nameFromXpath(xpath)}" />

<%-- HTML --%>
<div id="${name}-selection" class="health-situation">

	<form_v4:fieldset_columns sideHidden="true">

		<jsp:attribute name="rightColumn">
			<health_v2_content:sidebar />
		</jsp:attribute>

		<jsp:body>

			<simples:dialogue id="19" vertical="health" />
			<simples:dialogue id="20" vertical="health" />
			<simples:dialogue id="0" vertical="health" className="red">
				<div class="row">
					<div class="col-sm-12">
						<field_v2:array_radio xpath="health/simples/contactType" items="outbound=Outbound quote,inbound=Inbound quote,followup=Follow up call,callback=Chat callback" required="true" title="contact type (outbound/inbound/followup/callback)" />
					</div>
				</div>
			</simples:dialogue>
			<simples:dialogue id="21" vertical="health" mandatory="true" /> <%-- 3 Point Security Check --%>
			<simples:dialogue id="36" vertical="health" mandatory="true" className="hidden simples-privacycheck-statement" /> <%-- Inbound --%>
			<simples:dialogue id="25" vertical="health" mandatory="true" className="hidden follow-up-call" /> <%-- Follow up call --%>

            <c:set var="subText" value="" />
            <c:if test="${not callCentre}">
                <c:set var="subText" value="Tell us about yourself, so we can find the right cover for you" />
            </c:if>

            <form_v3:fieldset id="healthAboutYou" legend="Tell us about yourself, so we can find the right cover for you" postLegend="${subText}" className="health-about-you">

				<health_v4_aboutyou:livingin xpath="${xpath}" />
				<health_v4_aboutyou:youarea xpath="${xpath}" />
				<health_v4_aboutyou:youarea xpath="${xpath}" />

				<c:set var="xpath" value="${pageSettings.getVerticalCode()}/healthCover" />
				<health_v4_aboutyou:dob xpath="${xpath}" />
				<health_v4_aboutyou:currentlyowninsurance xpath="${xpath}" />
				<health_v4_aboutyou:optin xpath="${xpath}" />
			</form_v3:fieldset>

			<%-- Health benefits has simples messages --%>
			<simples:dialogue id="23" vertical="health" className="green" >
				<div style="margin-top:20px;">
					<a href="javascript:;"  data-benefits-control="Y" class="btn btn-form">Open Benefits</a>
				</div>
			</simples:dialogue>

			<form_v3:fieldset id="primary-health-cover" legend="Your Details" className="primary">
				<sql:setDataSource dataSource="${datasource:getDataSource()}"/>

				<sql:query var="result">
					SELECT code, description FROM aggregator.general WHERE type = 'healthSitu' AND (status IS NULL OR status != 0)
					<c:if test="${not taxTimeSplitTest}">
						and code != 'CHC'
					</c:if>
					<c:choose>
						<c:when test="${taxTimeSplitTest eq true and data.health.currentJourney eq 31}">
							ORDER BY FIELD(code,'CHC', 'LC','LBC','CSF','ATP')
						</c:when>
                        <c:when test="${taxTimeSplitTest eq true and data.health.currentJourney eq 32}">
                            AND code IN ('CHC', 'LC')
                            ORDER BY code
                        </c:when>
						<c:otherwise>
							ORDER BY orderSeq
						</c:otherwise>
					</c:choose>
				</sql:query>
				<c:set var="sep"></c:set>
				<c:set var="items">
					<c:forEach var="row" items="${result.rows}">
						${sep}${row.code}=${row.description}
						<c:set var="sep">,</c:set>
					</c:forEach>
				</c:set>
				<c:set var="fieldXpath" value="${xpath}/healthSitu" />
				<c:set var="analyticsAttr"><field_v1:analytics_attr analVal="looking for" quoteChar="\"" /></c:set>
				<form_v3:row label="Which situation describes you best?" fieldXpath="${fieldXpath}">
					<field_v2:array_radio xpath="${fieldXpath}"
										  required="true"
										  className="health-situation-healthSitu"
										  items="${items}"
										  style="group-tile"
										  id="${go:nameFromXpath(fieldXPath)}"
										  title="reason you are looking to quote"
										  additionalLabelAttributes="${analyticsAttr}"
										  wrapCopyInSpan="${true}" />
				</form_v3:row>

				<c:set var="fieldXpath" value="${xpath}/addExtrasCover" />
				<form_v3:row label="Do you wish to add extras cover for services like Dental, Optical or Physio?" fieldXpath="${fieldXpath}" id="extrasCoverOptionContainer">
					<field_v2:array_radio items="Y=Yes,N=No" style="group" xpath="${fieldXpath}" title="extras cover" required="true" />
				</form_v3:row>

			<%-- Did it this way to prevent the snapshot from pushing the fields below up/down depending on the option selected with the health_situation_healthCvr field --%>
			<c:set var="xpath" value="${pageSettings.getVerticalCode()}/healthCover" />
			<c:set var="name" 			value="${go:nameFromXpath(xpath)}" />



				<c:set var="fieldXpath" value="${xpath}/primary/healthCoverLoading" />
				<c:set var="analyticsAttr"><field_v1:analytics_attr analVal="continuous cover" quoteChar="\"" /></c:set>
				<form_v3:row label="Have you had continuous hospital cover since 1 July ${continuousCoverYear} or 1 July following your 31st birthday?" fieldXpath="${fieldXpath}" id="health-continuous-cover-primary" className="health-your_details-opt-group" helpId="239">
					<field_v2:array_radio items="Y=Yes,N=No" style="group" xpath="${fieldXpath}" title="your health cover loading" required="true" id="${name}_health_cover_loading" className="loading" additionalLabelAttributes="${analyticsAttr}"/>
				</form_v3:row>

				<c:if test="${callCentre}">
					<c:set var="fieldXpath" value="${xpath}/primary/lhc" />
					<form_v2:row label="Applicant's LHC" fieldXpath="${fieldXpath}" helpId="287">
						<field_v1:input_numeric xpath="${fieldXpath}" minValue="0" maxValue="70" title="Applicant's LHC" required="false" id="${name}_primary_lhc" maxLength="2" className="primary-lhc"/>
					</form_v2:row>
				</c:if>
			</form_v3:fieldset>

			<form_v3:fieldset id="partner-health-cover" legend="Your Partner's Details" className="partner">
				<c:set var="fieldXpath" value="${xpath}/partner/dob" />
				<form_v3:row label="Your partner's date of birth" fieldXpath="${fieldXpath}">
					<field_v2:person_dob xpath="${fieldXpath}" title="partner's" required="true" ageMin="16" ageMax="120" />
				</form_v3:row>

				<c:set var="fieldXpath" value="${xpath}/partner/cover" />
				<c:set var="analyticsAttr"><field_v1:analytics_attr analVal="partner health insurance status" quoteChar="\"" /></c:set>
				<form_v3:row label="Does your partner currently hold private health insurance?" fieldXpath="${fieldXpath}"  id="${name}_partnerCover">
					<field_v2:array_radio items="Y=Yes,N=No" style="group" xpath="${fieldXpath}" title="your private health cover" required="true" className="health-cover_details" id="${name}_partner_health_cover" additionalLabelAttributes="${analyticsAttr}" />
				</form_v3:row>

				<c:set var="fieldXpath" value="${xpath}/partner/healthCoverLoading" />
				<c:set var="analyticsAttr"><field_v1:analytics_attr analVal="partner continuous cover" quoteChar="\"" /></c:set>
				<form_v3:row label="Has your partner had continuous hospital cover since 1 July ${continuousCoverYear} or 1 July following their 31st birthday?" fieldXpath="${fieldXpath}" id="health-continuous-cover-partner" className="health-your_details-opt-group" helpId="239">
					<field_v2:array_radio items="Y=Yes,N=No" style="group" xpath="${fieldXpath}" title="your partner's health cover loading" required="true" id="${name}_partner_health_cover_loading" className="loading" additionalLabelAttributes="${analyticsAttr}" />
				</form_v3:row>

				<c:if test="${callCentre}">
					<c:set var="fieldXpath" value="${xpath}/partner/lhc" />
					<form_v2:row label="Partner's LHC" fieldXpath="${fieldXpath}">
						<field_v1:input_numeric xpath="${fieldXpath}" minValue="0" maxValue="70" title="Partner's LHC" required="false" id="${name}_partner_lhc" maxLength="2" className="partner-lhc"/>
					</form_v2:row>
				</c:if>
			</form_v3:fieldset>
			<simples:dialogue id="26" vertical="health" mandatory="true" />
			<form_v3:fieldset id="australian-government-rebate" legend="Australian Government Rebate" postLegend="Most Australians can reduce their upfront health insurance costs by applying the Government Rebate.">
				<c:set var="fieldXpath" value="${xpath}/rebate" />
				<c:set var="analyticsAttr"><field_v1:analytics_attr analVal="rebate application" quoteChar="\"" /></c:set>
				<form_v3:row label="Would you like to reduce your upfront premium by applying the rebate?" fieldXpath="${fieldXpath}" helpId="240" className="health_cover_details_rebate">
					<field_v2:array_radio items="Y=Yes,N=No" style="group" xpath="${fieldXpath}" title="your private health cover rebate" required="true" id="${name}_health_cover_rebate" className="rebate btn-group-wrap" additionalLabelAttributes="${analyticsAttr}" />
				</form_v3:row>

				<c:if test="${callCentre}">
					<c:set var="fieldXpath" value="${xpath}/incomeBasedOn" />
					<form_v2:row label="I wish to calculate my rebate based on" fieldXpath="${fieldXpath}" helpId="288" className="health_cover_details_incomeBasedOn" id="${name}_incomeBase">
						<field_v2:array_radio items="S=Single income,H=Household income" style="group" xpath="${fieldXpath}" title="income based on" required="true"  />
					</form_v2:row>
				</c:if>

				<c:set var="fieldXpath" value="${xpath}/dependants" />
				<form_v3:row label="How many dependent children do you have?" fieldXpath="${fieldXpath}" helpId="241" className="health_cover_details_dependants">
					<field_v2:count_select xpath="${fieldXpath}" max="12" min="1" title="number of dependants" required="true"  className="${name}_health_cover_dependants dependants"/>
				</form_v3:row>

				<c:set var="fieldXpath" value="${xpath}/income" />
				<c:set var="analyticsAttr"><field_v1:analytics_attr analVal="rebate income level" quoteChar="\"" /></c:set>
				<form_v3:row label="To receive the correct rebate, please select your expected annual income?" fieldXpath="${fieldXpath}" id="${name}_tier">
					<field_v2:array_select xpath="${fieldXpath}" title="your household income" required="true" items="=Please choose...||0=Tier 0||1=Tier 1||2=Tier 2||3=Tier 3" delims="||" className="income health_cover_details_income" extraDataAttributes="${analyticsAttr}" />
					<span class="fieldrow_legend" id="${name}_incomeMessage"></span>
					<c:set var="income_label_xpath" value="${xpath}/incomelabel" />
					<div class="fieldrow_legend" id="health_healthCover_tier_row_legend"></div>
                    <div class="hidden text-justify" id="health_healthCover_tier_row_legend_mls">
                        If you earn under $90,000 (or $180,000 total, for couples or families) in any financial year, you won’t be liable to pay the Medicare Levy Surcharge in that financial year. For help or further information call us on ${callCentreNumber}.
                    </div>
					<input type="hidden" name="${go:nameFromXpath(xpath)}_incomelabel" id="${go:nameFromXpath(xpath)}_incomelabel" value="${data[income_label_xpath]}" />
				</form_v3:row>

			</form_v3:fieldset>

            <%-- Override set in splittest_helper tag --%>
			<c:if test="${showOptInOnSlide3 eq false}">
				<c:set var="termsAndConditions">
					<%-- PLEASE NOTE THAT THE MENTION OF COMPARE THE MARKET IN THE TEXT BELOW IS ON PURPOSE --%>
					I understand <content:optin key="brandDisplayName" useSpan="true"/> compares health insurance policies from a range of
					<a href='<content:get key="participatingSuppliersLink"/>' target='_blank'>participating suppliers</a>.
					By providing my contact details I agree that <content:optin useSpan="true" content="comparethemarket.com.au"/> may contact me, during the Call Centre <a href="javascript:;" data-toggle="dialog" data-content="#view_all_hours" data-dialog-hash-id="view_all_hours" data-title="Call Centre Hours" data-cache="true">opening hours</a>, about the services they provide.
					I confirm that I have read the <form_v1:link_privacy_statement />.
				</c:set>

				<%-- Optional question for users - mandatory if Contact Number is selected (Required = true as it won't be shown if no number is added) --%>
				<div class="health-contact-details-optin-group">
					<div class="col-xs-12">
						<c:set var="analyticsAttr"><field_v1:analytics_attr analVal="combined optin" quoteChar="\"" /></c:set>
						<field_v2:checkbox
								xpath="${pageSettings.getVerticalCode()}/contactDetails/optin"
								value="Y"
								className="validate"
								required="true"
								label="${true}"
								title="${termsAndConditions}"
								errorMsg="Please agree to the Terms &amp; Conditions"
								additionalLabelAttributes="${analyticsAttr}"
						/>
					</div>
				</div>
			</c:if>
			<simples:dialogue id="37" vertical="health" mandatory="true" className="hidden" />

		</jsp:body>
	</form_v4:fieldset_columns>
</div>