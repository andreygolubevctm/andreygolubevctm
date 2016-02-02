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

		<form_v2:fieldset legend="Choose which benefits are important to you" postLegend="Knowing what's important to you will help us display policies relevant to your needs" >

			<div class="scrollable row">

				<div class="benefits-list col-sm-12">
					<c:set var="fieldXpath" value="${xpath}/coverType" />
					<form_v3:row label="What type of cover are you looking for?" fieldXpath="${fieldXpath}">
						<field_v2:general_select xpath="${fieldXpath}" type="healthCvrType" className="health-situation-healthCvrType" required="true" title="your cover type" />
					</form_v3:row>
					
					<div class="row">
						<%-- Note: ${resultTemplateItems} is a request scoped variable on health_quote.jsp page - as it is used in multiple places --%>
						<c:forEach items="${resultTemplateItems}" var="selectedValue">
							<health_v2:benefitsItem item="${selectedValue}" />
						</c:forEach>

						<c:if test="${not empty callCentre or splitTestService.isActive(pageContext.getRequest(), data.current.transactionId, 12)}">
							<div class="col-sm-12 short-list-item section expandable collapsed accidentCover">
								<div class="children">
									<h3 class="subTitle">Accident-only Cover</h3>
									<div class="noIcons">
										<div class="categoriesCell short-list-item category expandable collapsed">
											<c:set var="fieldXpath" value="${xpath}/accidentOnlyCover" />
											<field_v2:checkbox xpath="${fieldXpath}" required="false" title="Accident-only Cover" value="Y" label="true" />
											<br>
										</div>
									</div>
								</div>
							</div>
						</c:if>
					</div>
				</div>

			</div>

		</form_v2:fieldset>

	</jsp:body>

	</form_v2:fieldset_columns>

