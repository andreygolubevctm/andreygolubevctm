	function jscss(a,o,c1,c2) {
		switch (a){
		case 'swap':
		o.className=!jscss('check',o,c1)?o.className.replace(c2,c1):
		o.className.replace(c1,c2);
		break;
		case 'add':
		if(!jscss('check',o,c1)){o.className+=o.className?' '+c1:c1;}
		break;
		case 'remove':
		var rep=o.className.match(' '+c1)?' '+c1:c1;
		o.className=o.className.replace(rep,'');
		break;
		case 'check':
		return new RegExp('\\b'+c1+'\\b').test(o.className);
		break;
		}
	}
	function makeReq()	{
		try { return new ActiveXObject("Msxml2.XMLHTTP"); } catch (e) {}
		try { return new ActiveXObject("Microsoft.XMLHTTP"); } catch (e) {}
		try { return new XMLHttpRequest(); } catch(e) {}
		alert("XMLHttpRequest not supported");
		return null;
	}

	var load_is_running = null;
	function load(url, divId, callback , fld) {
		if (load_is_running) load_is_running.abort();
		fld.data("loading", true);
		load_is_running = $.ajax({
			url: url,
			dataType: "html",
			type: 'GET',
			async: true,
			timeout:30000,
			cache: false,
			success: function(responseText){
				document.getElementById(divId).innerHTML=responseText;
				if (typeof callback === 'function') {
					callback(fld);
				}
				fld.data("loading", false);
				load_is_running = null;
			},
			error: function(obj, txt, errorThrown){
				fld.data("loading", false);
				load_is_running = null;
			}
		});
	}


	var prevSearch = "";

	function ajaxdrop_update(fld) {
		if(!fld.data("loading") || typeof fld.data("loading") ===  'undefined') {
			var id = fld.attr("id");
			var srchLen = typeof fld.data("srchLen") ===  'undefined' ? 2 : fld.data("srchLen");
			var srch = fld.val();

			if (srch.indexOf("\'") !== -1) { //Stop initiating if ' is in the first two characters
				srchLen++;
			}

			if (srch.length >= srchLen) {
				fld.trigger('getSearchURL', function getSearchURLCallBack(url) {
					if(typeof url != 'undefined' && url != "") {
						load(url,"ajaxdrop_" + id, ajaxdrop_show, fld);
					}
				});
			} else {
				ajaxdrop_hide(id);
			}
		}
	}
	function ajaxdrop_highlight(id, idx){
		var cont=document.getElementById("ajaxdrop_"+id);

		var rows=cont.getElementsByTagName("div");
		var maxRow=rows.length;
		var curIdx = cont.curIdx;

		switch (idx){
		case "*NEXT":
			if (curIdx==null){
				idx=0;
			} else {
				// read forward to get the next idx
				for (idx = curIdx+1; idx <= maxRow; idx++){
					if (rows[idx]&& rows[idx].style.display!="none"){
						break;
					}
				}
			}
			break;

		case "*PREV":
			if (curIdx == null){
				idx = maxRow-1;
			} else {
				idx = curIdx-1;
				// read backwards to get the prev idx
				for (idx = curIdx-1; idx >= -1; idx--){
					if (rows[idx]&&rows[idx].style.display!="none"){
						break;
					}
				}
				break;
			}
		}

		//alert(idx);
		for (var i=0; i < maxRow; i++){
			jscss("remove",rows[i],"ajaxdrop_over");

			if (i == idx) {
				jscss("add",rows[i],"ajaxdrop_over");
				cont.curIdx = idx;
			}
		}
		document.getElementById("ajaxdrop_current").innerHTML = idx;
	}
	function ajaxdrop_click(id, idx){
		var field = $("#"+ id);
		var cont=document.getElementById("ajaxdrop_"+id);

		var rows=cont.getElementsByTagName("div");

		if (idx=='*CURRENT'){
			idx = cont.curIdx?cont.curIdx:0;
		}

		if (rows[idx]&&(rows[idx].style.display=="block"||rows[idx].style.display=="")){
			field.trigger('itemSelected' , [rows[idx].getAttribute("key"), rows[idx].getAttribute("val")]);
		}
	}
	function ajaxdrop_onkeydown(id, e) {
		if (!e) {
			e = window.event;
		}
		var cde = window.event?e.keyCode:e.which;
		switch(cde){
		case 9:
		case 13:
			ajaxdrop_click(id, '*CURRENT');
			return false;
			break;
		case 38:
			ajaxdrop_highlight(id, '*PREV');
			return false;
			break;
		case 40:
			ajaxdrop_highlight(id, '*NEXT');
			return false;
			break;
		}
		return true;
	}




	var ajaxdrop_onAction_timeout;
	function ajaxdrop_onAction(event) {
		var field = $(this);
		if (ajaxdrop_onAction_timeout) clearTimeout(ajaxdrop_onAction_timeout);
		ajaxdrop_onAction_timeout = setTimeout(function ajaxdrop_update_timout() {
			if (!event || typeof event == 'undefined') {
				event = window.event;
			}
			var cde = event? event.keyCode : event.which;
			if (cde != 38 && cde != 40){
				ajaxdrop_update(field);
			}
		}, 110 );
	}

	function ajaxdrop_hide(id){
		var cont=document.getElementById("ajaxdrop_"+id);
		cont.style.display="none";
		cont.innerHTML = "";
	}
	function ajaxdrop_show(fld){
		var id = fld.attr("id");
		var cont=document.getElementById("ajaxdrop_"+id);

		if (cont.innerHTML != "") {
			// Check to see how many results - if only 1, select it
			var rows = cont.getElementsByTagName("div");

			if (rows.length == 0){
				ajaxdrop_hide(id);
			} else if (rows.length < 2
						&& rows[0].getAttribute("val") != "*NOTFOUND"
						&& (!fld.prevAutoClick || fld.prevAutoClick!=fld.val().substring(0,1) )){
				fld.prevAutoClick = fld.val().substring(0,1);
				ajaxdrop_click(id, 0);
				ajaxdrop_hide(id);
			} else {
				$("#ajaxdrop_" + id).css({
						left:"auto",
						top:"auto",
						position:"absolute"
						});
				cont.style.display="block";

			}
			cont.curIdx = null;
		}
	}
	function findPosX(obj) {
		if (!obj) {return; }
		if (obj.offsetParent) {
			var posX=0;
			while (obj.offsetParent) {
				posX+=obj.offsetLeft;
				obj=obj.offsetParent;
			}
			return posX;
		} else if (obj.x) {
			return obj.x;
		}
	}
	function findPosY(obj) {
		if (!obj) {return;}
		if (obj.offsetParent) {
			var posY=0;
			while (obj.offsetParent) {
				posY +=obj.offsetTop;
				obj=obj.offsetParent;
			}
			return posY;
		} else if (obj.y) {
			return obj.y;
		}
	}