<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xalan="http://xml.apache.org/xalan"
	exclude-result-prefixes="xalan">
	
	<xsl:variable name="LOWERCASE" select="'abcdefghijklmnopqrstuvwxyz'" />
	<xsl:variable name="UPPERCASE" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'" />

	<!-- IMPORTS -->
	<xsl:param name="today" />
	<xsl:param name="transactionId" />	

	<xsl:template name="format_date">
		<xsl:param name="eurDate"/>

    	<xsl:variable name="day" 		select="substring-before($eurDate,'/')" />
    	<xsl:variable name="month-temp" select="substring-after($eurDate,'/')" />
    	<xsl:variable name="month" 		select="substring-before($month-temp,'/')" />    	
    	<xsl:variable name="year" 		select="substring-after($month-temp,'/')" />
    	
		<xsl:value-of select="$year" /><xsl:text>-</xsl:text>
		<xsl:value-of select="format-number($month,'00')" /><xsl:text>-</xsl:text>		
		<xsl:value-of select="format-number($day,'00')" />
	</xsl:template>	

	<xsl:template name="title_code">
		<xsl:param name="title" />
		<xsl:choose>
			<xsl:when test="$title='MR'">Mr</xsl:when>
			<xsl:when test="$title='MRS'">Mrs</xsl:when>
			<xsl:when test="$title='MISS'">Miss</xsl:when>
			<xsl:when test="$title='MS'">Ms</xsl:when>
			<xsl:when test="$title='DR'">Dr</xsl:when>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="card_type">
		<xsl:param name="cardtype" />
		<xsl:choose>
			<xsl:when test="$cardtype='v'">Visa</xsl:when>
			<xsl:when test="$cardtype='m'">MasterCard</xsl:when>
		</xsl:choose>
	</xsl:template>
	
	<!-- ADDRESS VARIABLES -->
	<xsl:template name="get_street_name">
		<xsl:param name="address" />
		
		<xsl:choose>
			<!-- Non-Standard -->
			<xsl:when test="$address/nonStd='Y'">			
				<xsl:choose>
					<!-- Has a unit/shop? -->
					<xsl:when test="$address/unitShop!=''">
						<xsl:value-of select="concat($address/unitShop, ' / ', $address/streetNum, ' ', $address/nonStdStreet)" />
					</xsl:when>
					
					<!-- No Unit/shop -->
					<xsl:otherwise>
						<xsl:value-of select="concat($address/streetNum, ' ', $address/nonStdStreet)" />
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			
			<!-- Standard Address -->
			<xsl:otherwise>
				<xsl:choose> 
				<!-- Smart capture unit and street number -->
				<xsl:when test="$address/unitSel != '' and $address/houseNoSel != ''">
					<xsl:value-of select="concat($address/unitSel, ' / ', $address/houseNoSel, ' ', $address/streetName)" />
				</xsl:when>
				
				<!-- Manual capture unit, Smart capture street number -->
				<xsl:when test="$address/unitShop != '' and $address/houseNoSel != ''">
					<xsl:value-of select="concat($address/unitShop, ' / ', $address/houseNoSel, ' ', $address/streetName)" />
				</xsl:when>
				
				<!-- Manual capture unit and street number -->
				<xsl:when test="$address/unitShop != '' and $address/streetNum != ''">
					<xsl:value-of select="concat($address/unitShop, ' / ', $address/streetNum, ' ', $address/streetName)" />
				</xsl:when>
				
				<!-- Smart capture street number (only, no unit) -->
				<xsl:when test="$address/houseNoSel != ''">
					<xsl:value-of select="concat($address/houseNoSel, ' ', $address/streetName)" />
				</xsl:when>
				
				<!-- Manual capture street number (only, no unit) -->
				<xsl:otherwise>
					<xsl:value-of select="concat($address/streetNum, ' ', $address/streetName)" />
				</xsl:otherwise>
				</xsl:choose>
				
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>		
	<xsl:variable name="streetNameLower">
		<xsl:call-template name="get_street_name">
			<xsl:with-param name="address" select="/health/application/address"/>
		</xsl:call-template>
	</xsl:variable>
		
	<xsl:variable name="streetName" select="translate($streetNameLower, $LOWERCASE, $UPPERCASE)" />
	<xsl:variable name="suburbName" select="translate(/health/application/address/suburbName, $LOWERCASE, $UPPERCASE)" /> 
	<xsl:variable name="state" select="translate(/health/application/address/state, $LOWERCASE, $UPPERCASE)" />
	
	<!-- Street Number -->
	<xsl:variable name="streetNo">
		<xsl:choose>
			<xsl:when test="/health/application/address/streetNum != ''">
				<xsl:value-of select="/health/application/address/streetNum" />
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="/health/application/address/houseNoSel" />
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>


	<!-- POSTAL ADDRESS VARIABLES -->
			<xsl:variable name="postal_streetNameLower">
				<xsl:call-template name="get_street_name">
					<xsl:with-param name="address" select="/health/application/postal"/>
				</xsl:call-template>
			</xsl:variable>

			<xsl:variable name="postal_streetName">
				<xsl:choose>
					<xsl:when test="$postal_streetNameLower != ' '">
						<xsl:value-of select="translate($postal_streetNameLower, $LOWERCASE, $UPPERCASE)" />
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="$streetName" />
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>

			<xsl:variable name="postal_suburbName">
				<xsl:choose>
					<xsl:when test="/health/application/postal/suburbName != ''">
				 		<xsl:value-of select="translate(/health/application/postal/suburbName, $LOWERCASE, $UPPERCASE)" />
				 	</xsl:when>
				 	<xsl:otherwise>
		 				<xsl:value-of select="$suburbName" /> 
				 	</xsl:otherwise> 
				</xsl:choose>
			</xsl:variable>

			<xsl:variable name="postal_state">
				<xsl:choose>
					<xsl:when test="/health/application/postal/state != ''">
						<xsl:value-of select="translate(/health/application/postal/state, $LOWERCASE, $UPPERCASE)" />
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="$state" />
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>

			<xsl:variable name="postal_postCode">
				<xsl:choose>
					<xsl:when test="/health/application/postal/postCode != ''">
						<xsl:value-of select="/health/application/postal/postCode" />
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="/health/application/address/postCode" />
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>

			<xsl:variable name="postal_streetNo">
				<xsl:choose>
					<xsl:when test="/health/application/postal/streetNum != ''">
						<xsl:value-of select="/health/application/postal/streetNum" />
					</xsl:when>
					<xsl:when test="/health/application/postal/houseNoSel != ''">
						<xsl:value-of select="/health/application/postal/houseNoSel" />
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="$streetNo"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>

	<xsl:variable name="todays_date">
    	<xsl:variable name="year" 	select="substring($today,1,4)" />
    	<xsl:variable name="month" 	select="substring($today,6,2)" />
    	<xsl:variable name="day" 	select="substring($today,9,2)" />    	
    	
		<xsl:value-of select="$year" />
		<xsl:text>-</xsl:text>
		<xsl:value-of select="format-number($month,'00')" />		
		<xsl:text>-</xsl:text>
		<xsl:value-of select="format-number($day,'00')" />
	</xsl:variable>

	<!-- COVER CODE -->
	<xsl:variable name="cover_code">
		<xsl:choose>
			<xsl:when test="/health/fundData/hospitalCoverName = 'Basic Plus'">17</xsl:when>
			<xsl:when test="/health/fundData/hospitalCoverName = 'Family Basic Saver'">14</xsl:when>
			<xsl:when test="/health/fundData/hospitalCoverName = 'Family Plus'">16</xsl:when>
			<xsl:when test="/health/fundData/hospitalCoverName = 'Just Hospital'">19</xsl:when>
			<xsl:when test="/health/fundData/hospitalCoverName = 'Mid Plus'">15</xsl:when>
			<xsl:when test="/health/fundData/extrasCoverName = 'Premium Extras'">0</xsl:when>
			<xsl:when test="/health/fundData/hospitalCoverName = 'Top Cover'">18</xsl:when>
			<xsl:when test="/health/fundData/hospitalCoverName = 'Young at Heart Mid'">24</xsl:when>
			<xsl:when test="/health/fundData/hospitalCoverName = 'Young at Heart Top'">23</xsl:when>
			<xsl:otherwise>0</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>


	<xsl:variable name="excess">
		<xsl:choose>
			<xsl:when test="substring-before(/health/fundData/excess,' ') != ''">
				<xsl:value-of select="substring-before(/health/fundData/excess,' ')" />
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="/health/fundData/excess" />
			</xsl:otherwise>
		</xsl:choose>
		
	</xsl:variable>


	<!-- COVER TYPE -->
	<xsl:variable name="cover_type">
		<xsl:choose>
			<xsl:when test="/health/situation/healthCvr = 'SPF'">P</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="/health/situation/healthCvr" />
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>

	<!-- FREQUENCY -->
	<xsl:variable name="frequency">
		<xsl:choose>
			<xsl:when test="/health/payment/details/frequency = 'A'">Yearly</xsl:when>
			<xsl:when test="/health/payment/details/frequency = 'H'">HalfYearly</xsl:when>
			<xsl:when test="/health/payment/details/frequency = 'Q'">Quarterly</xsl:when>
			<xsl:when test="/health/payment/details/frequency = 'M'">Monthly</xsl:when>
			<xsl:when test="/health/payment/details/frequency = 'F'">Fortnightly</xsl:when>
		</xsl:choose>
	</xsl:variable>

	<!-- PAYMENT METHOD -->
	<xsl:variable name="payment_method">
		<xsl:choose>
			<xsl:when test="/health/payment/details/type = 'cc'">CreditCard</xsl:when>
			<xsl:when test="/health/payment/details/type = 'ba'">Bankaccount</xsl:when>
		</xsl:choose>
	</xsl:variable>

	<!-- NOMINATED DAY -->
	<xsl:variable name="nominated_day">
		<xsl:choose>
			<xsl:when test="/health/payment/credit/paymentDay != ''"><xsl:value-of select="substring(/health/payment/credit/paymentDay,9,2)" /></xsl:when>
			<xsl:when test="/health/payment/bank/paymentDay != ''"><xsl:value-of select="substring(/health/payment/bank/paymentDay,9,2)" /></xsl:when>
		</xsl:choose>
	</xsl:variable>


	<!-- MAIN TEMPLATE -->
	<xsl:template match="/health">
		<!-- FUND PRODUCT SPECIFIC VALUES -->
<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:gat="http://www.nib.com.au/Broker/Gateway">
    <soapenv:Header />
    <soapenv:Body>
      <gat:Enrol>
        <gat:newMember>
          <gat:BrokerCustomerId><xsl:value-of select="$transactionId" /> </gat:BrokerCustomerId>
          <gat:BrokerId>45211</gat:BrokerId>
          <gat:Title><xsl:value-of select="application/primary/title" /></gat:Title>
          <gat:Firstname><xsl:value-of select="application/primary/firstname" /></gat:Firstname>
          <gat:Lastname><xsl:value-of select="application/primary/surname" /></gat:Lastname>
          <gat:DOB><xsl:call-template name="format_date">
						<xsl:with-param name="eurDate" select="application/primary/dob" />
					</xsl:call-template></gat:DOB>
          <gat:Gender><xsl:choose><xsl:when test="application/primary/gender = 'F'">Female</xsl:when><xsl:otherwise>Male</xsl:otherwise></xsl:choose></gat:Gender>

		  <xsl:if test="application/partner/firstname != ''">
			  <gat:PartnerTitle><xsl:value-of select="application/partner/title" /></gat:PartnerTitle>
			  <gat:PartnerFirstname><xsl:value-of select="application/partner/firstname" /></gat:PartnerFirstname>
			  <gat:PartnerLastname><xsl:value-of select="application/partner/surname" /></gat:PartnerLastname>
			  <gat:PartnerDOB><xsl:call-template name="format_date">
							<xsl:with-param name="eurDate" select="application/partner/dob" />
						</xsl:call-template></gat:PartnerDOB>
			  <gat:PartnerGender><xsl:choose><xsl:when test="application/partner/gender = 'F'">Female</xsl:when><xsl:otherwise>Male</xsl:otherwise></xsl:choose></gat:PartnerGender>
		  </xsl:if>
		  <gat:IncomeTier><xsl:value-of select="healthCover/income" /></gat:IncomeTier>

		  <xsl:variable name="dependants" select="application/dependants" />
		  <xsl:if test="$dependants">
		  <gat:Dependants>
			<xsl:for-each select="$dependants/*">
				<xsl:variable name="srcElementId"><xsl:value-of select="position()" /></xsl:variable>
				<xsl:variable name="srcElementName">dependant<xsl:value-of select="position()" /></xsl:variable>
				<xsl:variable name="srcElement" select="$dependants/*[name()=$srcElementName]" />
														
				<xsl:if test="$srcElement/firstName!=''">
		          <gat:Dependant>
		            <gat:Id><xsl:value-of select="$srcElementId"/></gat:Id>
		            <gat:Title>
		            	<xsl:call-template name="title_code">
							<xsl:with-param name="title" select="$srcElement/title" />
						</xsl:call-template>
					</gat:Title>
		            <gat:FirstName>
						<xsl:value-of select="$srcElement/firstName" />
					</gat:FirstName>
		            <gat:LastName>
						<xsl:value-of select="$srcElement/lastname" />
					</gat:LastName>
		            <gat:DOB>
						<xsl:call-template name="format_date">
							<xsl:with-param name="eurDate" select="$srcElement/dob" />
						</xsl:call-template>
					</gat:DOB>
		            <gat:Gender>
						<xsl:choose>
							<xsl:when test="$srcElement/title='MR'">Male</xsl:when>
							<xsl:otherwise>Female</xsl:otherwise>
						</xsl:choose>
					</gat:Gender>
		          </gat:Dependant>
				</xsl:if>
		  </xsl:for-each>
          </gat:Dependants>
		  </xsl:if>
          
          <gat:HomeAddress><xsl:value-of select="$streetName" /></gat:HomeAddress>
          <gat:HomeSuburb><xsl:value-of select="$suburbName" /></gat:HomeSuburb>
          <gat:HomeState><xsl:value-of select="$state" /></gat:HomeState>
          <gat:HomePostCode><xsl:value-of select="application/address/postCode" /></gat:HomePostCode>

          <gat:PostalAddress><xsl:value-of select="$postal_streetName" /></gat:PostalAddress>
          <gat:PostalSuburb><xsl:value-of select="$postal_suburbName" /></gat:PostalSuburb>
          <gat:PostalState><xsl:value-of select="$postal_state" /></gat:PostalState>
          <gat:PostalPostCode><xsl:value-of select="$postal_postCode" /></gat:PostalPostCode>

          <gat:HomePhone><xsl:value-of select="translate(application/other,' ()','')" /></gat:HomePhone>
		  <gat:MobilePhone><xsl:value-of select="translate(application/mobile,' ()','')" /></gat:MobilePhone>
          <gat:Email>
			<xsl:choose>
			<xsl:when test="application/email != ''">
				<xsl:value-of select="application/email" />
			</xsl:when>
			<xsl:when test="contactDetails/email != ''">
				<xsl:value-of select="contactDetails/email" />
			</xsl:when>    							
			<xsl:otherwise>andrew.buckley@aihco.com.au</xsl:otherwise>
			</xsl:choose>          
          </gat:Email>
          <gat:MedicareCardNo><xsl:value-of select="translate(payment/medicare/number,' ','')" /></gat:MedicareCardNo>
          <gat:MedicareCardName><xsl:value-of select="payment/medicare/firstName" /><xsl:text> </xsl:text><xsl:value-of select="payment/medicare/middleInitial" /><xsl:text> </xsl:text><xsl:value-of select="payment/medicare/surname" /></gat:MedicareCardName>
          <gat:Cover><xsl:value-of select="fundData/hospitalCoverName" /></gat:Cover>
          <gat:CoverCode><xsl:value-of select="$cover_code" /></gat:CoverCode>
          <gat:CoverTypeCode><xsl:value-of select="$cover_type" /></gat:CoverTypeCode>
          <gat:RebateReceive><xsl:choose><xsl:when test="healthCover/rebate = 'Y'">true</xsl:when><xsl:otherwise>false</xsl:otherwise></xsl:choose></gat:RebateReceive>
          <gat:Excess><xsl:value-of select="translate($excess,'$','')" /></gat:Excess>
          <gat:PaymentFrequency><xsl:value-of select="$frequency" /></gat:PaymentFrequency>
          <gat:PaymentMethod><xsl:value-of select="$payment_method" /></gat:PaymentMethod>
          <gat:PaymentDay><xsl:value-of select="$nominated_day" /></gat:PaymentDay>
          <gat:UpfrontPayment>false</gat:UpfrontPayment>
          <gat:YouFundTransferring><xsl:choose><xsl:when test="previousfund/primary/fundName != 'NONE'">true</xsl:when><xsl:otherwise>false</xsl:otherwise></xsl:choose></gat:YouFundTransferring>

		  <xsl:if test="previousfund/primary/fundName != 'NONE'">
	          <gat:YouPreviousFundCode><xsl:value-of select="previousfund/primary/fundName" /></gat:YouPreviousFundCode>
	          <gat:YouPreviousFundMemberNo><xsl:value-of select="previousfund/primary/memberID" /></gat:YouPreviousFundMemberNo>
	          <gat:YouPreviousNIBMember><xsl:choose><xsl:when test="previousfund/primary/fundName = 'NIB'">true</xsl:when><xsl:otherwise>false</xsl:otherwise></xsl:choose></gat:YouPreviousNIBMember>
		  </xsl:if>

          <gat:PartnerFundTransferring><xsl:choose><xsl:when test="previousfund/partner/fundName != 'NONE'">true</xsl:when><xsl:otherwise>false</xsl:otherwise></xsl:choose></gat:PartnerFundTransferring>

		  <xsl:if test="previousfund/partner/fundName != 'NONE'">
	          <gat:PartnerPreviousFundCode><xsl:value-of select="previousfund/partner/fundName" /></gat:PartnerPreviousFundCode>
	          <gat:PartnerPreviousFundMemberNo><xsl:value-of select="previousfund/partner/memberID" /></gat:PartnerPreviousFundMemberNo>
	          <gat:PartnerPreviousNIBMember><xsl:choose><xsl:when test="previousfund/partner/fundName = 'NIB'">true</xsl:when><xsl:otherwise>false</xsl:otherwise></xsl:choose></gat:PartnerPreviousNIBMember>
		  </xsl:if>

          <gat:EffectiveDate><xsl:value-of select="$todays_date" /></gat:EffectiveDate>

		  <xsl:choose>
		  	<xsl:when test="$payment_method = 'CreditCard'">
			  <gat:CreditCardTypeCode>
					<xsl:call-template name="card_type">
						<xsl:with-param name="cardtype" select="payment/credit/type" />
					</xsl:call-template>		  
			  </gat:CreditCardTypeCode>
	          <gat:CreditCardNo><xsl:value-of select="translate(payment/credit/number,' ','')" /></gat:CreditCardNo>
	          <gat:CreditCardHolder><xsl:value-of select="payment/credit/name" /></gat:CreditCardHolder>
	          <gat:CreditCardExpiry><xsl:value-of select="payment/credit/expiry/cardExpiryMonth" />/20<xsl:value-of select="payment/credit/expiry/cardExpiryYear" /></gat:CreditCardExpiry>
	        </xsl:when>
		  	<xsl:otherwise>
	          <gat:BankAccountNo><xsl:value-of select="translate(payment/bank/number,' ','')" /></gat:BankAccountNo>
	          <gat:BankAccountHolder><xsl:value-of select="payment/bank/account" /></gat:BankAccountHolder>
	          <gat:BSB><xsl:value-of select="format-number(translate(payment/bank/bsb,' -',''),'000000')" /></gat:BSB>
	          <gat:BankInstitution><xsl:value-of select="payment/bank/name" /></gat:BankInstitution>
		  	</xsl:otherwise>
		  </xsl:choose>
        
          <gat:SafeClaim>false</gat:SafeClaim>
          <gat:MedicareCardCheck>true</gat:MedicareCardCheck>
          <gat:IsOSHC>false</gat:IsOSHC>
        </gat:newMember>
        <gat:username>broker</gat:username>
        <gat:password>AD12890C-2BB3-4499-85C6-2F2849D64439</gat:password>
      </gat:Enrol>
    </soapenv:Body>
  </soapenv:Envelope>		
		
		
		
	</xsl:template>
	
</xsl:stylesheet>