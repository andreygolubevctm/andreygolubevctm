var aAcc=["CAD","Additional Seats (Max 2)",250,3000,100,"CD0","Air Compressor",75,900,25,"CB","Air Conditioner",500,6000,100,"CA","Airbag(S)",250,3000,50,"CC","Alloy Standard Size",250,3000,100,"C&amp;amp;","Amplifier",125,1500,50,"C8","Boot Speakers",125,1500,50,"CE","Brakes Anti Skid or Lock (ABS)",350,4200,100,"CF","Bull Bar",200,2400,50,"C#","Camper Added",125,1500,50,"C7","Canopy",600,7200,100,"C/","Cargo Barrier",75,900,25,"CG","CB/UHF Radio",500,6000,100,"CH","CD/MP3 Player/Stacker",125,1500,50,"C6","Central/Remote Locking",125,1500,50,"C{","Child Seats",50,600,25,"CI","Cruise Control",100,1200,50,"C@","Dual Fuel Tanks (No Lpg)",125,1500,50,"CD1","Dual Batteries",62,750,25,"CQ","Dual Fuel/Lpg Conversion",500,6000,100,"CAI","DVD Player",250,3000,100,"CD7","Electric Brakes / Trailer Controls",187,2250,50,"C_","Fabric Protection",125,1500,50,"CL","Fog/Driving Lights",75,900,25,"C0","Free Wheel Hubs",125,1500,50,"CAJ","GPS / Satellite Navigation",625,7500,100,"C*","Graphic Equaliser",125,1500,50,"CD3","Ladder Racks",187,2250,50,"CAE","Leather Interior",1000,12000,100,"CO","Locking Nuts",12,150,25,"C!","Long Range Tank",125,1500,50,"CK","Mobile Phone Kit (Fixed/Hardwired)",175,2100,50,"CAB","Non Standard Alloy Wheels",500,6000,100,"CN","Nudge Bar",87,1050,50,"C2","Nudge Bar Rear",75,900,25,"C=","Paint Protection",125,1500,50,"CAC","Paint Signwriting",625,7500,100,"CT","Plastic Covers",12,150,25,"C%","Plastic Shield(S)",50,600,25,"CR","Power Windows",187,2250,50,"CS","Radio Cassette",37,450,25,"CM","Rear Lamp",12,150,25,"CAA","Rear Spoiler or Aerofoil",62,750,25,"CAF","Reversing Sensors / Camera",200,2400,50,"CJ","Roll Bar (Utility)",175,2100,50,"CV","Roof Rack",75,900,25,"C-","Rust Protection",125,1500,50,"CW","Seat Covers",25,300,25,"CD4","Shelving/Storage",375,4500,100,"C9","Snorkel",125,1500,50,"CD2","Spare Wheel Cover",62,750,25,"CY","Sports Steering Wheel",25,300,25,"C3","Step Up",100,1200,50,"CD9","Stereo/Entertainment System",500,6000,100,"CZ","Sunroof",450,5400,100,"CAK","Television",187,2250,50,"CAG","Tonneau Cover (Soft or Hard)",250,3000,100,"C1","Tow Bar / Tow Pack",100,1200,50,"C}","Tray Top",425,5100,100,"CAH","Ute Liner",125,1500,50,"C4","Winch",452,5430,50,"CU","Window Louvre/Shade",20,240,25,"C5","Windows Tinted",62,750,50];

function resetSelectedNonStdAcc(t){
	var dur = (t)?t:100;
	// Having the timeout here stops IE from holding its breath until its finished doing all its tasks
	setTimeout(function(){
		for (var i=0; i < (aAcc.length/5); i++) {
			$('input[name=quote_accs_acc'+twoDigits(i)+'_sel]').attr('checked', false);
			$('input[name=quote_accs_acc'+twoDigits(i)+'_inc]').attr('checked', false);
			$("#cell_"+twoDigits(i)+"_inc").html("");
			$("#cell_"+twoDigits(i)+"_prc").html("");
		}
		$('input[name="quote_vehicle_accessories"]').attr({checked: false});
		$('#quote_vehicle_nonStandardRow_row_legend').html('');
		$('input[name="quote_vehicle_accessories"]').button('refresh');
	}, dur);
}

function validateSelected(){
	var allValid = true;


	for (var i=0; i < (aAcc.length/5); i++) {
		var rowNum=twoDigits(i);

		var selChk = $('input[name=quote_accs_acc'+rowNum+'_sel]').is(':checked');

		if ($('input[name=quote_accs_acc'+rowNum+'_sel]').is(':checked')){

			var incChk = $('input[name=quote_accs_acc'+rowNum+'_inc]').is(':checked');

			if (!incChk){

				var $theRow = $('#nonStdRow_'+rowNum);
				if (!($theRow.hasClass('nonStdErrMsg'))) {
					var errorBubble = "<div class='errMsgGraphic'>&nbsp;</div>";
					$theRow.addClass("nonStdErrMsg").find(".nonStdInc div").prepend(errorBubble);
				}

				var topPos = (24 * rowNum) - 24;
				topPos = Math.max(topPos,0);
				$("#tabTwoTitle").click();
				$("#nonStdTblWrapper").scrollTo(topPos, 800);
				return false;

			}
		}
	}

	if ($(".nonStdAccChkBox:checked").length > 0) {
		$('input[id="quote_vehicle_accessories_Y"]').attr({checked: true});
	} else {
		$("#quote_vehicle_accessories_N").click();
	}

	$('input[id="quote_vehicle_accessories"]').button('refresh');
	return true;
}

function getNonAccTable(){
	var altRow=false;

	var nonAccTable = "<div id='nonStdHdrTop'>"
		+ "<div id='nonStdDesHdr'>Accessory</div><div id='nonStdIncHdr'>Included in Purchase<br>Price of Car</div><div id='nonStdPrcHdr'>Accessory Purchase Price</div></div>"
		+ "<div id='nonStdTblWrapper'>"
		+ "<div id='nonStdErrMsg'></div>"
		+ "<table class=data cellspacing=1 cellpadding=0 border=0 id='nonStdHdrRow'>";


	for (var i=0; i < aAcc.length; i+=5){

		var row = twoDigits(i/5);
		var code = aAcc[i];
		var des  = aAcc[i+1];
		var from = aAcc[i+2];
		var to   = aAcc[i+3];
		var incr = aAcc[i+4];
		var isChk = false;
		var prc="";

		$(aih.xmlAccData).children().each(function() {

			if (code==$(this).find("sel").text()) {
				isChk=true;
				prc=$(this).find("prc").text();
			}
		});

		var evt = "onChange='updateRow(\""+row+"\");' onClick='updateRow(\""+row+"\");'";
		nonAccTable+="<tr id='nonStdRow_"+row+"' class='nonStdRow'>";
		var isChecked=(isChk)?"checked":"";
		nonAccTable+="<td class=nonStdDes><input id='acc_"+row+"_chk' type='checkbox' name='quote_accs_acc"+row+"_sel' value='"+code+"' "+evt+" "+isChecked+" class='nonStdAccChkBox'><label for='acc_"+row+"_chk'>"+des+"</label></td>";
		nonAccTable+="<td class=nonStdInc><div id='cell_"+row+"_inc'>";
		if (isChk) {
			nonAccTable+=drawInc(row,isChk,prc);
		}
		nonAccTable+="</div></td>";
		nonAccTable+=	"<td class='nonStdPrc'><div id='cell_"+row+"_prc'>";
		if (isChk && prc > 0) {
			nonAccTable+=drawPrc(row,prc);
		}
		nonAccTable+="</div></td><td class=nonStdSpc></td></tr>";

	}
	nonAccTable += "</table></div>";
	return nonAccTable;
}

function drawPrc(row, curVal){
	var offSet = (row * 5);
	var from   = aAcc[offSet+2];
	var	to	   = aAcc[offSet+3];
	var	incr   = aAcc[offSet+4];
	var r = "";

	if (from > 0 ){
		r=	"<select name=quote_accs_acc"+row+"_prc>";
		var lastValue = 0;
		for (var p = from; p<to; p+=incr){
			r+=	"<option value='"+p+"' " +((p==curVal)?" SELECTED":"")+ ">$" + p;
			lastValue=p;
		}
		if (lastValue<to) r+= "<option value='"+to+"' " + ((to==curVal)?" SELECTED":"") + ">$" + to;
		r+=	"</select>";
	} else {
		r="Not Available";
	}
	return r;
}

function drawInc(row, isChk, curPrc){
	var offSet = (row * 5);
	var from   = aAcc[offSet+2];
	var des	   = aAcc[offSet+1];
	var evt = "onChange='updateRow(\""+row+"\");' onClick='updateRow(\""+row+"\");' ";
	var r = "";

	if (from > 0 ){
		var chkY=(isChk && curPrc == 0)?" CHECKED":"";
		var chkN=(isChk && curPrc >  0)?" CHECKED":"";
		var title="title='Please choose if " + des + " is included in the purchase price of the car'";
		r="<nobr>"
			+"<input type=radio rel='"+row+"' name=quote_accs_acc"+row+"_inc value='Y' " + evt + title + chkY + " id='inc_"+row+"_y' class='required incRow'><label for='inc_"+row+"_y'>Yes</label>"
			+"&nbsp;"
			+"<input type=radio rel='"+row+"' name=quote_accs_acc"+row+"_inc value='N' " + evt + title + chkN + " id='inc_"+row+"_n' class='required incRow'><label for='inc_"+row+"_n'>No</label>"
			+"</nobr>";
	} else {
		r="Not Available";
	}
	return r;
}

function updateRow(row){
	//$(".nonStdErrMsg").removeClass("nonStdErrMsg");
	$('#nonStdRow_'+row).removeClass("nonStdErrMsg").find(".errMsgGraphic").remove();

	var sel  = $('input[name=quote_accs_acc'+row+'_sel]');
	var inc  = $('input[name=quote_accs_acc'+row+'_inc]');
	var prc  = $('input[name=quote_accs_acc'+row+'_prc]');
	var showInc = false;
	var showPrc = false;

	if (sel && $('input[name=quote_accs_acc'+row+'_sel]').is(':checked')) {
		showInc = true;
		if (inc && inc[1] && ($('input:radio[name=quote_accs_acc'+row+'_inc]:checked').val()=="N")) {
			showPrc = true;
		}
	}
	var c1=document.getElementById("cell_" + row + "_inc");
	if (showInc){
		if (c1.innerHTML==""  || c1.innerHTML=="&nbsp;"){
			c1.innerHTML=drawInc(row, false, "");
		}
	} else {
		c1.innerHTML="";
	}

	var c2=document.getElementById("cell_" + row + "_prc");
	if (showPrc) {
		if (c2.innerHTML=="" || c2.innerHTML=="&nbsp;"){
			c2.innerHTML=drawPrc(row, "");
		}
	} else {
		c2.innerHTML="";
	}

	/*var aData  = new Array();
	var idx=0;

	for (var i=0; i<(aAcc.length/5) ;i++){
		var obj=$('input[name=quote_accs_acc'+i+'_sel]');
		if (obj && $('input[name=quote_accs_acc'+(i/5)+'_sel]').is(':checked')){
			aData[idx]=aAcc[(i*5)+1];
			idx++;
		}
	}
	*/

}