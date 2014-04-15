<%@ page language="java" contentType="text/css; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- This is used to add a top level class to each class within an existing css file and present that to the browser instead of the original --%>
<%-- The point being to resolve css conflicts without code duplication as you restrict it within a container --%>

<%-- The server URL is taken from a settings file rather than using "<%=request.getLocalAddr()%>" as the f5 returns ecommerce.disconline.com.au rather than secure.comparethemarket.com.au --%>
<c:set var="server_url">${param.server_url}</c:set>
<c:set var="server_real_url">${param.server_real_url}</c:set>
<c:set var="server_port"><%=request.getLocalPort()%></c:set>

<c:if test="${not empty server_port}"><c:set var="server_port">:${server_port}</c:set></c:if>

<c:if test="${not empty param.path}">
	<c:set var="path">${param.path}</c:set>
	<c:set var="dir_path"></c:set>

	<c:forEach var="slashesSplt" items="${fn:split(path, '/')}">
		<c:set var="ind">${fn:indexOf(slashesSplt, ".")}</c:set> <%-- This will be a filename --%>
		<c:if test="${ind == -1}">
			<c:set var="dir_path">${dir_path}${slashesSplt}/</c:set>
		</c:if>
	</c:forEach>


	<c:set var="server_path">${server_url}ctm/</c:set>
	<c:set var="server_real_path">http://${server_real_url}/ctm/</c:set>
	<c:set var="path_contents"><go:import url="${server_real_path}${path}"></go:import></c:set>

</c:if>
<c:if test="${not empty param.id}"><c:set var="id">${param.id}</c:set></c:if>

<%-- Lets remove all comments from the css cause they are annoying and break things... --%>
<c:forEach var="howManyComments" items="${fn:split(path_contents, '/*')}">
	<c:set var="indStart">	${fn:indexOf(path_contents, "/*")}</c:set>
	<c:if test="${indStart != -1}">
		<c:set var="indEnd">	${fn:indexOf(path_contents, "*/")}</c:set>
		<c:set var="subString">	${fn:substring(path_contents, indStart, indEnd+2)}</c:set>
		<c:set var="path_contents">	${fn:replace(path_contents, subString, '')}</c:set>
<%-- 		.${indStart}.${indEnd}.${subString} --%>
	</c:if>
</c:forEach>

<%-- Time to attempt to make all image/font paths absolute to this server. Cross fingers plz. --%>

	<c:set var="imagesPathOrig1">'../../</c:set> <%-- Author is trying to get to the site root anyway --%>
	<c:set var="imagesPathNew1">'${server_path}</c:set>
	<c:set var="imagesPathOrig2">"../../</c:set> <%-- Author is trying to get to the site root anyway --%>
	<c:set var="imagesPathNew2">"${server_path}</c:set>
	<c:set var="imagesPathOrig3">../../common</c:set>
	<c:set var="imagesPathNew3">${server_path}common</c:set>
	<c:set var="imagesPathOrig4">../../brand</c:set>
	<c:set var="imagesPathNew4">${server_path}brand</c:set>
	<c:set var="imagesPathOrig5">url("</c:set>
	<c:set var="imagesPathNew5">url("${server_path}${dir_path}</c:set>
	<c:set var="imagesPathOrig6">url('</c:set>
	<c:set var="imagesPathNew6">url('${server_path}${dir_path}</c:set>
	<c:set var="imagesPathOrig7">url(fonts</c:set>
	<c:set var="imagesPathNew7">url(${server_path}${dir_path}fonts</c:set>
	<c:set var="imagesPathOrig8">url(images</c:set>
	<c:set var="imagesPathNew8">url(${server_path}${dir_path}images</c:set>
	<c:set var="imagesPathOrig9">${server_path}${dir_path}${server_path}</c:set>
	<c:set var="imagesPathNew9">${server_path}</c:set>
	<c:set var="imagesPathOrig10">ctm/../fonts</c:set>
	<c:set var="imagesPathNew10">ctm/fonts</c:set>

	<c:set var="path_contents">${fn:replace(path_contents, imagesPathOrig1, imagesPathNew1)}</c:set>
	<c:set var="path_contents">${fn:replace(path_contents, imagesPathOrig2, imagesPathNew2)}</c:set>
	<c:set var="path_contents">${fn:replace(path_contents, imagesPathOrig3, imagesPathNew3)}</c:set>
	<c:set var="path_contents">${fn:replace(path_contents, imagesPathOrig4, imagesPathNew4)}</c:set>
	<c:set var="path_contents">${fn:replace(path_contents, imagesPathOrig5, imagesPathNew5)}</c:set>
	<c:set var="path_contents">${fn:replace(path_contents, imagesPathOrig6, imagesPathNew6)}</c:set>
	<c:set var="path_contents">${fn:replace(path_contents, imagesPathOrig7, imagesPathNew7)}</c:set>
	<c:set var="path_contents">${fn:replace(path_contents, imagesPathOrig8, imagesPathNew8)}</c:set>
	<c:set var="path_contents">${fn:replace(path_contents, imagesPathOrig9, imagesPathNew9)}</c:set>
	<c:set var="path_contents">${fn:replace(path_contents, imagesPathOrig10, imagesPathNew10)}</c:set>


<c:forEach var="splt" items="${fn:split(path_contents, '}')}">

	<c:set var="charsetTest">${fn:indexOf(splt, "@CHARSET")}</c:set>
	<c:set var="mediaTest">${fn:indexOf(splt, "@media")}</c:set>

	<c:if test="${charsetTest != -1}">
		<c:set var="charset">${fn:substringBefore(splt, ";")}</c:set>
		<c:set var="splt">${fn:substringAfter(splt, ";")}</c:set>
		${charset};
	</c:if>

	<%-- Lets add in our id as a class --%>

	<c:forEach var="splt2" items="${fn:split(splt, '{')}" varStatus="loop1">

		<c:choose>
			<c:when test="${!loop1.last}">
				<c:forEach var="splt3" items="${fn:split(splt2, ',')}" varStatus="loop2">

					<c:set var="bodyTest">${fn:indexOf(splt3, "body")}</c:set>
					<c:set var="mediaTest2">${fn:indexOf(splt3, "@media")}</c:set>
					<c:set var="fontTest">${fn:indexOf(splt3, "@font-face")}</c:set>
					<c:choose>
						<c:when test="${mediaTest2 != -1}">${splt3}{</c:when> <%-- Encapsulate the media rules in brackets --%>
						<c:when test="${fontTest != -1}">${splt3}</c:when> <%-- We dont want to touch the font rules --%>
						<c:otherwise>.${id}<c:out value=" "/>${splt3}
							<c:choose>
								<c:when test="${charsetTest != -1}">

								</c:when>
								<c:otherwise>
										<c:if test="${!loop2.last and bodyTest == -1}">,</c:if>
								</c:otherwise>
							</c:choose>
						</c:otherwise>
					</c:choose>
				</c:forEach>
			</c:when>
			<c:otherwise>{${splt2}}</c:otherwise>
		</c:choose>
	</c:forEach>
	<c:if test="${mediaTest != -1}">}</c:if> <%-- closing brackets for the @media block --%>

</c:forEach>