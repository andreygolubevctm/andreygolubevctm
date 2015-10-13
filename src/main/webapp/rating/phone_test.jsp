<%@page import="com.ctm.utils.NGram"%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8" import="java.io.*,java.util.*,java.text.*,java.math.*"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>Phone Number Spam Test</title>
<link rel="stylesheet" href="/ctm/assets/brand/ctm/css/internal.css" media="all">
<script type="text/javascript" src="/ctm/common/js/jquery-1.10.1.min.js?rev="></script>
</head>
<body>
<div class="container"><div class="row" style="padding-top: 80px;">
<div class="col-md-6">
<form id="process" method="POST" class="form-vertical">
<div class="form-group">
<label for="number">Phone Number</label>
<input type="text" id="number" name="number" class="form-control">
</div>
</form>
</div>
</div></div>
<div class="container"><div class="row" style="padding-top: 80px;font-size: 32px">
<div class="result"></div>
</div></div>
<script type="text/javascript">
	$('#process').on('change', function(event) {
		event.preventDefault();

		var number = $("#number").val();
		var sequences = 2;
		var triples = 2;
		var patterns = 1;
		var reversepatterns = 1;

		$.ajax({
			url: "../phone/test.json",
			data: {"number":number, "sequences":sequences, "triples": triples, "patterns": patterns, "reversepatterns": reversepatterns},
			dataType: "json",
			cache: false,
			success: function(json){
				if(json) {
						$('.result *').remove();
						$('.result').append('<div>'+json.score+'</div>');
						$('.result').append('<div>'+json.list+'</div>');
				}
				return false;

			},
			error: function(obj,txt){
			},
			timeout:30000
		});

	});
</script>
</body>
</html>

