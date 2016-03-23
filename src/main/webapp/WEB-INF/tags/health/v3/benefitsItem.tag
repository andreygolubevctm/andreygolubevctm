<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%@ attribute name="item" required="true" type="com.ctm.web.core.results.model.ResultsTemplateItem" %>
<c:set var="logger" value="${log:getLogger('jsp.ajax.json.benefits')}" />

${logger.warn('Item. {}',log:kv('item',item.getName() ), error)}
<c:if test="${item.isShortlistable()}">

	<%-- Get the correct cell width for sections v. categories --%>
	<c:choose>
		<c:when test="${item.getType() == 'section'}">
			<c:choose>
				<c:when test="${item.getClassName() == 'hospitalCover'}">
					<%--<c:set var="colWidthValue" value="custom-col-sm" />--%>
					<c:set var="colContent">Hospital cover gives you the power to choose amongst a fund's participating hospitals, choose your own doctor and help you avoid public hospital waiting lists.</c:set>
					<c:set var="coverType">Hospital</c:set>
					<%-- Hospital needs to loop one more time because the first child of hospital is not shortListAable --%>
					<c:set var="loopCount" value="5" />
				</c:when>
				<c:otherwise>
					<%--<c:set var="colWidthValue" value="custom-col-lg" />--%>
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

	<c:if test="${coverType == 'Hospital'}">
	<form_v2:fieldset legend="" postLegend="" className="tieredHospitalCover hidden-sm hidden-md hidden-lg" >
		<div class="title">
			<h3>Choose Your Hospital Cover</h3>
			<p>${colContent}</p>
		</div>
		<div class="Hospital_container">
			<div class="hospitalCoverToggles visible-xs">
				<div class="btn-group btn-group-justified btn-group-wrap">
					<a href="javascript:;" class="btn btn-form-inverse benefit-category" data-category="basic">Basic</a>
					<a href="javascript:;" class="btn btn-form-inverse benefit-category" data-category="medium">Medium</a>
					<a href="javascript:;" class="btn btn-form-inverse benefit-category" data-category="top">Top</a>
				</div>
				<div class="nonComprehensiveCover">
					or
					<a href="javascript:;" class="btn btn-form-inverse benefit-category" data-category="customised">Customise your cover</a>
					<a href="javascript:;" class="benefit-category limited" data-category="limited">No thanks, I only want limited hospital cover</a>
				</div>
			</div>
		</div>
	</form_v2:fieldset>
	</c:if>
	<form_v2:fieldset legend="" postLegend="" className="tieredHospitalCover">
		<div class="scrollable row">
			<div class="benefits-list col-sm-12">
				<div class="row">
					<div class="${colWidthValue} short-list-item ${item.getClassString()} ${item.getShortlistKey()}_container">
						<c:set var="category">${item.getShortlistKey()}</c:set>
						<c:choose>
							<c:when test="${item.getType() == 'section'}">
								<div class="title hidden-xs">
									<h3>Choose Your ${item.getName()}</h3>
									<p>${colContent}</p>
								</div>
								<c:if test="${category eq 'Hospital'}">
								<div class="hospitalCoverToggles row hidden-xs">
									<div class="grouping-header">Comprehensive Cover</div>
									<div class="grouping-border"></div>
                                    <a href="javascript:;" class="btn btn-save benefit-category col-sm-2" data-category="top">top</a>
                                    <a href="javascript:;" class="btn btn-save benefit-category col-sm-2" data-category="medium">medium</a>
                                    <a href="javascript:;" class="btn btn-save benefit-category col-sm-2" data-category="basic">basic</a>
                                    <a href="javascript:;" class="btn btn-save benefit-category col-sm-2" data-category="customised">customise</a>
                                    <a href="javascript:;" class="btn btn-save benefit-category col-sm-2" data-category="limited">limited</a>
                                </div>

                                    <div class="coverExplanationContainer">
                                    <c:set var="tieredBenefits" value='${contentService.getContentWithSupplementary(pageContext.getRequest(), "coverOptions")}' />
                                    <c:forEach items="${tieredBenefits.getSupplementary()}" var="tieredBenefitsContent" >
                                        <div class="<c:if test="${tieredBenefitsContent.getSupplementaryKey() != 'midCover'}">hidden</c:if> coverExplanation ${tieredBenefitsContent.getSupplementaryKey()}">
                                                ${tieredBenefitsContent.getSupplementaryValue()}
                                        </div>
                                    </c:forEach>
                                    </div>
                                    </c:if>
                                </c:when>
                                <c:otherwise>
                                    <field_v2:checkbox xpath="${pageSettings.getVerticalCode()}/benefits/benefitsExtras/${item.getShortlistKey()}" value="Y" required="false" label="true" title="${item.getName()}" helpId="${item.getHelpId()}" errorMsg="Please tick" />
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
											<!-- This is a duplicate of the row above and needs to be cleaned up in the .less-->
											<field_v2:checkbox xpath="${pageSettings.getVerticalCode()}/benefits/benefitsExtras/${selectedValue.getShortlistKey()}" value="Y" required="false" label="true" title="${selectedValue.getName()}" helpId="${selectedValue.getHelpId()}" errorMsg="Please tick" customAttribute="data-attach=true" />
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
	</form_v2:fieldset>

		<%-- Hospital/Extra only side bar --%>
		<c:if test="${item.getType() == 'section'}">
			<div class="custom-col-sm benefits-side-bar sidebar${coverType} section">
				<div class="sidebar-wrapper">
					<div class="title">
						<h4>Interested in ${coverType} cover?</h4>
						<p>${colContent}</p>
					</div>
					<c:if test="${item.hasShortlistableChildren()}">
						<ul class="top-5-benefits">
							<c:forEach items="${item.getChildren()}" var="selectedValue" end="${loopCount}">
								<c:if test="${selectedValue.isShortlistable()}">

									<li class="${selectedValue.getClassString()}">${selectedValue.getName()}
										<field_v2:help_icon helpId="${selectedValue.getHelpId()}" position="${helpPosition}" tooltipClassName="${helpClassName}" />
									</li>
								</c:if>
							</c:forEach>
						</ul>
					</c:if>
					<div class="footer">
						<a class="btn btn-edit" href="javascript:;">Add ${coverType} Cover</a>
					</div>
				</div>
			</div>
		</c:if>

</c:if>