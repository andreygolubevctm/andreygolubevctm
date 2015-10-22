<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%@ attribute name="item" required="true" type="com.ctm.model.results.ResultsTemplateItem" %>


<c:if test="${item.isShortlistable()}">

	<%-- Get the correct cell width for sections v. categories --%>
	<c:choose>
		<c:when test="${item.getType() == 'section'}">
			<c:set var="colWidthValue" value="col-sm-6" />
		</c:when>
		<c:otherwise>
			<c:set var="colWidthValue" value="categoriesCell" />
		</c:otherwise>
	</c:choose>

	<div class="${colWidthValue} short-list-item ${item.getClassString()}">

		<c:choose>
			<c:when test="${item.getType() == 'section'}">
				<div class="title">
					<h3>${item.getName()}</h3>
					<field_new:switch xpath="${pageSettings.getVerticalCode()}/benefits/benefitsExtras/${item.getShortlistKey()}" value="Y" className="switch-small ${item.hasShortlistableChildren() ? 'hasChildren' : ''}" onText="&nbsp;YES" offText="NO" />
				</div>
			</c:when>
			<c:otherwise>
				<field_new:checkbox id="${item.getShortlistKey()}" label="true" xpath="${pageSettings.getVerticalCode()}/benefits/benefitsExtras/${item.getShortlistKey()}" value="Y" required="false" title="${item.getName()}" helpId="${item.getHelpId()}" helpClassName="benefitsHelpTooltips" />
			</c:otherwise>
		</c:choose>

		<c:if test="${item.hasShortlistableChildren()}">
			<div class="children">
				<c:forEach items="${item.getChildren()}" var="selectedValue">
					<health:benefitsItem item="${selectedValue}" />
				</c:forEach>
			</div>
		</c:if>

	</div>

</c:if>