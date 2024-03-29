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

		<simples:dialogue id="49" vertical="health" />
		<simples:dialogue id="117" vertical="health" className="simples-dialog-nextgenoutbound" />
		<simples:dialogue id="123" vertical="health" className="simples-dialog-nextgencli" />

		<form_v2:fieldset legend="Choose Your Cover" postLegend="">
			<field_v1:hidden xpath="${pageSettings.getVerticalCode()}/benefits/covertype" defaultValue="medium" />
			<div class="scrollable row">

				<div class="benefits-list col-sm-12">
					<c:set var="fieldXPath" value="${xpath}/coverType" />
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

	                    <c:set var="label" value="" />
	                    <c:if test="${not callCentre}">
	                        <c:set var="label" value="What type of cover are you looking for?" />
	                    </c:if>
					    <c:set var="analyticsAttr"><field_v1:analytics_attr analVal="cover type" quoteChar="\"" /></c:set>
	                    <form_v3:row label="${label}" fieldXpath="${fieldXpath}">
                            <field_v2:array_radio xpath="${fieldXPath}"
                                                  required="true"
                                                  className="health-situation-healthCvrType roundedCheckboxIcons"
                                                  items="${items}"
                                                  defaultValue="C"
                                                  id="${go:nameFromXpath(fieldXPath)}"
                                                  title="your cover type"
												  additionalLabelAttributes="${analyticsAttr}" />
                        </form_v3:row>
				</div>
			</div>
		</form_v2:fieldset>

		<simples:dialogue id="125" className="simples-dialogue-hospital-cover simples-dialog-inbound" vertical="health" />
		<simples:dialogue id="125" className="simples-dialogue-hospital-cover simples-dialog-outbound" vertical="health" />
		<simples:dialogue id="118" className="simples-dialogue-hospital-cover simples-dialog-nextgencli" vertical="health" />
		<simples:dialogue id="137" className="simples-dialogue-hospital-cover simples-dialog-nextgenoutbound" vertical="health" />
    <simples:dialogue id="81"  className="simples-dialogue-hospital-cover" vertical="health" />

    <simples:dialogue id="177" vertical="health" />

		<%-- TEMPLATES --%>
		<core_v1:js_template id="benefits-explanation">
			<content:get key="coverPopup" />
		</core_v1:js_template>

		<c:forEach items="${resultTemplateItems}" var="selectedValue">
			<health_v3:benefitsItem item="${selectedValue}" />
		</c:forEach>

		<core_v1:js_template id="customise-cover-template">
			<content:get key="customiseCoverTemplate"/>
		</core_v1:js_template>

		<c:set var="fieldsetClass">ambulanceAccidentCover</c:set>
		<form_v2:fieldset legend="" postLegend="" id="yourCover_${fieldsetClass}" className="${fieldsetClass}" >
			<div class="scrollable row">
				<div class="benefits-list col-sm-12">
					<div class="row">
						<div class="short-list-item ${fieldsetClass}_container">
						<div class="title">
							<h2 class="ignore">Has Your Customer Mentioned?</h2>
						</div>
						<div class="customer-mentioned-wrapper">
							<div class="children ${fieldsetClass}">
								<div class="hasIcons">
									<c:set var="resultPath" value="${pageSettings.getVerticalCode()}/${fieldsetClass}/" />
									<div class="categoriesCell short-list-item HLTicon-ambulance Ambulance_container ${fieldsetClass}">
										<field_v2:checkbox xpath="${resultPath}ambulance" value="Y" required="false" label="true" title="Ambulance" errorMsg="Please tick" />
									</div>
									<div class="categoriesCell short-list-item HLTicon-n-pain-management-no-device Accident_container ${fieldsetClass}">
										<field_v2:checkbox xpath="${resultPath}accident" value="Y" required="false" label="true" title="Accident" helpId="647" errorMsg="Please tick" />
									</div>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
		</form_v2:fieldset>

	</jsp:body>

	</form_v2:fieldset_columns>

