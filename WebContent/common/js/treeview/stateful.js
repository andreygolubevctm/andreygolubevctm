	function xmlToString(xmlData) {
		if (window.ActiveXObject) {
			xmlDoc=new ActiveXObject("Microsoft.XMLDOM");
			xmlDoc.async="false";
			xmlDoc.loadXML(xmlData);
			return xmlDoc;
		} else if (document.implementation && document.implementation.createDocument) {
			parser=new DOMParser();
			xmlDoc=parser.parseFromString(xmlData,"text/xml");
			return xmlDoc;
		}
	}
	
	function changeData(obj) {
	
		$('#errorData').val('');
	
		var originalValue = $("#"+obj.id).text();
	
		$("#"+obj.id).html("<input type='text' class='treeInput' name='"+obj.id+"' id='"+obj.id+"' value='"+$("#"+obj.id).text()+"'>");
		document.frmMain[obj.id].focus();
		$("#"+obj.id+" :input").bind({
			blur: function() {
				
				var fieldValue = $("#"+obj.id+" :input").val();
				
				//$("input[name=polNo]").val()
		  		
		  		var key = $("input[name=polNo]").val() + '_' + $("input[name=vehNo]").val();
		  		var entity = $("select[name=entity]").val();
		  		$.ajax({
		  		   type: "POST",
		  		   url: "callD3T?hPID=GENWXM",			
				   data: "root@method="+$("select[name=method]").val()+
		   	 	 		 "&root@type="+$("select[name=type]").val()+
		   		 		 "&root@location="+$("select[name=location]").val()+
		   		 	 	 "&root@flush="+$("select[name=flush]").val()+
		   		 		 "&root@remove="+$("select[name=remove]").val()+
		   		 		 "&root_entities_"+entity+"@key="+key+
				 		 "&root_entities_"+entity+"_"+obj.id+"=" + fieldValue,
				   
				   success: function(data) {	
				   
				   		$("#"+obj.id).html(fieldValue);
				   		
				   		$(data).find("errors").children().each(function() {
							if ($(this).find("message").text() != "") {
								$('#errorData').val($(this).find("help").text() + "\n\nError Id: " + $(this).find("id").text() + "\nMessage: " + $(this).find("message").text());
								$("#"+obj.id).html(originalValue);								
							}
						});
						
				   },
				   error: function(XMLHttpRequest, textStatus, errorThrown,data){
				   		alert("ERROR: " + textStatus + " - " + errorThrown);		
				   }
				 });		
				 			  		
		  	}
		});
	
	}
	
	function fetchCustomData(){
		var data = "";	
		var xmlString = xmlToString("<data>"+$("textarea[name=customData]").val()+"</data>");
		$(xmlString).find("data").children().each(function() {
			data += "&root_entities_"+$("select[name=entity]").val()+"_"+this.nodeName+"=" + $(this).text();
		});
		fetchData(data);
	}
	
	function fetchData(customData) {
	
		$('#errorData').val('');
		
		var key = $("input[name=polNo]").val() + '_' + $("input[name=vehNo]").val();
		//var customData = data;
	
		var method = ($("select[name=method]").val()=='set')?"POST":"GET";
	
		$.ajax({
		   type: method,
		   url: "callD3T?hPID=GENWXM",
		   data: "root@method="+$("select[name=method]").val()+
		   		 "&root@type="+$("select[name=type]").val()+
		   		 "&root@location="+$("select[name=location]").val()+
		   		 "&root@flush="+$("select[name=flush]").val()+
		   		 "&root@remove="+$("select[name=remove]").val()+
		   		 ((typeof(customData) != "undefined")?customData:"")+
		   		 "&root_entities_"+$("select[name=entity]").val()+"@key="+key,			   		 			
		   		 
		   success: function(data) {
		    	
				//xmlString = xmlToString(data);
				
				var treeData = "<ul id='red' class='treeview-red'>";
				$(data).find("entities").children().each(function() {
	
					treeData+= "<li><span>"+this.nodeName + "</span><ul>";
					
					$(this).children().each(function() {
						
						treeData += "<li><span>"+this.nodeName+"</span>" +
									"<ul>" +
									"<li><span id='"+this.nodeName+"' onClick='changeData(this)'>"+$(this).text()+"</span></li>" + 
									"</ul>" +
									"</li>";
					});
	
					treeData +="</ul></li>";
					
				});
				treeData += "</ul>";
	
				$("#tree").html(treeData);
			
				$("#tree").treeview({
				   collapsed: true,
				   unique: true,
				   animated: "fast"
				});				
	
		   },
		   error: function(XMLHttpRequest, textStatus, errorThrown,data){
		   		alert("Ooops there was an error with the ajax request.");		
		   }
		 });		
		 	 
	}	
			
	$(document).ready(function(){ 
				
		$(function() {
			$("#execute, #executeCustom").button();
		});
		
	});