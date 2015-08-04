<%@page import="org.jsoup.helper.StringUtil"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.SQLException"%>
<%@page import="com.ctm.connectivity.SimpleDatabaseConnection"%>
<%@page import="com.ctm.exceptions.DaoException"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1" import="java.io.*,java.util.*,java.text.*,java.math.*"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>


<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Upload Credit Card Rates</title>
<link rel="stylesheet" href="/ctm/brand/ctm/css/ctm.css" media="all">
<script type="text/javascript" src="../../common/js/jquery-1.10.1.min.js?rev="></script>
</head>
<body>


<%
	String providerCode = "";
	String providerName = "";

	SimpleDatabaseConnection dbSource = null;
	try {
		PreparedStatement stmt;

		dbSource = new SimpleDatabaseConnection();

		stmt = dbSource.getConnection().prepareStatement(
				"SELECT providerCode, Name  FROM ctm.provider_master WHERE providerCode IS NOT NULL ORDER BY Name"
		);

		ResultSet results = stmt.executeQuery();
%>
<div class="container"><div class="row" style="padding-top: 80px;">
<div class="col-md-6">
<form id="process" method="POST" enctype="multipart/form-data" class="form-horizontal" action="../../creditcards/products/import">
<input type="hidden" id="providercode" name="providercode">
<div class="form-group">
<div class="select">
<label for="provider">Select the Provider</label>
<select id="provider" name="provider" class="form-control">
	<option val="">Select the Provider...</option>
<%
		while (results.next()) {
			providerCode = results.getString("providerCode");
			providerName = results.getString("Name");
%>
	<option value="<%=providerCode %>"><%=providerName %></option>
<%
		}

	} catch (SQLException e) {
		throw new DaoException(e.getMessage(), e);
	}
	finally {
		dbSource.closeConnection();
	}

%></select></div>
</div>
<div class="form-group">

<table id="products" class="table table-striped">
<thead>
</thead>
<tbody></tbody>
</table>
</div>
<div class="form-group">
<label for="provider">Effective Date</label>
<input type="text" id="effectivedate" name="effectivedate" placeholder="2015-01-01" class="form-control">
</div>
<div class="form-group">
<label for="provider">Jira Id</label>
<input type="text" id="jira" name="jira" class="form-control">
</div>
<div class="form-group">
<label for="provider">Import File</label>
<input type="file" id="sheet" name="sheet">
</div>
<div class="form-group">
<input type="submit" value="Process">
</div>
</form>
</div>
</div></div>
<script type="text/javascript">
	var results;

	$('#provider').on('change', function() {
		var providerCode = $(this).val();
		$('#providercode').val(providerCode);
		$.ajax({
			url: "../../creditcards/products/list.json",
			data: {"providerCode":providerCode, "authorisationToken": "a85e9db4851f7cd3efb8db7bf69a07cfb97bc528b72785a9cff7bdfef7e2279d"},
			dataType: "json",
			cache: false,
			success: function(json){
				if(json) {
						$('#products tbody tr').remove();
						$('#products thead tr').remove();
						$('#products thead').append('<tr><th>Code</th><th>Name</th><th>Delete</th></tr>');
						for(var i = 0; i < json.length; i++) {

							$('#products').append('<tr><td>'+json[i].code+'</td><td>'+json[i].shortDescription+'</td><td><input type="checkbox" name="deleteid" value="'+json[i].id+'"></td></tr>');
						}
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