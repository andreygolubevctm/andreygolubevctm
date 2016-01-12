<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Benefits group"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" 		required="true"	 rtexprvalue="true"	 description="field group's xpath" %>


<%-- HTML --%>
<div id="${name}-selection" class="health-benefits">

	<form_new:fieldset_columns sideHidden="true">

	<jsp:attribute name="rightColumn">
		<health_new_content:sidebar />
	</jsp:attribute>

	<jsp:body>

		<form_new:fieldset legend="Choose which benefits are important to you" postLegend="Knowing what's important to you will help us display policies relevant to your needs" >

			<div class="scrollable row">

				<div class="benefits-list col-sm-12">
					<c:set var="fieldXpath" value="${xpath}/coverType" />
					<form_new:row label="What type of cover are you looking for?" fieldXpath="${fieldXpath}">
						<field_new:general_select xpath="${fieldXpath}" type="healthCvrType" className="health-situation-healthCvrType" required="true" title="your cover type" />
					</form_new:row>
					<div class="row">

						<%-- Note: ${resultTemplateItems} is a request scoped variable on health_quote.jsp page - as it is used in multiple places --%>
						<c:forEach items="${resultTemplateItems}" var="selectedValue">
							<health_new:benefitsItem item="${selectedValue}" />
						</c:forEach>
					</div>
				</div>

			</div>

		</form_new:fieldset>

	</jsp:body>

	</form_new:fieldset_columns>

</div>