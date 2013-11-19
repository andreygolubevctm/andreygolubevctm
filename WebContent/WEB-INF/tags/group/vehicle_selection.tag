<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Group for vehicle selection"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" required="true" rtexprvalue="true"
	description="field group's xpath"%>

<%-- VARIABLES --%>
<c:set var="name" 			value="${go:nameFromXpath(xpath)}" />
<c:set var="firstTwo" 		value="${name}_firstTwo" />
<c:set var="modelRow" 		value="${name}_modelRow" />
<c:set var="typeRow" 		value="${name}_typeRow" />
<c:set var="nonStandardRow" value="${name}_nonStandardRow" />
<c:set var="factoryRow" 	value="${name}_factoryRow" />
<c:set var="factoryOption"  value="${name}_factoryOption" />

<c:set var="standard_desc_inline"  value="${name}_standard_desc_inline" />
<c:set var="options_fitted_inline"  value="${name}_options_fitted_inline" />
<c:set var="accessories_fitted_inline"  value="${name}_accessories_fitted_inline" />

<%-- HTML --%>
<div id="${name}-selection">
	<form:fieldset legend="Identify the car you wish to insure"
		id="${name}_selection" helpId="3">
	
		<form:row label="Make" id="${name}_makeRow" className="initial">
			<field:make_select xpath="${xpath}/make" title="vehicle manufacturer" type="make" required="true" />
			<field:hidden xpath="${xpath}/makeDes"></field:hidden>
		</form:row>
		
		<form:row label="Model" id="${modelRow}">
			<field:general_select xpath="${xpath}/model" title="vehicle model" required="false" initialText="&nbsp;" />
			<field:hidden xpath="${xpath}/modelDes"></field:hidden>	
		</form:row>

		<form:row label="Year" id="${name}_yearRow">
			<field:general_select xpath="${xpath}/year" title="vehicle year" required="false" initialText="&nbsp;" />
		</form:row>
		
		<form:row label="Body" className="showOnPopulateSelect">
			<field:general_select xpath="${xpath}/body" title="vehicle body" required="true" initialText="&nbsp;" />
		</form:row>
		
		<form:row label="Transmission" className="showOnPopulateSelect">
			<field:general_select xpath="${xpath}/trans" title="vehicle transmission" required="true" initialText="&nbsp;" />
		</form:row>

		<form:row label="Fuel" className="showOnPopulateSelect">
			<field:general_select xpath="${xpath}/fuel" title="fuel type" required="true" initialText="&nbsp;" />
		</form:row>

		<form:row id="${typeRow}" label="Type"
			className="quote_vehicle_redbookCodeRow showOnPopulateSelect">
			<field:general_select xpath="${xpath}/redbookCode" title="vehicle type" required="false" className="vehicleDes" initialText="&nbsp;" />
			<field:hidden xpath="${xpath}/marketValue"></field:hidden>
			<field:hidden xpath="${xpath}/variant"></field:hidden>
		</form:row>
	</form:fieldset>
	
	<form:fieldset legend="Factory/dealer options and additional accessories">
		<form:row label="" id="${standard_desc_inline}" >
			<div class="inline_container">
				<div style="padding-top:10px;padding-bottom:15px;">
					<a id="toggle_factory_options"  href="javascript:;">View factory options fitted as standard with your car.</a>
				</div>
				<div id="inline_factory_standard_container" class="optionsList" >
					<!--  replaced with dynamic content -->
				</div>
			</div>
		</form:row>
		<form:row label="Does the car have any factory/dealer options fitted?" id="${factoryRow}" helpId="13">
		<field:array_radio xpath="quote/vehicle/factoryOptions"
						required="true"
						   className="car_factory_options" 
						   items="Y=Yes,N=No"
						   id="car_factory_options"
						   title="if the vehicle has any factory/dealer options fitted"/>
		</form:row>

		<form:row id="${options_fitted_inline}" label="" >
			<div class="inline_container">
				<div class="inline_heading">
					Select whether the car has any factory/dealer options fitted (even if they were purchased with the car).
				</div>
				<div id="inline_factory_options_container" class="optionsList">
					<!--  replaced with dynamic content -->
				</div>
			</div>
		</form:row>

		<form:row label="Does the car have additional accessories fitted?" id="${nonStandardRow}" helpId="4">
			<field:array_radio xpath="quote/vehicle/accessories"
							   required="true"
							   className="car_accessories" 
							   items="Y=Yes,N=No"
							   id="car_accessories"
							   title="if the vehicle has any non-standard accessories fitted"/>
		</form:row>

		<form:row  id="${accessories_fitted_inline}" label=""  >
			<div class="inline_container">
				<div class="inline_heading">
					Select whether the car has any additional accessories fitted (even if they were purchased with the car). Insurers use this information to calculate the value of the car.
				</div>
				<div id="inline_additional_accessories_container" class="optionsList">
					<!--  replaced with dynamic content -->
				</div>
			</div>
		</form:row>

	</form:fieldset>	
</div>

<%-- HTML --%>
<ui:dialog id="fittings" width="650" height="550" titleDisplay="true"
	title="<span class='custom-dialog-titlebar'>Select whether the car has any factory/dealer options fitted (even if they were purchased with the car). Insurers use this information to calculate the value of the car.</span><ul class='dialog-tabs'><li><a href='#tabOne' id='tabOneTitle'></a></li><li><a href='#tabTwo' id='tabTwoTitle'></a></li><li><a href='#tabThree' id='tabThreeTitle'></a></li></ul>"
	buttons="{ Ok: function() { $('#fittingsDialog').dialog('close');} }">

	<div class="dialog-tab-container">
		<div class="dialog-tabs-content">
			<div id="tabOne"></div>
			<div id="tabTwo"></div>
			<div id="tabThree"></div>			
		</div>
		<div class="ui-dialog-footer"></div>
	</div>

</ui:dialog>


<%-- CSS --%>
<go:style marker="css-head">
	/*#instructions { display:none; font-size: 10px; margin-left: 18px; font-weight: bold; padding-top: 20px; }*/
	.stdAcc  { width: 280px; height: 15px; font-size: 11px; }
	.nonStdDes { height: 24px; width: 245px; vertical-align: middle; color: #000000; font-size: 12px; }
	.nonStdInc { width: 173px; vertical-align: middle; color: #000000; font-size: 12px; }
	.nonStdPrc { width: 130px; vertical-align: middle; color: #000000; font-size: 12px; }
	.nonStdSpc { width: 39px;  border-bottom:1px solid white;}
	#nonStdDesHdr { font-size: 12px; line-height:15px; padding-left: 0px; padding-top: 5px; height: 30px; color: #4C4D4F; font-weight: bold; width:215px; }
	#nonStdIncHdr { font-size: 12px; font-weight: bold; width:154px;}
	#nonStdPrcHdr { font-size: 12px; font-weight: bold; cornerRadius: 5px; width:150px;}
	.nonStdRow { background-color:transparent; border-bottom:1px solid #DBE0E4;}

	#nonStdHdrRow { border: 0px solid #808080;}	
	#nonStdHdrRow tr { position:relative; }
	#nonStdHdrRow td { height:31px; background-image:none; background-color:transparent;}
	#nonStdTblWrapper {position: relative; height:260px; overflow:auto; padding:0; margin-top:12px; }
	.nonStdErrMsg {background: #EFEFEF; }
	*tr.nonStdErrMsg td {background: #EFEFEF; }
	*tr.nonStdErrMsg td.nonStdInc {background-image: url(common/images/nonStdErrMsg.gif) no-repeat scroll 86px 1px;}
	*tr.nonStdErrMsg td.nonStdPrc {background-image: url(common/images/nonStdErrMsg.gif) no-repeat scroll -87px 1px;}
	*tr.nonStdErrMsg td.nonStdSpc {background-image: url(common/images/nonStdErrMsg.gif) no-repeat scroll -217px 1px;}
	.nonStdRow td.nonStdInc > div { position: relative; }
	.errMsgGraphic { display:none; }
	.nonStdErrMsg .errMsgGraphic {
		background-image: url(common/images/nonStdErrMsg.gif); background-repeat: no-repeat;
		display: block; width: 237px; height: 23px; top: -2px; left: 83px; position: absolute;
	}

	#tabTitleText { position: relative; color: #4a4f51; font-size: 10px; }
	#quote_vehicle_factoryOption { font-size: 13px; }
	/*dialogClose { background: url(common/images/dialog/close.png) no-repeat; width: 36px; height: 34px; position: absolute; top: -34px; left: 608px; cursor: pointer; display: none;}*/
	#nonStdHdrTop { border-bottom: 1px solid #F4A97F; padding-top: 18px; *padding-top: 0px; padding-bottom: 3px; z-index:60; margin-top:-18px;  }
	#nonStdHdrTop div { display: inline-block; vertical-align: top; height: 32px; padding-top: 3px;zoom:1;*display: inline;}
	#tabOne { padding-bottom:0px; overflow: hidden; font-size: 11px; }
	#tabTwo { padding-bottom:0px; overflow: hidden;  }
	#tabThree { height: 310px; overflow:auto; }
	.vehicleDes { font-size: 12px; width: 400px; margin-bottom: 10px; }
	.footerPopupText { font-size:10px; margin-left:15px; font-weight:bold; }
	.ui-dialog .ui-dialog-buttonpane { top: -7px; position: relative; }
	.ui-dialog-titlebar { height: auto; padding: 16px 2em 0.5em !important; }
	.dialog-tabs-content { position:relative; }
	.dialog-tabs {  }
	.custom-dialog-titlebar { font-size: 15px; font-weight: normal; }

	#quote_vehicle-selection .fieldrow_value select {
		width: 200px;
		max-width: 380px;
		min-width: 200px;
	}
	#quote_vehicle-selection #quote_vehicle_redbookCode {
		width: 380px;
	}

	<%-- STYLE FOR showOnPopulateSelect --%>

	.showOnPopulateSelect {
		display: none;
	}

	/* CSS for inline */

	#${standard_desc_inline},
	#${options_fitted_inline},
	#${accessories_fitted_inline},
	#inline_factory_standard_container{
		display:none;
	}


	#inline_factory_options_container .item{
		border-bottom: 1px solid #DBE0E4;
		padding: 3px;
		padding-top:8px;
		padding-bottom:8px;
	}

	.inline_heading{
		font-weight:bold;
		margin-bottom:10px;
	}

	.inline_container{
		width:410px;
	}
	
	.optionsList{
		margin-bottom:25px;
	}

	.optionsList td{
		padding-top:8px;
		padding-bottom:8px;
	}
	
	.optionsList input{
		vertical-align:middle;
		margin-right:6px;
	}

	.optionsList input[type='radio'] + label,
	.optionsList input[type='checkbox'] + label{
		vertical-align:middle;
		font-size:14px;
		margin-right:6px;
		-webkit-text-size-adjust: none; /* prevents iOS from automatically resizing the fonts */
	}

	.nonStdDes{
		padding: 0 0 0 22px;
		
			}
		
	#${accessories_fitted_inline} .nonStdDes{
		padding:3px 3px 3px 22px;
	}
					
	.nonStdDes input{
		/* absolute position to allow label to wrap neatly */
		position:absolute;
		left:0;
		margin-top:0px;
	}
			
	.stage-0 #slide0{
		/* page needs to be longer to hold all of the content */
		max-height: 6000px;
					}
			   	 
	#${accessories_fitted_inline} #nonStdDesHdr{
		width:185px;
					  }	     	  

	#${accessories_fitted_inline} #nonStdHdrTop div{
		height: 41px;
			   }

	#${accessories_fitted_inline} #nonStdIncHdr{
		width: 105px;
		} 
	
	#${accessories_fitted_inline} #nonStdPrcHdr{
		width: 105px;
	}

</go:style>
	
<%-- JAVASCRIPT --%>
<go:script href="common/js/car/nonStandardAcc.js" marker="js-href" />
<go:script href="common/js/utils.js" marker="js-href" />
	
<go:script href="common/js/car/vehicle_selection.js" marker="js-href" />
	
<%-- Legacy and onready calls --%>
<go:script marker="onready">
		
	<%-- console.log('=-=-=-=-=-=-=-=-=-=-=-=-=-= GOSCRIPT MARKER RUNNING CODE -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-='); --%>
	<%-- Here are all our #id selectors if the JSTL needs them --%>
	<c:set var="year"			value="${name}_year" />
	<c:set var="trans"			value="${name}_trans" />
	<c:set var="make"			value="${name}_make" />
	<c:set var="makeDes"		value="${name}_makeDes" />
	<c:set var="fuel"			value="${name}_fuel" />
	<c:set var="body"			value="${name}_body" />
	<c:set var="bodyDes"		value="${name}_bodyDes" />
	<c:set var="model"			value="${name}_model" />
	<c:set var="modelDes"		value="${name}_modelDes" />
	<c:set var="redbookCode"	value="${name}_redbookCode" />
	<c:set var="marketValue"	value="${name}_marketValue" />
	<c:set var="variant" 		value="${name}_variant" />
		
	<c:set var="xpathModel" value="${xpath}/model" />
	<c:set var="xpathType" value="${xpath}/redbookCode" />

	<%-- Likewise if the JavaScript needs them --%>
	car.vehicleSelect.fields = {
		namePfx : "${name}",
		ajaxPfx : "car_",
		year    : "#${year}",
		make    : "#${make}",
		model   : "#${model}",
		body    : "#${body}",
		trans   : "#${trans}",
		fuel    : "#${fuel}",
		type    : "#${redbookCode}",
		nonStandardRow : "#${nonStandardRow}",
		factoryRow : "#${factoryRow}",
		factoryOption : "#${factoryOption}"
	};
	
	<%-- Mobile only inline display for accessories --%>
	var inlineMode =  is_mobile_device();
	
	$("#toggle_factory_options").click(function(){
		$("#inline_factory_standard_container").toggle();
	});
		
	function validateCheckList(element, checkboxSelector){
		if($(element).attr('checked') == 'checked'){
			if($(checkboxSelector+":checked").length > 0 ){
				$(element).removeClass('error');
				return true;
					}
			return false;
				}
		$(element).removeClass('error');
		return true;
		}

	if(inlineMode){

		$.validator.addMethod("validFactoryOptions",
			function(value, element, params) {
				return validateCheckList(element, '.quote_vehicle_factoryOption');
			},
			"Please select at least one factory/dealer option"
		);

		$.validator.addMethod("validFactoryAccessories",
			function(value, element, params) {
				return validateCheckList(element, '.nonStdAccChkBox');
			},
			"Please select at least one accessory option"
		);
	
		$( "#quote_vehicle_factoryOptions_Y" ).rules( "add", {
			validFactoryOptions: true
		});

		$( "#quote_vehicle_accessories_Y" ).rules( "add", {
			validFactoryAccessories: true
				 });

				 }
	
	<%-- The data bucket for vehicle might be filled from elsewhere, or preload=2 --%>
	aih.xmlAccData = '${data.xml["quote/accs"]}';
	aih.xmlOptData = "${data.xml["quote/*/opt"]}";
	
	<%-- -------------------------------------------------- --%>
	<%-- KICK OFF EVERYTHING FROM THE VEHICHLE_SELECTION.JS --%>
	<%-- -------------------------------------------------- --%>
	car.vehicleSelect.init();
	
	<%-- console.log('=-=-=-=-=-=-=-=-=-=-=-=-=-= EVERYTHING AFTER INIT() -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-='); --%>
	
	<%-- Vehicle Variant Selection --%>

	$("#${typeRow}").change(function(){
		initFactoryDetailOptions();
			});		
				
				
	//
	// FACTORY OPTIONS DIALOG WINDOW CLICK
	//	
	$("#quote_vehicle_factoryOptions_Y").click(function(){		
		showFactoryDetailOptions();
		});			
   		
	$("#quote_vehicle_factoryOptions_N").click(function(){		
		hideFactoryDetailOptions();
		});	

	//
	// NON STANDARD ACCESSORIES DIALOG WINDOW CLICK
	//
	$("#quote_vehicle_accessories_Y").click(function(){
		showAdditionalAccessoriesOptions();
			});
		   	
	$("#quote_vehicle_accessories_N").click(function(){
		hideAdditionalAccessoriesOptions();
		});
	//
	// FACTORY OPTIONS
	//
	function factoryOptions(redbookCode) {	
		// I direly want to use an alternative JSON endpoint here instead.
		var xmlData = 	
		$.ajax({
	   		url: "ajax/xml/car_options.jsp",
	   		async: false,
	   		data: "redbookCode=" + redbookCode
	   	}).responseXML;
	   		   	
		var predata = "";
		var factoryOptionsData = "";

		$(xmlData).find("factoryOption").each(function(index) {
		 	  var code = $.trim($(this).attr("optionCode"));
		 	  var sel = "";
			<%-- If it has multiple nodes use those, else take the single one
			which jquery wont .find because it's trying too hard --%>
			var $optionData = $(aih.xmlOptData).find("text");
			if (!($optionData.length > 0)) { $optionData = $(aih.xmlOptData); }
			$optionData.each(function() {
				var dataBucketCode = $.trim($(this).text());
				if (code == dataBucketCode) {
						sel=" checked";
			      }
		      });
			factoryOptionsData += "<div class='item'><input id='fact_"+index+"_chk' type='checkbox' name='quote_opts"+twoDigits(index)+"_opt' value='" + code + "'" + sel + " class='${factoryOption}'><label for='fact_"+index+"_chk'>" + $.trim($(this).text()) + "</label></div>";
		});
		var data = "";
		if (factoryOptionsData!="") {
			data = predata + factoryOptionsData;
			$("#${factoryRow}").slideDown('normal').removeAttr('disabled');
		} else {
			$("#${factoryRow}").slideUp('normal');
		}
   		this.options = data; 
	   		
	}

	function factoryOptionToggle(){
		var n = $(".${factoryOption}:checked").length;
		if (n > 0) {
			$('input[id="quote_vehicle_factoryOptions_Y"]').attr({checked: true});
			$('#quote_vehicle_factoryRow_row_legend').html(n + ' factory option' + ((n>1)?'s':'') + ' fitted');
		} else {
			$("#quote_vehicle_factoryOptions_N").click();
		}
		$('input[name="quote_vehicle_factoryOptions"]').button('refresh').trigger("change");
	}

	// 
	// STANDARD ACCESSORIES
	//
	function standardAccessories() {	
		// I direly want to use an alternative JSON endpoint here instead.
		var xmlData = 
		$.ajax({
			url: "ajax/xml/car_accessories.jsp",
			async: false,
			data: "redbookCode=" + $("#${redbookCode}").val()
		}).responseXML;
		
		var data = '<table>';
		var stdAccCount = 0;
		
		$(xmlData).find("stdacc").each(function() {
			stdAccCount ++;
			if (stdAccCount == 1) {data += "<tr>"};
			data += '<td class=stdAcc>' + $.trim($(this).text()) + '</td>';
			if (stdAccCount == 2) {
				data += '</tr>';
				stdAccCount = 0;
			}
		});
		data += '</table>';
		this.accessories = data;
	}
	
	function standardAccessoriesToggle(n){
		if ($.browser.msie && $.browser.version < 8) {
			$("#tabTwo").html($("#tabTwo").html());
		}
		if (n > 0) {
			$('#quote_vehicle_nonStandardRow_row_legend').html(n + ' additional accessor' + ((n>1)?'ies':'y') + ' fitted');
		} else {
			$('#quote_vehicle_nonStandardRow_row_legend').html();
		}
	}
	
	
	//
	// STANDARD FEATURES
	//
	function standardFeatures() {
		var alarm = false;
		var immobiliser = false;
		var select = "";
		// I direly want to use an alternative JSON endpoint here instead.
		var xmlData =
		$.ajax({
			url: "ajax/xml/car_features.jsp",
			async: false,
			data: "redbookCode=" + $("#${redbookCode}").val()
		}).responseXML;

		$(xmlData).find("alarm").each(function() {
			if($.trim($(this).text()) != '')
			alarm = true;
		});

		$(xmlData).find("immobiliser").each(function() {
			if($.trim($(this).text()) != '')
			immobiliser = true;
		});

		if(alarm && immobiliser) {
			$('#securityOption').html('<input type="hidden" name="quote_vehicle_securityOption"  id="quote_vehicle_securityOption" value="B"/>');
		} else if(alarm) {
			$('#securityOption').html('<input type="hidden" name="quote_vehicle_securityOption" id="quote_vehicle_securityOption" value="A"/>');
		} else if(immobiliser) {
			$('#securityOption').html('<input type="hidden" name="quote_vehicle_securityOption"  id="quote_vehicle_securityOption" value="I"/>');
		} else {
			$('#securityOption').html(securityOption);
		}
	}


	var nonAccTable = getNonAccTable();

	var accessoriesDiv = "";
	if(inlineMode){
		accessoriesDiv = "inline_additional_accessories_container";
	}else{
		accessoriesDiv = "tabTwo";
	}
	
	$("#"+accessoriesDiv).html(nonAccTable);


	$('.ui-dialog-buttonpane').prepend('<span class="footerPopupText">Please scroll to review the complete list of accessories on this form.</span>');
	$('.ui-dialog').tabs();

	<%-- //refine //fix Move to ui:dialog so that items can be form present --%>
	$('#fittingsDialog').parent().appendTo($("form:first"));




	function initFactoryDetailOptions(){
		if ($("#${go:nameFromXpath(xpathType)}").val() != "") {

			if (resetCar) {
				resetSelectedNonStdAcc();
				<%--
				car.vehicleSelect.data.redbookCode  = "";
				we used to clear our 'loaded' data model, but why not just check if there was a reset flag 'resetCar' - see NOTE1 and NOTE2 comment flags below.
				TODO: FIXME: Also, Chrome on Mac seems to not have resetCar set because of the click event not being set which tracks if a reset should happen.
				--%>
			}

			standardFeatures();
			stdAccObj = new standardAccessories();

			// Tab 1
			factOptObj = new factoryOptions($("#${redbookCode}").val());

			if(inlineMode == true){
				$("#${options_fitted_inline}").hide();
				$("#inline_factory_options_container").html(factOptObj.options);
				$("#nonStdTblWrapper").css('height','auto');

				$("#${standard_desc_inline}").show();

				$("#inline_factory_standard_container").html(stdAccObj.accessories);

			}else{
				$("#tabOneTitle").html("<span id='tabTitleText'>Are any of the following options fitted?</span>");
				$("#tabOne").html(factOptObj.options);
				$("#tabOneTitle, #tabOne").show();

				// Tab 2
				$("#tabTwoTitle").html("<span id='tabTitleText'>Additional Accessories</span>");

				// Tab 3
				$("#tabThreeTitle").html("<span id='tabTitleText'>Click here to view factory options fitted as standard with your car</span>");
				$("#tabThree").html(stdAccObj.accessories);

				$('.ui-dialog').tabs("select", 0);
				$("#tabTwoTitle, #tabTwo").hide();

				fittingsDialog.dialog({
					close: function() {
						factoryOptionToggle();
					}
	});

				// NOTE1
				if (resetCar && factOptObj.options.length > 0) {
					$("#helpToolTip").fadeOut(300);
					fittingsDialog.open();
				}
			}

			$('#nonStdHdrRow').corner("keep");

			<%-- Also set the vehicle value into the hidden fields for a redbook item --%>
			// Set the vehicle value
			var v=$(car.vehicleSelect.fields.type).find(":selected").attr("rel");
			$("#${marketValue}").val(v);

			var m=$(car.vehicleSelect.fields.type).find(":selected").html();
			$("#${variant}").val(m);

			// NOTE2
			if (resetCar && factOptObj.options.length == 0) {
				resetSelectedNonStdAcc();
			}

		}
	}

	function showFactoryDetailOptions(){

		if(inlineMode == true){

			$("#${options_fitted_inline}").show();

		}else{

			$(".custom-dialog-titlebar").html("Select whether the car has any factory/dealer options fitted (even if they were purchased with the car). Insurers use this information to calculate the value of the car.");
			$("#tabTwoTitle, #tabTwo").hide();
			$("#tabOneTitle, #tabOne").show();
			$("#tabOneTitle").click();
			$('.ui-dialog').tabs("select", 0);

			fittingsDialog.dialog({
				close: function() {
					factoryOptionToggle();
				}
			});

			fittingsDialog.open();
		}

		$("#helpToolTip").fadeOut(300);

	}

	function hideFactoryDetailOptions(){

		if(inlineMode == true){
			$("#${options_fitted_inline}").hide();
		}

		$('#quote_vehicle_factoryRow_row_legend').html('No factory options fitted');
		$('input[id="quote_vehicle_factoryOptions_N"]').attr({checked: true});
		$('input[name="quote_vehicle_factoryOptions"]').button("refresh").trigger("change");
		$('.${factoryOption}').each(function(){
			$(this).attr('checked', false);
		});
	}


	function showAdditionalAccessoriesOptions(){
		if ($("#${go:nameFromXpath(xpathType)}").val() == "") {
			QuoteEngine.validate();
			resetSelectedNonStdAcc();
		} else if($("#${variant}").val() != '') {
			if(inlineMode == true){
				$("#${accessories_fitted_inline}").show();
			}else{
				$(".custom-dialog-titlebar").html("Select whether the car has any additional accessories fitted (even if they were purchased with the car). Insurers use this information to calculate the value of the car.");
				$("#tabOneTitle, #tabOne").hide();
				$("#tabTwoTitle, #tabTwo").show();
				$("#tabTwoTitle").click();
				$('.dialog-tab-container').tabs("select", 1);
				fittingsDialog.dialog({
					beforeclose: function() {
						if (validateSelected()) {
							standardAccessoriesToggle($(".nonStdAccChkBox:checked").length);
							return true;
						} else {
							return false;
						}
					}
				});

				fittingsDialog.open();

			}

			$("#helpToolTip").fadeOut(300);

		}

	}

	function hideAdditionalAccessoriesOptions(){

		if(inlineMode == true){
			$("#${accessories_fitted_inline}").hide();
		}

		$("#quote_vehicle_accessories_N").queue(function(next) {
			log("FIRST");
			resetSelectedNonStdAcc();
			next();

		}).delay(100).queue(function(next) {

			if ($("#${go:nameFromXpath(xpathType)}").val() != "") {
				log("SECOND");
				$('input[id="quote_vehicle_accessories_N"]').attr({checked: true});
				$('input[name="quote_vehicle_accessories"]').button('refresh').trigger("change");
				$('#quote_vehicle_nonStandardRow_row_legend').html('No additional accessories fitted');
			}
			next();

		});
	}

</go:script>


