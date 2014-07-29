<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	xmlns:xalan="http://xml.apache.org/xalan"
	exclude-result-prefixes="xalan">
	
	<xsl:variable name="LOWERCASE" select="'abcdefghijklmnopqrstuvwxyz'" />
	<xsl:variable name="UPPERCASE" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'" />
	
	<!-- PARAMETERS -->
	<xsl:param name="today" />
	<xsl:param name="overrideEmail"></xsl:param>
	<xsl:param name="keyname" />
	<xsl:param name="keycode" />
	
	<!-- IMPORTS -->
	<xsl:include href="../utils.xsl"/>
	
	<xsl:variable name="startDate">
		<xsl:call-template name="format_date">
			<xsl:with-param name="eurDate" select="/health/payment/details/start" />
		</xsl:call-template>    								
	</xsl:variable>

	<!-- Previous Fund Start/End dates -->
	<xsl:variable name="prevFundEnd">
		<xsl:call-template name="subtract_1_day">
			<xsl:with-param name="isoDate" select="$startDate" />
		</xsl:call-template>
	</xsl:variable>
	<xsl:variable name="prevFundStart">
		<xsl:call-template name="subtract_1_day">
			<xsl:with-param name="isoDate" select="$prevFundEnd" />
		</xsl:call-template>
	</xsl:variable>	
	
	<xsl:template name="get_street_name">
		<xsl:param name="address" />
				<xsl:value-of select="$address/fullAddressLineOne" />
	</xsl:template>		
	<xsl:variable name="streetNameLower">
		<xsl:call-template name="get_street_name">
			<xsl:with-param name="address" select="/health/application/address"/>
		</xsl:call-template>
	</xsl:variable>
	<xsl:variable name="streetNameCapitalised">
		<xsl:call-template name="titleize">
            <xsl:with-param name="title" select="normalize-space($streetNameLower)"/>
            <xsl:with-param name="firstWord" select="1 = 1"/>
        </xsl:call-template>
	</xsl:variable>	
	<xsl:variable name="suburbCapitalised">
		<xsl:call-template name="titleize">
            <xsl:with-param name="title" select="normalize-space(/health/application/address/suburbName)"/>
            <xsl:with-param name="firstWord" select="1 = 1"/>
        </xsl:call-template>
	</xsl:variable>	
		
	<xsl:variable name="streetName"><xsl:value-of select="$streetNameCapitalised" /></xsl:variable>
	<xsl:variable name="suburbName"><xsl:value-of select="$suburbCapitalised" /></xsl:variable>
	<xsl:variable name="state"><xsl:value-of select="/health/application/address/state" /></xsl:variable>
	
	<xsl:variable name="address">
		<xsl:value-of select="concat($streetName, ' ', $suburbName, ' ', $state, ' ', /health/application/address/postCode)" />
	</xsl:variable>
		
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
	<xsl:variable name="postalAddress" select="/health/application/postal" />
	
	<xsl:variable name="postal_streetNameLower">
		<xsl:call-template name="get_street_name">
			<xsl:with-param name="address" select="$postalAddress"/>
		</xsl:call-template>
	</xsl:variable>
		
	<xsl:variable name="postal_streetName" select="$postal_streetNameLower" />
	<xsl:variable name="postal_suburbName" select="$postalAddress/suburbName" />
	<xsl:variable name="postal_state" select="$postalAddress/state" />
	
	<xsl:variable name="postal_address">
		<xsl:value-of select="concat($postal_streetName, ' ', $postal_suburbName, ' ', $postal_state, ' ', $postalAddress/postCode)" />
	</xsl:variable>
		
	<!-- Street Number -->
	<xsl:variable name="postal_streetNo">
		<xsl:choose>
			<xsl:when test="$postalAddress/streetNum != ''">
				<xsl:value-of select="$postalAddress/streetNum" />
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$postalAddress/houseNoSel" />
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<xsl:variable name="emailAddress">
		<xsl:choose>
			<xsl:when test="$overrideEmail!=''">
				<xsl:value-of select="$overrideEmail" />
			</xsl:when>
			<xsl:when test="health/application/email != ''">
				<xsl:value-of select="health/application/email" />
			</xsl:when>
			<xsl:when test="health/contactDetails/email != ''">
				<xsl:value-of select="health/contactDetails/email" />
			</xsl:when>    							
			<xsl:otherwise>andrew.buckley@aihco.com.au</xsl:otherwise>
		</xsl:choose>			
	</xsl:variable>
	
	<!-- MAIN TEMPLATE -->
	<xsl:template match="/health">
		<!-- FUND PRODUCT SPECIFIC VALUES -->
		<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:hsl="http://HSL.OMS.Public.API.Service">
    		<soapenv:Header>
<!--     		  <wsse:Security xmlns:wsse="http://schemas.xmlsoap.org/ws/2003/06/secext">
			   <wsse:UsernameToken wsu:Id="Compare" 
			       xmlns:wsu="http://schemas.xmlsoap.org/ws/2003/06/utility">
			    <wsse:Username>Compare</wsse:Username>
			    <wsse:Password Type="wsse:PasswordText">Gmfcompare</wsse:Password>-->
				<wsse:Security soapenv:mustUnderstand="1" xmlns:wsse="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd">
					<wsse:UsernameToken wsu:Id="UsernameToken-8" xmlns:wsu="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd">
						<wsse:Username><xsl:value-of select="$keyname" /></wsse:Username>
						<wsse:Password Type="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-username-token-profile-1.0#PasswordText"><xsl:value-of select="$keycode" /></wsse:Password>
						<wsu:Created><xsl:value-of select="$today" />T00:00:00Z</wsu:Created>
					</wsse:UsernameToken>
			  </wsse:Security>
    		</soapenv:Header>
    		<soapenv:Body>
				<hsl:SubmitMembership>
         		<hsl:xmlFile>
         		<xsl:text disable-output-escaping="yes">&lt;![CDATA[</xsl:text> 		
    			<MembershipApplication xmlns="http://www.hambs.com.au/MemberServices/MemberServices.xsd">
    				<SubmittedBy>Agent</SubmittedBy>
    				<Persons>
    					<Person>
    						<PersonID>0</PersonID>
    						<EffDate><xsl:value-of select="$startDate" /></EffDate>
    						<Relationship>Membr</Relationship>
    						<Title>
    							<xsl:choose>
    								<xsl:when test="application/primary/title='MR'">Mr</xsl:when>
    								<xsl:when test="application/primary/title='MRS'">Mrs</xsl:when>
    								<xsl:when test="application/primary/title='MISS'">Miss</xsl:when>
    								<xsl:when test="application/primary/title='MS'">Ms</xsl:when>
    								<xsl:when test="application/primary/title='DR'">Dr</xsl:when>
    							</xsl:choose>
    						</Title>
    						<FirstName><xsl:value-of select="application/primary/firstname" /></FirstName>
    						<Surname><xsl:value-of select="application/primary/surname" /></Surname>
    						<Gender><xsl:value-of select="application/primary/gender" /></Gender>
    						<Birthdate>
								<xsl:call-template name="format_date">
									<xsl:with-param name="eurDate" select="application/primary/dob" />
								</xsl:call-template>    						
    						</Birthdate>
    						<xsl:if test="healthCover/rebate = 'Y'">
    							<MediCardNo><xsl:value-of select="translate(payment/medicare/number,' ','')" /></MediCardNo>
	    						<MediCardExpDate>
									<xsl:text>20</xsl:text><xsl:value-of select="payment/medicare/expiry/cardExpiryYear" />-<xsl:value-of select="payment/medicare/expiry/cardExpiryMonth" /><xsl:text>-01</xsl:text>								
	    						</MediCardExpDate>
	    						<MediCardFirstName><xsl:value-of select="payment/medicare/firstName" /></MediCardFirstName>
	    						<xsl:if test="payment/medicare/middleInitial!= ''">
		    						<MediCardSecondName><xsl:value-of select="payment/medicare/middleInitial" /></MediCardSecondName>
	    						</xsl:if>
	    						<MediCardSurname><xsl:value-of select="payment/medicare/surname" /></MediCardSurname>    						
							</xsl:if>    						    						
    						
    						<IsRebateApplicant>
    							<xsl:choose>
    								<xsl:when test="healthCover/rebate='Y'">true</xsl:when>
    								<xsl:otherwise>false</xsl:otherwise>
    							</xsl:choose>
    						</IsRebateApplicant>
    						<FullTimeStudent>false</FullTimeStudent>
    						<EmailAddress>
								<xsl:value-of select="$emailAddress" />
    						</EmailAddress>
    						
    						<xsl:variable name="primaryFund">
    							<xsl:call-template name="get-fund-name">
    								<xsl:with-param name="fundName" select="previousfund/primary/fundName" />
    							</xsl:call-template>
    						</xsl:variable>

    						<xsl:choose>
    						<xsl:when test="$primaryFund !='NONE'">
	    						<Transferring>true</Transferring>
	    						<PreviousFund>
									<xsl:value-of select="$primaryFund" />
	    						</PreviousFund>    						
	    						<xsl:if test="previousfund/primary/memberID != ''">
	    							<PreviousFundMemberNo>
										<xsl:value-of select="previousfund/primary/memberID" />
	    							</PreviousFundMemberNo>
	    						</xsl:if>
	                            <PreviousFundDateJoined><xsl:value-of select="$prevFundStart" /></PreviousFundDateJoined>
	                            <PreviousFundDateCeased><xsl:value-of select="$prevFundEnd" /></PreviousFundDateCeased>	    						
    						</xsl:when>
    						<xsl:otherwise>
    							<Transferring>false</Transferring>
    						</xsl:otherwise>
    						</xsl:choose>
    						<IsMember>true</IsMember>
    						<JoinDate><xsl:value-of select="$startDate" /></JoinDate>    						
    					</Person>
    					<xsl:if test="application/partner/firstname != ''">
	    					<Person>
	    						<PersonID>0</PersonID>
	    						<EffDate><xsl:value-of select="$startDate" /></EffDate>
	    						<Relationship>
	    							<xsl:choose>
	    								<xsl:when test="application/partner/surname = application/primary/surname">Sps</xsl:when>
	    								<xsl:otherwise>Ptnr</xsl:otherwise>
	    							</xsl:choose>
	    						</Relationship>
	    						<Title>
	    							<xsl:choose>
	    								<xsl:when test="application/partner/title='MR'">Mr</xsl:when>
	    								<xsl:when test="application/partner/title='MRS'">Mrs</xsl:when>
	    								<xsl:when test="application/partner/title='MISS'">Miss</xsl:when>
	    								<xsl:when test="application/partner/title='MS'">Ms</xsl:when>
	    								<xsl:when test="application/partner/title='DR'">Dr</xsl:when>
	    							</xsl:choose>
	    						</Title>
	    						<FirstName><xsl:value-of select="application/partner/firstname" /></FirstName>
	    						<Surname><xsl:value-of select="application/partner/surname" /></Surname>
	    						<Gender><xsl:value-of select="application/partner/gender" /></Gender>
	    						<Birthdate>
									<xsl:call-template name="format_date">
										<xsl:with-param name="eurDate" select="application/partner/dob" />
									</xsl:call-template>    						
	    						</Birthdate>
	    						<IsRebateApplicant>false</IsRebateApplicant>
	    						<FullTimeStudent>false</FullTimeStudent>
	    						
	    						<xsl:variable name="partnerFund">
	    							<xsl:call-template name="get-fund-name">
	    								<xsl:with-param name="fundName" select="previousfund/partner/fundName" />
	    							</xsl:call-template>
	    						</xsl:variable>

	    						<xsl:choose>
	    						<xsl:when test="$partnerFund !='NONE'">
		    						<Transferring>true</Transferring>
		    						<PreviousFund>
										<xsl:value-of select="$partnerFund" />
		    						</PreviousFund>
		    						<xsl:if test="previousfund/partner/memberID != ''">
		    						<PreviousFundMemberNo>
										<xsl:value-of select="previousfund/partner/memberID" />
		    						</PreviousFundMemberNo>
		    						</xsl:if>
		                            <PreviousFundDateJoined><xsl:value-of select="$prevFundStart" /></PreviousFundDateJoined>
		                            <PreviousFundDateCeased><xsl:value-of select="$prevFundEnd" /></PreviousFundDateCeased>		    						
	    						</xsl:when>
	    						<xsl:otherwise>
	    							<Transferring>false</Transferring>
	    						</xsl:otherwise>
	    						</xsl:choose>
	    						<IsMember>false</IsMember>
	    						<JoinDate><xsl:value-of select="$startDate" /></JoinDate>
	    					</Person>
    					</xsl:if>
    					<xsl:for-each select="application/dependants/*">
    						<xsl:if test="firstName!=''"> 
								<Person>
		    						<PersonID>0</PersonID>
		    						<EffDate><xsl:value-of select="$startDate" /></EffDate>
		    						<Relationship>
		    							<xsl:choose>
		    								<xsl:when test="title='MR'">Son</xsl:when>
		    								<xsl:otherwise>Dtr</xsl:otherwise>
		    							</xsl:choose>
		    						</Relationship>
		    						<Title>
		    							<xsl:choose>
		    								<xsl:when test="title='MR'">Mr</xsl:when>
		    								<xsl:when test="title='MRS'">Mrs</xsl:when>
		    								<xsl:when test="title='MISS'">Miss</xsl:when>
		    								<xsl:when test="title='MS'">Ms</xsl:when>
		    							</xsl:choose>
		    						</Title>
		    						<FirstName><xsl:value-of select="firstName" /></FirstName>
		    						<Surname><xsl:value-of select="lastname" /></Surname>
		    						<Gender>
		    							<xsl:choose>
		    								<xsl:when test="title='MR'">M</xsl:when>
		    								<xsl:otherwise>F</xsl:otherwise>
		    							</xsl:choose>	    						
		    						</Gender>
		    						<Birthdate>
										<xsl:call-template name="format_date">
											<xsl:with-param name="eurDate" select="dob" />
										</xsl:call-template>    						
		    						</Birthdate>
		    						<FullTimeStudent>
		    							<xsl:choose>
		    								<xsl:when test="school!= '' or maritalincomestatus='Y'">true</xsl:when>
		    								<xsl:otherwise>false</xsl:otherwise>
		    							</xsl:choose>
		    						</FullTimeStudent>
	    							<Transferring>false</Transferring>
		    						<IsMember>false</IsMember>
		    						<JoinDate><xsl:value-of select="$startDate" /></JoinDate>
		    					</Person>    					
    						</xsl:if>    					
    					</xsl:for-each>
    				</Persons>
    				<Contacts>
    					<Addresses>
    						<Address>
    							<Code>H</Code>
    							<EffDate><xsl:value-of select="$startDate" /></EffDate>
    							<Overseas>false</Overseas>
    							<Line1><xsl:value-of select="$streetName" /></Line1>
    							<Locality><xsl:value-of select="$suburbName" /></Locality>
    							<State><xsl:value-of select="$state" /></State>
    							<Postcode><xsl:value-of select="/health/application/address/postCode" /></Postcode>
    						</Address>
    						<xsl:if test="not(application/postalMatch) or application/postalMatch!='Y'">
    						<Address>
    							<Code>P</Code>
    							<EffDate><xsl:value-of select="$startDate" /></EffDate>
    							<Overseas>false</Overseas>
    							<Line1><xsl:value-of select="$postal_streetName" /></Line1>
    							<Locality><xsl:value-of select="$postal_suburbName" /></Locality>
    							<State><xsl:value-of select="$postal_state" /></State>
    							<Postcode><xsl:value-of select="$postalAddress/postCode" /></Postcode>
    						</Address>
    						</xsl:if>
    					</Addresses>
    					<Phones>
							<xsl:if test="application/mobile != ''">
	    						<Phone>
									<Code>M</Code>
									<Number>
										<xsl:value-of select="translate(application/mobile,' ()','')" />
									</Number>    						
	    						</Phone>							
							</xsl:if>
							<xsl:if test="application/other != ''">
	    						<Phone>
									<Code>H</Code>
									<Number>							
										<xsl:value-of select="translate(application/other,' ()','')" />
									</Number>
								</Phone>
							</xsl:if>
    					</Phones>
    					<EmailAddress><xsl:value-of select="$emailAddress" /></EmailAddress>
    					<CorrMethID>Mail</CorrMethID>
    					<IsSendEmail>true</IsSendEmail>
    					<IsReceiveMarketing>true</IsReceiveMarketing>
						<CommunicationPreferences>
							<CommunicationPreference>
								<CommGroup>9</CommGroup>
								<CommMedium>4</CommMedium>
								<IsUsed>Y</IsUsed>
							</CommunicationPreference>
							<CommunicationPreference>
								<CommGroup>16</CommGroup>
								<CommMedium>1</CommMedium>
								<IsUsed>Y</IsUsed>
							</CommunicationPreference>							
						</CommunicationPreferences>
    				</Contacts>
    				<Cover>
    					<EffDate><xsl:value-of select="$startDate" /></EffDate>
    					<Class>
    						<xsl:choose>
    							<xsl:when test="situation/healthCvr = 'S'">Sgl</xsl:when>
    							<xsl:otherwise>Fam</xsl:otherwise>
    						</xsl:choose>
    					</Class>
    					<CoverType>BLANK</CoverType>
    					<ProductSelection>BLANK</ProductSelection>
    					<AccountIgnored>false</AccountIgnored>
    					<BenefitPaymentMethod>D/Cr</BenefitPaymentMethod>
    					<CoverRateSelection><xsl:value-of select="fundData/fundCode" /></CoverRateSelection>
    					<Account>
    						<AccountType>credit</AccountType>
    						<DebitCreditID>Bank</DebitCreditID>
    						<xsl:choose>
    						<xsl:when test="payment/details/type='cc' or payment/bank/claims!='Y'">
	    						<BSB><xsl:value-of select="concat(substring(payment/bank/claim/bsb,1,3),'-',substring(payment/bank/claim/bsb,4,3))" /></BSB>
	    						<AccountNumber><xsl:value-of select="translate(payment/bank/claim/number,' ','')" /></AccountNumber>
	    						<AccountName><xsl:value-of select="payment/bank/claim/account" /></AccountName>
	    					</xsl:when>
	    					<xsl:otherwise>
	    						<BSB><xsl:value-of select="concat(substring(payment/bank/bsb,1,3),'-',substring(payment/bank/bsb,4,3))" /></BSB>
	    						<AccountNumber><xsl:value-of select="translate(payment/bank/number,' ','')" /></AccountNumber>
	    						<AccountName><xsl:value-of select="payment/bank/account" /></AccountName>	    					
	    					</xsl:otherwise>
    						</xsl:choose> 		    						   							    						
    					</Account>
    				</Cover>
    				<Contributions>
    					<DirectDebitContribPayments>true</DirectDebitContribPayments>
    					<EffDate><xsl:value-of select="$startDate" /></EffDate>
    					<ContribFreq>
    						<xsl:choose>
    							<xsl:when test="payment/details/frequency='W'">Wkly</xsl:when>
    							<xsl:when test="payment/details/frequency='F'">Fnght</xsl:when>
    							<xsl:when test="payment/details/frequency='M'">Mtly</xsl:when>
    							<xsl:when test="payment/details/frequency='Q'">Qtly</xsl:when>
    							<xsl:when test="payment/details/frequency='H'">6Mtly</xsl:when>
    							<xsl:when test="payment/details/frequency='A'">Yrly</xsl:when>
    						</xsl:choose>
    					</ContribFreq>
    					<ContribRateSelection><xsl:value-of select="fundData/fundCode" /></ContribRateSelection>
    					<Rebate>
    						<xsl:choose>
    							<xsl:when test="healthCover/rebate='Y'">true</xsl:when>
    							<xsl:otherwise>false</xsl:otherwise>
    						</xsl:choose>
    					</Rebate>
    					<xsl:if test="healthCover/rebate='Y'">
	    					<RebateTier>
	    						<EffDate><xsl:value-of select="$startDate"/></EffDate>
	    						<Tier>
	    							<xsl:value-of select="healthCover/income" />
	    						</Tier>
	    					</RebateTier>
	    				</xsl:if>
	    				<EligibleMedicare>
	    					<xsl:choose>
	    						<xsl:when test="payment/medicare/cover='Y'">true</xsl:when>
	    						<xsl:otherwise>false</xsl:otherwise>
	    					</xsl:choose>    					
	    				</EligibleMedicare>
    				
						<xsl:variable name="debitDay">
    						<xsl:choose>
    							<xsl:when test="payment/details/type='cc'">
	    							<xsl:value-of select="format-number(number(payment/credit/day),'00')" />
	    						</xsl:when>
	    						<xsl:otherwise>
	    							<xsl:value-of select="format-number(number(payment/bank/day),'00')" />
	    						</xsl:otherwise>
							</xsl:choose>							
						</xsl:variable>	  
						<xsl:variable name="currentDay" select="substring($today,9,2)" />
						<xsl:variable name="currentMonth" select="substring($today,6,2)" />
						<xsl:variable name="currentYear" select="substring($today,1,4)" />
						<xsl:variable name="nextYear" select="format-number(number($currentYear)+1,'0000')" />
						<xsl:variable name="nextMonth" select="format-number(number($currentMonth)+1,'00')" />
						  				
    					<xsl:variable name="debitDate">
    						<xsl:choose>
    							<xsl:when test="$debitDay > $currentDay">
    								<xsl:value-of select="concat($currentYear,'-',$currentMonth,'-',$debitDay)" />
    							</xsl:when>
								<xsl:when test="$currentMonth = '12'">
									<xsl:value-of select="concat($nextYear,'-01-',$debitDay)" />
								</xsl:when>	    							
								<xsl:otherwise>
									<xsl:value-of select="concat($currentYear,'-',$nextMonth,'-',$debitDay)" />
								</xsl:otherwise>	    						
    						</xsl:choose>
    					</xsl:variable>
						<DebitOnDate><xsl:value-of select="$debitDate" /></DebitOnDate>    					
    					<Account>
    						<xsl:choose>
    							<xsl:when test="payment/details/type='cc'">
									<DebitCreditID><xsl:value-of select="payment/gateway/nab/cardType" /></DebitCreditID>
									<ExpiryMonth><xsl:value-of select="payment/gateway/nab/expiryMonth" /></ExpiryMonth>
									<ExpiryYear><xsl:value-of select="payment/gateway/nab/expiryYear" /></ExpiryYear>
									<AccountNumber><xsl:value-of select="payment/gateway/nab/cardNumber" /></AccountNumber>
									<AccountName>NA</AccountName>
									<TempCRN><xsl:value-of select="payment/gateway/nab/crn" /></TempCRN>
    							</xsl:when>
    							<xsl:otherwise>
		    						<DebitCreditID>GMFDD</DebitCreditID>
		    						<BSB><xsl:value-of select="concat(substring(payment/bank/bsb,1,3),'-',substring(payment/bank/bsb,4,3))" /></BSB>
		    						<AccountNumber><xsl:value-of select="translate(payment/bank/number,' ','')" /></AccountNumber>
		    						<AccountName><xsl:value-of select="payment/bank/account" /></AccountName> 		    						   							
    							</xsl:otherwise>
    						</xsl:choose>
    					</Account>
    				</Contributions>
    				<Membership>
    					<Group>
    						<EffDate><xsl:value-of select="$startDate" /></EffDate>
    						<GroupID>
    							<xsl:choose>
    								<xsl:when test="payment/details/type='ba'">G0504</xsl:when>
    								<xsl:otherwise>G0506</xsl:otherwise>
    							</xsl:choose>
    						</GroupID>
    						<PayrollNo />
    					</Group>
    					<Agency>
    						<EffDate><xsl:value-of select="$startDate" /></EffDate>
    						<AgencyID>A022</AgencyID>
    					</Agency>
    				</Membership>
    			</MembershipApplication>
    			<xsl:text disable-output-escaping="yes">]]&gt;</xsl:text>
    			</hsl:xmlFile>
				<hsl:BrokerID>A023</hsl:BrokerID>
				</hsl:SubmitMembership>
    		</soapenv:Body>
  		</soapenv:Envelope>		
	</xsl:template>
	
		<!-- This fund mapping as per JIRA HLT-119 -->
		<xsl:template name="get-fund-name">
		<xsl:param name="fundName" />
		<xsl:choose>
				<xsl:when test="$fundName='AHM'">AHM</xsl:when>
				<xsl:when test="$fundName='AUSTUN'">AU</xsl:when>
				<xsl:when test="$fundName='BUPA'">NMH</xsl:when>
				<xsl:when test="$fundName='FRANK'">FHI</xsl:when>
				<xsl:when test="$fundName='GMHBA'">GMH</xsl:when>
				<xsl:when test="$fundName='HBA'">HUB</xsl:when>
				<xsl:when test="$fundName='HBF'">HBF</xsl:when>
				<xsl:when test="$fundName='HBFSA'">SPS</xsl:when>
				<xsl:when test="$fundName='HCF'">HCF</xsl:when>
				<xsl:when test="$fundName='HHBFL'">HHB</xsl:when>
				<xsl:when test="$fundName='MBF'">MBF</xsl:when>
				<xsl:when test="$fundName='MEDIBK'">MP</xsl:when>
				<xsl:when test="$fundName='NIB'">NIB</xsl:when>
				<xsl:when test="$fundName='WDHF'">WEF</xsl:when>
				<xsl:when test="$fundName='ACA'">ACA</xsl:when>
				<xsl:when test="$fundName='CBHS'">CBH</xsl:when>
				<xsl:when test="$fundName='CDH'">CDH</xsl:when>
				<xsl:when test="$fundName='CUA'">CUA</xsl:when>
				<xsl:when test="$fundName='CWH'">CWH</xsl:when>
				<xsl:when test="$fundName='DHBS'">AHB</xsl:when>
				<xsl:when test="$fundName='GMF'">GMF</xsl:when>
				<xsl:when test="$fundName='GU'">GUC</xsl:when>
				<xsl:when test="$fundName='HCI'">HCI</xsl:when>
				<xsl:when test="$fundName='HIF'">HIF</xsl:when>
				<xsl:when test="$fundName='LHMC'">LHM</xsl:when>
				<xsl:when test="$fundName='LVHHS'">LHS</xsl:when>
				<xsl:when test="$fundName='MC'">MUT</xsl:when>
				<xsl:when test="$fundName='MU'">MU</xsl:when>
				<xsl:when test="$fundName='MDHF'">MDH</xsl:when>
				<xsl:when test="$fundName='NHBA'">NHA</xsl:when>
				<xsl:when test="$fundName='NHBS'">NHB</xsl:when>
				<xsl:when test="$fundName='NRMA'">NRM</xsl:when>
				<xsl:when test="$fundName='PWAL'">PWA</xsl:when>
				<xsl:when test="$fundName='QCH'">MIM</xsl:when>
				<xsl:when test="$fundName='QTUHS'">QTH</xsl:when>
				<xsl:when test="$fundName='RBHS'">RBH</xsl:when>
				<xsl:when test="$fundName='RTEHF'">RTE</xsl:when>
				<xsl:when test="$fundName='SAPOL'">PH</xsl:when>
				<xsl:when test="$fundName='SGIC'">SGC</xsl:when>
				<xsl:when test="$fundName='SGIO'">SGO</xsl:when>
				<xsl:when test="$fundName='SLHI'">SL</xsl:when>
				<xsl:when test="$fundName='TFHS'">NTF</xsl:when>
				<xsl:when test="$fundName='TFS'">TFS</xsl:when>
				<xsl:when test="$fundName='HEA'">HTH</xsl:when>
				<xsl:when test="$fundName='NONE'">NONE</xsl:when>
				<!-- All other funds in our list -->
				<xsl:when test="$fundName != ''">OTH</xsl:when>
				<xsl:otherwise>NONE</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template name="titleize">
        <xsl:param name="title"/>
        <xsl:param name="firstWord"/>
        <xsl:choose>
            <xsl:when test="contains($title, ' ')">
                <xsl:call-template name="upperFirst">
                    <xsl:with-param name="word" select="substring-before($title, ' ')"/>
                    <xsl:with-param name="firstWord" select="$firstWord"/>
                </xsl:call-template>
                <xsl:text> </xsl:text>
                <xsl:call-template name="titleize">
                    <xsl:with-param name="title" select="substring-after($title, ' ')"></xsl:with-param>
                    <xsl:with-param name="firstWord" select="1 = 2"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="upperFirst">
                    <xsl:with-param name="word" select="$title"/>
                    <xsl:with-param name="firstWord" select="$firstWord"/>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
	
    <xsl:template name="upperFirst">
        <xsl:param name="word"/>
        <xsl:param name="firstWord"/>
        <xsl:choose>
            <xsl:when test="string-length($word) &lt;= 3 and not($firstWord)">
                <xsl:value-of select="$word"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="translate(substring($word, 1, 1), $LOWERCASE, $UPPERCASE)"/>
                <xsl:value-of select="substring($word, 2 , string-length($word) - 1)"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
	
	
	
</xsl:stylesheet>