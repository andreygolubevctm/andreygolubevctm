<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<!-- IMPORTS -->
	<xsl:import href="../includes/get_street_name.xsl"/>
	<xsl:import href="../includes/utils.xsl"/>

	<xsl:param name="today" />
	<xsl:param name="request" />	

<!-- MAIN TEMPLATE -->	
	<xsl:template match="/quote">
	
		<!-- Address variables -->
		<xsl:variable name="streetNameLower">
			<xsl:call-template name="get_street_name">
				<xsl:with-param name="address" select="avea/riskAddress" />
			</xsl:call-template>
		</xsl:variable>

		<xsl:variable name="streetName"
			select="translate($streetNameLower, $LOWERCASE, $UPPERCASE)" />
			
		<xsl:variable name="suburbName"
			select="translate(avea/riskAddress/suburbName, $LOWERCASE, $UPPERCASE)" />
			
		<xsl:variable name="state"
			select="translate(avea/riskAddress/state, $LOWERCASE, $UPPERCASE)" />
			
		<xsl:variable name="postcode" select="avea/riskAddress/postCode" />
	
		<!-- SOAP REQUEST -->
		<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"
			xmlns:pay="http://services.fastr.com.au/Payment"
			xmlns:data="http://services.fastr.com.au/Payment/Data"
			xmlns:i="http://www.w3.org/2001/XMLSchema-instance">

			<soapenv:Header/>
			<soapenv:Body>
			   <ProcessAndUpdateMainInsured xmlns="http://services.fastr.com.au/Payment">
					<paymentRequest xmlns="http://services.fastr.com.au/Payment" xmlns:data="http://services.fastr.com.au/Payment/Data">
						<data:MotorQuotationItemPaymentDetail>
							<data:CreditCardDetails>
								<data:CardNumber><xsl:value-of select="translate(avea/payment/cardNumber,' ','')" /></data:CardNumber>
								<data:CardholderName><xsl:value-of select="translate(avea/payment/cardName,$LOWERCASE,$UPPERCASE)" /></data:CardholderName>
								<data:Expiry>
									<data:Month><xsl:value-of select="avea/payment/cardExpiryMonth" /></data:Month>
									<data:Year><xsl:value-of select="avea/payment/cardExpiryYear" /></data:Year>
								</data:Expiry>
								<data:VerificationCode>000</data:VerificationCode>
							</data:CreditCardDetails>
							<data:PaymentMethodCode><xsl:value-of select="avea/premiumType" /></data:PaymentMethodCode>
						</data:MotorQuotationItemPaymentDetail>
						<data:QuotationNumber><xsl:value-of select="avea/leadNo" /></data:QuotationNumber>
					</paymentRequest>
					<updateMainInsuredRequest xmlns="http://services.fastr.com.au/Payment" xmlns:data="http://services.fastr.com.au/Payment/Data">
						<data:MainInsured>
							<data:Email><xsl:value-of select="avea/policyholder/email" /></data:Email>
							<data:FirstName><xsl:value-of select="avea/driver0/firstName" /></data:FirstName>
							
							<xsl:choose>
								<xsl:when test="avea/policyholder/areaCode=''">
									<data:Mobile />
									<data:Phone1><xsl:value-of select="avea/policyholder/phone" /></data:Phone1>
								</xsl:when>
								<xsl:otherwise>
									<data:Mobile><xsl:value-of select="avea/policyholder/phone" /></data:Mobile>
									<data:Phone1><xsl:value-of select="contact/phone" /></data:Phone1>
								</xsl:otherwise>
							</xsl:choose>							

							<data:PostCode><xsl:value-of select="$postcode" /></data:PostCode>
							<data:PostalAddress1><xsl:value-of select="$streetName" /></data:PostalAddress1>
							<data:State><xsl:value-of select="$state" /></data:State>
							<data:Suburb><xsl:value-of select="$suburbName" /></data:Suburb>
							<data:Surname><xsl:value-of select="avea/driver0/lastName" /></data:Surname>
							<data:Title><xsl:value-of select="avea/driver0/title" /></data:Title>
							<data:WorkPhone />
						</data:MainInsured>
					</updateMainInsuredRequest>		         
					<username xmlns="http://services.fastr.com.au/Payment">
						<xsl:choose>
							<xsl:when test="/quote/avea/productId = 'crsr'">captaincompare</xsl:when>
							<xsl:when test="/quote/avea/productId = 'aubn'">captaincompareauto</xsl:when>
							<xsl:otherwise>captaincompare</xsl:otherwise>
						</xsl:choose>						
					</username>
					</ProcessAndUpdateMainInsured>
				</soapenv:Body>
			</soapenv:Envelope>
		
	</xsl:template>

</xsl:stylesheet>

