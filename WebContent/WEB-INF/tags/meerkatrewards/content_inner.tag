<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Utility tag to create the head tag including markers needed for the gadget object framework."%>

<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- HTML --%>
<div class="row">
	<div class="large-12 columns">

	<label for="radio1">
		<input name="answer" type="radio" id="answer_wrong" value='N' style="display:none;">
		<span class="answer custom radio"></span>
		<div class="radioLabel">comparethemeerkat.com.au</div>
	</label>

	<label for="radio1">
		<input name="answer" type="radio" id="answer_right" value='Y' style="display:none;">
		<span class="answer custom radio"></span>
		<div class="radioLabel">comparethemarket.com.au</div>
	</label>

	<hr class="goldHrTwo" />
	<p class="gold">Now please choose your size most carefully for tailoring. (Sergei will only cut the cloth once).</p>

		<div class="large-1 columns">
		<label for="radio1">
			<input name="robesize" type="radio" id="robesize_XS" value="XS" style="display:none;">
			<span class="robesize custom radio"></span>
			<div class="radioLabel">XS</div>
		</label>
		</div>

		<div class="large-1 columns">
		<label for="radio1">
			<input name="robesize" type="radio" id="robesize_S" value="S" style="display:none;">
			<span class="robesize custom radio"></span>
			<div class="radioLabel">S</div>
		</label>
		</div>

		<div class="large-1 columns">
		<label for="radio1">
			<input name="robesize" type="radio" id="robesize_M" value="M" style="display:none;">
			<span class="robesize custom radio"></span>
			<div class="radioLabel">M</div>
		</label>
		</div>

		<div class="large-1 columns">
		<label for="radio1">
			<input name="robesize" type="radio" id="robesize_L" value="L" style="display:none;">
			<span class="robesize custom radio"></span>
			<div class="radioLabel">L</div>
		</label>
		</div>

		<div class="large-1 columns">
		<label for="radio1">
			<input name="robesize" type="radio" id="robesize_XL" value="XL" style="display:none;">
			<span class="robesize custom radio"></span>
			<div class="radioLabel">XL</div>
		</label>
		</div>

		<div class="large-4 columns">
		<p id="size_guide_parent"><a href="javascript:void(0);" class="formHelpTxt" id="size_guide">? Size Guide</a></p>
		</div>
	<hr class="goldHrTwo"/>
		<p class="gold">and your details for delivery</p>

	<div class="row nohover">
		<div class="large-6 columns">
		<label>First name</label>
		<input id="firstname" type="text" name="firstname" value="">
		</div>
		<div class="large-6 columns">
		<label>Last name</label>
		<input id="lastname" type="text" name="lastname" value="">
		</div>
	</div>

	<div class="row nohover">
		<div class="large-12 columns">
		<label>Email</label>
		<input id="email" type="text" name="email" value="">
		</div>
	</div>

	<meerkatrewards:address xpath="address" type="R" />

	<!-- Inputs and Submits -->
	<div class="row enter_competition_wrapper">
		<div class="large-12 columns">
			<a href="javascript:void(0);" id="enter_competition" class="buttonMeerkat">I Want The Robe
				<div class="meerkatBtnArrow">
					<div class="chevron"></div>
				</div>
			</a>
		</div>
	</div>

	</div> <!-- large-12 columns -->
</div> <!-- Row -->