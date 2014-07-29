<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" required="true" rtexprvalue="true"
	description="field group's xpath"%>

<%-- VARIABLES --%>
<c:set var="name"  value="${go:nameFromXpath(xpath)}" />

<%-- Dialog wrapper --%>
<script type="text/html" id="quote-factoryoptions-template">
<div id="${name}Dialog">
	<div class="tab-content">
		<div class="tab-pane quote-factory-options">
			<form_new:fieldset legend="Your Selections">
				<p class="no-items-found">No factory/dealer options have been found for your selected vehicle.</p>
				<div class="row items-found">
					<form id="${name}DialogForm"><ul>{{= optionalAccessories }}</ul></form>
				</div>
			</form_new:fieldset>
		</div>
		<div class="tab-pane quote-standard-accessories">
			<form_new:fieldset legend="These are fitted standard to your vehicle and do not need to be declared">
				<p class="no-items-found">No included standard accessories have been found for your selected vehicle.</p>
				<div class="row items-found">
					<ul>{{= standardAccessories }}</ul>
				</div>
			</form_new:fieldset>
		</div>
	</div>
</div>
</script>