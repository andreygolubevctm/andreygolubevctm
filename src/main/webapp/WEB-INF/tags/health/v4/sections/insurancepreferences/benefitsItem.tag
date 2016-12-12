<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%@ attribute name="item" required="true" type="com.ctm.web.core.results.model.ResultsTemplateItem" %>
<c:set var="logger" value="${log:getLogger('jsp.ajax.json.benefits')}" />

<c:if test="${item.isShortlistable()}">

	<c:set var="benefitsContent" value='${contentService.getContentWithSupplementary(pageContext.getRequest(), "healthbenefits2017")}' />

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

	<c:set var="fieldsetClass">tieredHospitalCover</c:set>
	<c:set var="category">Extras</c:set>
	<c:if test="${item.getShortlistKey() eq 'Hospital'}"><c:set var="category">Hospital</c:set></c:if>
	<form_v2:fieldset legend="" postLegend="" className="${fieldsetClass}" >
		<div class="scrollable row">
			<div class="benefits-list col-sm-12">
				<div class="row">
					<c:set var="overlayName">hospital</c:set>
					<c:if test="${category != 'Hospital'}"><c:set var="overlayName">extras</c:set></c:if>
					<div class="${overlayName}Overlay">
						<div class="selectionStatus ${overlayName}">
							Your ${overlayName} benefits selection
						<span>0</span></div>
					</div>
					<div class="${colWidthValue} short-list-item ${item.getClassString()} ${item.getShortlistKey()}_container">
						<%-- ======================= --%>
						<%-- HEADING SECTION START --%>
						<%-- ======================= --%>

						<c:if test="${category != 'Hospital'}">
							<div class="title <c:if test="${category eq 'Hospital'}">hidden-xs</c:if>">
								<h2 class="ignore">${category}</h2>
								<p class="hidden-xs">${colContent}</p>
								<health_v4_insuranceprefs:quick_select options="Dental:dental|Sports:sports|Prace of Mind:peace" />
							</div>
						</c:if>
						<c:if test="${category eq 'Hospital'}">
							<div class="title hidden-xs">
								<h2 class="ignore">Hospital</h2>
							</div>
						<div id="tabs">
							<ul class="nav nav-tabs tab-count-2">
								<li><a href="javascript:;" data-target=".comprehensive-pane"><h2 class="ignore">Comprehensive</h2></a></li>
								<li><a href="javascript:;" data-target=".limited-pane"><h2 class="ignore">Limited Cover</h2></a></li>
							</ul>
							<health_v4_insuranceprefs:quick_select options="Start a Family:family|Ageing Gracefully:aging" />
							<div class="tab-content">
								<div class="tab-pane comprehensive-pane">
						</c:if>

						<%-- ======================= --%>
						<%-- HEADING SECTION END --%>
						<%-- ======================= --%>
						<div class="${category}-wrapper">

						<c:choose>
							<c:when test="${item.getType() == 'section'}">
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

						<%-- ======================= --%>
						<%-- ACTUAL BENEFITS SECTION START --%>
						<%-- ======================= --%>
                        <c:if test="${item.hasShortlistableChildren()}">
									<div class="children healthBenefits">
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
												<c:set var="benefitLabel">
													<span class="benefitContent">
														<div class="benefitTitle">${selectedValue.getName()}</div>
														<span class="benefitSummary">hasf jkldfhas kljd hasklj fhasjkld  <a href="javascript:;" class="help_icon floatLeft" id="help_${selectedValue.getHelpId()}">more</a></span>
													</span>
												</c:set>
												<field_v2:checkbox xpath="${pageSettings.getVerticalCode()}/benefits/benefitsExtras/${selectedValue.getShortlistKey()}" value="Y" required="false" label="true" title="${benefitLabel}" errorMsg="Please tick" customAttribute="data-attach=true data-benefit-id='${selectedValue.getId()}'"  additionalLabelAttributes="${analyticsLabelAttr}" additionalHelpAttributes="${analyticsHelpAttr}" />
												</div>
											</c:if>
										</c:forEach>
										</div>
									</div>

							<c:if test="${category eq 'Hospital'}">
									</div>
								</div>
								<div class="tab-pane limited-pane">
										${benefitsContent.getSupplementaryValueByKey('limitedText')}
								</div>
							</div>
							</c:if>
						</c:if>
						<%-- ======================= --%>
						<%-- ACTUAL BENEFITS SECTION END --%>
						<%-- ======================= --%>
						</div>
					</div>
				</div>
			</div>
		</div>
	</form_v2:fieldset>

	<c:choose>
        <c:when test="${coverType == 'Hospital'}">
            <simples:dialogue id="45" className="simples-dialogue-hospital-cover" vertical="health" />
            <simples:dialogue id="50" className="simples-dialogue-extras-cover" vertical="health" />
        </c:when>
        <c:otherwise>
            <simples:dialogue id="51" className="simples-dialogue-extras-cover" vertical="health" />
        </c:otherwise>
    </c:choose>
</c:if>