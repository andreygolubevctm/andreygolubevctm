<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Represents the age the driver obtained their full Australian driver licence "%>

<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" 		required="true"	 rtexprvalue="true"	 description="variable's xpath" %>
<%@ attribute name="className" 	required="false" rtexprvalue="true"	 description="additional css class attribute" %>
<%@ attribute name="id" 		required="false" rtexprvalue="true"	 description="id of the surround div" %>
<%@ attribute name="items" 		required="true"  rtexprvalue="true"  description="comma seperated list of values in value=description format" %>
<%@ attribute name="helpIds" 	required="true"  rtexprvalue="true"  description="comma seperated list of values" %>

<%-- VARIABLES --%>
<c:set var="name" value="${go:nameFromXpath(xpath)}" />
<c:set var="value" value="${data[xpath]}" />

<c:set var="helpIds" value="${fn:split(helpIds, ',')}" />
<c:forTokens items="${items}" delims="," var="radio" varStatus="status" ><c:set var="key" value="${fn:substringBefore(radio,'=')}" />
	<c:set var="des" value="${fn:substringAfter(radio,'=')}" />
	<c:set var="valueMap" value ="${valueMap}'${key}':2" />
	<c:if test="${!status.last}"><c:set var="valueMap" value ="${valueMap}," /></c:if>
</c:forTokens>

<%-- Javascript --%>
<go:script marker="js-head">
	var ${name}_RadioSliderManager = new Object();

	${name}_RadioSliderManager = {

		_values : {${valueMap}},

		toggleRadio :  function(key , value) {
			this._values[key] = value;
			$("#${name}_" + key + "_" + value).attr('checked', true);
			if (!jQuery.support.leadingWhitespace) {
				$( ".${name}_" + key ).each(function( index ) {
					if ($(this).attr('id') != "${name}_" + key + "_" + value + "_label") {
						$(this).removeClass('regular-radio-checked');
						$(this).addClass('regular-radio-unchecked');
					} else {
						$(this).addClass("regular-radio-checked");
						$(this).removeClass('regular-radio-unchecked');
					}
				});
			}
		}
	};
</go:script>

<%-- HTML --%>
<div id="${id}" class="${className}">
	<div class="labelHdrs">
		<ul>
			<li>Trivial</li>
			<li>Neutral</li>
			<li>Important</li>
		</ul>
	</div>

	<c:forTokens items="${items}" delims="," var="radio" varStatus="status" >
		<c:set var="key" value="${fn:substringBefore(radio,'=')}" />
		<c:set var="des" value="${fn:substringAfter(radio,'=')}" />
		<c:set var="inputName" value="${name}_${key}" />

		<div class="label">
			<span class="help_icon" id="help_${helpIds[status.index]}"> </span>
			${des}
			<div class="radioButtons <c:if test="${status.last}">noBorder</c:if>">
				<input type="radio" name="${inputName}" id="${inputName}_1" value="1" class="regular-radio big-radio" />
				<label for="${inputName}_1"
							class="radioButtonslabel ${inputName} regular-radio-unchecked"
							id="${inputName}_1_label"
							onclick="${name}_RadioSliderManager.toggleRadio('${key}',1);" ></label>
				<input type="radio" name="${inputName}" id="${inputName}_2" value="N" class="regular-radio big-radio" checked />
				<label for="${inputName}_2"
							class="radioButtonslabel ${inputName} regular-radio-checked"
							id="${inputName}_2_label"
							onclick="${name}_RadioSliderManager.toggleRadio('${key}', 2);"
							></label>
				<input type="radio" name="${inputName}" id="${inputName}_3" value="3"
							class="regular-radio big-radio" />
				<label for="${inputName}_3"
							class="radioButtonslabel ${inputName} regular-radio-unchecked"
							id="${inputName}_3_label"
							onclick="${name}_RadioSliderManager.toggleRadio('${key}', '3');" ></label>
			</div>
		</div>
	</c:forTokens>
</div>