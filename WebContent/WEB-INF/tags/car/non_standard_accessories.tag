<%--
	Car footer
--%>
<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<a href="javascript:;" id="renameMeForAdditionalAccessories" title="">Additional accessories</a>

<%-- Dialog wrapper --%>
<script type="text/html" id="car-accessories-template">
<div id="renameMyModelId">

	<%-- Tab wrapper --%>
	<div class="tab-content">
		<div class="tab-pane car-non-standard-accessories">
			<form_new:fieldset legend="Available non-standard accessories for your car">
				<p>By listing aasdfasdfasdfasdfasdfdea of the car's true value. </p>
				<div class="row">
					<div class="col-md-4 small">
						<p>Option / Accessory type</p>
						<field_new:array_select xpath="test" title="Option / Accessory type" required="true" items="=Please choose...||0=Tier 0||1=Tier 1||2=Tier 2||3=Tier 3" delims="||" className="test" />
					</div>
					<div class="col-md-4 small">
						<p>Included in purchase price of car?</p>
						<field_new:array_radio items="Y=Yes,N=No" style="group" xpath="" title="" required="true" id="test" className="test" />
					</div>
					<div class="col-md-4 small">
						<p>Purchase price</p>
						<field_new:input type="number" xpath="test" className="test" maxlength="test" required="false" title="Purchase price" placeHolder="Purchase Price" />
					</div>

				</div>
			</form_new:fieldset>
		</div>
		<div class="tab-pane car-standard-accessories">
			<ul>
				<li>list here</li>
				{{= includedOptions }}
			</ul>
		</div>
	</div>
</div>
</script>