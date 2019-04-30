<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%@ attribute name="item" required="true" type="com.ctm.web.core.results.model.ResultsTemplateItem" %>
<c:set var="logger" value="${log:getLogger('jsp.ajax.json.benefits')}" />
<c:set var="altJourneyCustomiseBtn">
	<div class="row altBenefitsJourney customise">
		<div class="hidden-xs col-sm-2 col-lg-3"></div>
		<div class="col-xs-12 col-sm-8 col-lg-6 no-column-medling"><a href="javascript:;" class="btn btn-form-inverse benefit-category" data-category="limited">Switch to Limited Hospital Cover</a></div>
		<div class="hidden-xs col-sm-2 col-lg-3"></div>
	</div>
</c:set>
<c:set var="altJourneyLimitedBtn">
	<div class="altBenefitsJourney limited">
		<h5>Prefer to have extra piece of mind?</h5>
		<div class="row">
			<div class="hidden-xs col-sm-2 col-lg-3"></div>
			<div class="col-xs-12 col-sm-8 col-lg-6 no-column-medling">
				<a href="javascript:;" class="btn btn-form-inverse benefit-category hidden-xs" data-category="customise">Select Benefits for Comprehensive Hospital Cover</a>
				<a href="javascript:;" class="btn btn-form-inverse benefit-category visible-xs" data-category="customise">Switch to Comprehensive Hospital Cover</a>
			</div>
			<div class="hidden-xs col-sm-2 col-lg-3"></div>
		</div>
	</div>
</c:set>

<c:if test="${item.isShortlistable()}">

	<%-- Get the correct cell width for sections v. categories --%>
	<c:choose>
		<c:when test="${item.getType() == 'section'}">
			<c:choose>
				<c:when test="${item.getClassName() == 'hospitalCover'}">
					<c:set var="colContent">Hospital cover gives you the power to choose your own doctor at any one of the fund's partner hospitals allowing you avoid public hospital waiting lists.</c:set>
					<c:set var="coverType">Hospital</c:set>
					<%-- Hospital needs to loop one more time because the first child of hospital is not shortListAable --%>
					<c:set var="loopCount" value="5" />
				</c:when>
				<c:otherwise>
					<c:set var="colContent">Extras cover gives you money back for day to day services like dental, optical and physiotherapy.</c:set>
					<c:set var="coverType">Extras</c:set>
					<c:set var="loopCount" value="4" />
				</c:otherwise>
			</c:choose>
		</c:when>
		<c:otherwise>
			<c:set var="colWidthValue" value="categoriesCell" />
		</c:otherwise>
	</c:choose>

    <c:if test="${callCentre}">
    	<c:set var="colContent" value="" />
    </c:if>

	<c:if test="${coverType == 'Hospital'}">
	<form_v2:fieldset legend="" postLegend="" className="tieredHospitalCover hidden-sm hidden-md hidden-lg" >
		<div class="title">
			<h2 class="ignore">Choose Your Hospital Cover</h2>
			<div class="hospitalCoverToggles visible-xs">${altJourneyCustomiseBtn}</div>
			<p>${colContent}</p>
		</div>
		<div class="Hospital-wrapper">
			<div class="Hospital_container">
				<div class="hospitalCoverToggles visible-xs">
					<div class="btn-group btn-group-justified btn-group-wrap">
						<a href="javascript:;" class="btn btn-form-inverse benefit-category" data-category="basic">Basic</a>
						<a href="javascript:;" class="btn btn-form-inverse benefit-category" data-category="medium">Medium</a>
						<a href="javascript:;" class="btn btn-form-inverse benefit-category" data-category="top">Top</a>
					</div>
					<div class="nonComprehensiveCover">
						or
						<a href="javascript:;" class="btn btn-form-inverse benefit-category" data-category="customise">Customise your cover</a>
						<a href="javascript:;" class="benefit-category limited" data-category="limited">No thanks, I only want limited hospital cover</a>
					</div>
					${altJourneyLimitedBtn}
				</div>
			</div>
		</div>
	</form_v2:fieldset>
	</c:if>
	<c:set var="fieldsetClass">tieredHospitalCover</c:set>
	<form_v2:fieldset legend="" postLegend="" className="${fieldsetClass}" >
		<%-- TODO in part 2 --%>
		<%--<div class="switch-wrapper right">Switch ${coverType} cover <field_v2:switch xpath="health/benefits/benefitsExtras/${coverType}" value="Y" className="switch-small" onText="On" offText="Off" /></div>--%>
		<div class="scrollable row">
			<div class="benefits-list col-sm-12">
				<div class="row">
					<div class="${colWidthValue} short-list-item ${item.getClassString()} ${item.getShortlistKey()}_container">
						<c:set var="category">${item.getShortlistKey()}</c:set>
						<div class="title <c:if test="${category eq 'Hospital'}">hidden-xs</c:if>">
							<h2 class="ignore">Choose Your ${item.getName()}</h2>
							<c:if test="${category eq 'Hospital'}">
								<div class="hospitalCoverToggles hidden-xs">${altJourneyCustomiseBtn}</div>
							</c:if>
							<p class="hidden-xs">${colContent}</p>
							<c:if test="${item.getName() eq 'Extras Cover'}">
								<p><strong>Select the benefits below to add extras specific to your needs</strong></p>
							</c:if>
						</div>
						<div class="${category}-wrapper">

						<c:choose>
							<c:when test="${item.getType() == 'section'}">

								<c:if test="${category eq 'Hospital'}">
									<div class="hospitalCoverToggles row hidden-xs">
	                                    <c:if test="${!callCentre}">
										<div class="grouping-header">Comprehensive Cover</div>
										<div class="grouping-border"></div>
	                                    <a href="javascript:;" class="btn btn-save benefit-category col-sm-2" data-category="top" <field_v1:analytics_attr analVal="benefit category" quoteChar="\"" />>top</a>
	                                    <a href="javascript:;" class="btn btn-save benefit-category col-sm-2" data-category="medium" <field_v1:analytics_attr analVal="benefit category" quoteChar="\"" />>medium</a>
	                                    <a href="javascript:;" class="btn btn-save benefit-category col-sm-2" data-category="basic" <field_v1:analytics_attr analVal="benefit category" quoteChar="\"" />>basic</a>
	                                    </c:if>
	                                    <a href="javascript:;" class="btn btn-save benefit-category col-sm-2" data-category="customise" <field_v1:analytics_attr analVal="custom cover" quoteChar="\"" />>customise</a>
	                                    <a href="javascript:;" class="btn btn-save benefit-category col-sm-2" data-category="limited" <field_v1:analytics_attr analVal="benefit category" quoteChar="\"" />>limited</a>
										${altJourneyLimitedBtn}
	                                </div>


                                    <div class="coverExplanationContainer">
                                    <c:set var="tieredBenefits" value='${contentService.getContentWithSupplementary(pageContext.getRequest(), "coverOptions")}' />
                                    <c:forEach items="${tieredBenefits.getSupplementary()}" var="tieredBenefitsContent" >

										<c:if test="${!fn:endsWith(tieredBenefitsContent.getSupplementaryKey(), 'XS')}">
											<div class="<c:if test="${tieredBenefitsContent.getSupplementaryKey() != 'midCover'}">hidden</c:if> coverExplanation ${tieredBenefitsContent.getSupplementaryKey()}">

											<c:if test="${!callCentre}">
												<div class="hidden-xs">${tieredBenefitsContent.getSupplementaryValue()}</div>
												<c:set var="xsLabel" value="${tieredBenefitsContent.getSupplementaryKey()}XS" />
												<c:forEach items="${tieredBenefits.getSupplementary()}" var="tieredBenefitsContentXS" >
													<c:if test="${tieredBenefitsContentXS.getSupplementaryKey() eq xsLabel}">
														<div class="visible-xs">${tieredBenefitsContentXS.getSupplementaryValue()}</div>
													</c:if>
												</c:forEach>
											</c:if>

											<c:if test="${tieredBenefitsContent.getSupplementaryKey() == 'limitedCover'}">
									            <simples:dialogue id="67" className="simples-dialogue-limited-cover" vertical="health" />
									        </c:if>

											</div>
		                                </c:if>

                                    </c:forEach>
                                    </div>
                                </c:if>
                            </c:when>
                            <c:otherwise>
								<c:set var="resultPath" value="${item.getResultPath()}" />
								<c:set var="benefitGroup">
									<c:choose>
										<c:when test="${not empty resultPath and fn:startsWith(resultPath,'hospital')}">hospital</c:when>
										<c:when test="${not empty resultPath and fn:startsWith(resultPath,'extras')}">extras</c:when>
									</c:choose>
								</c:set>
								<c:set var="analyticsLabelAttr"><field_v1:analytics_attr analVal="benefit ${benefitGroup}" quoteChar="\"" /></c:set>
								<c:set var="analyticsHelpAttr"><field_v1:analytics_attr analVal="qtip ${item.getShortlistKey()}" quoteChar="\"" /></c:set>
								<field_v2:checkbox xpath="${pageSettings.getVerticalCode()}/benefits/benefitsExtras/${item.getShortlistKey()}" value="Y" required="false" label="true" title="${item.getName()}" helpId="${item.getHelpId()}" errorMsg="Please tick" additionalLabelAttributes="${analyticsLabelAttr}" additionalHelpAttributes="${analyticsHelpAttr}"/>
                            </c:otherwise>
                        </c:choose>

                        <c:if test="${item.hasShortlistableChildren()}">
                            <div class="children healthBenefits">
								<c:if test="${category != 'Hospital'}">
									<div class="grouping-header fourIconWidth hidden-xs">Dental Services</div>
									<div class="grouping-header twoIconWidth hidden-xs">Eye Care</div>
									<div class="grouping-header twoIconWidth hidden-xs">Foot Care</div>
									<div class="grouping-border fourIconWidth hidden-xs"></div>
									<div class="grouping-border twoIconWidth hidden-xs"></div>
									<div class="grouping-border twoIconWidth hidden-xs"></div>
									<core_v1:js_template id="extras-mid-row-groupings">
									<div class="grouping-header fourIconWidth hidden-xs">Clinical Therapies</div>
									<div class="grouping-header fourIconWidth hidden-xs">Natural Therapies</div>
									<div class="grouping-border fourIconWidth hidden-xs"></div>
									<div class="grouping-border fourIconWidth hidden-xs"></div>
									</core_v1:js_template>
									<core_v1:js_template id="extras-last-row-groupings">
									<div class="grouping-header twoIconWidth lastRow hidden-xs">Health Aids</div>
									<div class="grouping-border twoIconWidth lastRow hidden-xs"></div>
									</core_v1:js_template>
								</c:if>
								<div class="hasIcons">
                                <c:forEach items="${item.getChildren()}" var="selectedValue">
									<c:if test="${selectedValue.isShortlistable()}">

										<%--<health_v3:benefitsItem item="${selectedValue}" />--%>
										<div class="categoriesCell ${colWidthValue} short-list-item ${selectedValue.getClassString()} ${selectedValue.getShortlistKey()}_container">
										<c:set var="resultPath" value="${selectedValue.getResultPath()}" />
										<c:set var="benefitGroup">
											<c:choose>
												<c:when test="${not empty resultPath and fn:startsWith(resultPath,'hospital')}">hospital</c:when>
												<c:when test="${not empty resultPath and fn:startsWith(resultPath,'extras')}">extras</c:when>
											</c:choose>
										</c:set>
										<c:set var="analyticsLabelAttr"><field_v1:analytics_attr analVal="benefit ${benefitGroup}" quoteChar="\"" /></c:set>
										<c:set var="analyticsHelpAttr"><field_v1:analytics_attr analVal="qtip ${selectedValue.getShortlistKey()}" quoteChar="\"" /></c:set>

										<%-- This is a duplicate of the row above and needs to be cleaned up in the .less--%>
										<field_v2:checkbox xpath="${pageSettings.getVerticalCode()}/benefits/benefitsExtras/${selectedValue.getShortlistKey()}" value="Y" required="false" label="true" title="${selectedValue.getName()}" helpId="${selectedValue.getHelpId()}" errorMsg="Please tick" customAttribute=" data-attach='true' "  additionalLabelAttributes="${analyticsLabelAttr}" additionalHelpAttributes="${analyticsHelpAttr}" />
										</div>
									</c:if>
								</c:forEach>
								</div>
							</div>
						</c:if>
						</div>
					</div>
				</div>
			</div>
		</div>
		<%-- TODO Enable in part 2 --%>
		<%--<div class="situation-wrapper"></div>--%>
	</form_v2:fieldset>

	<c:if test="${coverType == 'Hospital'}">
		<simples:dialogue id="50" className="simples-dialogue-extras-cover" vertical="health" />
		<simples:dialogue id="119" className="simples-dialogue-extras-cover simples-dialog-nextgenoutbound" vertical="health" />
		<simples:dialogue id="82" className="simples-dialogue-extras-cover" vertical="health" />
	</c:if>
</c:if>