<%@ tag description="The IP Journey's 'All About You' Slide" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<layout_v3:slide formId="startForm" firstSlide="true" nextLabel="Next Step">

	<layout_v3:slide_content >

		<form_v2:fieldset legend="Life Insurance Details" postLegend="">

			<c:set var="fieldLabel" value="Who is the cover for?" />
			<c:set var="fieldXPath" value="life/primary/insurance/partner" />
			<form_v3:row label="${fieldLabel}">
				<field_v2:array_radio xpath="${fieldXPath}" required="true" title="${fieldLabel}" items="N=Just for You,Y=You & your partner" defaultValue="N" />
			</form_v3:row>

			<c:set var="fieldLabel" value="Would you like to be covered for the same amount?" />
			<c:set var="fieldXPath" value="life/primary/insurance/samecover" />
			<form_v3:row label="${fieldLabel}">
				<field_v2:array_radio xpath="${fieldXPath}" required="true" title="if you would like to be covered for the same amount" items="Y=Same cover,N=Different cover" />
			</form_v3:row>

			<div class="primary">
				<c:set var="fieldLabel" value="Your Term Life Cover" />
				<c:set var="fieldXPath" value="life/primary/insurance/term" />
				<form_v3:row label="${fieldLabel}">
					<div class="input-group">
						<div class="input-group-addon">$</div>
						<field_v2:input type="number" xpath="${fieldXPath}" required="true" title="${fieldLabel}" />
					</div>
				</form_v3:row>

				<c:set var="fieldLabel" value="Total and Permanent Disability (TPD)" />
				<c:set var="fieldXPath" value="life/primary/insurance/tpd" />
				<form_v3:row label="${fieldLabel}">
					<div class="input-group">
						<div class="input-group-addon">$</div>
						<field_v2:input type="number" xpath="${fieldXPath}" required="true" title="${fieldLabel}" />
					</div>
				</form_v3:row>

				<c:set var="fieldLabel" value="Trauma Cover" />
				<c:set var="fieldXPath" value="life/primary/insurance/trauma" />
				<form_v3:row label="${fieldLabel}">
					<div class="input-group">
						<div class="input-group-addon">$</div>
						<field_v2:input type="number" xpath="${fieldXPath}" required="true" title="${fieldLabel}" />
					</div>
				</form_v3:row>
			</div>

			<div class="partner">
				<c:set var="fieldLabel" value="Your Partner's Term Life Cover" />
				<c:set var="fieldXPath" value="life/partner/insurance/term" />
				<form_v3:row label="${fieldLabel}">
					<div class="input-group">
						<div class="input-group-addon">$</div>
						<field_v2:input type="number" xpath="${fieldXPath}" required="true" title="${fieldLabel}" />
					</div>
				</form_v3:row>

				<c:set var="fieldLabel" value="Total and Permanent Disability (TPD)" />
				<c:set var="fieldXPath" value="life/partner/insurance/tpd" />
				<form_v3:row label="${fieldLabel}">
					<div class="input-group">
						<div class="input-group-addon">$</div>
						<field_v2:input type="number" xpath="${fieldXPath}" required="true" title="${fieldLabel}" />
					</div>
				</form_v3:row>

				<c:set var="fieldLabel" value="Trauma Cover" />
				<c:set var="fieldXPath" value="life/partner/insurance/trauma" />
				<form_v3:row label="${fieldLabel}">
					<div class="input-group">
						<div class="input-group-addon">$</div>
						<field_v2:input type="number" xpath="${fieldXPath}" required="true" title="${fieldLabel}" />
					</div>
				</form_v3:row>
			</div>

		</form_v2:fieldset>

	</layout_v3:slide_content>

</layout_v3:slide>