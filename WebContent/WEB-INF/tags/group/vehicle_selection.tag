<%@ tag language="java" pageEncoding="ISO-8859-1" %>
<%@ tag description="Group for vehicle selection"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" 		required="true"	 rtexprvalue="true"	 description="field group's xpath" %>

<%-- VARIABLES --%>
<c:set var="name" 			value="${go:nameFromXpath(xpath)}" />
<c:set var="firstTwo" 		value="${name}_firstTwo" />
<c:set var="modelRow" 		value="${name}_modelRow" />
<c:set var="typeRow" 		value="${name}_typeRow" />
<c:set var="nonStandardRow" value="${name}_nonStandardRow" />
<c:set var="factoryRow" 	value="${name}_factoryRow" />
<c:set var="factoryOption"  value="${name}_factoryOption" />

<%-- HTML --%>
<div id="${name}-selection">
	<form:fieldset legend="Identify the car you wish to insure" id="${name}_selection" helpId="3">
	
		<form:row label="Year of manufacture" id="${name}_yearRow">
			<field:vehicle_year xpath="${xpath}/year" required="true" className="${firstTwo}"/>	
		</form:row>
		
		<form:row label="Make of car" id="${name}_makeRow">
			<field:make_select xpath="${xpath}/make" title="vehicle manufacturer" type="make" className="${firstTwo}" required="true" />	
			<field:hidden xpath="${xpath}/makeDes"></field:hidden>
		</form:row>
		
		<form:row label="Model" id="${modelRow}">
			<field:general_select xpath="${xpath}/model" title="vehicle model" type="model" required="false"/>
			<field:hidden xpath="${xpath}/modelDes"></field:hidden>	
		</form:row>

		<form:row label="Body">
			<field:general_select xpath="${xpath}/body" title="vehicle body" type="body" required="true" />	
		</form:row>
		
		<form:row label="Transmission">
			<field:general_select xpath="${xpath}/trans" title="vehicle transmission" type="trans" required="true" />	
		</form:row>
		
		<form:row label="Fuel">
			<field:general_select xpath="${xpath}/fuel" title="fuel type" type="fuel" required="true" />
		</form:row>

		<form:row id="${typeRow}" label="Type" className="quote_vehicle_redbookCodeRow">
			<field:general_select xpath="${xpath}/redbookCode" title="vehicle type" type="type" required="false" className="vehicleDes"/>	
			<field:hidden xpath="${xpath}/marketValue"></field:hidden>
			<field:hidden xpath="${xpath}/variant"></field:hidden>
		</form:row>
	</form:fieldset>
	
	<form:fieldset legend="Factory/dealer options and non-standard accessories">
		<form:row label="Does the car have any factory/dealer options fitted?" id="${factoryRow}" helpId="13">
		<field:array_radio xpath="quote/vehicle/factoryOptions"
						   required="false"
						   className="car_factory_options" 
						   items="Y=Yes,N=No"
						   id="car_factory_options"
						   title="if the vehicle has any factory/dealer options fitted"/>
		</form:row>
		<form:row label="Does the car have non-standard accessories fitted?" id="${nonStandardRow}" helpId="4">
			<field:array_radio xpath="quote/vehicle/accessories"
							   required="true"
							   className="car_accessories" 
							   items="Y=Yes,N=No"
							   id="car_accessories"
							   title="if the vehicle has any non-standard accessories fitted"/>
		</form:row>
	</form:fieldset>	
</div>

<%-- CSS --%>
<div id="dialog">
	<div id="dialog_info">
		<ul id="dialog_tabs">
			<div id="dialogClose"></div>
			<li><a href="#tabOne" id="tabOneTitle"></a></li>
			<li><a href="#tabTwo" id="tabTwoTitle"></a></li>
			<li><a href="#tabThree" id="tabThreeTitle"></a></li>			
		</ul>
		<div id="dialog_content">
			<div id="tabOne"></div>
			<div id="tabTwo"></div>
			<div id="tabThree"></div>			
		</div>
	</div>
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
	#nonStdTblWrapper {position: relative; width:605px; *width:590px; height:260px; overflow:auto; padding:0; margin-top:12px; }
	.nonStdErrMsg {background: #EFEFEF url(common/images/nonStdErrMsg.gif) no-repeat scroll 330px 0px;}
	*tr.nonStdErrMsg td {background: #EFEFEF; }
	*tr.nonStdErrMsg td.nonStdInc {background-image: url(common/images/nonStdErrMsg.gif) no-repeat scroll 86px 1px;}
	*tr.nonStdErrMsg td.nonStdPrc {background-image: url(common/images/nonStdErrMsg.gif) no-repeat scroll -87px 1px;}
	*tr.nonStdErrMsg td.nonStdSpc {background-image: url(common/images/nonStdErrMsg.gif) no-repeat scroll -217px 1px;}
	#tabTitleText { position: relative; color: #4a4f51; }
	#quote_vehicle_factoryOption { font-size: 13px; }
	#dialogClose { background: url(common/images/dialog/close.png) no-repeat; width: 36px; height: 34px; position: absolute; top: -34px; left: 608px; cursor: pointer; display: none;}
	#nonStdHdrTop { border-bottom: 1px solid #F4A97F; padding-top: 18px; *padding-top: 0px; padding-bottom: 3px; z-index:60; margin-top:-18px;  }
	#nonStdHdrTop div { display: inline-block; vertical-align: top; height: 32px; padding-top: 3px;zoom:1;*display: inline;}
	#tabTwo {padding-bottom:0px}
	.vehicleDes { font-size: 12px; width: 400px; margin-bottom: 10px; }
	#productInfoFooter { display:none;}
	.ui-dialog-buttonset .ui-button { display: none !important;}

</go:style>

<%-- JAVASCRIPT --%>
<go:script href="common/js/car/nonStandardAcc.js" marker="js-href" />
<go:script href="common/js/car/dialog_controller.js" marker="js-href" />
<go:script href="common/js/utils.js" marker="js-href" />

<go:script marker="onready">

	$pleaseChooseOption = "<option value=''>Please choose...</option>";
	$notFoundModel = "<option value=''> No Models Found</option>";

	<%-- Initial: Hide model if not yet selected - Removed --%>
	<c:set var="xpathModel" value="${xpath}/model" />	

	<c:set var="xpathType" value="${xpath}/redbookCode" />	
	<c:if test="${data[xpathType] == null || data[xpathType] == ''}">
		$("#${factoryRow}").hide();
	</c:if>

	<c:set var="nonStanardAccessories" value="${xpath}/accessories" />

	<c:set var="year" value="${go:nameFromXpath(xpath)}_year" />
	<c:set var="trans" value="${go:nameFromXpath(xpath)}_trans" />
	<c:set var="make" value="${go:nameFromXpath(xpath)}_make" />
	<c:set var="makeDes" value="${go:nameFromXpath(xpath)}_makeDes" />
	<c:set var="fuel" value="${go:nameFromXpath(xpath)}_fuel" />
	<c:set var="body" value="${go:nameFromXpath(xpath)}_body" />
	<c:set var="bodyDes" value="${go:nameFromXpath(xpath)}_bodyDes" />
	<c:set var="model" value="${go:nameFromXpath(xpath)}_model" />
	<c:set var="modelDes" value="${go:nameFromXpath(xpath)}_modelDes" />
	<c:set var="redbookCode" value="${go:nameFromXpath(xpath)}_redbookCode" />
	<c:set var="marketValue" value="${go:nameFromXpath(xpath)}_marketValue" />
	<c:set var="variant" value="${go:nameFromXpath(xpath)}_variant" />
	<c:set var="pleaseChoose" value="<option>Please choose...</option>" />

	$model = "${data[xpathModel]}";
	$type  = "${data[xpathType]}";
	
	var resetCar = false;
	$("#${typeRow}, #${modelRow}, .${firstTwo}").click(function(){
		resetCar = true;
	});
	aih.xmlAccData = '${data.xml["quote/accs"]}';

	
	<%-- Interactive: Hide model if not yet selected --%>

	$(".${firstTwo}").change(function(){

		<%-- Clear Subsequent Selects first --%>
		$("#${model}").html('${pleaseChoose}');
		$("#${body}").html('${pleaseChoose}');		
		$("#${trans}").html('${pleaseChoose}');
		$("#${fuel}").html('${pleaseChoose}');
		
		// Check if all of the first two have been selected 
		var allSelected = true;
		$(".${firstTwo}").each(function(){
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
					if(resetCar) {
						resetSelectedNonStdAcc();
					}
		        }, 
		       async: false,
		       timeout: 30000,
			   data:{"car_year":$("#${year}").val(), 
			         "car_manufacturer":$("#${make}").val()},
			   success: function(data){
			   	 var options = $pleaseChooseOption;
			   	 if ($(data).find("model").length==0) { options = $notFoundModel; }
			   	 
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
	

	
	<%-- Model Row Selection --%>
	
	$("#${modelRow}").change(function(){
	
		<%-- Clear Subsequent Selects first --%>
		$("#${body}").html('${pleaseChoose}');
		$("#${trans}").html('${pleaseChoose}');
		$("#${fuel}").html('${pleaseChoose}');
		
		$("#${go:nameFromXpath(xpathType)}").html($pleaseChooseOption);	
		
		if($("#${go:nameFromXpath(xpathModel)}").val() != "") {
			var mdlDes=$("#${model}").find(":selected").html();
			$("#${modelDes}").val(mdlDes);
			<%-- Ajax: Get list of varients --%>
			$.ajax({
				url: "ajax/xml/car_body.jsp",
				async: false,
				data: {"car_year":$('#${year}').val(), 
					   "car_manufacturer":$('#${make}').val(), 
					   "car_model":$('#${model}').val()}, 
				success: function(data){
					var bodyType = '';
					var lastVal;
					$(data).find("body").each(function() {
						bodyType += "<option value='" + $(this).attr("value") + "'>" + $(this).text() + "</option>";
						lastVal = $(this).attr("value");
					});
					$("#${body}").html(bodyType);
					if($(data).find("body").length<=2){
						$("#${body}").val(lastVal);
						$("#${body}").change();
					}
				}
			});
		}
	});

	<%-- Body type Row Selection --%>
	
	$("#${body}").change(function(){
	
		<%-- Clear Subsequent Selects first --%>
		$("#${trans}").html('${pleaseChoose}');
		$("#${fuel}").html('${pleaseChoose}');
		
		$("#${go:nameFromXpath(xpathType)}").html($pleaseChooseOption);	
		
		if($("#${go:nameFromXpath(xpathModel)}").val() != "") {
			var mdlDes=$("#${model}").find(":selected").html();
			$("#${modelDes}").val(mdlDes);
			<%-- Ajax: Get list of varients --%>
			$.ajax({
				url: "ajax/xml/car_transmission.jsp",
				async: false,
				data: {"car_year":$('#${year}').val(), 
					   "car_manufacturer":$('#${make}').val(), 
					   "car_model":$('#${model}').val(),
					   "car_body":$('#${body}').val()}, 
				success: function(data){
					var transmissions = '';
					var lastVal;
					$(data).find("trans").each(function() {
						transmissions += "<option value='" + $(this).attr("value") + "'>" + $(this).text() + "</option>";
						lastVal = $(this).attr("value");
					});
					$("#${trans}").html(transmissions);
					if($(data).find("trans").length<=2){
						$("#${trans}").val(lastVal);
						$("#${trans}").change();
					}
				}
			});
		}
	});


	<%-- Transmission Selection --%>

	$("#${trans}").change(function(){
		$("#${go:nameFromXpath(xpathType)}").html($pleaseChooseOption);	
	
		if ($("#${go:nameFromXpath(xpathModel)}").val() != "") {
			var mdlDes=$("#${model}").find(":selected").html();
	   		$("#${modelDes}").val(mdlDes);
			<%-- Ajax: Get list of varients --%>
			$.ajax({
			   url: "ajax/xml/car_fuel_type.jsp",
			   async: false,
			   data: {"car_year":$('#${year}').val(), 
					   "car_manufacturer":$('#${make}').val(), 
					   "car_model":$('#${model}').val(), 
					   "car_body":$('#${body}').val(),
					   "car_transmition":$('#${trans}').val()},

			   	success: function(data){
			   	 var fuels = '';
			   	 var lastVal;
			     $(data).find("fuel").each(function() {
					  fuels += "<option value='" + $(this).attr("value") + "'>" + $(this).text() + "</option>";
					  lastVal = $(this).attr("value");
				 });
				 $("#${fuel}").html(fuels);
				 if($(data).find("fuel").length<=2){
				 	$("#${fuel}").val(lastVal);
					$("#${fuel}").change();
				 }
			   }
			 });			 
		}
	});		
	
	
	<%-- Fuel Type Selection --%>
	
	$("#${fuel}").change(function(){
		$("#${go:nameFromXpath(xpathType)}").html($pleaseChooseOption);	
	
		if ($("#${go:nameFromXpath(xpathModel)}").val() != "") {
			var mdlDes=$("#${model}").find(":selected").html();
	   		$("#${modelDes}").val(mdlDes);
			<%-- Ajax: Get list of varients --%>		
			$.ajax({
			   url: "ajax/xml/car_variant.jsp",
			   async: false,
			   data:{"car_year":$("#${year}").val(), 
			         "car_manufacturer":$("#${make}").val(),
			         "car_fuel":$("#${fuel}").val(),
			         "car_transmition":$("#${trans}").val(),
			         "car_body":$('#${body}').val(),
			         "car_model":$("#${model}").val()},
			         
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
	
	<%-- Vehicle Variant Selection --%>

	$("#${typeRow}").change(function(){
		if ($("#${go:nameFromXpath(xpathType)}").val() != "") {
			if (resetCar) {
		   		resetSelectedNonStdAcc();
		   		$type  = "";
		   	} 
		   	// Tab 1
			factOptObj = new factoryOptions($("#${redbookCode}").val());
			
			$("#tabOneTitle").html("<span id='tabTitleText'>Factory/dealer options</span>");
			$("#tabOne").html(factOptObj.options);	
			$("#tabOneTitle, #tabOne").show();

			// Tab 2
			$("#tabTwoTitle").html("<span id='tabTitleText'>Non Standard Accessories</span>");	

			// Tab 3
			stdAccObj = new standardAccessories();	
			$("#tabThreeTitle").html("<span id='tabTitleText'>View accessories/options fitted as standard</span>");
			$("#tabThree").html(stdAccObj.accessories);

 			$('#dialog').dialog({
   				close: function() { 
   					factoryOptionToggle(); 
   				}   				
			});		
				
			$('#dialog').dialog("option", "show", "clip");
			$('#dialog').dialog("option", "hide", "clip");
				
			$('#dialog_info').tabs("select", 0);
			$("#tabTwoTitle, #tabTwo").hide();

			if ($type=="" && factOptObj.options.length > 0) {
				$("#helpToolTip").fadeOut(300);
				$('#dialog').dialog("open");				
			}	
	   		
	   		$('#nonStdHdrRow').corner("keep");
	   		
	   		// Set the vehicle value
	   		var v=$(this).find(":selected").attr("rel");
	   		$("#${marketValue}").val(v);
	   		
	   		var m=$(this).find(":selected").html();
	   		$("#${variant}").val(m);
	   		if ($type=="" && factOptObj.options.length == 0) {
	   			resetSelectedNonStdAcc();
			}
		   		
		} 	
	});		


	//
	// FACTORY OPTIONS DIALOG WINDOW CLICK
	//	
	$("#quote_vehicle_factoryOptions_Y").click(function(){		
		$("#tabTwoTitle, #tabTwo").hide();
		$("#tabOneTitle, #tabOne").show();
		$("#tabOneTitle").click();			
		$('#dialog_info').tabs("select", 0);		
		$('#dialog').dialog({
   			close: function() {
   				factoryOptionToggle();
   			},
			open: function(){
				$("#dialogClose").css("display","block");
			}
		});			
		$("#helpToolTip").fadeOut(300);
   		$('#dialog').dialog('open');
   		
	});

	$("#quote_vehicle_factoryOptions_N").click(function(){		
		$('#quote_vehicle_factoryRow_row_legend').html('No factory options fitted'); 	
		$('input[id="quote_vehicle_factoryOptions_N"]').attr({checked: true});
		$('input[name="quote_vehicle_factoryOptions"]').button("refresh");
		$('.${factoryOption}').each(function(){
			$(this).attr('checked', false);
		});	
	});

	//
	// NON STANDARD ACCESSORIES DIALOG WINDOW CLICK
	//
	$("#quote_vehicle_accessories_Y").click(function(){
		if ($("#${go:nameFromXpath(xpathType)}").val() == "") {
	   		resetSelectedNonStdAcc();
		} else {
		
			$("#tabOneTitle, #tabOne").hide();	
			$("#tabTwoTitle, #tabTwo").show();
			$("#tabTwoTitle").click();
			$('#dialog_info').tabs("select", 1);
			$('#dialog').dialog({
				open: function(){
					$("#dialogClose").css("display","block");
				},
	   			beforeclose: function() {
	   				
		   				if (validateSelected()) {
		   					standardAccessoriesToggle($(".nonStdAccChkBox:checked").length);
		   					return true;
		   				} else {
		   					return false;
		   				}
		   			},
	   			close: function(){ 
	   				$("#dialogClose").css("display","none");	   				
	   			}   				
			});
			$("#helpToolTip").fadeOut(300);
		   	$('#dialog').dialog('open');
		   	
		}			   	
	});
	
	$("#quote_vehicle_accessories_N").click(function(){

		$("#quote_vehicle_accessories_N").queue(function(next) {
			log("FIRST");
			resetSelectedNonStdAcc();	
			next();

		}).delay(100).queue(function(next) {
	
			if ($("#${go:nameFromXpath(xpathType)}").val() != "") {
			   	log("SECOND");
		   	   	$('input[id="quote_vehicle_accessories_N"]').attr({checked: true});	 	
		   		$('input[name="quote_vehicle_accessories"]').button('refresh');
			   	$('#quote_vehicle_nonStandardRow_row_legend').html('No non-standard accessories fitted');  
			}
			next();
		
		});
   	   	
	});	
	//
	// FACTORY OPTIONS
	//
	function factoryOptions(redbookCode) {	
		var xmlData = 	
		$.ajax({
	   		url: "ajax/xml/car_options.jsp",
	   		async: false,
	   		data: "redbookCode=" + redbookCode
	   	}).responseXML;
	   		   	
		var predata = "<b>Does the car have any factory/dealer options fitted?</b><br><br>";
		var factoryOptionsData = "";

		$(xmlData).find("factoryOption").each(function(index) {
		 	  var code = $.trim($(this).attr("optionCode"));
		 	  var sel = "";
			  $(aih.xmlOptData).find("text").each(function() {
				  if ( code == $.trim($(this).text())) {
						sel=" checked";
			      }
		      });
		 	  factoryOptionsData += "<input type='checkbox' name='quote_opts"+twoDigits(index)+"_opt' value='" + code + "'" + sel + " class='${factoryOption}'>" + $.trim($(this).text()) + "<br>";
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
		$('input[name="quote_vehicle_factoryOptions"]').button('refresh');		
	}

	// 
	// STANDARD ACCESSORIES
	//
	function standardAccessories() {	
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
			if (stdAccCount == 1) data += "<tr>";
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
			$('#quote_vehicle_nonStandardRow_row_legend').html(n + ' non-standard accessor' + ((n>1)?'ies':'y') + ' fitted');
		} else {
			$('#quote_vehicle_nonStandardRow_row_legend').html();
		}
	}
	
	
	var nonAccTable = getNonAccTable();

	$("#tabTwo").html(nonAccTable);
	
	// Call this to auto complete car selection on page redisplay
	$(".${firstTwo}").change();

	$('.ui-dialog-buttonpane').append('<a id="dialog_car_ok"><span>Ok</span></a>');
	$("#dialogClose, #dialog_car_ok").click(function(){
		$('#dialog').dialog('close');
	});
</go:script>


