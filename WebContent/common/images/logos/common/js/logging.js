document.write("<div id='log' style='display:none; text-align:left;left-margin:2px; right-margin:2px; font-size:10px;font-family:arial;position:absolute;top:0px;left:0px;width:150px;height:800px;background-color:white;border:1px solid black;'><a href='javascript:clearLog()'>Clear Log</a>|<a href='javascript:hideLog()'>Hide</a><br></div>");

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
	var d = new Date();
	document.getElementById("log").innerHTML = 	document.getElementById("log").innerHTML + d.getISOTime() + ": " + data + "<br>";
	//return;
}
function clearLog(){
	document.getElementById("log").innerHTML="<a href='javascript:clearLog()'>Clear Log</a>|<a href='javascript:hideLog()'>Hide Log</a><br>";
}
//clearLog();
function hideLog(){
	$("#log").hide()
}
