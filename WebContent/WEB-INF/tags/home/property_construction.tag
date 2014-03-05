<%@ tag import="java.util.*"%>
<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ tag description="Property features group gadget."%>

<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<%@ attribute name="xpath" required="true" rtexprvalue="true"	description="variable's xpath"%>
<%@ attribute name="className" required="false" rtexprvalue="true"	description="additional css class attribute"%>
<%@ attribute name="title" required="true" rtexprvalue="true"	description="title of the panel"%>

<%-- VARIABLES --%>
<c:set var="name" value="${go:nameFromXpath(xpath)}" />

<go:style marker="css-head">
	.ownerBuilder,
	.lockupStage,
	.renovation,
	.construcSchedCompletDate{
		display: none;
	}
</go:style>

<div class="${className}">

	<form:fieldset legend="${title}" className="${className}" id="${name}">

		<form:row label="Is the home under construction or undergoing renovation, alteration or extension?">
			<field:array_radio xpath="${xpath}/workOngoing"
				title="if the home is under construction or undergoing renovation, alteration or extension"
				required="true"
				className="pretty_buttons"
				items="N=No,construction=Construction,renovation=Renovation" />
		</form:row>

		<div class="ownerBuilder">
			<form:row label="Are you an owner builder?">
				<field:array_radio xpath="${xpath}/ownerBuilder"
					title="if you are an owner builder"
					required="true"
					className="pretty_buttons"
					items="Y=Yes,N=No" />
			</form:row>
		</div>

		<div class="lockupStage">
			<form:row label="Is the home at lock-up stage?">
				<field:array_radio xpath="${xpath}/lockupStage"
					title="if the home is at lock-up stage?"
					required="true"
					className="pretty_buttons"
					items="Y=Yes,N=No" />
			</form:row>

			<div class="construcSchedCompletDate">
				<form:row label="What is the scheduled completion date?">
					<field:commencement_date
						xpath="${xpath}/construcSchedCompletDate"
						title="scheduled completion date"
						required="true" />
				</form:row>
			</div>
		</div>

		<div class="renovation">

			<form:row label="Are any of the external walls or areas of the roof being removed?">
				<field:array_radio
					xpath="${xpath}/roofWallRemoved"
					title="if any of the external walls or areas of the roof are being removed"
					required="true"
					className="pretty_buttons"
					items="Y=Yes,N=No" />
			</form:row>

			<form:row label="Is the home being raised, stumps removed or replaced or being built underneath?">
				<field:array_radio
					xpath="${xpath}/raisedStumpReplaced"
					title="if the home is being raised, stumps removed or replaced or being built underneath"
					required="true"
					className="pretty_buttons"
					items="Y=Yes,N=No" />
			</form:row>

			<form:row label="When is the estimated date of completion of the building work?">
				<field:basic_date
					xpath="${xpath}/estimWorkCompletDate"
					title="the estimated date of completion of the building work"
					maxDate="+1y"
					required="true"/>
			</form:row>

			<form:row label="What is the value of the work being completed?">
				<field:currency
					title="The value of the complete work"
					maxLength="6"
					minValue="1"
					maxValue="999999"
					decimal="${false}"
					xpath="${xpath}/completeWorkValue"
					required="true"/>
			</form:row>
		</div>

		<core:clear />
	</form:fieldset>
</div>

<%-- JAVASCRIPT HEAD --%>
<go:script marker="js-head">

	var PropertyConstruction = new Object();
	PropertyConstruction = {

		init: function(){
			$('input[name=${name}_workOngoing], input[name=${name}_ownerBuilder]').on('change', function(){
				PropertyConstruction.toggleLockupRenovation();
			});

			$('input[name=${name}_lockupStage]').on('change', function(){
				PropertyConstruction.toggleScheduledCompletionDate();
			});

			PropertyConstruction.toggleLockupRenovation();
			PropertyConstruction.toggleScheduledCompletionDate();
		},

		toggleLockupRenovation: function(){

			var workOngoing = $('input[name=${name}_workOngoing]:checked').val();
			var ownerBuilder = $('input[name=${name}_ownerBuilder]:checked').val();

			if( $.inArray(workOngoing, ['construction', 'renovation']) != -1 ){
				$(".ownerBuilder").slideDown();
			} else {
				$(".ownerBuilder").slideUp();
			}

			<%--
			workType = under construction and not ownerBuilder
			=> show Lock up stage question
			=> hide renovation questions
			--%>
			if ( workOngoing == 'construction' && ownerBuilder == 'N'){
				$('.lockupStage').slideDown();
				$('.renovation').slideUp();
			<%--
			workType = renovation
			=> show renovation questions
			=> hide Lock up stage question
			--%>
			} else if( workOngoing == 'renovation' ) {
				$('.lockupStage').slideUp();
				$('.renovation').slideDown();
			<%-- hide all --%>
			} else {
				$('.lockupStage').slideUp();
				$('.renovation').slideUp();
			}

		},

		toggleScheduledCompletionDate: function(){

			if( $('input[name=${name}_lockupStage]:checked').val() == 'Y' ){
				$(".construcSchedCompletDate").slideDown();
			} else {
				$(".construcSchedCompletDate").slideUp();
			}

		}

	}

</go:script>

<go:script marker="onready">
	PropertyConstruction.init();
</go:script>