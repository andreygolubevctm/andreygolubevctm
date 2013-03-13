<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"
	exclude-result-prefixes="soapenv">

	<xsl:strip-space elements="*"/>
		
	<!-- IMPORTS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
	<xsl:include href="utils.xsl"/>
	
	<!-- PARAMETERS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
	
	<!-- ADDRESS VARIABLES -->
	
	<xsl:template name="get_street_type">
		<xsl:param name="streetname"/>
		
		<xsl:variable name="streettype">
			<xsl:call-template name="substring-after-last">
				<xsl:with-param name="list" select="normalize-space($streetname)"/>
				<xsl:with-param name="delimiter" select="' '"/>
			</xsl:call-template>
		</xsl:variable>
		
		<xsl:value-of select="$streettype" />
		
		<!-- Alley/Arcade/Avenue/Boulevard/Close/Crescent/Drive/Esplanade/Grove/Highway/Lane/Parade/Place/Road/Square/Street/Terrace/OTHER/Unspecified -->
		<!-- 
		<xsl:choose>
			<xsl:when test="$streettype = 'Alley'">
				<xsl:text>Alley</xsl:text>
			</xsl:when>
			<xsl:when test="$streettype = 'Arcade'">
				<xsl:text>Arcade</xsl:text>
			</xsl:when>
			<xsl:when test="$streettype = 'Avenue'">
				<xsl:text>Avenue</xsl:text>
			</xsl:when>
			<xsl:when test="$streettype = 'Boulevard'">
				<xsl:text>Boulevard</xsl:text>
			</xsl:when>
			<xsl:when test="$streettype = 'Circuit'">
				<xsl:text>Circuit</xsl:text>
			</xsl:when>
			<xsl:when test="$streettype = 'Close'">
				<xsl:text>Close</xsl:text>
			</xsl:when>
			<xsl:when test="$streettype = 'Court'">
				<xsl:text>Court</xsl:text>
			</xsl:when>
			<xsl:when test="$streettype = 'Crescent'">
				<xsl:text>Crescent</xsl:text>
			</xsl:when>
			<xsl:when test="$streettype = 'Drive'">
				<xsl:text>Drive</xsl:text>
			</xsl:when>
			<xsl:when test="$streettype = 'Esplanade'">
				<xsl:text>Esplanade</xsl:text>
			</xsl:when>
			<xsl:when test="$streettype = 'Grove'">
				<xsl:text>Grove</xsl:text>
			</xsl:when>
			<xsl:when test="$streettype = 'Highway'">
				<xsl:text>Highway</xsl:text>
			</xsl:when>
			<xsl:when test="$streettype = 'Lane'">
				<xsl:text>Lane</xsl:text>
			</xsl:when>
			<xsl:when test="$streettype = 'Parade'">
				<xsl:text>Parade</xsl:text>
			</xsl:when>
			<xsl:when test="$streettype = 'Place'">
				<xsl:text>Place</xsl:text>
			</xsl:when>
			<xsl:when test="$streettype = 'Quay'">
				<xsl:text>Quay</xsl:text>
			</xsl:when>
			<xsl:when test="$streettype = 'Road'">
				<xsl:text>Road</xsl:text>
			</xsl:when>
			<xsl:when test="$streettype = 'Square'">
				<xsl:text>Square</xsl:text>
			</xsl:when>
			<xsl:when test="$streettype = 'St.'">
				<xsl:text>Street</xsl:text>
			</xsl:when>
			<xsl:when test="$streettype = 'Terrace'">
				<xsl:text>Terrace</xsl:text>
			</xsl:when>
			<xsl:when test="$streettype = 'Way'">
				<xsl:text>Way</xsl:text>
			</xsl:when>
			<xsl:otherwise>
				<xsl:text>Unspecified</xsl:text>
			</xsl:otherwise>
		</xsl:choose>
		 -->
	  
	</xsl:template>
	
	<!-- SUPPLY ADDRESS VARIABLES ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
	<xsl:variable name="streetType">
		<xsl:choose>
			<xsl:when test="/utilities/application/details/address/streetName != ''">
			    <xsl:if test="contains(/utilities/application/details/address/streetName, ' ')">
				    <xsl:call-template name="get_street_type">
				    	<xsl:with-param name="streetname" select="/utilities/application/details/address/streetName"/>
				    </xsl:call-template>
				</xsl:if>
			</xsl:when>
			<xsl:when test="/utilities/application/details/address/nonStdStreet != ''">
				<xsl:if test="contains(/utilities/application/details/address/nonStdStreet, ' ')">
				    <xsl:call-template name="get_street_type">
				    	<xsl:with-param name="streetname" select="/utilities/application/details/address/nonStdStreet"/>
				    </xsl:call-template>
				</xsl:if>
			</xsl:when>
		</xsl:choose>
	</xsl:variable>
	
	<xsl:variable name="streetName">
		<xsl:choose>
			<xsl:when test="/utilities/application/details/address/streetName != ''">
				<xsl:choose>
					<xsl:when test="contains(/utilities/application/details/address/streetName, ' ')">
						<xsl:call-template name="substring-before-last">
							<xsl:with-param name="list" select="normalize-space(/utilities/application/details/address/streetName)"/>
							<xsl:with-param name="delimiter" select="' '"/>
						</xsl:call-template>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="/utilities/application/details/address/streetName"></xsl:value-of>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="/utilities/application/details/address/nonStdStreet != ''">
				<xsl:choose>
					<xsl:when test="contains(/utilities/application/details/address/nonStdStreet, ' ')">
						<xsl:call-template name="substring-before-last">
							<xsl:with-param name="list" select="normalize-space(/utilities/application/details/address/nonStdStreet)"/>
							<xsl:with-param name="delimiter" select="' '"/>
						</xsl:call-template>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="/utilities/application/details/address/nonStdStreet"></xsl:value-of>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
		</xsl:choose>
	</xsl:variable>
	
	<xsl:variable name="unitNo" select="/utilities/application/details/address/unitShop" />	
	<xsl:variable name="suburbName" select="/utilities/application/details/address/suburbName" /> 
	<xsl:variable name="state" select="/utilities/application/details/address/state" />
	
	<!-- Street Number -->
	<xsl:variable name="streetNo">
		<xsl:choose>
			<xsl:when test="/utilities/application/details/address/streetNum != ''">
				<xsl:value-of select="/utilities/application/details/address/streetNum" />
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="/utilities/application/details/address/houseNoSel" />
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	
	<xsl:variable name="postCode">
		<xsl:value-of select="/utilities/application/details/address/postCode" />
	</xsl:variable>
	
	
	
	<!-- BILLING ADDRESS VARIABLES ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
	<xsl:variable name="billing_streetType">
		<xsl:choose>
			<xsl:when test="/utilities/application/details/address/streetName != ''">
			    <xsl:if test="contains(/utilities/application/details/address/streetName, ' ')">
				    <xsl:call-template name="get_street_type">
				    	<xsl:with-param name="streetname" select="/utilities/application/details/address/streetName"/>
				    </xsl:call-template>
				</xsl:if>
			</xsl:when>
			<xsl:when test="/utilities/application/details/address/nonStdStreet != ''">
				<xsl:if test="contains(/utilities/application/details/address/nonStdStreet, ' ')">
				    <xsl:call-template name="get_street_type">
				    	<xsl:with-param name="streetname" select="/utilities/application/details/address/nonStdStreet"/>
				    </xsl:call-template>
				</xsl:if>
			</xsl:when>
		</xsl:choose>
	</xsl:variable>
	
	<xsl:variable name="billing_streetName">
		<xsl:choose>
			<xsl:when test="/utilities/application/details/postal/streetName != ''">
				<xsl:choose>
					<xsl:when test="contains(/utilities/application/details/postal/streetName, ' ')">
						<xsl:call-template name="substring-before-last">
							<xsl:with-param name="list" select="normalize-space(/utilities/application/details/postal/streetName)"/>
							<xsl:with-param name="delimiter" select="' '"/>
						</xsl:call-template>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="/utilities/application/details/postal/streetName"></xsl:value-of>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="/utilities/application/details/postal/nonStdStreet != ''">
				<xsl:choose>
					<xsl:when test="contains(/utilities/application/details/postal/nonStdStreet, ' ')">
						<xsl:call-template name="substring-before-last">
							<xsl:with-param name="list" select="normalize-space(/utilities/application/details/postal/nonStdStreet)"/>
							<xsl:with-param name="delimiter" select="' '"/>
						</xsl:call-template>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="/utilities/application/details/postal/nonStdStreet"></xsl:value-of>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
		</xsl:choose>
	</xsl:variable>
	
	<xsl:variable name="billing_unitNo" select="/utilities/application/details/postal/unitShop" />	
	<xsl:variable name="billing_suburbName" select="/utilities/application/details/postal/suburbName" /> 
	<xsl:variable name="billing_state" select="/utilities/application/details/postal/state" />
	
	<!-- Street Number -->
	<xsl:variable name="billing_streetNo">
		<xsl:choose>
			<xsl:when test="/utilities/application/details/postal/streetNum != ''">
				<xsl:value-of select="/utilities/application/details/postal/streetNum" />
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="/utilities/application/details/postal/houseNoSel" />
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	
	<xsl:variable name="billing_postCode">
		<xsl:value-of select="/utilities/application/details/postal/postCode" />
	</xsl:variable>
		
	<!-- MAIN TEMPLATE ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
	<xsl:template match="/utilities">
		<SwitchwiseApplication xmlns='http://switchwise.com.au/' xmlns:i='http://www.w3.org/2001/XMLSchema-instance'>
			<Title><xsl:value-of select="application/details/title" /></Title>
			<FirstName><xsl:value-of select="application/details/firstName" /></FirstName>
			<LastName><xsl:value-of select="application/details/lastName" /></LastName>
			<MobileNo><xsl:value-of select="application/details/mobileNumber" /></MobileNo>
			<OtherPhoneAreaNo><xsl:value-of select="substring(application/details/otherPhoneNumber,1,2)" /></OtherPhoneAreaNo>
			<OtherPhoneNo><xsl:value-of select="substring(application/details/otherPhoneNumber,3,8)" /></OtherPhoneNo>
			<Email><xsl:value-of select="application/details/email" /></Email>
			<DOB><xsl:call-template name="format_date"><xsl:with-param name="eurDate" select="application/details/dob" /></xsl:call-template>T00:00:00</DOB>
			<Address>
				<DPID>0</DPID>
				<UnitNo><xsl:value-of select="$unitNo" /></UnitNo>
				<StreetNo><xsl:value-of select="$streetNo" /></StreetNo>
				<StreetName><xsl:value-of select="$streetName" /></StreetName>
				<StreetType><xsl:value-of select="$streetType" /></StreetType>
				<Suburb><xsl:value-of select="$suburbName" /></Suburb>
				<State><xsl:value-of select="$state" /></State>
				<Postcode><xsl:value-of select="$postCode" /></Postcode>
			</Address>
			<xsl:choose>
				<xsl:when test="application/details/postalMatch = 'Y'"></xsl:when>
				<xsl:otherwise>
					<BillingAddress>
						<DPID>0</DPID>
						<UnitNo><xsl:value-of select="$billing_unitNo" /></UnitNo>
						<StreetNo><xsl:value-of select="$billing_streetNo" /></StreetNo>
						<StreetName><xsl:value-of select="$billing_streetName" /></StreetName>
						<StreetType><xsl:value-of select="$billing_streetType" /></StreetType>
						<Suburb><xsl:value-of select="$billing_suburbName" /></Suburb>
						<State><xsl:value-of select="$billing_state" /></State>
						<Postcode><xsl:value-of select="$billing_postCode" /></Postcode>
					</BillingAddress>				
				</xsl:otherwise>				
			</xsl:choose>
			
			<IsMovingToAddress>
				<xsl:choose>
					<xsl:when test="application/details/movingIn = 'Y'">true</xsl:when>
					<xsl:otherwise>false</xsl:otherwise>
				</xsl:choose>
			</IsMovingToAddress>
			<xsl:if test="application/details/movingIn = 'Y'">
				<MoveInDate><xsl:call-template name="format_date"><xsl:with-param name="eurDate" select="application/details/movingDate" /></xsl:call-template>T00:00:00</MoveInDate>
			</xsl:if>
			
			<xsl:if test="application/thingsToKnow/hidden/identificationRequired = 'Y'">
				<CustomerIdentification>
					<IdentificationType><xsl:value-of select="application/situation/identification/idType" /></IdentificationType>
					<IdentificationNo><xsl:value-of select="application/situation/identification/idNo" /></IdentificationNo>
					<IssueFrom>
						<xsl:choose>
							<xsl:when test="application/situation/identification/idType = 'DriversLicence'"><xsl:value-of select="application/situation/identification/state" /></xsl:when>
							<xsl:when test="application/situation/identification/idType = 'Passport'"><xsl:value-of select="application/situation/identification/country" /></xsl:when>
							<xsl:otherwise></xsl:otherwise>
						</xsl:choose>
					</IssueFrom>
				</CustomerIdentification>
			</xsl:if>
			
			<xsl:if test="application/situation/concession/hasConcession = 'Y' and $state != 'SA'">
				<Concession>
					<ConcessionType><xsl:value-of select="application/situation/concession/type" /></ConcessionType>
					<CardNumber><xsl:value-of select="application/situation/concession/cardNo" /></CardNumber>
					<CardStartDate><xsl:call-template name="format_date"><xsl:with-param name="eurDate" select="application/situation/concession/cardDateRange/fromDate" /></xsl:call-template>T00:00:00</CardStartDate>
					<CardEndDate><xsl:call-template name="format_date"><xsl:with-param name="eurDate" select="application/situation/concession/cardDateRange/toDate" /></xsl:call-template>T00:00:00</CardEndDate>
					<AllowConsessionAuthorisation><xsl:choose><xsl:when test="application/situation/concession/concessionAgreement = 'Y'">true</xsl:when><xsl:otherwise>false</xsl:otherwise></xsl:choose></AllowConsessionAuthorisation>
				</Concession>
			</xsl:if>
			
			<AgreeToTransferSupplier><xsl:choose><xsl:when test="application/thingsToKnow/transfer = 'Y'">true</xsl:when><xsl:otherwise>false</xsl:otherwise></xsl:choose></AgreeToTransferSupplier>
			<AgreeToRateChanges><xsl:choose><xsl:when test="application/thingsToKnow/rateChange = 'Y'">true</xsl:when><xsl:otherwise>false</xsl:otherwise></xsl:choose></AgreeToRateChanges>
			<AgreeSupplierTermConditions><xsl:choose><xsl:when test="application/thingsToKnow/providerTermsAndConditions = 'Y'">true</xsl:when><xsl:otherwise>false</xsl:otherwise></xsl:choose></AgreeSupplierTermConditions>
			<AgreeSwitchwiseTermConditions><xsl:choose><xsl:when test="application/thingsToKnow/switchwiseTermsAndConditions = 'Y'">true</xsl:when><xsl:otherwise>false</xsl:otherwise></xsl:choose></AgreeSwitchwiseTermConditions>
			<AgreeReceiveInfo><xsl:choose><xsl:when test="application/thingsToKnow/receiveInfo = 'Y'">true</xsl:when><xsl:otherwise>false</xsl:otherwise></xsl:choose></AgreeReceiveInfo>
			<ProductID><xsl:value-of select="application/thingsToKnow/hidden/productId" /></ProductID>
			<SearchID><xsl:value-of select="application/thingsToKnow/hidden/searchId" /></SearchID>
			
			<PasswordQuestion i:nil="true" />
			<PasswordAnswer i:nil="true" />
			
			<LifeSupport><xsl:choose><xsl:when test="application/situation/lifeSupport = 'Y'">true</xsl:when><xsl:otherwise>false</xsl:otherwise></xsl:choose></LifeSupport>
			
			<xsl:if test="application/thingsToKnow/hidden/isPowerOnRequired = 'Y'">
				<IsPowerOff>
					<xsl:choose><xsl:when test="application/details/isPowerOn = 'N'">true</xsl:when><xsl:otherwise>false</xsl:otherwise></xsl:choose>
				</IsPowerOff>
			</xsl:if>
			
			<xsl:if test="application/details/isPowerOn = 'N'">
				<VisualInspectionAppointment>
					<xsl:value-of select="application/details/visualInspectionAppointment" />
				</VisualInspectionAppointment>
			</xsl:if>
			
			<MedicalMultipleSclerosis><xsl:choose><xsl:when test="application/situation/multipleSclerosis = 'Y'">true</xsl:when><xsl:otherwise>false</xsl:otherwise></xsl:choose></MedicalMultipleSclerosis>
			
			<HasConcession><xsl:choose><xsl:when test="application/situation/concession/hasConcession = 'Y'">true</xsl:when><xsl:otherwise>false</xsl:otherwise></xsl:choose></HasConcession>
			
			<xsl:if test="application/thingsToKnow/hidden/directDebitRequired = 'Y'">
				<DirectDebit><xsl:choose><xsl:when test="application/options/directDebit = 'Y'">true</xsl:when><xsl:otherwise>false</xsl:otherwise></xsl:choose></DirectDebit>
			</xsl:if>
			
			<xsl:if test="application/thingsToKnow/hidden/paymentSmoothingRequired ='Y'">
				<BillSmoothing><xsl:choose><xsl:when test="application/options/paymentSmoothing = 'Y'">true</xsl:when><xsl:otherwise>false</xsl:otherwise></xsl:choose></BillSmoothing>
			</xsl:if>
			
			<xsl:if test="application/thingsToKnow/hidden/electronicBillRequired = 'Y'">
				<ElectronicBill><xsl:choose><xsl:when test="application/options/electronicBill = 'Y'">true</xsl:when><xsl:otherwise>false</xsl:otherwise></xsl:choose></ElectronicBill>
			</xsl:if>
			
			<xsl:if test="application/thingsToKnow/hidden/electronicCommunicationRequired = 'Y'">
				<ElectronicCommunication><xsl:choose><xsl:when test="application/options/electronicCommunication = 'Y'">true</xsl:when><xsl:otherwise>false</xsl:otherwise></xsl:choose></ElectronicCommunication>
			</xsl:if>
			
			<xsl:if test="application/thingsToKnow/hidden/billDeliveryMethodRequired = 'Y'">
				<BillDeliveryMethod><xsl:value-of select="application/options/billDeliveryMethod" /></BillDeliveryMethod>
			</xsl:if>
			
		</SwitchwiseApplication>
		
	</xsl:template>
		
</xsl:stylesheet>