<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<core:progress_bar />

<form:active_progress_bar />

<go:script marker="onready">
	<%-- Instantiating ActiveProgressBar will enable the progress bar steps to be clickable --%>
	var active_progress_bar = new ActiveProgressBar({
		milestones : {
			7:{
				enter : {
					forward : function(){
						$('#next-step').trigger("click");
					}
				}
			}
		}
	});
</go:script>