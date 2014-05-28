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
		<c:if test="${fn:startsWith(pageContext.request.remoteAddr,'192.168.') or fn:startsWith(pageContext.request.remoteAddr,'0:0:0:')}">
			<c:import var="prettyXml" url="/WEB-INF/xslt/pretty_xml.xsl"/>
	
			<session:core />

			<c:set var="serverIp">
				<% String ip = request.getLocalAddr();
				try {
					java.net.InetAddress address = java.net.InetAddress.getLocalHost();
					ip = address.getHostAddress();
				}
				catch (Exception e) {}
				%>
				<%= ip %>
			</c:set>

		
			<div style="margin:10px;padding:10px 20px; border:1px solid #ccc;">
				<h1>${serverIp} (${environmentService.getEnvironmentAsString()})</h1>
				<ul>
				<c:forEach items="${applicationService.getBrands()}" var="brand">
					<li>${brand.getName()}</li>
					<ul>
						<c:forEach items="${brand.getVerticals()}" var="vertical">
							<c:if test="${vertical.isEnabled()}">
								<li><a href="#${brand.getId()}${vertical.getId()}">${vertical.getName()}</a></li>
							</c:if>
						</c:forEach>
					</ul>
				</c:forEach>
				</ul>
			</div>

		<c:catch var="error">
		<h1>${serverIp} (${environmentService.getEnvironmentAsString()})</h1>

			<c:forEach items="${applicationService.getBrands()}" var="brand">

				<div style="padding:10px;border:1px solid #ccc;margin:10px;background-color:#f5f5f5">
					<h1>${brand.getName()} [${brand.getId()}]</h1>

					<c:forEach items="${brand.getVerticals()}" var="vertical">

						<div style="padding:10px 20px;border:3px double #ccc;margin:10px;background-color:#fff">
							<a name="${brand.getId()}${vertical.getId()}" ></a>
							<h2>${vertical.getName()} [${vertical.getId()}]</h2>
							
							<table>
								<c:forEach items="${vertical.getConfigSettings()}" var="setting">
									<tr>
										<td align="right" width="30%">${setting.getName()}</td>
										<td>${setting.getValue()}</td>
										<td align="right" width="20%">
											<c:if test="${setting.getStyleCodeId() != 0}">BrandSpecific </c:if>
											<c:if test="${setting.getVerticalId() != 0}">VerticalSpecific</c:if>											
										</td>
									</tr>
								</c:forEach>
							</table>
						</div>

					</c:forEach>
				</div>

			</c:forEach>
		</c:catch>
		<c:if test="${not empty error}">
			<p>Could not list brand information due to server exception.</p>
		</c:if>
				
		</c:if>

	</body>
</html>