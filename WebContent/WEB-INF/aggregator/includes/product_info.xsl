<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">	
	<xsl:template name="productInfo">
		<xsl:param name="productId" />
		<xsl:param name="priceType" />
		<xsl:param name="kms" />
		
		<xsl:choose>
		<!-- REAL Pay as you drive -->
		<xsl:when test="$productId = 'PAYD-01-01'">
			<name>Pay As You Drive Option</name>
			<des><![CDATA[
				Comprehensive cover for less, only pay for the km's you plan to drive - the less you drive, the more you save.
				]]>								
			</des>
			<feature>Only pay for KM's you drive. Get a free quote on unlimited km's.</feature>
			<info>
				<![CDATA[
				<p><strong>Innovative car insurance for people who drive less</strong></p>
				<p>If you want the security of Comprehensive car insurance but you only drive a little, then Pay as You Drive cover from Real Insurance could be for you.</p> 
				<p>Available exclusively to those who drive less, Real Insurance's Pay as You Drive option offers all the benefits of Comprehensive insurance for a competitive price.  You only pay for the kilometres you plan to drive, so the less you drive, the less you pay. And if you need more, you can always call them to increase your kilometre range. Simple!</p>
				<p>Pay As You Drive is an option of Real Insurance's Comprehensive cover for qualified customers. And when you take out Comprehensive car insurance from Real Insurance, you can also choose from their wide range of unique optional extras, to suit your situation.</p> 
				<p>You can also Build Your Own cover and select or cut out certain covers, meaning you only pay for what you need and want. </p>
				<p>Real Insurance's car insurance is tailored individually for each of their customers, so call Real Insurance today to speak to one of their experienced consultants and save with Real Car Insurance.</p> 
				]]>
			</info>					 				
			<terms>
				<![CDATA[
				<p><b>Indicative quote based on ]]><xsl:value-of select="$kms" /><![CDATA[ kilometres</b></p>
				<p>If it looks like you will exceed your planned kilometres, you can easily increase your number of planned kilometres by calling Real Insurance. Should you exceed your planned kilometres, an additional excess will be applied in the event of a claim, as stated on your Certificate of Insurance.</p>				
				<p>Indicative quote based on ]]><xsl:value-of select="$kms" /><![CDATA[ kilometres. Free quotes are available for different kilometre ranges or for standard Comprehensive insurance with an unlimited kilometre range.</p>
				]]>
			</terms>
			<carbonOffset />
			<kms><xsl:value-of select="$kms" /></kms>
						
			</xsl:when>	
<!-- AI INSURANCE -->
		<xsl:when test="$productId = 'AI-01-01'">
			<name>Classic Comprehensive Cover</name>
			<des>A specialist car insurer which focuses on providing a wide range of uniquely tailored policies.</des>
			<feature>Includes 65% Maximum No Claim Discount &amp; a Reducible Basic Excess structure</feature>
			<info>
				<![CDATA[
				<p>AI Insurance provides comprehensive car insurance which includes cover for younger drivers and non standard vehicles.
				<br>Features and benefits include:</p>
				<li style="font-size:11px;"><strong>Lifetime Protected 65% No Claims Discount</strong> (NCD) provided with each policy</li>
				<li style="font-size:11px;"><strong>Excess free windscreen cover</strong> (limited to one excess free claim per period)*</li>
				<li style="font-size:11px;"><strong>Faultless excess</strong> – no excess payable for accident claims where the driver is not at fault and the at fault drivers details have been provided to AI Insurance*</li>
				<li style="font-size:11px;"><strong>Reducible basic excess</strong> – AI Insurance rewards you for each year that you don't make a claim by reducing your excess*</li>
				<li style="font-size:11px;"><strong>Client choice of repairer</strong> – AI Insurance allows clients to select their repairer of choice*<br>
				*Refer to the Product Disclosure Statement for more information.</li>
				<p style="margin-top:5px;">AI Insurance comprehensive car policies are underwritten by The Hollard Insurance Company Pty Ltd. Hollard is a member of the international Hollard Insurance Group which provides a wide range of insurance products and services to more than 6.5 million policyholders worldwide.</p>
				<p>Hollard has won the Australian Banking and Finance Magazine's awards for Best General Insurance Product (2008) and Nice Insurer of the Year (2007).</p>
				]]>
			</info>
			<terms>
				<![CDATA[
					<p><b>Maximum No Claims discount:</b></p>
					<p>With AI Insurance you will automatically receive the 65% maximum no claims discount.</p>
					<p><b>Adjustable Excess Structure:</b></p>
					<p>This policy includes a reducing basic excess structure which rewards you for claims-free driving. This means that the amount of your basic excess is reduced for each claim-free year that you hold your policy with AI Insurance.</p>
					<p>The following table provides you with more information on how the basic excess reduces when you have no at fault claims.</p>

					<table class="offer-terms-table">
						<tr class="otbh">
							<td class="otbh">Claims Free Year</td>
							<td class="otbh">Basic Excess – Option 1</td>
						</tr>
						<tr><td>Year 1</td><td>$600</td></tr>
						<tr><td>Year 2</td><td>$450</td></tr>
						<tr><td>Year 3</td><td>$300</td></tr>
						<tr><td>Year 4</td><td>$150</td></tr>
						<tr><td>Year 5</td><td>$0</td></tr>
					</table>

					<p>Please note that if you make an at fault claim, your basic excess level will revert back by two years. For more information, please refer to the <a href="javascript:showDoc('http://www.aiinsurance.com.au/Docs/Pds_a.pdf');">Product Disclosure Statement Part A</a> and <a href="javascript:showDoc('http://www.aiinsurance.com.au/Docs/Pds_b.pdf');">Product Disclosure Statement Part B</a></p>
				]]>				
			</terms>
			<carbonOffset />
			<kms />
			
			</xsl:when>				

<!-- CARSURE INSURANCE -->
		<xsl:when test="$productId = 'CRSR-01-01'">
			<name>Carsure Comprehensive</name>
			<des>
				<![CDATA[
					100% Australian Owned and Operated. Automotive insurance is not just <u>one</u> of the things Carsure do; it's the only thing they do.				
				]]>
			</des>
			<feature>
				<![CDATA[
					Guaranteed 5% discount on 2nd year renewal if your situation does not change.		
				]]>
			</feature>
			<info>
				<![CDATA[
				<p><b>Carsure.com.au</b> au (associated with AVEA Insurance Limited) is 100% owned and operated in Australia.</p>
				<p>Carsure standard car insurance policy includes;</p>
				<p>				
					<li>One excess free windscreen claim in any period of insurance ($400)*</li>
					<li>Faultless excess if accident not your fault (refer Product Disclosure Statement)* </li>
					<li>New vehicle replacement within 2 years of registration, when insured with us from new*</li>
					<li>Automatic No Claim Bonus protection when full no claims rating held* </li>
					<li>Emergency repairs and / or accommodation when away from home ($300)* </li>
					<li>Loss of personal items in your vehicle ($300)* </li>
					<li>Trailer/caravan damage or theft whilst attached to your car ($1000)* </li>
					<li>Hire Car Cover when vehicle stolen (for 14 days) ($500)*</li>
				</p>
				<p>* Refer to the Product Disclosure Statement for more information</p>						
				<p>You can pay your premium monthly!</p>
				]]>
			</info>
			<terms>
				<![CDATA[
				<p><b>Carsure.com.au</b> au (associated with AVEA Insurance Limited) is 100% owned and operated in Australia.</p>
				<p>Carsure standard car insurance policy includes;</p>
				<div style="margin-left: 35px">
					<p>				
						<li>One excess free windscreen claim in any period of insurance ($400)*</li>
						<li>Faultless excess if accident not your fault (refer Product Disclosure<br>Statement)* </li>
						<li>New vehicle replacement within 2 years of registration, when insured<br>with us from new*</li>
						<li>Automatic No Claim Bonus protection when full no claims rating held* </li>
						<li>Emergency repairs and / or accommodation when away from home ($300)* </li>
						<li>Loss of personal items in your vehicle ($300)* </li>
						<li>Trailer/caravan damage or theft whilst attached to your car ($1000)* </li>
						<li>Hire Car Cover when vehicle stolen (for 14 days) ($500)*</li>
					</p>
				</div>
				<p>* Refer to the Product Disclosure Statement for more information</p>						
				<p>You can pay your premium monthly!</p>
				]]>
			</terms>
			<carbonOffset />
			<kms />
			
			</xsl:when>				

<!-- AUTOBARN INSURANCE -->
		<xsl:when test="$productId = 'AUBN-01-01'">
			<name>AutObarn</name>
			<des>
				<![CDATA[
					Provide car insurance to protect people who love their cars.				
				]]>
			</des>				
			<feature>
				<![CDATA[
					Includes a $30 AutObarn gift voucher and free Club Membership (excl. Pay By Month)				
				]]>
			</feature>
			<info>
				<![CDATA[
				<p><b>AutObarn</b> is one of Australia's most recognised names in the world of cars, serving the Australian community with over 100 stores as well as sponsoring and participating in V8 motorsports. AutObarn is synonymous with everything automotive so it makes sense that AutObarn; provide car insurance to protect people who love their cars.</p>
				<p><b>AutObarn</b> standard car insurance policy includes;</p>
				<p>
					<li>One excess free windscreen claim in any period of insurance ($400)*</li>
					<li>Faultless excess if accident not your fault (refer Product Disclosure Statement)*</li>
					<li>New vehicle replacement within 2 years of registration, when insured with us from new*</li>
					<li>Automatic No Claim Bonus protection when full no claims rating held*</li>
					<li>Emergency repairs and / or accommodation when away from home ($300)*</li>
					<li>Loss of personal items in your vehicle ($300)*</li>
					<li>Trailer/caravan damage or theft whilst attached to your car ($1000)*</li>
					<li>Hire Car Cover when vehicle stolen (for 14 days) ($500)*</li>
				</p>
				<p>* Refer to the Product Disclosure Statement for more information</p>				
				<p>You can even pay your premium monthly!</p>				
				]]>
			</info>
			<terms />
			<carbonOffset />
			<kms />
			
			</xsl:when>				

<!-- DEFAULT -->								
		<xsl:otherwise>
			<name></name>
			<des></des>
			<feature></feature>
			<info></info>
			<terms></terms>
			<carbonOffset />
			<kms />
		</xsl:otherwise>				
		</xsl:choose>	
	</xsl:template>

</xsl:stylesheet>