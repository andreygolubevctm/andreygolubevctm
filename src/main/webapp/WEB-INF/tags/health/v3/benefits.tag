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

		<form_v2:fieldset legend="Choose Your Cover" postLegend="" >

			<div class="scrollable row">

				<div class="benefits-list col-sm-12">
					<c:set var="fieldXPath" value="${xpath}/coverType" />
					<%-- <form_v2:row label="What type of cover are you looking for?" fieldXpath="${fieldXpath}">
						<field_v2:general_select xpath="${fieldXpath}" type="healthCvrType" className="health-situation-healthCvrType" required="true" title="your cover type" />
					</form_v2:row> --%>

						<%-- Taken this from the general_select. I don't like it. Please explain. :D--%>
                        <sql:setDataSource dataSource="${datasource:getDataSource()}"/>
                        <sql:query var="result">
                            SELECT code, description FROM aggregator.general WHERE type = 'healthCvrType' AND (status IS NULL OR status != 0) ORDER BY orderSeq
                        </sql:query>

                        <c:set var="sep"></c:set>
                        <c:set var="items">
							<c:forEach var="row" items="${result.rows}">
								${sep}${row.code}=${row.description}
								<c:set var="sep">,</c:set>
							</c:forEach>
                        </c:set>

                        <form_v3:row label="What type of cover are you looking for?" fieldXpath="${fieldXPath}">
                            <field_v2:array_radio xpath="${fieldXPath}"
                                                  required="true"
                                                  className="health-situation-healthCvrType roundedCheckboxIcons"
                                                  items="${items}"
                                                  id="${go:nameFromXpath(fieldXPath)}"
                                                  title="your cover type" />
                        </form_v3:row>
				</div>
			</div>
		</form_v2:fieldset>
		<%--<form_v2:fieldset legend="" postLegend="" >--%>

							<%-- Note: ${resultTemplateItems} is a request scoped variable on health_quote.jsp page - as it is used in multiple places --%>
						<c:forEach items="${resultTemplateItems}" var="selectedValue">
							<health_v3:benefitsItem item="${selectedValue}" />
						</c:forEach>

									<%--<c:if test="${not empty callCentre or splitTestService.isActive(pageContext.getRequest(), data.current.transactionId, 12)}">--%>
							<%--<div class="col-sm-12 short-list-item section expandable collapsed accidentCover">--%>
								<%--<div class="children">--%>
									<%--<h3 class="subTitle">Accident-only Cover</h3>--%>
									<%--<div class="noIcons">--%>
										<%--<div class="categoriesCell short-list-item category expandable collapsed">--%>
											<%--<c:set var="fieldXpath" value="${xpath}/accidentOnlyCover" />--%>
											<%--<field_v2:checkbox xpath="${fieldXpath}" required="false" title="Accident-only Cover" value="Y" label="true" />--%>
											<%--<br>--%>
										<%--</div>--%>
									<%--</div>--%>
								<%--</div>--%>
							<%--</div>--%>
									<%--</c:if>--%>


		<%--</form_v2:fieldset>--%>

	</jsp:body>

	</form_v2:fieldset_columns>

