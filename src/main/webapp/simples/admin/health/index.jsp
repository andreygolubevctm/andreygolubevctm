<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<!DOCTYPE html>

<session:new verticalCode="GENERIC" />
<!--[if lt IE 7]>      <html class="no-js lt-ie9 lt-ie8 lt-ie7" lang="en"> <![endif]-->
<!--[if IE 7]>         <html class="no-js lt-ie9 lt-ie8" lang="en"> <![endif]-->
<!--[if IE 8]>         <html class="no-js lt-ie9" lang="en"> <![endif]-->
<!--[if gt IE 8]><!--> <html class="no-js" lang="en"> <!--<![endif]-->
	<head>
		<meta charset="utf-8">
		<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
		<title>CTM Template for Bootstrap</title>
		<meta name="description" content="">
		<meta name="viewport" content="width=device-width">
		<meta name="viewport" content="width=device-width, initial-scale=1.0">
		<link rel="shortcut icon" href="../graphics/favicon.png">

		<link rel="stylesheet" href="/ctm/brand/${pageSettings.getBrandCode()}/css/ctm.min.css">
		<link rel="stylesheet" href="/ctm/brand/${pageSettings.getBrandCode()}/css/health.ctm.min.css">

	</head>
	<body>
		<div class="container">
			<div class="row">
				<div class="col-md-12" style="margin-top: 20px;">
					<div class="well" style="text-align: center;">
						<h1>Health Reports</h1>
					</div>
				</div>
			</div>
			<div style="text-align: center;">
				<div class="btn-group">
					<a href="show_product_sales_limit.jsp" title="Bootstrap 3 Themes Generator" class="btn btn-lg  btn-info">Product Limits</a>

				</div>
			</div>
		</div>

		<script src="../js/bootstrap.ctm.min.js"></script>
		<script src="../js/modules.ctm.min.js"></script>
		<script src="../js/health.modules.ctm.min.js"></script>
	</body>
</html>