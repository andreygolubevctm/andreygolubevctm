<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<%@ attribute name="verticalFeatures"	required="true"	 		rtexprvalue="true"	 description="The vertical using the tag" %>
<%@ attribute name="displayCoverType"	required="false" 		rtexprvalue="true"	 description="Whether to display the Compare button or not" %>
<%@ attribute name="min"				required="false"	 	rtexprvalue="true"	 description="Minimum number of brands to be selected" %>
<%@ attribute name="max"				required="false"	 	rtexprvalue="true"	 description="Maximum number of brands to be selected" %>
<%@ attribute name="comparisonText"		required="false"	 	rtexprvalue="true"	 description="Optional text to display in the left hand column" %>

<c:if test="${empty displayCoverType}"><c:set var="displayCoverType" value="false" /></c:if>
<c:if test="${empty min}"><c:set var="min" value="1" /></c:if>
<c:if test="${empty max}"><c:set var="max" value="12" /></c:if>
<c:if test="${empty comparisonText}"><c:set var="comparisonText">Brands we compare on price &amp; features</c:set></c:if>

<go:style marker="css-head">

	.panel{
		overflow:hidden;
		display: table;
		table-layout: fixed;
		width:980px;
		margin-bottom: 20px;
	}

	.panel .column{
		display: table-cell;
		vertical-align: top;
	}

	.panel .column .insert{
		padding:20px;
	}

	.panel .column.leftSide{
		<css:rounded_corners value="10" corners="top-left,bottom-left"/>
		width:265px;
	}

	.panel .column.green{
		background-color: #bbf0ce;
		color:#2e4c3a;
	}

	.panel .column.rightSide{
		<css:rounded_corners value="10" corners="top-right,bottom-right"/>
		width:715px;
	}

	.panel .column.blue{
		background-color: #becce8;
		color:#4c4c49;
	}

	.panel h2{
		font-size:22px;
		margin-bottom:10px;
		height:50px;
	}

	.panel .column.green h2{
		color: #0b9941;
	}

	.panel .column.blue h2{
		color: #485f94;
	}

	.panel .checkboxes{
		overflow:hidden;
	}

	.panel .rightSide .checkboxes{
		-moz-columns: 3 auto;
		-webkit-columns: 3 auto;
		columns: 3 auto;
	}

	.panel .item{
		*float:left;
		display:inline-block;
		width:215px;

		margin-bottom:10px;
		font-family: "SunLTLightRegular";
	}

	.panel .item.disabled{
		opacity: 0.5;
		filter:alpha(opacity=50);
	}

	.panel .item label{
		font-size:15px;
		cursor: pointer;
		line-height:23px;
	}

	.panel .item.disabled label{
		cursor: auto;
	}

	.panel .button_footer{
		text-align:right;
	}

	.panel input[type="checkbox"] {
		display:none;
	}

	.panel input[type="checkbox"] + label span.ch {
		display:inline-block;
		width:23px;
		height:23px;
		margin:0px 6px 0 0;
		vertical-align:middle;
		border-radius:3px;
	}

	.panel input[type="checkbox"] + label span.lb {
		vertical-align: bottom;
		display:inline-block;
		overflow:hidden;
		white-space: nowrap;
		display:inline-block;
		text-overflow:ellipsis;
		width:177px;
	}

	.panel .blue input[type="checkbox"] + label span.ch {
		background-color:#d8e0f1;
	}

	.panel .green input[type="checkbox"] + label span.ch {
		background-color:#0db14b;
	}

	.panel .blue input[type="checkbox"]:checked + label span.ch {
		background-color:#485f94;
	}

	.panel input[type="checkbox"]:checked + label span.ch {
		background-image:url("brand/ctm/images/checkboxes/checkbox_on.png");
	}

	/* No nices checkboxes for IE8 and below */

	.panel input[type="checkbox"] {
		display:inline\9;
		vertical-align:top\9;
		margin-top:3px\9;
	}

	.panel input[type="checkbox"] + label span.ch {
		background: none\9;
		display:none\9;
	}

</go:style>
<go:script marker="js-head">

	function updateBrandSelectionState(){

		var count = $(".brands_container :checkbox:checked").length;

		if(count >= ${min} && count <= ${max}){
			$("#next-step-real").removeClass("disabled");
		}else{
			$("#next-step-real").addClass("disabled");
		}

		<c:if test="${displayCoverType eq true}">
			var countTypes = $(".cover_type :checkbox:checked").length;
			if(countTypes == 0 ){
				$("#next-step-real").addClass("disabled");
			}
		</c:if>

		if(count < ${max}){
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

	$(".brands_container :checkbox, .cover_type :checkbox").click(function(eventObject){
		updateBrandSelectionState();
	});

	$("#next-step-real").click(function(eventObject){

		var selectedBrands = $(".brands_container :checkbox:checked");
		var count = selectedBrands.length;

		<c:set var="typesCondition" value="" />
		<c:if test="${displayCoverType eq true}">
			var selectedTypes = $(".cover_type :checkbox:checked");
			<c:set var="typesCondition">&& selectedTypes.length > 0</c:set>
		</c:if>


		if( count >= ${min} && count <= ${max} <c:out value="${typesCondition}" escapeXml="false" />){

			// add the list of the select brand names to hidden field
			var brandNames = new Array();
			for(var i=0;i< selectedBrands.length; i++){
				brandNames.push($(selectedBrands[i]).attr('data-name'));
			}
			$("#selected_brands_hdn").val(brandNames.join(','));

			<c:if test="${displayCoverType eq true}">
				// add the list of the selected type names to hidden field
				var typeNames = new Array();
				for(var i=0;i< selectedTypes.length; i++){
					typeNames.push($(selectedTypes[i]).attr('data-name'));
				}
				$("#selected_types_hdn").val(typeNames.join(','));
			</c:if>

			$("#next-step").trigger('click');

			// Call Supertag...
			Track_Features.trackBrandSelection(brandNames);

		}

	});

</go:script>

<sql:setDataSource dataSource="jdbc/test"/>

<sql:query var="results">
	SELECT DISTINCT
		fb.id,
		displayName AS name,
		realName,
		(
			SELECT count(*) AS count
			FROM test.features_product_mapping map
			JOIN test.features_products fp
			WHERE fp.ref = map.lmi_Ref
			AND fp.brandId = fb.id
		) AS in_ctm
	FROM test.features_brands fb
	LEFT JOIN test.features_products fp
	ON fp.brandId = fb.id
	WHERE fp.vertical = ?
	ORDER BY fb.displayName ASC;

	<sql:param>${fn:toUpperCase(verticalFeatures)}</sql:param>
</sql:query>

<div class="panel brands_container force-invisible-select">
	<input id="selected_brands_hdn" type="hidden" name="${fn:toLowerCase(pageSettings.getVerticalCode())}_brands" value=""/>
	<div class="column leftSide green">
		<div class="insert">
			<h2>${comparisonText}</h2>

			<c:set var="countInCtm" value="0" />
			<c:forEach items="${results.rows}" var="brand">
				<c:if test="${brand.in_ctm > 0}">
					<c:set var="countInCtm" value="${countInCtm+1}" />
					<div class="item">
						<input id="product${brand.id}_check" type="checkbox" name="brand" value="${brand.id}" data-name="${go:htmlEscape(brand.name)}"/>
						<label for="product${brand.id}_check"><span class="ch"></span><span class="lb"><c:out value="${brand.name}"/></span></label>
					</div>
				</c:if>
			</c:forEach>
			<c:if test="${countInCtm eq 0}">
				<go:style marker="css-head">
					.brands_container .leftSide{
						display: none;
					}
					.brands_container .rightSide{
						<css:rounded_corners value="10" />
					}
				</go:style>
			</c:if>
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

			<c:if test="${displayCoverType eq false}">
				<div class="button_footer">
					<span id="count_txt"></span>
					<a id="next-step-real" class="btn orange arrow-right" href="javascript:;">Compare Now</a>
					<a id="next-step" style="display:none;" href="javascript:;">Next</a>
				</div>
			</c:if>

		</div>
	</div>

</div>

<%-- Cover type --%>
<c:if test="${displayCoverType eq true}">
	<features:cover_choice verticalFeatures="${verticalFeatures}" />
</c:if>
