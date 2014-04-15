<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>



<core:doctype />
<html>
	<head>
		<link rel='stylesheet' type='text/css' href='common/js/treeview/jquery.treeview.css' />
		<link rel='stylesheet' type='text/css' href='common/js/treeview/screen.css' />
		<link rel='stylesheet' type='text/css' href='common/data.css' />
		<script type="text/javascript" src="common/js/jquery-1.4.2.min.js"></script>
		<script type="text/javascript" src="common/js/jquery.treeview.js"></script>
		<style type="text/css">
			#buildIdentifierRow { margin:0; padding:0.5em 1em; }
			#buildIdentifier { color:#930; }
			h1,h2{
				padding: 10px 0px;
			}
			table{
				border-collapse: collapse;
				width: 100%;
			}
			table td{
				border:1px solid #ccc;
				padding:4px;
				font-family: monospace;
			}
		</style>
	</head>
	<body>
		
		<%-- SECURITY FEATURE --%>
		<c:if test="${ remoteAddr == '127.0.0.1' or remoteAddr == '0.0.0.0' or remoteAddr == '0:0:0:0:0:0:0:1' or fn:startsWith(remoteAddr, '192.168.') or (not empty(param.bucket) and param.bucket == '1') or (not empty(param.preload) and param.preload == '2') }">
			<c:import var="prettyXml" url="/WEB-INF/xslt/pretty_xml.xsl"/>
		</c:if>


		<session:core />

		<h1>${environmentService.getEnvironmentAsString()}</h1>

		<c:forEach items="${applicationService.getBrands()}" var="brand">

			<div style="padding:10px;border:1px solid #ccc;margin:10px;">
				<h1>${brand.getName()} [${brand.getId()}]</h1>

				<c:forEach items="${brand.getVerticals()}" var="vertical">

					<div style="padding:10px;border:1px solid #ccc;margin:10px;">
						<h2>${vertical.getName()} [${vertical.getId()}]</h2>

						<table>
							<c:forEach items="${vertical.getConfigSettings()}" var="setting">
								<tr>
									<td align="right">${setting.getName()}</td>
									<td>${setting.getValue()}</td>
								</tr>
							</c:forEach>
						</table>
					</div>

				</c:forEach>
			</div>


		</c:forEach>

				
	</body>
</html>