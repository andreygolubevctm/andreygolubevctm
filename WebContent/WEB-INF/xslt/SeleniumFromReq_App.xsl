<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output indent="no" method="html"></xsl:output>
	<xsl:param name="env"></xsl:param>
	<xsl:param name="filename"></xsl:param>
	
	<xsl:template match="/health">
		<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
		<head profile="http://selenium-ide.openqa.org/profiles/test-case">
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
		<xsl:choose>
			<xsl:when test="$env = 'pro'">	
				<link rel="selenium.base" href="https://secure.comparethemarket.com.au/ctm/health_quote.jsp" />
			</xsl:when>
			<xsl:when test="$env = 'staging'">
				<link rel="selenium.base" href="https://staging.secure.comparethemarket.com.au/ctm/health_quote.jsp" />
			</xsl:when>
			<xsl:when test="$env = 'qa'">
				<link rel="selenium.base" href="https://qa.secure.comparethemarket.com.au/ctm/health_quote.jsp" />
			</xsl:when>
			<xsl:otherwise>
				<link rel="selenium.base" href="http://localhost:8080/ctm/health_quote.jsp" />
			</xsl:otherwise>
		</xsl:choose>
					
		<title><xsl:value-of select="$filename" /></title>
		</head>
		<body>
			<table cellpadding="1" cellspacing="1" border="1">
			<thead>
			<tr><td rowspan="1" colspan="3"><xsl:value-of select="$filename" /></td></tr>
			</thead><tbody>
			<xsl:for-each select="application/dependants/*">
				<xsl:if test="firstName != ''">
					<tr>
						<td>select</td>
						<td>id=health_application_dependants_<xsl:value-of select="name()" />_title</td>
						<td>value=<xsl:value-of select="title" /></td>
					</tr>
					<tr>
						<td>type</td>
						<td>id=health_application_dependants_<xsl:value-of select="name()" />_firstName</td>
						<td><xsl:value-of select="firstName" /></td>
					</tr>
					<tr>
						<td>type</td>
						<td>id=health_application_dependants_<xsl:value-of select="name()" />_lastname</td>
						<td><xsl:value-of select="lastname" /></td>
					</tr>
					<tr>
						<td>type</td>
						<td>id=health_application_dependants_<xsl:value-of select="name()" />_school</td>
						<td><xsl:value-of select="school" /></td>
					</tr>
					<tr>
						<td>type</td>
						<td>id=health_application_dependants_<xsl:value-of select="name()" />_dob</td>
						<td><xsl:value-of select="dob" /></td>
					</tr>
				</xsl:if>				
			</xsl:for-each>		
			<tr>
				<td>select</td>
				<td>id=health_application_primary_title</td>
				<td>value=<xsl:value-of select="application/primary/title" /></td>
			</tr>
			<tr>
				<td>click</td>
				<xsl:choose>
				<xsl:when test="application/primary/gender='M'">
					<td>id=health_application_primary_gender_M</td>
				</xsl:when>
				<xsl:otherwise>
					<td>id=health_application_primary_gender_F</td>
				</xsl:otherwise>
				</xsl:choose>
				<td></td>
			</tr>
			<xsl:if test="application/partner/firstname != ''">
				<tr>
					<td>select</td>
					<td>id=health_application_partner_title</td>
					<td>value=<xsl:value-of select="application/partner/title" /></td>
				</tr>
				<tr>
					<td>type</td>
					<td>id=health_application_partner_firstname</td>
					<td><xsl:value-of select="application/partner/firstname" /></td>
				</tr>
				<tr>
					<td>type</td>
					<td>id=health_application_partner_surname</td>
					<td><xsl:value-of select="application/partner/surname" /></td>
				</tr>
				<tr>
					<td>click</td>
					<td>id=health_application_partner_gender_<xsl:value-of select="application/partner/gender" /></td>
					<td></td>
				</tr>
			</xsl:if>
			<tr>
				<td>type</td>
				<td>id=health_application_address_postCode</td>
				<td>4066</td>
			</tr>
			
			<xsl:if test="application/address/nonStd = 'Y' ">
				<tr>
					<td>click</td>
					<td>id=health_application_address_nonStd</td>
					<td></td>
				</tr>
				<tr>
					<td>type</td>
					<td>id=health_application_address_nonStdStreet</td>
					<td><xsl:value-of select="application/address/nonStdStreet" /></td>
				</tr>
				<tr>
					<td>type</td>
					<td>id=health_application_address_streetNum</td>
					<td><xsl:value-of select="application/address/streetNum" /></td>
				</tr>
				<tr>
					<td>pause</td>
					<td>250</td>
					<td></td>
				</tr>
				<tr>
					<td>select</td>
					<td>id=health_application_address_suburb</td>
					<td><xsl:value-of select="application/address/suburbName" /></td>
				</tr>				
			</xsl:if>
			<tr>
				<td>select</td>
				<td>id=health_previousfund_primary_fundName</td>
				<td>value=<xsl:value-of select="previousfund/primary/fundName" /></td>
			</tr>
			<tr>
				<td>type</td>
				<td>id=health_previousfund_primary_memberID</td>
				<td><xsl:value-of select="previousfund/primary/memberID" /></td>
			</tr>
			<tr>
				<td>fireEvent</td>
				<td>id=health_application_address_suburb</td>
				<td>click</td>
			</tr>
			<xsl:if test="previousfund/partner/fundName != ''">
				<tr>
					<td>select</td>
					<td>id=health_previousfund_partner_fundName</td>
					<td>value=<xsl:value-of select="previousfund/partner/fundName" /></td>
				</tr>			
				<tr>
					<td>type</td>
					<td>id=health_previousfund_partner_memberID</td>
					<td><xsl:value-of select="previousfund/partner/memberID" /></td>
				</tr>
			</xsl:if>
			<tr>
				<td>click</td>
				<td>css=#next-step &gt; span</td>
				<td></td>
			</tr>
			<tr>
				<td>click</td>
				<td>id=health_payment_details_start</td>
				<td></td>
			</tr>
			<tr>
				<td>click</td>
				<td>link=19</td>
				<td></td>
			</tr>
			<tr>
				<td>click</td>
				<td>id=health_payment_details_type_<xsl:value-of select="payment/details/type" /></td>
				<td></td>
			</tr>
			<tr>
				<td>select</td>
				<td>id=health_payment_details_frequency</td>
				<td>value=<xsl:value-of select="payment/details/frequency" /></td>
			</tr>
			<xsl:choose>
			<xsl:when test="payment/details/type=cc" >
				<tr>
					<td>type</td>
					<td>id=health_payment_credit_name</td>
					<td>CCName</td>
				</tr>
				<tr>
					<td>select</td>
					<td>id=health_payment_credit_expiry_cardExpiryMonth</td>
					<td>value=<xsl:value-of select="payment/credit/expiry/cardExpiryMonth" /></td>
				</tr>
				<tr>
					<td>select</td>
					<td>id=health_payment_credit_expiry_cardExpiryYear</td>
					<td>value=<xsl:value-of select="payment/credit/expiry/cardExpiryYear" /></td>
				</tr>
				<tr>
					<td>type</td>
					<td>id=health_payment_credit_ccv</td>
					<td><xsl:value-of select="payment/credit/ccv" /></td>
				</tr>
				<tr>
					<td>select</td>
					<td>id=health_payment_credit_type</td>
					<td>value=<xsl:value-of select="payment/credit/type" /></td>
				</tr>				
				<tr>
					<td>select</td>
					<td>id=health_payment_credit_day</td>
					<td>value=<xsl:value-of select="payment/credit/day" /></td>
				</tr>
				<tr>
					<td>type</td>
					<td>id=health_payment_credit_number</td>
					<td><xsl:value-of select="payment/credit/number" /></td>
				</tr>
			</xsl:when>
			</xsl:choose>
			<tr>
				<td>click</td>
				<td>id=health_payment_medicare_cover_<xsl:value-of select="payment/medicare/cover" /></td>
				<td></td>
			</tr>
			<xsl:if test="payment/medicare/cover = 'Y'">
				<tr>
					<td>select</td>
					<td>id=health_payment_medicare_expiry_cardExpiryMonth</td>
					<td>value=<xsl:value-of select="payment/medicare/expiry/cardExpiryMonth" /></td>
				</tr>
				<tr>
					<td>select</td>
					<td>id=health_payment_medicare_expiry_cardExpiryYear</td>
					<td>value=<xsl:value-of select="payment/medicare/expiry/cardExpiryYear" /></td>
				</tr>
				<tr>
					<td>type</td>
					<td>id=health_payment_medicare_firstName</td>
					<td>value=<xsl:value-of select="payment/medicare/firstName" /></td>
				</tr>
				<tr>
					<td>type</td>
					<td>id=health_payment_medicare_middleInitial</td>
					<td><xsl:value-of select="payment/medicare/middleInitial" /></td>
				</tr>
				<tr>
					<td>type</td>
					<td>id=health_payment_medicare_number</td>
					<td><xsl:value-of select="payment/medicare/number" /></td>
				</tr>
				<tr>
					<td>type</td>
					<td>id=health_payment_medicare_surname</td>
					<td><xsl:value-of select="payment/medicare/surname" /></td>
				</tr>
			</xsl:if>
							
			<tr>
				<td>click</td>
				<td>id=health_declaration</td>
				<td></td>
			</tr>
			<tr>
				<td>click</td>
				<td>css=#update-step &gt; span</td>
				<td></td>
			</tr>
			
			<tr>
				<td>click</td>
				<td>css=#confirm-step &gt; span</td>
				<td></td>
			</tr>			
		</tbody></table>
		</body>
		</html>
	</xsl:template>
</xsl:stylesheet>