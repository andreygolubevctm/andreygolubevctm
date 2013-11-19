<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">	
	<xsl:template name="productInfo">
		<xsl:param name="productId" />
		<xsl:param name="priceType" />
		<xsl:param name="kms" />
		
		<xsl:choose>
		<!-- REAL Pay as you drive -->
		<xsl:when test="$productId = 'PAYD-01-01'">
			<name>Pay As You Drive</name>
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
		<xsl:when test="$productId = 'REIN-01-01'">
			<name>Real Pay As You Drive</name>
			<des><![CDATA[
				Comprehensive cover for less, only pay for the km's you plan to drive - the less you drive, the more you save.
				]]>
			</des>
			<feature>Only pay for the kilometres you drive!</feature>
			<info>
				<![CDATA[
				<p>With Real Pay As You Drive, the less you drive, the less you pay.</p>
				<p>You get the benefits of comprehensive car insurance cover, but only pay for the kilometres you plan to drive. You pay a minimum premium and buy kilometres to use.</p>
				<p>If you don't drive the kilometres you paid for, they can be transferred to the following cover period and unused kilometres never expire!</p>
				<div id="real_insurance_awards"><img src="common/images/real_insurance_awards.jpg"></div>
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
	<!-- REAL Comprehensive NEW PRODUCT -->
		<xsl:when test="$productId = 'REIN-01-02'">
			<name>Comprehensive Car Insurance</name>
			<des><![CDATA[
				Awarded Money magazines Best of the Best 2013 award for Cheapest Car Insurance for our Comprehensive cover.
				]]>
			</des>
			<feature>Build personalised cover and only pay for what you choose.</feature>
			<info>
				<![CDATA[
				<p>With Real Pay As You Drive, the less you drive, the less you pay.</p>
				<p>You get the benefits of comprehensive car insurance cover, but only pay for the kilometres you plan to drive. You pay a minimum premium and buy kilometres to use.</p>
				<p>If you dont drive the kilometres you paid for, they can be transferred to the following cover period and unused kilometres never expire!</p>
				<div id="real_insurance_awards"><img src="common/images/real_insurance_awards.jpg"></div>
				]]>
			</info>
			<terms />
			<carbonOffset />
			<kms><xsl:value-of select="$kms" /></kms>

			</xsl:when>

			<!-- WOOL #1 -->
			<xsl:when test="$productId = 'WOOL-01-01'">
				<name>Woolworths Drive Less Pay Less</name>
				<des><![CDATA[
					Available to people who drive less than average for their age and postcode. See how this can lower your comprehensive insurance premium.
					]]>
				</des>
				<feature>
					<![CDATA[
						Plus get a $50 fuel gift card<sup>#</sup> and an extra 4c per litre fuel savings<sup>^</sup>
					]]>
				</feature>
				<info>
					<![CDATA[

					]]>
				</info>
				<terms>
					<![CDATA[
						<p>
							# The $50 Fuel Gift Card will be sent within 45 days of first premium being paid. The Card is issued by and remains the property of Woolworths. The Card may be used at participating stores. The Card and any unspent value expires 12 months from date of issue. The Card is not reloadable or redeemable for cash. For terms and conditions and a list of participating stores visit <a href="http://www.everydaygiftcards.com.au" target="_blank">www.everydaygiftcards.com.au<a/>. Offer ends 31 December 2013.
						</p>
						<p>
							^ Valid to Woolworths Car Insurance policy holders in the first year of insurance. The extra 4c per litre fuel saving for Woolworths Car Insurance policy holders is in addition to, and can only be used in conjunction with a fuel saving voucher received in-store when spending $30 or more in one transaction at a Woolworths supermarket (excluding Tasmania). Offer only applies to the Everyday Rewards Card registered when taking out a Woolworths Car Insurance policy. The extra 4c per litre fuel saving will be available on the applicable Everyday Rewards Card within 45 days of the first premium being paid and will expire after 12 months. To receive the extra 4c per litre discount you must comply with all requirements for the standard in-store fuel discount promotion. For standard terms and conditions visit <a href="http://www.woolworthspetrol.com.au/discountterms.html" target="_blank">http://www.woolworthspetrol.com.au/discountterms.html</a>
						</p>
						<p>
							Benefits are subject to the terms and conditions including the limits and exclusions of the insurance policy. Cover is issued by The Hollard Insurance Company Pty Ltd ABN 78 090 584 473AFSL No. 241436 (Hollard). Woolworths Ltd ABN 88 000 014 675 AR No. 245476 (Woolworths) acts as Hollard's authorised representative. Any advice provided is general only and may not be right for you. Before you purchase this product you should carefully read the Combined Product Disclosure Statement and Financial Services Guide (Combined <a href="http://insurance.woolworths.com.au/sites/default/files/Woolworths_Car%20Insurance_PDS.pdf" target="_blank">PDS</a> FSG) to decide if it is right for you.
						</p>
					]]>
				</terms>
				<carbonOffset />
				<kms><xsl:value-of select="$kms" /></kms>

			</xsl:when>
			<!-- WOOL #2 -->
			<xsl:when test="$productId = 'WOOL-01-02'">
				<name>Woolworths Comprehensive</name>
				<des><![CDATA[
					Thorough cover from bonnet to boot. Super insurance at a low supermarket price.
					]]>
				</des>
				<feature>
					<![CDATA[
						Plus get a $50 fuel gift card<sup>#</sup> and an extra 4c per litre fuel savings<sup>^</sup>
					]]>
				</feature>
				<info>
					<![CDATA[
					]]>
				</info>
				<terms>
					<![CDATA[
						<p>
							# The $50 Fuel Gift Card will be sent within 45 days of first premium being paid. The Card is issued by and remains the property of Woolworths. The Card may be used at participating stores. The Card and any unspent value expires 12 months from date of issue. The Card is not reloadable or redeemable for cash. For terms and conditions and a list of participating stores visit <a href="http://www.everydaygiftcards.com.au" target="_blank">www.everydaygiftcards.com.au<a/>. Offer ends 31 December 2013.
						</p>
						<p>
							^ Valid to Woolworths Car Insurance policy holders in the first year of insurance. The extra 4c per litre fuel saving for Woolworths Car Insurance policy holders is in addition to, and can only be used in conjunction with a fuel saving voucher received in-store when spending $30 or more in one transaction at a Woolworths supermarket (excluding Tasmania). Offer only applies to the Everyday Rewards Card registered when taking out a Woolworths Car Insurance policy. The extra 4c per litre fuel saving will be available on the applicable Everyday Rewards Card within 45 days of the first premium being paid and will expire after 12 months. To receive the extra 4c per litre discount you must comply with all requirements for the standard in-store fuel discount promotion. For standard terms and conditions visit <a href="http://www.woolworthspetrol.com.au/discountterms.html" target="_blank">http://www.woolworthspetrol.com.au/discountterms.html</a>
						</p>
						<p>
							Benefits are subject to the terms and conditions including the limits and exclusions of the insurance policy. Cover is issued by The Hollard Insurance Company Pty Ltd ABN 78 090 584 473AFSL No. 241436 (Hollard). Woolworths Ltd ABN 88 000 014 675 AR No. 245476 (Woolworths) acts as Hollard's authorised representative. Any advice provided is general only and may not be right for you. Before you purchase this product you should carefully read the Combined Product Disclosure Statement and Financial Services Guide (Combined <a href="http://insurance.woolworths.com.au/sites/default/files/Woolworths_Car%20Insurance_PDS.pdf" target="_blank">PDS</a> FSG) to decide if it is right for you.
						</p>
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
				<li style="font-size:11px;"><strong>Faultless excess</strong> - no excess payable for accident claims where the driver is not at fault and the at fault drivers details have been provided to AI Insurance*</li>
				<li style="font-size:11px;"><strong>Reducible basic excess</strong> - AI Insurance rewards you for each year that you don't make a claim by reducing your excess*</li>
				<li style="font-size:11px;"><strong>Client choice of repairer</strong> - AI Insurance allows clients to select their repairer of choice*<br>
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
							<td class="otbh">Basic Excess - Option 1</td>
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
					<li>Faultless excess if accident not your fault (refer to Product Disclosure Statement)*</li>
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
						<li>Faultless excess if accident not your fault (refer to Product Disclosure<br>Statement)* </li>
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

		<xsl:when test="$productId = 'BUDD-05-01'">
			<name>Standard Comprehensive</name>
			<des><![CDATA[Simply smarter car insurance. Winner of CANSTAR's 'Outstanding Value Car Insurance' award every year since it was first presented in 2007.]]></des>
			<feature><![CDATA[Car insurance that could save you $100s!]]></feature>
			<info><![CDATA[<p>With seven consecutive CANSTAR awards for "Outstanding Value Car Insurance" (2007-2013), Budget Direct is proud to offer simply smarter insurance that could save you money. Using smarter questions Budget Direct are able to identify better drivers which means you could be offered a cheaper price. Their commitment to innovation means you get the features you'd expect + more including Hail Hero,  Budget Direct's award winning hail alert service, fortnightly payment options  &amp; the reliable service of 100% Australian based call centres.</p><p>Budget Direct's multi-award-winning Standard Comprehensive car insurance policy has the features and benefits you'd expect from standard cover at a competitive price. It covers the cost of repairs not only to your car, but also to other vehicles as well, if you are deemed to be at fault. It also includes emergency transport and accommodation cover, as well as hire car cover after theft, to give you peace of mind in the event of a claim.</p>                                                                            <p><div id="budget_direct_awards"><img src="common/images/awards_canstar_final.png"></div></p>]]></info>
			<terms/>
			<carbonOffset/>
			<kms/>
		</xsl:when>

		<xsl:when test="$productId = 'BUDD-05-04'">
			<name>Gold Comprehensive</name> 
			<des><![CDATA[Winner CANSTAR award for 'Outstanding Value Car Insurance' a record 7 years in a row 2007-2013]]></des>
			<info><![CDATA[<p>With seven consecutive CANSTAR awards for "Outstanding Value Car Insurance" (2007-2013), Budget Direct is proud to offer simply smarter insurance that could save you money. Using smarter questions Budget Direct are able to identify better drivers which means you could be offered a cheaper price. Their commitment to innovation means you get the features you'd expect + more including Hail Hero,  an award winning hail alert service, fortnightly payment options  &amp; the reliable service of 100% Australian based call centres.</p><p>Budget Direct's Gold Comprehensive car insurance policy is a step up from Standard Comprehensive cover. It has all the features of Standard Comprehensive cover, but includes additional elements such as 24 month New Car replacement and higher limits on a range of benefits. See PDS for full details.</p> <p><div id="budget_direct_awards"><img src="common/images/awards_canstar_final.png"></div></p>]]></info>
			<feature><![CDATA[Price shown includes 10% Online Discount]]></feature> 
			<terms><![CDATA[<p><b>10% Online Discount</b></p> <p>Discount applies to Budget Direct Gold comprehensive motor policies initiated online between 01 Jun 13 &amp; 31 Dec 13. Budget Direct reserves the right to amend the discount amount or period. Discount applies to premium only (not fees and statutory charges) and does not extend to renewing motor policies. </p>]]></terms>
			<carbonOffset />
			<kms />
		</xsl:when>

		<xsl:when test="$productId = 'OZIC-05-01'">
			<name>Standard Comprehensive</name> 
			<des><![CDATA[Hassle free car insurance at a price that won't break the bank]]></des> 
			<feature><![CDATA[Cares for you and your car, at very competitive prices]]></feature> 
			<info><![CDATA[<p>Ozicare pride themselves on providing hassle free car insurance at a price that won't break the bank.</p> <p>For average Australian drivers, with a good driving history, Ozicare can offer policies with a broad range of cover at highly competitive premiums.</p>]]></info> 
			<terms /> 
			<carbonOffset /> 
			<kms /> 
		</xsl:when>

		<xsl:when test="$productId = 'OZIC-05-04'">
			<name>Gold Comprehensive</name>
			<des><![CDATA[Hassle free car insurance at a price that won't break the bank]]></des>
			<feature><![CDATA[Cares for you and your car, at very competitive prices and our Gold level of coverage]]></feature>
			<info><![CDATA[<p>Ozicare pride themselves on providing hassle free car insurance at a price that won't break the bank.</p>  <p>For average Australian drivers, with a good driving history, Ozicare can offer policies with their gold level of cover at competitive premiums.</p>]]></info>
			<terms/>
			<carbonOffset/>
			<kms/>
		</xsl:when>

		<xsl:when test="$productId = '1FOW-05-02'">
			<name>Lady Driver Comprehensive</name> 
			<des><![CDATA[Dedicated to providing women drivers with better rates]]></des> 
			<info><![CDATA[<p>Female drivers can save with hassle free comprehensive car insurance designed just for them.</p><p>As a women you could now pay less for your car insurance, by taking advantage of competitive rates and many additional optional extras to help tailor a policy that's perfect for you.</p>]]></info> 
			<feature><![CDATA[Female drivers can save with hassle free car insurance.]]></feature> 
			<terms><![CDATA[<p><b>Additional excess for male drivers</b></p> <p>This indicative quote includes an additional excess of $200 for Male Drivers.</p>]]></terms> 
			<carbonOffset />
			<kms />
		</xsl:when>

		<xsl:when test="$productId = 'RETI-05-03'">
			<name>Retired Driver Comprehensive</name> 
			<des><![CDATA[Comprehensive vehicle cover designed to reward the driving patterns of safe, retired drivers with better premiums]]></des> 
			<info><![CDATA[<p>Retirease Comprehensive vehicle insurance rewards Australia's quality retired drivers with lower prices, while still offering great coverage and an easy claims process.</p><p> For additional savings, customers can also choose to reduce the premium by optionally restricting the age of drivers covered by the policy.</p>]]></info> 
			<feature><![CDATA[Retirease rewards Australia's quality retired drivers with lower prices]]></feature> 
			<terms><![CDATA[<p><b>Additional excess for non-retired drivers</b></p> <p>This indicative quote includes an additional excess of $200 for non-retired drivers.</p>]]></terms> 
			<carbonOffset />
			<kms />
		</xsl:when>

		<xsl:when test="$productId = 'CBCK-05-08'">
			<name>Cashback Comprehensive</name> 
			<des><![CDATA[Australia's First Cashback Car Insurance provider.]]></des> 
			<feature><![CDATA[Refunds 10% of the total premium paid over 3 years if you don't make a claim!]]></feature> 
			<info><![CDATA[<p>When was the last time you were given money for being claim free?</p><p>At Cashback, they believe valued customers deserve rewards and give a refund of 10% of the total premium paid over 3 years if you don't make a claim!</p><p>The refund is 10% of the total annual Vehicle Premiums paid during the three year period.</p>]]></info> 
			<terms><![CDATA[<p><b>10% Cashback Offer</b></p> <p>The refund is 10% of the total annual Vehicle Premiums paid during the three year period, excluding any fees and unrecoverable government charges, as long you don't lodge a claim over the 3 continuous policy years.</p>]]></terms> 
			<carbonOffset /> 
			<kms /> 
		</xsl:when>

		<xsl:when test="$productId = 'IECO-05-09'">
			<name>ibuyeco Comprehensive</name> 
			<des><![CDATA[ibuyeco policies can help you to save money, and help you to save the environment]]></des> 
			<feature><![CDATA[100% carbon offset of your car's annual carbon emissions]]></feature> 
			<info><![CDATA[<p>ibuyeco policies can help you save money while you're helping to save the environment.</p> <p>Not only will you get a great deal on quality car insurance, an ibuyeco policy includes a carbon offset service to offset 100% of your car's annual carbon emissions, calculated using information you have provided.</p>]]></info> 
			<terms><![CDATA[<p><b>Carbon offset</b></p> <p>Indicative quote includes cost to offset 5.86 tonnes of CO2 emissions.</p> <p>The carbon offsetting activity will meet the Australian Government Greenhouse Friendly&#0153; standard, the criteria of the Kyoto Protocol, will be independently audited and is guaranteed for 100 years.</p>]]></terms>
			<carbonOffset>5.86</carbonOffset> 
			<kms /> 
		</xsl:when>

		<xsl:when test="$productId = 'VIRG-05-11'">
			<name>Virgin Car Insurance</name> 
			<des><![CDATA[Park your car insurance in a better place with Virgin Car Insurance. Tailor your policy and save up to $250, plus get the same low price in year 2 if your situation stays the same.]]></des> 
			<feature><![CDATA[Tailor your policy and save, plus same low price year 2.]]></feature> 
			<info><![CDATA[<p><b>Park your car insurance in a better place</b></p>If you've been hit by a higher car insurance premium this year, compare a quote from Virgin Car Insurance today.</p> <li><b>Save up to $250</b> - You could save up to $250, simply by tailoring your policy*</li> <li><b>Same low price in year 2</b> - Once you get your great low price, Virgin Car Insurance will guarantee it for your second year if your situation stays the same*</li> <p>Find out how you and Virgin Car Insurance could be good together - get a quote and compare today.</p>]]></info> 
			<terms><![CDATA[Save up to $250: Based on a basic comprehensive policy, with no optional extras, drivers age restricted to 30 and over, $200 additional excess and no rating 1 protection.<br><br> Same low price in second year: Subject to no changes to the policy details or driving history of listed drivers and no claim being made on the policy. Offer excludes fees and government charges.]]></terms> 
			<carbonOffset /> 
			<kms /> 
		</xsl:when>
		
		<xsl:when test="$productId = 'EXPO-05-13'">
			<name>Australia Post Comprehensive</name> 
			<des><![CDATA[A choice of affordable and highly competitive insurance cover from one of Australia's most trusted brands]]></des> 
			<feature><![CDATA[Australia Post, delivering affordable car insurance]]></feature> 
			<info><![CDATA[<p>Australia Post Car Insurance is designed to help meet Australians' everyday needs. It offers you cost effective way to cover your car and your lifestyle should the unexpected happen. With Australia Post Car Insurance you'll get all the features you'd expect at a price that might surprise you.</p>]]></info> 
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