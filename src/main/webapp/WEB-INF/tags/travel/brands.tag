<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ tag description="Brands Renderer"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>
<%@ attribute name="providerCodes" 	required="true" type="java.util.List" rtexprvalue="true"	 description="All the available provider codes for this vertical & brandCode combination" %>


<core:js_template id="brands-template">

	<%-- To add another brand, just add another item to the list and
		remember to add a new class in framework\modules\less\homeloan\logos.less --%>

	<div class="travel-brands-content">
		<h2><content:get key="modalHeading"/></h2>
		<p><content:get key="modalCopy"/></p>
	<c:forEach items="${providerCodes}" var="pc">
		<c:if test="${not empty pc}">
			<div class="col-sm-2">
				<div class="travelCompanyLogo logo_${pc}"></div>
			</div>
		</c:if>
	</c:forEach>
		<div class="col-sm-12 underwriters small"><content:get key="underwriters"/></div>
	</div>

</core:js_template>
