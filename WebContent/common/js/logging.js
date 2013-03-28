Date.prototype.getISOTime = function() {
	var hours = this.getHours();
	var minutes = this.getMinutes();
	var seconds = this.getSeconds();
	var seconds = this.getSeconds();
	var milliseconds = this.getMilliseconds();
	if (minutes < 10){
		minutes = "0" + minutes;
	}
	if (seconds < 10){
		seconds = "0" + seconds;
	}
	var result = hours + ":" + minutes + ":" + seconds + ":" + milliseconds + "&nbsp;";
	return result;
};

function log(data){
	return;
	var d = new Date(),
		logObj = document.getElementById("log");

	if ( logObj == null ) {
		logObj = document.createElement("DIV");
		logObj.id = "log";	// old IE
		logObj.setAttribute("id", "log");
		var logObjStyle = "display:none; text-align:left;left-margin:2px; right-margin:2px; font-size:10px;font-family:arial;position:absolute;top:0px;left:0px;width:150px;height:800px;background-color:white;border:1px solid black;";
		if ( logObj.style.setAttribute ) {
			logObj.style.setAttribute("cssText", logObjStyle);
		} else {
			logObj.setAttribute("style", logObjStyle);
		}
		logObj.innerHTML = "<a href='javascript:clearLog()'>Clear Log<" + "/a>|<a href='javascript:hideLog()'>Hide<" + "/a><br>";
		document.body.insertBefore(logObj, document.body.firstChild);
	}

	logObj.innerHTML = 	document.getElementById("log").innerHTML + d.getISOTime() + ": " + data + "<br>";
	//return;
}
function clearLog(){
	document.getElementById("log").innerHTML="<a href='javascript:clearLog()'>Clear Log</a>|<a href='javascript:hideLog()'>Hide Log</a><br>";
}
//clearLog();
function hideLog(){
	$("#log").hide()
}
