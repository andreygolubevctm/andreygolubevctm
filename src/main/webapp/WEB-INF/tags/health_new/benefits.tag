<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Benefits group"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" 		required="true"	 rtexprvalue="true"	 description="field group's xpath" %>


<%-- HTML --%>
<div id="${name}-selection" class="health-benefits benefits-component">

	<form_new:fieldset_columns sideHidden="true">

	<jsp:attribute name="rightColumn">
	</jsp:attribute>

	<jsp:body>

		<form_new:fieldset legend="Choose your benefits" >



			<div class="scrollable row">

				<div class="hidden-xs col-sm-12">
					<h4>Hospital Benefits</h4>
					<p>Hospital cover gives you the power to choose amongst a fund's participating hispitals, choose your own doctor and help you avoid public hospital waiting lists.</p>

				</div>

				<div class="hidden-xs col-sm-12">
					<h4>Extras Benefits</h4>
					<p>Extras cover gives you money back for day to day services like dental, optical and physiotherapy.</p>

				</div>

				<div class="benefits-list col-sm-12">
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