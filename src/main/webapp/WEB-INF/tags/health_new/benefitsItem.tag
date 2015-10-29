<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%@ attribute name="item" required="true" type="com.ctm.model.results.ResultsTemplateItem" %>
<c:set var="logger" value="${log:getLogger('jsp.ajax.json.benefits')}" />

${logger.warn('Item. {}',log:kv('item',item.getName() ), error)}
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

					<c:choose>
						<c:when test="${fn:contains(item.getName(), 'Hospital')}">
							<p>Hospital cover gives you the power to choose amongst a fund's participating hispitals, choose your own doctor and help you avoid public hospital waiting lists.</p>
						</c:when>
						<c:when test="${fn:contains(item.getName(), 'Extras')}">
							<p>Extras cover gives you money back for day to day services like dental, optical and physiotherapy.</p>
						</c:when>
					</c:choose>
				</div>
			</c:when>
			<c:otherwise>
				<field_new:checkbox xpath="${pageSettings.getVerticalCode()}/benefits/benefitsExtras/${item.getShortlistKey()}" value="Y" required="false" label="true" title="${item.getName()}" errorMsg="Please tick" helpId="${item.getHelpId()}" helpClassName="benefitsHelpTooltips" theme="v2"/>
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