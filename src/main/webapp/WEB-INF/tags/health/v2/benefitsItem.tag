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
					<c:set var="colWidthValue" value="custom-col-sm" />
					<c:set var="colContent">Hospital cover gives you the power to choose your own doctor at any one of the fund's partner hospitals allowing you avoid public hospital waiting lists.</c:set>
					<c:set var="coverType">Hospital</c:set>
					<%-- Hospital needs to loop one more time because the first child of hospital is not shortListAable --%>
					<c:set var="loopCount" value="5" />
				</c:when>
				<c:otherwise>
					<c:set var="colWidthValue" value="custom-col-lg" />
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

	<div class="${colWidthValue} short-list-item ${item.getClassString()} ${item.getShortlistKey()}_container">

		<c:choose>
			<c:when test="${item.getType() == 'section'}">
				<div class="title">
					<h4>${item.getName()}</h4>
					<p>${colContent}</p>
				</div>
			</c:when>
			<c:otherwise>
				<field_v2:checkbox xpath="${pageSettings.getVerticalCode()}/benefits/benefitsExtras/${item.getShortlistKey()}" value="Y" required="false" label="true" title="${item.getName()}" helpId="${item.getHelpId()}" errorMsg="Please tick" />
			</c:otherwise>
		</c:choose>

		<c:if test="${item.hasShortlistableChildren()}">
			<div class="children healthBenefits">
				<h3 class="subTitle">More ${coverType} Benefits</h3>
				<c:forEach items="${item.getChildren()}" var="selectedValue">
					<health_v2:benefitsItem item="${selectedValue}" />
				</c:forEach>
				<div class="categoriesCell category CTM-plus">
					<div class="checkbox">
						<input type="hidden" name="CTM_plus" class="checkbox" />
						<label>View more benefits</label>
					</div>
				</div>
			</div>
		</c:if>

	</div>

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