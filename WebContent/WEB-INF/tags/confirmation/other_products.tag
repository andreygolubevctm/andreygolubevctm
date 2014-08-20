<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ tag description="Other Products Renderer"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<%-- HTML --%>
<fieldset id="confirmation-compare-options">

	<c:set var="currentVertical" value="${pageSettings.getVerticalCode()}"/>

	<%-- To add another product, just add another item to the list and
		remember to add a new class and update the sprite sheet
		in framework\modules\less\core\relatedProducts.less --%>

	<%-- Ideally this would come from a database or config/settings to identify all verticals enabled for current brand. --%>
	<c:set var="brand" value="${applicationService.getBrandFromRequest(pageContext.getRequest())}" />

	<c:set var="products"
		value="${fn:split('car,fuel,health,home,ip,life,homeloan,roadside,travel,utilities',',')}" />
	<c:set var="fragments"
		value="${fn:split('car,fuel,health,home-contents,ip,life,home-loans,roadside,travel,energy',',')}" />
	<c:set var="titles"
		value="${fn:split('Car Insurance,Fuel,Health Insurance,Home & Contents,Income Protection,Life Insurance,Home Loans,Roadside,Travel Insurance,Energy',',')}" />

	<div class="options-list clearfix">
	<c:forEach items="${brand.getVerticals()}" var="vertical" varStatus="loop">
		<c:set var="verticalSettings" value="${settingsService.getPageSettings(pageSettings.getBrandId(), fn:toUpperCase(vertical.getCode()))}" scope="page"  />

		<c:if test="${verticalSettings.getSetting('displayOption') eq 'Y' and currentVertical ne fn:toLowerCase(vertical.getCode())}">

			<c:set var="titleParts" value="${fn:split(vertical.getName(), ' ')}" />
			<c:set var="title2" value="${titleParts[1]}" />
			<c:set var="title3" value="${titleParts[2]}" />
			<c:if test="${empty title2 }">
				<c:set var="title2" value="&nbsp;" />
			</c:if>
			<c:if test="${not empty title2 and not empty title3 }">
				<c:set var="title2" value="${title2} ${title3}" />
			</c:if>
			<div class="col-lg-3 col-sm-4 col-xs-6">
				<a href="${verticalSettings.getSetting('exitUrl')}"
					title="${titles[loop.index]}">
					<div class="icon icon-${fn:toLowerCase(vertical.getCode())}"></div>${titleParts[0]}<span>${title2}</span>
				</a>
			</div>
		</c:if>
	</c:forEach>
	</div>

</fieldset>