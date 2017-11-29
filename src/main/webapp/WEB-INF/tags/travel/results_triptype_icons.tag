<%@ tag description="Results Trip Type Icons" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>


{{ if(isTripType) { }}
<span class="trip-type-list">
	{{ for(var i in tripTypes) { }}
	{{      if(_.has(tripTypes, i) && tripTypes[i].active) { }}
	<span class="trip-type {{= i }}">
		<span class="icon icon-trip-type-{{= i }}"></span><span class="type">{{= tripTypes[i].label }}</span>
	</span>
	{{      } }}
	{{ } }}
</span>
{{ } }}
