<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Benefits group"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" 		required="true"	 rtexprvalue="true"	 description="field group's xpath" %>


<%-- HTML --%>


	<form_v2:fieldset_columns sideHidden="true">

	<jsp:attribute name="rightColumn">
		<health_v2_content:sidebar />
	</jsp:attribute>

	<jsp:body>

		<form_v2:fieldset legend="" postLegend="" >

			<div class="scrollable row">

				<div class="benefits-list col-sm-12">
					<c:set var="fieldXpath" value="${xpath}/coverType" />
					<form_v2:row label="What type of cover are you looking for?" fieldXpath="${fieldXpath}">
						<field_v2:general_select xpath="${fieldXpath}" type="healthCvrType" className="health-situation-healthCvrType" required="true" title="your cover type" />
					</form_v2:row>
					
					<div class="row">
						<%-- Note: ${resultTemplateItems} is a request scoped variable on health_quote.jsp page - as it is used in multiple places --%>
						<c:forEach items="${resultTemplateItems}" var="selectedValue">
							<health_v2:benefitsItem item="${selectedValue}" />
						</c:forEach>
					</div>
				</div>

				<div class="col-sm-12">
					<h4>Accident-only Cover</h4>
					<c:set var="fieldXpath" value="${xpath}/accidentOnlyCover" />
					<form_v2:row >
						<field_v2:checkbox xpath="${fieldXpath}" required="false" title="Accident-only Cover" value="Y" label="true" />
					</form_v2:row>
				</div>

			</div>

		</form_v2:fieldset>

	</jsp:body>

	</form_v2:fieldset_columns>

