<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<go:style marker="css-head">

	.brands_container{
		overflow:hidden;
		display: table;
		table-layout: fixed;
		width:980px;
	}

	.brands_container .column{
		display: table-cell;
		vertical-align: top;
	}

	.brands_container .column .insert{
		padding:20px;
	}

	.brands_container .column.leftSide{

		border-radius: 10px 0px 0px 10px;
		width:265px;
	}

	.brands_container .column.green{
		background-color: #bbf0ce;
		color:#2e4c3a;
	}

	.brands_container .column.rightSide{
		border-radius: 0px 10px 10px 0px;
		width:715px;
	}

	.brands_container .column.blue{
		background-color: #becce8;
		color:#4c4c49;
	}

	.brands_container h2{
		font-size:22px;
		margin-bottom:10px;
		height:50px;
	}

	.brands_container .column.green h2{
		color: #0b9941;
	}

	.brands_container .column.blue h2{
		color: #485f94;
	}

	.brands_container .checkboxes{
		overflow:hidden;
	}

	.brands_container .rightSide .checkboxes{
		-moz-columns: 3 auto;
		-webkit-columns: 3 auto;
		columns: 3 auto;
	}

	.brands_container .item{
		*float:left;
		display:inline-block;
		width:215px;

		margin-bottom:10px;
		font-family: "SunLTLightRegular";
	}

	.brands_container .item.disabled{
		opacity: 0.5;
		filter:alpha(opacity=50);
	}

	.brands_container .item label{
		font-size:15px;
		cursor: pointer;
		line-height:23px;
	}

	.brands_container .item.disabled label{
		cursor: auto;
	}

	.brands_container .button_footer{
		text-align:right;
	}

	.brands_container input[type="checkbox"] {
		display:none;
	}

	.brands_container input[type="checkbox"] + label span.ch {
		display:inline-block;
		width:23px;
		height:23px;
		margin:0px 6px 0 0;
		vertical-align:middle;
		border-radius:3px;
	}

	.brands_container input[type="checkbox"] + label span.lb {
		vertical-align: bottom;
		display:inline-block;
		overflow:hidden;
		white-space: nowrap;
		display:inline-block;
		text-overflow:ellipsis;
		width:177px;
	}

	.brands_container .blue input[type="checkbox"] + label span.ch {
		background-color:#d8e0f1;
	}

	.brands_container .green input[type="checkbox"] + label span.ch {
		background-color:#0db14b;
	}

	.brands_container .blue input[type="checkbox"]:checked + label span.ch {
		background-color:#485f94;
	}

	.brands_container input[type="checkbox"]:checked + label span.ch {
		background-image:url("brand/ctm/images/checkboxes/checkbox_on.png");
	}

	/* No nices checkboxes for IE8 and below */

	.brands_container input[type="checkbox"] {
		display:inline\9;
		vertical-align:top\9;
		margin-top:3px\9;
	}

	.brands_container input[type="checkbox"] + label span.ch {
		background: none\9;
		display:none\9;
	}

</go:style>
<go:script marker="js-head">

	function updateBrandSelectionState(){

		var count = $(".brands_container :checkbox:checked").length;

		if(count > 0 && count < 13){
			$("#next-step-real").removeClass("disabled");
		}else{
			$("#next-step-real").addClass("disabled");
		}

		if(count < 12){
			$(".brands_container .item").removeClass('disabled');
			$(".brands_container input[disabled='disabled']").removeAttr('disabled');
		}else{
			$(".brands_container input:checkbox:not(:checked)").attr('disabled', 'disabled');
			$(".brands_container input:checkbox:not(:checked)").parent().addClass('disabled');
		}

	}

</go:script>
<go:script marker="onready">

	updateBrandSelectionState();

	$(".brands_container :checkbox").click(function(eventObject){
		updateBrandSelectionState();
	});

	$("#next-step-real").click(function(eventObject){

		var selectedCheckboxes = $(".brands_container :checkbox:checked");
		var count = selectedCheckboxes.length;
		if(count > 0 && count < 13){

			var brandNames = new Array();

			for(var i=0;i< selectedCheckboxes.length; i++){
				brandNames.push($(selectedCheckboxes[i]).attr('data-name'));
			}

			$("#selected_brands_hdn").val(brandNames.join(','))

			$("#next-step").trigger('click');

			// Call Supertag...
			Track_CarLMI.trackBrandSelection(brandNames);

		}

	});

</go:script>

<sql:setDataSource dataSource="jdbc/test"/>

<sql:query var="results">
	SELECT  id, displayName AS name, realName,
		(SELECT count(*) AS count
		FROM test.features_product_mapping map JOIN test.features_products fp
		WHERE fp.ref = map.lmi_Ref AND fp.brandId = fb.id) AS in_ctm
	FROM test.features_brands fb
	ORDER BY fb.displayName ASC;
</sql:query>

<div class="brands_container force-invisible-select">
	<input id="selected_brands_hdn" type="hidden" name="${fn:toLowerCase(data.settings.vertical)}_brands" value=""/>
	<div class="column leftSide green">
		<div class="insert">
			<h2>Brands we compare on price &amp; features</h2>

			<c:forEach items="${results.rows}" var="brand">
				<c:if test="${brand.in_ctm > 0}">
					<div class="item">
						<input id="product${brand.id}_check" type="checkbox" name="brand" value="${brand.id}" data-name="${go:htmlEscape(brand.name)}"/>
						<label for="product${brand.id}_check"><span class="ch"></span><span class="lb"><c:out value="${brand.name}"/></span></label>
					</div>
				</c:if>
			</c:forEach>

		</div>

	</div>

	<div class="column rightSide blue">
		<div class="insert">
			<h2>Brands we compare on features only</h2>
			<div class="checkboxes">
				<c:forEach items="${results.rows}" var="brand">
					<c:if test="${brand.in_ctm == 0}">
						<div class="item">
							<input id="product${brand.id}_check" type="checkbox" name="brand" value="${brand.id}" data-name="${go:htmlEscape(brand.name)}" />
							<label for="product${brand.id}_check"><span class="ch"></span><span class="lb"><c:out value="${brand.name}"/></span></label>
						</div>
					</c:if>
				</c:forEach>
			</div>
			<div class="button_footer">
				<span id="count_txt"></span>
				<a id="next-step-real" class="btn orange arrow-right" href="javascript:;">Compare Now</a>
				<a id="next-step" style="display:none;" href="javascript:;">Next</a>
			</div>

		</div>
	</div>

</div>
