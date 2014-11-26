<%@ tag description="Travel Single Signup Form"%>
<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>
<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" required="true" rtexprvalue="false" description="Parent xpath to hold individual items"%>
<%@ attribute name="xpathhidden" required="true" rtexprvalue="false" description="xpath to hold hidden item"%>

<%-- HTML --%>
<div class="row">
	<div class="col-xs-12 col-md-6">
		<div class="row">
			<div class="col-xs-6">
				<h5>Africa</h5>
					<field_new:checkbox xpath="${xpath}/af/af" value="af:af" label="true" title="Africa" required="false" className="destcheckbox"></field_new:checkbox>
				<h5>The Americas</h5>
					<field_new:checkbox xpath="${xpath}/am/us" value="am:us" label="true" title="USA" required="false" className="destcheckbox"></field_new:checkbox>
					<field_new:checkbox xpath="${xpath}/am/ca" value="am:ca" label="true" title="Canada" required="false" className="destcheckbox"></field_new:checkbox>
					<field_new:checkbox xpath="${xpath}/am/sa" value="am:sa" label="true" title="South America" required="false" className="destcheckbox"></field_new:checkbox>
			</div>
			<div class="col-xs-6">
				<h5>Asia</h5>
					<field_new:checkbox xpath="${xpath}/as/ch" value="as:ch" label="true" title="China" required="false" className="destcheckbox"></field_new:checkbox>
					<field_new:checkbox xpath="${xpath}/as/hk" value="as:hk" label="true" title="Hong Kong" required="false" className="destcheckbox"></field_new:checkbox>
					<field_new:checkbox xpath="${xpath}/as/jp" value="as:jp" label="true" title="Japan" required="false" className="destcheckbox"></field_new:checkbox>
					<field_new:checkbox xpath="${xpath}/as/in" value="as:in" label="true" title="India" required="false" className="destcheckbox"></field_new:checkbox>
					<field_new:checkbox xpath="${xpath}/as/th" value="as:th" label="true" title="Thailand" required="false" className="destcheckbox"></field_new:checkbox>
			</div>
		</div>
	</div>
	<div class="col-xs-12 col-md-6">
		<div class="row">
			<div class="col-xs-6">
				<h5>Oceania / Pacific</h5>
					<field_new:checkbox xpath="${xpath}/au/au" value="pa:au" label="true" title="Australia" required="false" className="destcheckbox"></field_new:checkbox>
					<field_new:checkbox xpath="${xpath}/pa/ba" value="pa:ba" label="true" title="Bali" required="false" className="destcheckbox"></field_new:checkbox>
					<field_new:checkbox xpath="${xpath}/pa/in" value="pa:in" label="true" title="Indonesia" required="false" className="destcheckbox"></field_new:checkbox>
					<field_new:checkbox xpath="${xpath}/pa/nz" value="pa:nz" label="true" title="New Zealand" required="false" className="destcheckbox"></field_new:checkbox>
					<field_new:checkbox xpath="${xpath}/pa/pi" value="pa:pi" label="true" title="Pacific Islands" required="false" className="destcheckbox"></field_new:checkbox>
			</div>
			<div class="col-xs-6">
				<h5>Europe</h5>
					<field_new:checkbox xpath="${xpath}/eu/eu" value="eu:eu" label="true" title="Europe" required="false" className="destcheckbox"></field_new:checkbox>
					<field_new:checkbox xpath="${xpath}/eu/uk" value="eu:uk" label="true" title="UK" required="false" className="destcheckbox"></field_new:checkbox>
				<h5>Middle East</h5>
					<field_new:checkbox xpath="${xpath}/me/me" value="me:me" label="true" title="Middle East" required="false" className="destcheckbox"></field_new:checkbox>
				<h5>Any other country</h5>
					<field_new:checkbox xpath="${xpath}/do/do" value="do:do" label="true" title="Any other country" required="false" className="destcheckbox"></field_new:checkbox>
			</div>
		</div>
	</div>
</div>

<field_new:validatedHiddenField xpath="${xpathhidden}" className="validate" title="Please select your destination/s." validationErrorPlacementSelector=".travel_details_destinations .content"></field_new:validatedHiddenField>