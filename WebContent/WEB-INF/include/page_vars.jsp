<%--
	page_vars.jsp
	
	Initialises variables for ease of access.
	All variables are stored in the PAGE context so that can 
	accessed from any custom tag 
	
	VARIABLE			DESCRIPTION
	----------- 		----------------------------------------------------------------
	images				Root folder for images that apply to all brands 
	brand_images		Root folder for graphics for the brand (specified in settings)
	css_brand_images	Path to brand images from within CSS files.
	
 --%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" 	prefix="c" %>
<c:set var="images" 		value="common/images" />
<c:set var="brand_images" 	value="brand/${data['settings/images-folder']}" />
<c:set var="css_brand_images" value="../../../brand/${data['settings/images-folder']}" />
