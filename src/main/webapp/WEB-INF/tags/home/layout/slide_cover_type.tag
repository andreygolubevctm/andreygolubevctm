<%@ tag description="Journey slide - Cover Type" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<c:set var="xpath" value="${pageSettings.getVerticalCode()}" />

<layout_v1:slide formId="startForm" firstSlide="true" nextLabel="Next Step">

	<layout_v1:slide_columns sideHidden="false">

		<jsp:attribute name="rightColumn">
			<home:snapshot />
		</jsp:attribute>

		<jsp:body>

			<layout_v1:slide_content>
				<%-- PROVIDER TESTING --%>
				<agg_v1:provider_testing xpath="${xpath}" displayFullWidth="true" keyLabel="authToken" filterProperty="providerList" hideSelector="${false}" />

				<form_v2:fieldset legend="Cover for your property">

					<div class="notLandlord">
							<%-- Own the home --%>
						<c:set var="fieldXpath" value="${xpath}/occupancy/ownProperty" />
						<c:set var="analyticsAttr"><field_v1:analytics_attr analVal="Own or Rent" quoteChar="\"" /></c:set>
						<form_v2:row fieldXpath="${fieldXpath}" label="Are you the home owner or are you renting?">
							<field_v2:array_radio xpath="${fieldXpath}"
												  className="ownProperty radioIcons"
												  required="true"
												  items="Y=Home Owner,N=Renting"
												  title="if you own the home"
												  additionalLabelAttributes="${analyticsAttr}" />
						</form_v2:row>

							<%-- Cover type --%>
						<c:set var="fieldXpath" value="${xpath}/coverType" />
						<c:set var="analyticsAttr"><field_v1:analytics_attr analVal="Cover Type" quoteChar="\"" /></c:set>
						<form_v2:row fieldXpath="${fieldXpath}" label="Type of cover">
							<field_v2:import_select xpath="${fieldXpath}"
													required="true"
													title="the type of cover"
													url="/WEB-INF/option_data/home_contents_cover_type.html"
													additionalAttributes="${analyticsAttr}" />
						</form_v2:row>
					</div>

						<div class="isLandlord">
							<%-- Are you the landlord --%>
							<c:set var="fieldXpath" value="${xpath}/occupancy/ownProperty" />
							<c:set var="analyticsAttr"><field_v1:analytics_attr analVal="Landlord or Occupant"
																										quoteChar="\"" /></c:set>
							<form_v2:row fieldXpath="${fieldXpath}" label="Are you the landlord or the occupant?">
								<field_v2:array_radio xpath="${fieldXpath}"
									className="ownProperty radioIcons"
									required="true"
									items="Y=Landlord,N=Tenant"
									title="if you are the landlord"
									additionalLabelAttributes="${analyticsAttr}" />
							</form_v2:row>

                                    <%-- Cover type --%>
                            <c:set var="fieldXpath" value="${xpath}/coverType" />
                            <c:set var="analyticsAttr"><field_v1:analytics_attr analVal="Cover Type" quoteChar="\"" /></c:set>
                            <form_v2:row fieldXpath="${fieldXpath}" label="Type of cover">
                                <field_v2:import_select xpath="${fieldXpath}"
                                    required="true"
                                    title="the type of cover"
                                    url="/WEB-INF/option_data/landlord_cover_type.html"
                                    additionalAttributes="${analyticsAttr}" />
                                </form_v2:row>
						</div>


				</form_v2:fieldset>

			</layout_v1:slide_content>

		</jsp:body>

	</layout_v1:slide_columns>

</layout_v1:slide>
