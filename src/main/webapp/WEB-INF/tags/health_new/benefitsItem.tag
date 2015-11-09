<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%@ attribute name="item" required="true" type="com.ctm.model.results.ResultsTemplateItem" %>
<c:set var="logger" value="${log:getLogger('jsp.ajax.json.benefits')}" />

${logger.warn('Item. {}',log:kv('item',item.getName() ), error)}
<c:if test="${item.isShortlistable()}">

	<%-- Get the correct cell width for sections v. categories --%>
	<c:choose>
		<c:when test="${item.getType() == 'section'}">
			<c:choose>
				<c:when test="${item.getClassName() == 'hospitalCover'}">
					<c:set var="colWidthValue" value="custom-col-sm" />
					<c:set var="colContent">Hospital cover gives you the power to choose amongst a fund's participating hospitals, choose your own doctor and help you avoid public hospital waiting lists.</c:set>
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

	<div class="${colWidthValue} short-list-item ${item.getClassString()}">

		<c:choose>
			<c:when test="${item.getType() == 'section'}">
				<div class="title">
					<h4>${item.getName()}</h4>
					<p>${colContent}</p>
				</div>
			</c:when>
			<c:otherwise>
				<field_new:checkbox xpath="${pageSettings.getVerticalCode()}/benefits/benefitsExtras/${item.getShortlistKey()}" value="Y" required="false" label="true" title="${item.getName()}" errorMsg="Please tick" />
			</c:otherwise>
		</c:choose>

		<c:if test="${item.hasShortlistableChildren()}">
			<div class="children">
				<h3 class="subTitle">More ${coverType} Benefits</h3>
				<c:forEach items="${item.getChildren()}" var="selectedValue">
					<health_new:benefitsItem item="${selectedValue}" />
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
								<li class="${selectedValue.getClassString()}">${selectedValue.getName()}</li>
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