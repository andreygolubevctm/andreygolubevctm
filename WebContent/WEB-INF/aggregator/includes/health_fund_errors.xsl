<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xalan="http://xml.apache.org/xalan"
	exclude-result-prefixes="xsl xalan">

	<!-- VARIABLES ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
	<xsl:variable name="fundErrorMapping" select="xalan:nodeset($fundErrors)/errors" />
	<xsl:variable name="errorMap">
		<errors>
			<!--
				This list is not intended to be an exhaustive list of possible error responses
				but rather focus exclusively on errors related to fields completed by the user.

				All other errors will be mapped to 000 and will include the error returned by
				the service verbatim. These types are of more value internally than	assisting
				users over the phone.
			-->
			<error code="000">Non-user related error - </error>
			<error code="001">Client&#39;s Title is invalid.</error>
			<error code="002">Client&#39;s Given Name is invalid.</error>
			<error code="003">Client&#39;s Surname is invalid.</error>
			<error code="004">Client&#39;s Date of Birth is invalid.</error>
			<error code="005">Client&#39;s Gender is invalid.</error>
			<error code="006">Client&#39;s Gender and Title are mismatched.</error>
			<error code="007">Partner&#39;s Title is invalid.</error>
			<error code="008">Partner&#39;s Given Name is invalid.</error>
			<error code="009">Partner&#39;s Surname is invalid.</error>
			<error code="010">Partner&#39;s Date of Birth is invalid.</error>
			<error code="011">Partner&#39;s Gender is invalid.</error>
			<error code="012">Partner&#39;s Gender and Title are mismatched.</error>
			<error code="013">A Dependant&#39;s Title is invalid.</error>
			<error code="014">A Dependant&#39;s Given Name is invalid.</error>
			<error code="015">A Dependant&#39;s Surname is invalid.</error>
			<error code="016">A Dependant&#39;s Date of Birth is invalid.</error>
			<error code="017">A Dependant&#39;s Gender is invalid.</error>
			<error code="018">A Dependant&#39;s School is invalid.</error>
			<error code="019">A Dependant&#39;s Gender and Title are mismatched.</error>
			<error code="020">A Dependant is invalid.</error>
			<error code="021">Number of Dependants is invalid for the situation</error>
			<error code="022">Contact Address is invalid.</error>
			<error code="023">Contact Suburb is invalid.</error>
			<error code="024">Contact Post Code is invalid.</error>
			<error code="025">Contact State is invalid.</error>
			<error code="026">Postal Address is invalid.</error>
			<error code="027">Postal Suburb is invalid.</error>
			<error code="028">Postal Post Code is invalid.</error>
			<error code="029">Postal State is invalid.</error>
			<error code="030">Contact Mobile Number is invalid.</error>
			<error code="031">Contact Other Number is invalid.</error>
			<error code="032">Contact Email Address is invalid.</error>
			<error code="033">Further communication indicator is invalid.</error>
			<error code="034">Client&#39;s Previous Fund is invalid.</error>
			<error code="035">Client&#39;s Previous Fund Membership ID is invalid.</error>
			<error code="036">Client&#39;s Previous Fund Authorisation is invalid.</error>
			<error code="037">Client&#39;s Previous Fund Authorisation Date is invalid.</error>
			<error code="038">Partner&#39;s Previous Fund is invalid.</error>
			<error code="039">Partner&#39;s Previous Fund Membership ID is invalid.</error>
			<error code="040">Partner&#39;s Previous Fund Authorisation is invalid.</error>
			<error code="041">Partner&#39;s Previous Fund Authorisation Date is invalid.</error>
			<error code="042">Policy Start Date is invalid.</error>
			<error code="043">Policy Payment Method indicator is invalid.</error>
			<error code="044">Policy Payment Frequency is invalid.</error>
			<error code="045">Direct Debit Bank Name is invalid.</error>
			<error code="046">Direct Debit Bank Account Name is invalid.</error>
			<error code="047">Direct Debit Bank BSB is invalid.</error>
			<error code="048">Direct Debit Bank Account Number is invalid.</error>
			<error code="049">Direct Debit Payment Day is invalid.</error>
			<error code="050">Credit Card Type is invalid.</error>
			<error code="051">Credit Card Name on Card is invalid.</error>
			<error code="052">Credit Card Number is invalid.</error>
			<error code="053">Credit Card Expiry Date is invalid.</error>
			<error code="054">Credit Card CCV Number is invalid.</error>
			<error code="055">Claims Bank Name is invalid.</error>
			<error code="056">Claims Bank Account Name is invalid.</error>
			<error code="057">Claims Bank BSB is invalid.</error>
			<error code="058">Claims Bank Account Number is invalid.</error>
			<error code="059">Medicare Number is invalid.</error>
			<error code="060">Medicare Expiry Date is invalid.</error>
			<error code="061">Medicare First Name is invalid.</error>
			<error code="062">Medicare Middle Initial is invalid.</error>
			<error code="063">Medicare Surname is invalid.</error>
			<error code="064">Medicare Date of Birth is invalid.</error>
			<error code="065">Medicare Gender is invalid.</error>
			<error code="066">A Mobile or Other number must be provided.</error>
			<error code="067">Client is an existing customer.</error>
			<error code="068">System offline, resubmit join after waiting a couple of minutes</error>
			<error code="069">Invalid Suburb/Postcode/State Combination</error>
			<error code="070">Phone number has invalid STD code</error>
			<error code="071">Phone Number Post Code / STD mismatch</error>
			<error code="072">Sex does not match title</error>
			<error code="073">Payment date cannot be less than DJF</error>
			<error code="074">Date must be >= today's date</error>
			<error code="075">Credit Card details are invalid.</error>
			<!-- Error code when you just want to return the original message without the awkward prefix  -->
			<error code="999"></error>
		</errors>
	</xsl:variable>
	<xsl:variable name="errorMapping" select="xalan:nodeset($errorMap)/errors" />

	<!-- TEMPLATE ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
	<xsl:template name="maperrors">
		<xsl:param name="code"/>
		<xsl:param name="parameter"></xsl:param>
		<xsl:param name="message"/>

		<xsl:variable name="errorMapCode">
			<xsl:choose>
				<xsl:when test="$code = '' or not($fundErrorMapping)"><xsl:text>999</xsl:text></xsl:when>
				<!-- The ? is a default override to force all errors to map to a specific internal code -->
				<xsl:when test="$fundErrorMapping/error[@code='?'] != ''"><xsl:value-of select="$fundErrorMapping/error[@code='?']" /></xsl:when>
				<!-- If code not found then auto map to 000 -->
				<xsl:when test="not($fundErrorMapping/error[@code=$code])"><xsl:text>000</xsl:text></xsl:when>
				<!-- Otherwise use the mapped code -->
				<xsl:otherwise><xsl:value-of select="$fundErrorMapping/error[@code=$code]" /></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="mappedErrorMessage">
			<xsl:choose>
				<!-- Return original message if code not mapped -->
				<xsl:when test="not($errorMapping) or not($errorMapping/error[@code=$errorMapCode])"><xsl:value-of select="$message" /></xsl:when>
				<!-- If code mapped to 999 return the original message -->
				<xsl:when test="$errorMapCode='999'"><xsl:value-of select="$message" /></xsl:when>
				<!-- If code mapped to 000 or 999 return mapped message AND the original message -->
				<xsl:when test="$errorMapCode='000'"><xsl:value-of select="$errorMapping/error[@code=$errorMapCode]" /><xsl:text> </xsl:text><xsl:value-of select="$message" /></xsl:when>
				<!-- Otherwise just return the mapped message -->
				<xsl:otherwise><xsl:value-of select="$errorMapping/error[@code=$errorMapCode]" /></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<error>
			<code>
				<xsl:choose>
					<xsl:when test="$code != ''">
						<xsl:value-of select="$code" />
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="$parameter" />
					</xsl:otherwise>
				</xsl:choose>
			</code>
			<text><xsl:value-of select="$mappedErrorMessage" /></text>
			<original><xsl:value-of select="$message" /></original>
		</error>
	</xsl:template>

</xsl:stylesheet>