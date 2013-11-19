<%@ tag language="java" pageEncoding="UTF-8" %>

<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<%@ attribute name="className" 		required="false"  rtexprvalue="true" description="Custom Class to apply to the container" %>
<%@ attribute name="xpath" 			required="true"  rtexprvalue="true" description="Set the xpath base" %>


<%-- HTML --%>

 	<strong>Please enter the cars' registration number</strong>
	<form:row label="Car Registration Number" className="wide_label">
		<field:input_alphanumeric xpath="quote/avea/regoNumber" maxlength="10" title="Car Registration Number" required="true"></field:input_alphanumeric>
	</form:row>

	<div class="mt10"></div>
	
	<strong class="wider_label fleft">Please confirm your vehicles' modification</strong><core:clear />

	<div class="mods_left">
		<input type="text" id="aveaMods" name="aveaMods" />
		<core:clear />
	</div>
	<div class="mods_right">
		<div class="col3">
			<field:checkbox required="false" title="Body Kit" label="true" xpath="${xpath}/bodyKit" value="1" className="mod" /><br />
			<field:checkbox required="false" title="Engine Modification" label="true" xpath="${xpath}/engineMod" value="1" className="mod" /><br />
		</div>
		<div class="col3">
			<field:checkbox required="false" title="Lowered Suspension" label="true" xpath="${xpath}/loweredSuspension" value="1" className="mod" /><br />
			<field:checkbox required="false" title="Lowered Chassis" label="true" xpath="${xpath}/loweredChassis" value="1" className="mod" />
			<core:clear />
		</div>
		<div class="col3">
			<field:checkbox required="false" title="Extractor" label="true" xpath="${xpath}/extractor" value="1" className="mod" />
			<core:clear />
		</div>
		<core:clear />
		<div class="other_label">
			<field:checkbox required="false" title="Other" label="true" xpath="${xpath}/other" value="1" className="mod" />
		</div>
		<div class="other_content">
			<field:input required="false" title="Specify Other" xpath="${xpath}/otherModification" maxlength="200" /><br />
			<div class="dollar_sign">$</div>
			<core:clear />
		</div>
		
		<form:row label="" helpId="227" className="mls">
			<field:input required="false" title="Specify Other Value" xpath="${xpath}/otherModificationValue" className="value_input" maxlength="10" />
		</form:row>
		
		<core:clear />
	</div>

	<core:clear />


<%-- STYLES --%>
<go:style marker="css-head">
	.col3{
		margin-top:5px;
		width:32%;
		float:left;
		position:relative;
		line-height:28px;
	}
	.other_label{
		line-height:28px;
		float:left;
		width:70px;
	}
	.other_content{
		margin-top:6px;
		line-height:28px;
		float:left;
		width:275px;
		position:relative;
	}
	.other_message{
		width:145px;
		position:relative;
		bottom:5px;
		float:right;
		margin-right:10px;
		font-size:10px;
		line-height:12px;
		height:45px;
		margin-top:8px;
	}
	.other_content input{margin-bottom:7px;}
	.dollar_sign{
		width:10px;
		text-align:right;
		position:absolute;
		bottom:-25px;
		left:-14px;
	}
	.mods_left{width:320px;float:left;margin-top:-20px;}
	.mods_right{width:500px;float:right;margin-top:-20px;}
	.mods_left input{width:1px;height:1px;color:#fff;border:none;background-color:#fff;margin:0;padding:0;margin-left:10px;}
	.fleft{float:left;}
	.mt10{margin-top:10px;}
	.value_input{width:80px;}
	.mod_help{float:right;}
	.help_c{width:24px; height:24px;margin:0; float:right;}
	.mls{margin-left:-68px;}
</go:style>


<%-- JAVASCRIPT ONREADY --%>
<go:script marker="onready">
	<c:set var="nameBase" value="${go:nameFromXpath(xpath)}" />
	$.validator.addMethod("otherMod",
		function(value, elem, parm) {
			if($('#${nameBase}_other').is(':checked') && $('#${nameBase}_otherModification').val() == ''){
				return false;
			}else{return true;}
		}, ""
	);
	$.validator.addMethod("otherModValue",
		function(value, elem, parm) {
			if($('#${nameBase}_other').is(':checked') && $('#${nameBase}_otherModificationValue').val() == ''){
				return false;
			}else{return true;}
		}, ""
	);
	$.validator.addMethod("mustSelectMod",
		function(value, elem, parm) {
			if($('.mod:checked').length<1){
				return false;
			}else{return true;}
		}, ""
	);
	$('#quote_avea_modifications_otherModificationValue').numeric();
	
	$('#${nameBase}_otherModification').focus(function(){
		$('#${nameBase}_other').attr('checked', true);
	});
	$('#${nameBase}_otherModificationValue').focus(function(){
		$('#${nameBase}_other').attr('checked', true);
	});
	$('#${nameBase}_other').change(function(){
		if($('#${nameBase}_other').is(':unchecked')){
			$('#${nameBase}_otherModification').val('');
			$('#${nameBase}_otherModificationValue').val('');
		}
	});
	
</go:script>

<%-- VALIDATION --%>
<go:validate selector="${go:nameFromXpath(xpath)}_otherModification" rule="otherMod" parm="true" message="Please describe the 'other' modification" />	
<go:validate selector="${go:nameFromXpath(xpath)}_otherModificationValue" rule="otherModValue" parm="true" message="Please specify the 'other' modifications' value" />	
<go:validate selector="aveaMods" rule="mustSelectMod" parm="true" message="You previously advised you had modifications on this vehicle. If this is incorrect please <a href='javascript:window.close();'>revise your quote</a>." />	



