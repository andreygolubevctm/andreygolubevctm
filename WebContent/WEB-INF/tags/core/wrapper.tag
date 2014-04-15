<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ tag description="Dynamically load a tag from an external source"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%@ attribute name="loadjQuery" 	required="false" rtexprvalue="true"	 description="If jquery is needed to be loaded" %>
<%@ attribute name="loadExtJs" 		required="false" rtexprvalue="true"	 description="If extJs is needed to be loaded" %>
<%@ attribute name="loadjQueryUI" 	required="false" rtexprvalue="true"	 description="If jqueryUI is needed to be loaded" %>
<%@ attribute name="loadHead" 		required="false" rtexprvalue="true"	 description="If the main head content needs to be loaded" %>
<%@ attribute name="vertical" 		required="false" rtexprvalue="true"	 description="vertical type" %>
<%@ attribute name="id" 			required="false" rtexprvalue="true"	 description="ID used primarily for anti css conflicting" %>
<%@ attribute name="title" 			required="false" rtexprvalue="true"	 description="Title for the head tag" %>
<%@ attribute name="loadCSS" 		required="false" rtexprvalue="true"	 description="Optional flag to turn off css inclusions" %>

<c:if test="${empty loadjQuery}"><c:set var="loadjQuery">true</c:set></c:if>
<c:if test="${empty loadExtJs}"><c:set var="loadExtJs">true</c:set></c:if>
<c:if test="${empty loadjQueryUI}"><c:set var="loadjQueryUI">true</c:set></c:if>
<c:if test="${empty loadHead}"><c:set var="loadHead">true</c:set></c:if>
<c:if test="${empty vertical}"><c:set var="vertical">main</c:set></c:if>
<c:if test="${empty id}"><c:set var="id">generalWrapper</c:set></c:if>
<c:if test="${empty title}"><c:set var="title">General Wrapper</c:set></c:if>
<c:if test="${empty loadCSS}"><c:set var="loadCSS">true</c:set></c:if>


<go:root>
<%-- The server URL is taken from a settings file rather than using "<%=request.getLocalAddr()%>" as the f5 returns ecommerce.disconline.com.au rather than secure.comparethemarket.com.au --%>
<c:set var="server_real_url">${pageSettings.getServerUrl()}</c:set>
<c:set var="server_url">${pageSettings.getRootUrl()}</c:set>

var allowExternal = 1; // 1 = on, 0 = off
var uri = window.location.host;
if ((allowExternal == 0 && uri.indexOf("secure") != -1) || (allowExternal == 1)) {


	if (typeof(started) == 'undefined' ||  started == 'finished'){
		started = true;
		var ${id}_wrapper = new Object();
		${id}_wrapper = {

			_head : document.getElementsByTagName('head')[0],
			_ext_code_jquery : [],

			_startStrip : "<script type=\"text/javascript\" src=\"",
			_endStrip : "\"></script>",
			_cssStartStrip : "<link rel=\"stylesheet\" href=\"",
			_cssEndStrip : "\">",
			_headStart : "<head>",
			_headEnd : "</head>",
			_counter2 : 0,
			_ext_code : [],
			_css_code : '',
			_server : "${server_url}ctm/",
			_ext_css_count : 0,
			_ext_script_id : 0,
			_currentType : '',
			_jquery_loaded : false,
			_browserVersion : '',

			_jsonobj : {
			<c:if test="${loadHead == true}">
				"head":"<go:insertmarker name="head" format="JSON"/>",
			</c:if>
				"jsHead":"<go:insertmarker name="js-head" format="JSON"/>",
				"jsOnReady":"<go:insertmarker name="onready" format="JSON"/>",
				"extJs":"<go:insertmarker name="js-href" format="JSON"/>",
			<c:if test="${loadCSS == true}">
				"css":"<go:insertmarker name="css-head" format="JSON"/>",
				"cssIE":"<go:insertmarker name="css-head-ie" format="JSON"/>",
				"cssIE9":"<go:insertmarker name="css-head-ie9" format="JSON"/>",
				"cssIE8":"<go:insertmarker name="css-head-ie8" format="JSON"/>",
				"cssIE7":"<go:insertmarker name="css-head-ie7" format="JSON"/>",
				"extCss":"<go:insertmarker name="css-href" format="JSON"/>",
			</c:if>
			<c:if test="${loadjQueryUI == true}">
				"jqueryui":"<go:insertmarker name="jquery-ui" format="JSON"/>",
			</c:if>
			<c:if test="${loadjQuery == true}">
				"valRules":"{<go:insertmarker name="jquery-val-rules" format="JSON" delim=","/>}",
				"valMessages":"{<go:insertmarker name="jquery-val-messages" format="JSON" delim=","/>}",
			</c:if>
				"html":"<go:insertmarker name="body" format="JSON"/>"
			},
			<go:script marker="body"><jsp:doBody /></go:script>
			<go:script marker="head"><core:head quoteType="main" title="${title }" loadjQuery="${loadjQuery}" loadjQueryUI="${loadjQueryUI}" jqueryVersion="1.7.2.min" nonQuotePage="${true}"/></go:script>


			init: function(){

				var html_code = ${id}_wrapper.addServerURI(${id}_wrapper._jsonobj.html);
				document.write('<div class="${id} hidden" id="${id}_div">');
				document.write(html_code);
				document.write('</div>');
				${id}_wrapper._browserVersion = ${id}_wrapper.getIEVersion(document);
				if (${id}_wrapper._browserVersion == "7" || ${id}_wrapper._browserVersion == "8"){ // IE7/IE8 fails to load without a delay... NFI why
					setTimeout("${id}_wrapper.addheadercode('js', 'ext', 'no', ${id}_wrapper._jsonobj.extJs);", 1000);
				}
				else {
					${id}_wrapper.addheadercode('js', 'ext', 'no', ${id}_wrapper._jsonobj.extJs);
				}
				${id}_wrapper.fixExtCSSConflicts();
				started = 'finished';
			},
			loadScript : function (url, callback){
				// adding the script tag to the head as suggested before
				${id}_wrapper._counter2++;

				var script = document.createElement('script');
				script.type = 'text/javascript';
				script.src = url;
				// then bind the event to the callback function
				// there are several events for cross browser compatibility
					if (script.onreadystatechange === null){ //IE
						//alert("callback: "+callback);

						//script.onreadystatechange = callback;
						script.onreadystatechange = function (){
							if (script.readyState == "loaded" || script.readyState == "complete"){
								script.onreadystatechange = null;
								//alert("something finished...");
								callback();
							}
						};
					}
					else if(script.onload === null){ // w3c
						script.onload = callback;
					}
				script = ${id}_wrapper.addElementID(script);

				// fire the loading
				${id}_wrapper._head.appendChild(script);

				//alert(${id}_wrapper._counter2 + " : " + url);
			},
			addheadercode : function (type, loc, run, code, targetBrowser){
				${id}_wrapper.currentType = type;

				var bodgyBrowser = false;

				switch (targetBrowser) {
					case 'ie':
						if (${id}_wrapper._browserVersion !== undefined) { var bodgyBrowser = true; }
						break;
					case 'ie9':
						if (${id}_wrapper._browserVersion == '9') { var bodgyBrowser = true; }
						break;
					case 'ie8':
						if (${id}_wrapper._browserVersion == '8') { var bodgyBrowser = true; }
						break;
					case 'ie7':
						if (${id}_wrapper._browserVersion == '7') { var bodgyBrowser = true; }
						break;
				}

				if (targetBrowser == null || bodgyBrowser == true) {
					if (type == "head"){
						var new_code = code.replace (${id}_wrapper._headStart,"");
						new_code = new_code.replace(${id}_wrapper._headEnd,"");
						${id}_wrapper._head.innerHTML = ${id}_wrapper._head.innerHTML + new_code;
					}
					else if (loc == 'int'){
						code = ${id}_wrapper.addServerURI(code);
						if (code != "" && code != "{}"){

							if (type == "js"){
								var s = ${id}_wrapper.createJSNode();
							}
							else if (type == "css") {
								code = ${id}_wrapper.fixCSSConflicts (code);
								var s = ${id}_wrapper.createCSSNode(loc);
							}
							if(bodgyBrowser == true || ${id}_wrapper._browserVersion !== undefined){// IE
								if (type == "js"){
									s.text = code;
								}
								else if (type == "css") {
									s.styleSheet.cssText = code;
								}
							} else {// w3c
								s.appendChild(document.createTextNode(code));
							}

							${id}_wrapper._head.appendChild(s);
						}
					}
					else if (loc == 'ext'){
						if (type == "css"){
							${id}_wrapper.createCssArray (code);
							for (i = 0; i < ${id}_wrapper._css_code.length; i++){
								if(${id}_wrapper._css_code[i] != "" && ${id}_wrapper._css_code[i] != "\n" && ${id}_wrapper._css_code[i] != " "){
									var s = ${id}_wrapper.createCSSNode(loc);
									//s.appendChild(document.createTextNode(${id}_wrapper._css_code[i]));
									var abs_url = ${id}_wrapper._server+"wrapper_parse_css.jsp?id=${id}&path="+${id}_wrapper._css_code[i]+"&server_real_url=${server_real_url}&server_url=${server_url}";
									s.setAttribute('href', abs_url);
									${id}_wrapper._head.appendChild(s);
								}
							}
							${id}_wrapper.fixExtCSSConflicts();
						}
						else {
							${id}_wrapper.createCodeArray (code);
							if (${id}_wrapper._ext_code[0] !== undefined){
								${id}_wrapper.loadScript(${id}_wrapper._server+${id}_wrapper._ext_code[0], ${id}_wrapper.addToHead); // Kick start this baby
							}
							else {
								${id}_wrapper.loadRemainingScripts();
							}
						}
					}
				}
			},
			addServerURI : function (code) {
				new_code = 	   code.replace(/href="brand/g, 			"href=\""+${id}_wrapper._server+"brand");
				new_code = new_code.replace(/href="common/g, 			"href=\""+${id}_wrapper._server+"common");
				new_code = new_code.replace(/href=\\"common/g, 			"href=\""+${id}_wrapper._server+"common");
				new_code = new_code.replace(/src="brand/g, 				"src=\""+${id}_wrapper._server+"brand");
				new_code = new_code.replace(/src="common/g, 	 		"src=\""+${id}_wrapper._server+"common");
				new_code = new_code.replace(/src=\\"common/g, 	 		"src=\""+${id}_wrapper._server+"common");
				new_code = new_code.replace(/url\("brand/g, 	 		"url(\""+${id}_wrapper._server+"brand");
				new_code = new_code.replace(/url\("common/g, 	 		"url(\""+${id}_wrapper._server+"common");
				new_code = new_code.replace(/url\(\\"brand/g, 	 		"url(\""+${id}_wrapper._server+"brand");
				new_code = new_code.replace(/url\(\\"common/g, 	 		"url(\""+${id}_wrapper._server+"common");
				new_code = new_code.replace(/buttonImage: "common/g, 	"buttonImage: \""+${id}_wrapper._server+"common");
				new_code = new_code.replace(/ajax\/json\//g, 	 		${id}_wrapper._server+"ajax/json/");

				return new_code;
			},
			createCSSNode : function (loc){
				var nodeType = '';
				if (loc == 'ext'){
					nodeType = 'link';
				}
				else {
					nodeType = 'style';
				}

				var s = document.createElement(nodeType);
				s.setAttribute('type', 'text/css');
				s.setAttribute('rel', 'stylesheet');
				s = ${id}_wrapper.addElementID(s);

				return s;
			},
			createJSNode : function (){
				var s = document.createElement('script');
				s.setAttribute('type', 'text/javascript');
				s = ${id}_wrapper.addElementID(s);
				return s;
			},
			addElementID : function (s) {
				s.setAttribute('id', '${id}_id_'+${id}_wrapper._ext_script_id);
				${id}_wrapper._ext_script_id++;
				return s;
			},
			addToHead : function () {

				var new_code = ${id}_wrapper._ext_code[${id}_wrapper._counter2].replace(${id}_wrapper._startStrip,"");
				new_code = ${id}_wrapper._server+new_code;

				if(	${id}_wrapper._ext_code[${id}_wrapper._counter2] != "" &&
					${id}_wrapper._ext_code[${id}_wrapper._counter2] != "\n" &&
					${id}_wrapper._ext_code[${id}_wrapper._counter2] != " "){

					if (${id}_wrapper._ext_code.length-1 == ${id}_wrapper._counter2) {
						${id}_wrapper.loadScript(new_code, ${id}_wrapper.loadRemainingScripts);
					}
					else {
						${id}_wrapper.loadScript(new_code, ${id}_wrapper.addToHead);
					}
				}
			},
			createCodeArray : function  (code) {
				${id}_wrapper._ext_code = code.replace(/\n/g,"");
				${id}_wrapper._ext_code = ${id}_wrapper._ext_code.replace(/> </g,"><");
				${id}_wrapper._ext_code = ${id}_wrapper._ext_code.split(${id}_wrapper._endStrip);

				var counter = 0;

				for (i = 0; i < ${id}_wrapper._ext_code.length; i++){//Move jquery to the first element
					${id}_wrapper._ext_code[i] = ${id}_wrapper._ext_code[i].replace(${id}_wrapper._startStrip,"");
					if (${id}_wrapper._ext_code[i] == ""){
						${id}_wrapper._ext_code.splice(i,1); //remove the item
					}
					else if (${id}_wrapper._ext_code[i].indexOf("jquery-") != -1){
							${id}_wrapper._ext_code.splice(counter,0,${id}_wrapper._ext_code[i]); // Add the item to the front
							${id}_wrapper._ext_code_jquery.splice(counter,0, ${id}_wrapper._ext_code[i]); // Add the item to the front of the jquery var
							${id}_wrapper._ext_code.splice(i+1,1); //remove the item from its old position
							counter++;
							${id}_wrapper._jquery_loaded = true;
					}
				}
			},
			createCssArray : function (code){
				${id}_wrapper._css_code = code;
				${id}_wrapper._css_code = ${id}_wrapper._css_code.split(${id}_wrapper._cssEndStrip);
				var counter = 0;

				for (i = 0; i < ${id}_wrapper._css_code.length; i++){
					${id}_wrapper._css_code[i] = ${id}_wrapper._css_code[i].replace(${id}_wrapper._cssStartStrip,"");
					${id}_wrapper._css_code[i] = ${id}_wrapper._css_code[i].replace(/^\s\s*/, '').replace(/\s\s*$/, '');
					if (${id}_wrapper._css_code[i] == ""){
						${id}_wrapper._css_code.splice(i,1); //remove the item
					}
				}
			},
			fixCSSConflicts : function (code){
				var cssArray = code.replace(/}/g, "}~");
				var new_code = ""
				cssArray = cssArray.split("~");
				if (cssArray[cssArray.length-1] == "\r\n"){
					cssArray.pop(); // split adds an extra item usually due to whitespace
				}
				for (i=0; i < cssArray.length; i++){
					cssArray[i] = "\r\n.${id} " + cssArray[i].replace(/^\s\s*/, '').replace(/\s\s*$/, '');
					new_code = new_code + cssArray[i];
				}
				return new_code;

			},
			fixExtCSSConflicts : function (){
				for (i = 0; i < ${id}_wrapper._ext_css_count; i++){
					try {
						var styles = document.styleSheets[i+1].cssRules;
					}
					catch(e){

					}
				}
			},
			loadRemainingScripts : function () {

				<%-- _jsonobj.extJs is loaded first on purpose as we need jquery so isnt here --%>
				<c:if test="${loadHead == true}">
					//${id}_wrapper.addheadercode('head', 'int', 'no', ${id}_wrapper._jsonobj.head);
				</c:if>
				<c:if test="${loadCSS == true}">
				${id}_wrapper.addheadercode('css', 'ext', 'no', ${id}_wrapper._jsonobj.extCss);
				${id}_wrapper.addheadercode('css', 'int', 'no', ${id}_wrapper._jsonobj.css);
				${id}_wrapper.addheadercode('css', 'int', 'no', ${id}_wrapper._jsonobj.cssIE, 'ie');
				${id}_wrapper.addheadercode('css', 'int', 'no', ${id}_wrapper._jsonobj.cssIE9, 'ie9');
				${id}_wrapper.addheadercode('css', 'int', 'no', ${id}_wrapper._jsonobj.cssIE8, 'ie8');
				${id}_wrapper.addheadercode('css', 'int', 'no', ${id}_wrapper._jsonobj.cssIE7, 'ie7');
				</c:if>
				${id}_wrapper.addheadercode('js', 'int', 'yes', ${id}_wrapper._jsonobj.jsHead);
				<c:if test="${loadjQueryUI == true}">
					${id}_wrapper.addheadercode('js', 'int', 'yes', ${id}_wrapper._jsonobj.jqueryui);
				</c:if>
				${id}_wrapper.addheadercode('js', 'valrules', 'no', ${id}_wrapper._jsonobj.valRules);
				${id}_wrapper.addheadercode('js', 'valmessages', 'no', ${id}_wrapper._jsonobj.valMessages);

				${id}_wrapper.addheadercode('js', 'int', 'yes', ${id}_wrapper._jsonobj.jsOnReady);
			},

			getIEVersion : function (odoc){
				if (odoc.body != null){
					if (odoc.body.style.scrollbar3dLightColor!=undefined) {
						if (navigator.appVersion.indexOf("MSIE 10") != -1) {return '10';} // IE10
						else if (odoc.body.style.opacity!=undefined) {return '9';} // IE9
						else if (odoc.body.style.msBlockProgression!=undefined) {return '8';} // IE8
						else if (odoc.body.style.msInterpolationMode!=undefined) {return '7';} // IE7
						else if (odoc.body.style.textOverflow!=undefined) {return '6'} //IE6
						else {return 'IE5.5';} // or lower
					}
				}
			}
		}

		${id}_wrapper.init();

	}
	function addLoadEvent(func) {
		var oldonload = window.onload;
		if (typeof window.onload != 'function') {
			window.onload = func;
		} else {
			window.onload = function() {
				if (oldonload) {
					oldonload();
				}
				func;
			}
		}
	}
	function load${id}(id){
		var loader = document.getElementById(id+'_div');
		loader.className = loader.className.replace(/\bhidden\b/,'');
	};
	addLoadEvent(load${id}('${id}'));
	addLoadEvent(function() {
		setUpPlaceHolders()
	});
}
</go:root>