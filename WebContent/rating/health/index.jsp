<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Health Rates Upload </title>
<style type="text/css">
body {
	font-family:sans-serif;
	margin:40px;
}
a,button {
	margin:10px;
	text-decoration:none;
	border:1px outset #660000;
	color:white;
	background-color:#B23939;
	padding:4px 6px;
	text-align:center;
	border-radius:0.5em;
	font-size:1em;
	float:left;             
}
label {
	width:100px;
	display:block;
	padding:5px;
	clear:left;
	float:left;
	background-color:#EFEFEF;
	margin-bottom:2px;
}
input {
	float:left;
	margin:4px 10px; 
}
button {
	margin-top:2px;
	margin-left:20px;
}
</style>
</head>
<body>

<h2>CTM Health Product Database Utilities</h2>
<div style="clear:both;height:30px;border-top:1px solid #EFEFEF">
	<form method="GET" action="upload.jsp" target="_new">
		<label for="fundCode">FundId</label><input type="text" name="fundCode" id="fundCode" value="HCF"/>
		<button>Start Upload</button> 
	</form>
</div>
<div style="clear:both;height:30px;border-top:1px solid #EFEFEF">
	<form method="GET" action="rename_phio_xml.jsp" target="_new">
		<label for="fundCode">FundId</label><input type="text" name="fundCode" id="fundCode" value="HCF"/>
		<button>Rename PHIO xml files</button> 
	</form>
</div>

</body>
</html>