<%@page import="com.ctm.utils.NGram"%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8" import="java.io.*,java.util.*,java.text.*,java.math.*"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>Text Spam Test</title>
<link rel="stylesheet" href="/ctm/brand/ctm/css/ctm.css" media="all">
<script type="text/javascript" src="/ctm/common/js/jquery-1.10.1.min.js?rev="></script>
</head>
<body>
<div class="container"><div class="row" style="padding-top: 80px;">
<div class="col-md-6">
<form id="process" method="POST" class="form-vertical">
<div class="form-group">
<label for="number">Text</label>
<input type="text" id="name" name="name" class="form-control">
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

		var text = $("#name").val();
		var sequences = 2;
		var triples = 2;
		var patterns = 1;
		var reversepatterns = 1;

		$.ajax({
			url: "../ngram/test.json",
			data: {"text":text, "sequences":sequences, "triples": triples, "patterns": patterns, "reversepatterns": reversepatterns},
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

