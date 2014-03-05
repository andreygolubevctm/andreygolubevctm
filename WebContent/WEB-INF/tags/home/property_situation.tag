<%@ tag import="java.util.*"%>
<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ tag description="Property situation group gadget."%>

<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<%@ attribute name="xpath" required="true" rtexprvalue="true"	description="variable's xpath"%>
<%@ attribute name="className" required="false" rtexprvalue="true"	description="additional css class attribute"%>
<%@ attribute name="title" required="true" rtexprvalue="true"	description="title of the panel"%>

<%-- VARIABLES --%>
<c:set var="name" value="${go:nameFromXpath(xpath)}" />

<go:style marker="css-head">
	.mortgagee,
	.borderedBy{
		display: none;
	}
</go:style>

<div class="${className}">

	<form:fieldset legend="${title}" className="${className}" id="${name}">

		<form:section title="Is the home..." separator="false" id="isTheHome">

<%-- TEMPORARY REMOVAL OF QUESTION WHICH IS ONLY REQUIRED BY HOLLARD & CALLIDEN --%>
<%-- 			<form:row label="...situated on a farm or on more than 10 acres?"> --%>
<%-- 				<field:array_radio xpath="${xpath}/farm" --%>
<%-- 					title="if the home is situated on a farm or on more than 10 acres" --%>
<%-- 					required="true" --%>
<%-- 					className="pretty_buttons" --%>
<%-- 					items="Y=Yes,N=No" /> --%>
<%-- 			</form:row> --%>

<%-- TEMPORARY REMOVAL OF QUESTION WHICH IS NEEDED LATER IN THE QUOTE --%>
<%-- 			<form:row label="...under immediate threat of damage by severe storm or bushfire?"> --%>
<%-- 				<field:array_radio xpath="${xpath}/stormBushfireThreat" --%>
<%-- 					title="if the home is under immediate threat of damage by severe storm or bushfire" --%>
<%-- 					required="true" --%>
<%-- 					className="pretty_buttons" --%>
<%-- 					items="Y=Yes,N=No" /> --%>
<%-- 			</form:row> --%>

			<form:row label="...part of a body corporate/strata title complex?">
				<field:array_radio xpath="${xpath}/bodyCorp"
					title="if the home is part of a body corporate/strata title complex"
					required="true"
					className="pretty_buttons"
					items="Y=Yes,N=No" />
			</form:row>

		</form:section>

		<core:clear />
	</form:fieldset>
</div>

<%-- JAVASCRIPT HEAD --%>
<go:script marker="js-head">

	var PropertySituation = new Object();
	PropertySituation = {

		init: function(){



		}

	}

</go:script>

<go:script marker="onready">
	PropertySituation.init();
</go:script>