<%@ tag language="java" pageEncoding="ISO-8859-1" %>
<%@ tag description="Group for vehicle selection"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" 		required="true"	 rtexprvalue="true"	 description="field group's xpath" %>

<%-- VARIABLES --%>
<c:set var="name" 			value="${go:nameFromXpath(xpath)}" />
<c:set var="firstFour" 		value="${name}_firstFour" />
<c:set var="modelRow" 		value="${name}_modelRow" />
<c:set var="typeRow" 		value="${name}_typeRow" />
<c:set var="nonStandardRow" value="${name}_nonStandardRow" />
<c:set var="commercialRow" 	value="${name}_commercialRow" />
<c:set var="odometerRow"  value="${name}_odometerRow" />
<c:set var="factoryRow" 	value="${name}_factoryRow" />
<c:set var="factoryOption"  value="${name}_factoryOption" />

<%-- HTML --%>
<div id="vehicle-selection">
	<form:fieldset legend="Tell us about the car">
		<form:row label="Year of manufacture">
			<field:vehicle_year xpath="${xpath}/year" required="true" className="${firstFour}"/>	
		</form:row>
		<form:row label="Transmission type">
			<field:general_select xpath="${xpath}/trans" title="vehicle transmission" type="trans" className="${firstFour}" required="true" />	
		</form:row>
		<form:row label="Make of car" helpId="3">
			<field:make_select xpath="${xpath}/make" title="vehicle manufacturer" type="make" className="${firstFour}" required="true" />	
			<field:hidden xpath="${xpath}/makeDes"></field:hidden>
		</form:row>
		<form:row label="Fuel type">
			<field:general_select xpath="${xpath}/fuel" title="fuel type" type="fuel" className="${firstFour}" required="true" />
		</form:row>
		<form:row label="Model" id="${modelRow}">
			<field:general_select xpath="${xpath}/model" title="vehicle model" type="model" required="false"/>
			<field:hidden xpath="${xpath}/modelDes"></field:hidden>	
		</form:row>
	</form:fieldset>
	
	<form:fieldset legend="Now select the specific car description">
		<form:fullrow id="${typeRow}" className="quote_vehicle_redbookCodeRow">
			<field:general_select xpath="${xpath}/redbookCode" title="vehicle type" type="type" required="false" className="vehicleDes"/>	
			<field:hidden xpath="${xpath}/variant"></field:hidden>
		</form:fullrow>
	</form:fieldset>
	
	<form:fieldset legend="Car particulars" id="car-particulars">
		<form:row label="Will anyone use the car for commercial business purposes?" id="${commercialRow}" helpId="201">
		<field:array_radio xpath="${xpath}/vehicle/commercial"
						   required="true"
						   className="car_commercial" 
						   items="Y=Yes,N=No"
						   id="car_commercial"
						   title="if anyone will use the car for commercial business purposes"/>
		</form:row>
		<form:row label="Does the car have over 250,000 kilometers on the odometer?" id="${odometerRow}" helpId="202">
			<field:array_radio xpath="${xpath}/vehicle/odometer"
							   required="true"
							   className="car_odometer" 
							   items="Y=Yes,N=No"
							   id="car_odometer"
							   title="if the vehicle has over 250,000 kilometers on the odomoter"/>
		</form:row>
	</form:fieldset>	
</div>



<%-- CSS --%>
<go:style marker="css-head">
	#dialog { width: 600px; }
	#dialog_info { border:0; width: 590px; font-size: 10px }
	#dialog_content { width: 590px; }	
	#ui-tab-dialog-close { display: none; }
	.stdAcc  { width: 280px; height: 15px; font-size: 11px; }
	.nonStdDes { height: 24px; width: 245px; vertical-align: middle; color: #000000; font-size: 12px; }
	.nonStdInc { width: 173px; vertical-align: middle; color: #000000; font-size: 12px; }
	.nonStdPrc { width: 130px; vertical-align: middle; color: #000000; font-size: 12px; }
	.nonStdSpc { width: 39px;  border-bottom:1px solid white;}
	#nonStdDesHdr { font-size: 12px; line-height:15px; padding-left: 35px; padding-top: 5px; height: 30px; color: #4C4D4F; font-weight: bold; width:215px; }
	#nonStdIncHdr { font-size: 12px; font-weight: bold; width:154px;}
	#nonStdPrcHdr { font-size: 12px; font-weight: bold; cornerRadius: 5px; width:150px;}
	.nonStdRow { background-color:transparent; border-bottom:1px solid #DBE0E4;}
	.nonStdAccChkBox { margin-left: 5px; }
	#nonStdHdrRow { border: 0px solid #808080;}	
	#nonStdHdrRow tr { position:relative; }
	#nonStdHdrRow td { height:24px; background-image:none; background-color:transparent;}
	#nonStdTblWrapper {position: relative; width:605px; *width:590px; height:260px; overflow:auto; padding:0; margin-top:12px;}
	.nonStdErrMsg {background: #EFEFEF url(common/images/nonStdErrMsg.gif) no-repeat scroll 330px 0px;}
	*tr.nonStdErrMsg td {background: #EFEFEF; }
	*tr.nonStdErrMsg td.nonStdInc {background-image: url(common/images/nonStdErrMsg.gif) no-repeat scroll 86px 1px;}
	*tr.nonStdErrMsg td.nonStdPrc {background-image: url(common/images/nonStdErrMsg.gif) no-repeat scroll -87px 1px;}
	*tr.nonStdErrMsg td.nonStdSpc {background-image: url(common/images/nonStdErrMsg.gif) no-repeat scroll -217px 1px;}
	#quote_vehicle_redbookCode { font-size: 12px; width: 482px; margin-left: 5px; margin-bottom: 10px; }
	#tabOneTitle { background: url(common/images/dialog/fopt-sel.gif) no-repeat; width: 190px; }
	#tabTwoTitle { background: url(common/images/dialog/fopt-sel.gif) no-repeat; width: 190px; }	
	#tabThreeTitle { background: url(common/images/dialog/aopt.gif) no-repeat; width: 327px; }
	#tabTitleText { top: -4px; position: relative; color: #004FD9 }
	#quote_vehicle_factoryOption { font-size: 13px; }
	#dialogClose { background: url(common/images/dialog/close.gif) no-repeat; width: 36px; height: 34px; position: absolute; top: -34px; left: 608px; cursor: pointer; display: none;}
	#nonStdHdrTop { border-bottom: 1px solid #F4A97F; padding-top: 18px; *padding-top: 0px; padding-bottom: 3px; z-index:60; margin-top:-18px;  }
	#nonStdHdrTop div { display: inline-block; vertical-align: top; height: 32px; padding-top: 3px;zoom:1;*display: inline;}
	#tabTwo {padding-bottom:0px}
	#car-particulars .fieldrow_label { width:220px; }
	#roadside_vehicle_odometerRow, #roadside_vehicle_commercialRow { min-height:40px; }
	#productInfoFooter { display:none !important;}
</go:style>

<%-- JAVASCRIPT --%>
<go:script href="common/js/car/nonStandardAcc.js" marker="js-href" />
<go:script href="common/js/car/dialog_controller.js" marker="js-href" />
<go:script href="common/js/utils.js" marker="js-href" />

<go:script marker="onready">

	$pleaseChooseOption = "<option value=''>Please choose...</option>";

<%-- Initial: Hide model if not yet selected --%>
	<c:set var="xpathModel" value="${xpath}/model" />	
	<c:if test="${data[xpathModel] == null || data[xpathModel] == ''}">
		$("#${modelRow}").hide();
	</c:if>

	<c:set var="xpathType" value="${xpath}/redbookCode" />	
	<c:if test="${data[xpathType] == null || data[xpathType] == ''}">
		$("#${factoryRow}").hide();
	</c:if>

	<c:set var="year" value="${go:nameFromXpath(xpath)}_year" />
	<c:set var="trans" value="${go:nameFromXpath(xpath)}_trans" />
	<c:set var="make" value="${go:nameFromXpath(xpath)}_make" />
	<c:set var="makeDes" value="${go:nameFromXpath(xpath)}_makeDes" />
	<c:set var="fuel" value="${go:nameFromXpath(xpath)}_fuel" />
	<c:set var="model" value="${go:nameFromXpath(xpath)}_model" />
	<c:set var="modelDes" value="${go:nameFromXpath(xpath)}_modelDes" />
	<c:set var="redbookCode" value="${go:nameFromXpath(xpath)}_redbookCode" />
	<c:set var="variant" value="${go:nameFromXpath(xpath)}_variant" />

	$model = "${data[xpathModel]}";
	$type  = "${data[xpathType]}";
	
	var resetCar = false;
	$("#${typeRow}, #${modelRow}, .${firstFour}").click(function(){
		resetCar = true;
	});
		aih.xmlAccData = '${data.xml["quote/accs"]}';
	<%-- Interactive: Hide model if not yet selected --%>
	$(".${firstFour}").change(function(){
	
		$model = "";
		$type  = "";
		aih.xmlOptData = "${data.xml["quote/*/opt"]}";	

		$("#${modelRow}, #${factoryRow}").slideUp('normal').attr('disabled', true);		
		
		$("#${go:nameFromXpath(xpathType)}").html($pleaseChooseOption);		
		$("#${go:nameFromXpath(xpathModel)}").rules("remove", "required");
		$("#${go:nameFromXpath(xpathType)}").rules("remove", "required");
		
		// Check if all of the first four have been selected 
		var allSelected = true;
		$(".${firstFour}").each(function(){
			if ($(this).val() == "") {
				allSelected = false;
			}
		});
		
		// If they are all blank, hide the model
		if (allSelected){
						
			var makDes=$("#${make}").find(":selected").html();
	   		$("#${makeDes}").val(makDes);
			
			// Ajax: Get list of models 
			$.ajax({
			   url: "ajax/xml/car_model.jsp",
			   dataType: "xml",
		       complete: function(xhr){
					if (resetCar) {
						resetSelectedNonStdAcc();
					}
		        }, 
		       async: false,
		       timeout: 5000,
			   data: "car_year=" + $("#${year}").val() + 
			         "&car_manufacturer=" + $("#${make}").val() + 
			         "&car_fuel=" + $("#${fuel}").val() + 
			         "&car_transmition=" + $("#${trans}").val(),
			
			   success: function(data){
			   	 var options = $pleaseChooseOption;
			     $(data).find("model").each(function() {
			     	  $model = "${data[xpathModel]}";	
			     	  var sel = "";
			     	  if ($model == $(this).attr("modelCode")) {
						sel = " selected";
					  }			     	  
					  options += "<option value='" + $(this).attr("modelCode") + "'" + sel + ">" + $(this).text() + "</option>";
				 });
				$("#${go:nameFromXpath(xpathModel)}").html(options);
				$("#${modelRow}").slideDown('normal').removeAttr('disabled');
				$("#${go:nameFromXpath(xpathModel)}").rules("add", {required: true});	
				$("#${modelRow}").change();				
				
			   }
			 });
		} 
	});	
	

//
	// Model Row Selection
	//
	$("#${modelRow}").change(function(){
		$("#${go:nameFromXpath(xpathType)}").html($pleaseChooseOption);	
	
		if ($("#${go:nameFromXpath(xpathModel)}").val() != "") {
			var mdlDes=$("#${model}").find(":selected").html();
	   		$("#${modelDes}").val(mdlDes);
			<%-- Ajax: Get list of varients --%>		
			$.ajax({
			   url: "ajax/xml/car_variant.jsp",
			   async: false,
			   data: "car_year=" + $("#${year}").val() + 
			         "&car_manufacturer=" + $("#${make}").val() + 
			         "&car_fuel=" + $("#${fuel}").val() + 
			         "&car_transmition=" + $("#${trans}").val() + 
			         "&car_model=" + $("#${model}").val(),
			   success: function(data){
			   	 var varients = $pleaseChooseOption;
			     $(data).find("car").each(function() {
			     	  var sel = "";
			     	  $type = "${data[xpathType]}";
			     	  if ($type == $(this).attr("redbookCode")) sel = " selected";
					  varients += "<option value='" + $(this).attr("redbookCode") + "'" + sel + " rel='" + $(this).attr("mktVal") + "'>" + $(this).text() + "</option>";
				 });
				$("#${go:nameFromXpath(xpathType)}").html(varients);				
				$("#${go:nameFromXpath(xpathType)}").rules("add", {required: true});				
				$("#${typeRow}").change();					
					
			   }
			 });			 
		} else {
			$('input[name="quote_vehicle_accessories"]').attr({checked: false});
			$("#${factoryRow}").slideUp('normal');	
		}
	});		
	
	
	
	
	var nonAccTable = getNonAccTable();

	$("#tabTwo").html(nonAccTable);
	
	// Call this to auto complete car selection on page redisplay
	$(".${firstFour}").change();

	$("#tabThreeTitle").click(function(){
		$("#tabOneTitle, #tabTwoTitle").css("background","url(https://ecommerce.disconline.com.au/cc/common/images/dialog/fopt.gif)");
		$("#tabThreeTitle").css("background","url(https://ecommerce.disconline.com.au/cc/common/images/dialog/aopt-sel.gif)");
	});
	$("#tabOneTitle,#tabTwoTitle").click(function(){
		$("#tabOneTitle,#tabTwoTitle").css("background","url(https://ecommerce.disconline.com.au/cc/common/images/dialog/fopt-sel.gif)");	
		$("#tabThreeTitle").css("background","url(https://ecommerce.disconline.com.au/cc/common/images/dialog/aopt.gif)");
	});	
	$('.ui-dialog-buttonpane').append('<div id="dialog_car_ok"></div>')
	$("#dialogClose, #dialog_car_ok").click(function(){
		$('#dialog').dialog('close');
	});
	
		
</go:script>


