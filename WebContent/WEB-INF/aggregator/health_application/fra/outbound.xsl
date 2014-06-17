<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	xmlns:xalan="http://xml.apache.org/xalan"
	xmlns:date="http://exslt.org/dates-and-times"
	exclude-result-prefixes="xalan date">
	
	<xsl:variable name="LOWERCASE" select="'abcdefghijklmnopqrstuvwxyz'" />
	<xsl:variable name="UPPERCASE" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'" />
	
	<!-- PARAMETERS -->
	<xsl:param name="today" />
	<xsl:param name="overrideEmail"></xsl:param>
	
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
		
		<xsl:choose>
			<!-- Non-Standard -->
			<xsl:when test="$address/nonStd='Y'">
				<xsl:value-of select="$address/fullAddressLineOne" />
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
		
	<xsl:variable name="postal_streetName" select="translate($postal_streetNameLower, $LOWERCASE, $UPPERCASE)" />
	<xsl:variable name="postal_suburbName" select="translate($postalAddress/suburbName, $LOWERCASE, $UPPERCASE)" /> 
	<xsl:variable name="postal_state" select="translate($postalAddress/state, $LOWERCASE, $UPPERCASE)" />
	
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
		<xsl:variable name="debitOnDate">
			<xsl:choose>
				<xsl:when test="payment/details/type='ba' and payment/bank/policyDay != ''">
					<xsl:value-of select="payment/bank/policyDay" />
				</xsl:when>
				<xsl:when test="payment/details/type='ba'">
					<xsl:value-of select="payment/bank/paymentDay" />
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="payment/credit/policyDay" />
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
	
	
		<!-- FUND PRODUCT SPECIFIC VALUES -->
		<soapenv:Envelope xmlns:tem="http://tempuri.org/" xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/">
		   <soapenv:Header>
				<wsse:Security soapenv:mustUnderstand="1" xmlns:wsse="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd">
				<wsse:UsernameToken wsu:Id="UsernameToken-8" xmlns:wsu="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd">
				<wsse:Username>Comparethemarket</wsse:Username>
				<wsse:Password Type="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-username-token-profile-1.0#PasswordText">y$ha6ESw</wsse:Password>
				<wsu:Created>2011-04-15T07:35:42.904Z</wsu:Created>
				</wsse:UsernameToken>
				</wsse:Security>
			</soapenv:Header>

    		<soapenv:Body>
				<tem:SubmitMembershipTransaction>
 
				<tem:xmlFile>
    				<xsl:text disable-output-escaping="yes">&lt;![CDATA[</xsl:text>
				<MembershipApplication xmlns="http://tempuri.org/MemberServices/MemberServices.xsd">
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
    						<xsl:if test="payment/medicare/number != ''">
    							<MediCardNo><xsl:value-of select="translate(payment/medicare/number,' ','')" /></MediCardNo>
    						</xsl:if>
    						<xsl:if test="payment/medicare/expiry/cardExpiryYear != ''">
    						<MediCardExpDate>
								<xsl:text>20</xsl:text><xsl:value-of select="payment/medicare/expiry/cardExpiryYear" />-<xsl:value-of select="payment/medicare/expiry/cardExpiryMonth" /><xsl:text>-01</xsl:text>								    						
    						</MediCardExpDate>
    						</xsl:if>
    						<xsl:if test="payment/medicare/firstName!=''" >
    							<MediCardFirstName><xsl:value-of select="payment/medicare/firstName" /></MediCardFirstName>
    						</xsl:if>
    						<xsl:if test="payment/medicare/middleInitial!= ''">
    						<MediCardSecondName><xsl:value-of select="payment/medicare/middleInitial" /></MediCardSecondName>
    						</xsl:if>
    						<MediCardSurname><xsl:value-of select="payment/medicare/surname" /></MediCardSurname>
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
    						
    						<Properties> 
                				<Property> 
                                	<Name>bTier</Name> 
                                	<Value>
                                		<xsl:choose>
                                			<xsl:when test="healthCover/rebate='N'">No Rebate</xsl:when>
                                			<xsl:when test="healthCover/income='1'">Tier 1</xsl:when>
                                			<xsl:when test="healthCover/income='2'">Tier 2</xsl:when>
                                			<xsl:when test="healthCover/income='3'">Tier 3</xsl:when>
                                			<xsl:otherwise>Unchanged</xsl:otherwise>
                                		</xsl:choose>
                                	</Value>
                                </Property> 
                				<Property> 
                                	<Name>TAuth</Name> 
                                	<Value>
                                		<xsl:choose>
                                			<xsl:when test="previousfund/primary/authority='Y'">Yes</xsl:when>
                                			<xsl:otherwise>No</xsl:otherwise>
                                		</xsl:choose>
                                	</Value>
                                </Property> 
                				<Property> 
                                	<Name>CTBDA</Name> 
                                	<Value>
                                		<xsl:value-of select="$debitOnDate" />
                                	</Value>
                                </Property>
                                <xsl:if test="$primaryFund!='NONE'"> 
	            					<Property> 
	                                	<Name>002</Name> 
	                                	<Value>Fund: <xsl:value-of select="$primaryFund"/>, No: <xsl:value-of select="previousfund/primary/memberID" /></Value>
	                				</Property>
                				</xsl:if>
							</Properties>
    					</Person>
    					<xsl:if test="application/partner/firstname != ''">
	    					<Person>
	    						<PersonID>0</PersonID>
	    						<EffDate><xsl:value-of select="$startDate" /></EffDate>
	    						<Relationship>Sps</Relationship>
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
	    						<IsRebateApplicant>
	    							<xsl:choose>
	    								<xsl:when test="healthCover/rebate='Y'">true</xsl:when>
	    								<xsl:otherwise>false</xsl:otherwise>
	    							</xsl:choose>
	    						</IsRebateApplicant>
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
		    								<xsl:when test="school!= ''">true</xsl:when>
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
    				</Contacts>
    				<Cover>
    					<EffDate><xsl:value-of select="$startDate" /></EffDate>
    					<Class>
    						<xsl:choose>
    							<xsl:when test="situation/healthCvr = 'S'">Sgl</xsl:when>
    							<xsl:when test="situation/healthCvr = 'C'">Cpl</xsl:when>
    							<xsl:when test="situation/healthCvr = 'SPF'">SPFam</xsl:when>
    							<xsl:otherwise>Fam</xsl:otherwise>
    						</xsl:choose>
    					</Class>
    					<CoverType>
    						<xsl:choose>
    							<xsl:when test="fundData/hospitalCoverName != '' and fundData/extrasCoverName!=''">C</xsl:when>
    							<xsl:when test="fundData/hospitalCoverName != ''">H</xsl:when>
    							<xsl:when test="fundData/extrasCoverName!=''">A</xsl:when>
    						</xsl:choose>
    					</CoverType>
    					<!-- <ProductSelection><xsl:value-of select="fundData/fundCode" /></ProductSelection> -->
    					<ProductSelection>BLANK</ProductSelection>
    					<AccountIgnored>true</AccountIgnored>
    					<BenefitPaymentMethod>Chq</BenefitPaymentMethod>
    					<xsl:variable name="crsState">
    					    <xsl:choose>
	    						<xsl:when test="$state='QLD'">Q</xsl:when>
	    						<xsl:when test="$state='NSW'">N</xsl:when>
	    						<xsl:when test="$state='ACT'">A</xsl:when>
	    						<xsl:when test="$state='NT'">X</xsl:when>
	    						<xsl:when test="$state='WA'">W</xsl:when>
	    						<xsl:when test="$state='SA'">S</xsl:when>
	    						<xsl:when test="$state='VIC'">V</xsl:when>
	    						<xsl:when test="$state='TAS'">T</xsl:when>
    						</xsl:choose>
    					</xsl:variable>
    					<xsl:variable name="crsCvr">
    						<xsl:choose>
    							<xsl:when test="situation/healthCvr = 'S'">S</xsl:when>
    							<xsl:when test="situation/healthCvr = 'C'">C</xsl:when>
    							<xsl:when test="situation/healthCvr = 'SPF'">P</xsl:when>
    							<xsl:otherwise>F</xsl:otherwise>
    						</xsl:choose>
    					</xsl:variable>
    					<CoverRateSelection><xsl:value-of select="fundData/fundCode" /><xsl:value-of select="$crsCvr" />/<xsl:value-of select="$crsState" /></CoverRateSelection>
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
	    				<DebitOnDate><xsl:value-of select="$debitOnDate" /></DebitOnDate>
    					<Account>
    						<xsl:choose>
    							<xsl:when test="payment/details/type='cc'">
		    						<DebitCreditID>
		    							<xsl:choose>
		    								<xsl:when test="substring(payment/credit/number,1,1) = '4'">Visa</xsl:when>
		    								<xsl:otherwise>Mcard</xsl:otherwise>
		    							</xsl:choose>
		    						</DebitCreditID>
		    						<ExpiryMonth><xsl:value-of select="payment/credit/expiry/cardExpiryMonth" /></ExpiryMonth>
		    						<ExpiryYear>20<xsl:value-of select="payment/credit/expiry/cardExpiryYear" /></ExpiryYear>
		    						<AccountNumber><xsl:value-of select="translate(payment/credit/number,' ','')" /></AccountNumber>
		    						<AccountName><xsl:value-of select="payment/credit/name" /></AccountName>    							
    							</xsl:when>
    							<xsl:otherwise>
		    						<DebitCreditID>Bank</DebitCreditID>
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
    								<xsl:when test="payment/details/type='ba'">FDDBA</xsl:when>
    								<xsl:otherwise>FDDCC</xsl:otherwise>
    							</xsl:choose>
    						</GroupID>
    						<PayrollNo></PayrollNo>
    					</Group>
    					<Branch>
    						<EffDate><xsl:value-of select="$startDate" /></EffDate>
    						<BranchID>FrB</BranchID>
    					</Branch>
    					<Agency>
    						<EffDate><xsl:value-of select="$startDate" /></EffDate>
    						<AgencyID>A57012</AgencyID>
    					</Agency>
    					<Site>
    						<EffDate><xsl:value-of select="$startDate" /></EffDate>
    						<LocationID>Frank</LocationID>
    						<SiteID>Fr1</SiteID>
    					</Site>
    				</Membership>
    			</MembershipApplication>
    				
    				
    				<xsl:text disable-output-escaping="yes">]]&gt;</xsl:text>
				</tem:xmlFile>
 
		<tem:AgentID>F-CTM</tem:AgentID>
	</tem:SubmitMembershipTransaction>

    		</soapenv:Body>
  		</soapenv:Envelope>		
	</xsl:template>
	
	<xsl:template name="get-fund-name">
		<xsl:param name="fundName" />
		<xsl:choose>
			<xsl:when test="$fundName='AHM'">GEH</xsl:when>
			<xsl:when test="$fundName='AUSTUN'">AU</xsl:when>
			<xsl:when test="$fundName='BUPA'">BUP</xsl:when>
			<xsl:when test="$fundName='FRANK'">Frank</xsl:when>
			<xsl:when test="$fundName='GMHBA'">GMHBA</xsl:when>
			<xsl:when test="$fundName='HBA'">HBA</xsl:when>
			<xsl:when test="$fundName='HBF'">HBF</xsl:when>
			<xsl:when test="$fundName='HBFSA'">NONE</xsl:when>
			<xsl:when test="$fundName='HCF'">HCF</xsl:when>
			<xsl:when test="$fundName='HHBFL'">HHBF</xsl:when>
			<xsl:when test="$fundName='MBF'">MBF</xsl:when>
			<xsl:when test="$fundName='MEDIBK'">MP</xsl:when>
			<xsl:when test="$fundName='NIB'">NIB</xsl:when>
			<xsl:when test="$fundName='WDHF'">WDHF</xsl:when>
			<xsl:when test="$fundName='ACA'">ACA</xsl:when>
			<xsl:when test="$fundName='AMA'">AMA</xsl:when>
			<xsl:when test="$fundName='API'">NONE</xsl:when>
			<xsl:when test="$fundName='BHP'">NONE</xsl:when>
			<xsl:when test="$fundName='CBHS'">NONE</xsl:when>
			<xsl:when test="$fundName='CDH'">CDH</xsl:when>
			<xsl:when test="$fundName='CI'">NONE</xsl:when>
			<xsl:when test="$fundName='CPS'">NONE</xsl:when>
			<xsl:when test="$fundName='CUA'">CUA</xsl:when>
			<xsl:when test="$fundName='CWH'">CWH</xsl:when>
			<xsl:when test="$fundName='DFS'">UAOD</xsl:when>
			<xsl:when test="$fundName='DHBS'">AHBS</xsl:when>
			<xsl:when test="$fundName='FI'">YMHS</xsl:when>
			<xsl:when test="$fundName='GMF'">GMF</xsl:when>
			<xsl:when test="$fundName='GU'">GU</xsl:when>
			<xsl:when test="$fundName='HCI'">HCI</xsl:when>
			<xsl:when test="$fundName='HIF'">HIF</xsl:when>
			<xsl:when test="$fundName='HEA'">NONE</xsl:when>
			<xsl:when test="$fundName='IFHP'">NONE</xsl:when>
			<xsl:when test="$fundName='IMAN'">NONE</xsl:when>
			<xsl:when test="$fundName='IOOF'">IOOF</xsl:when>
			<xsl:when test="$fundName='IOR'">IOR</xsl:when>
			<xsl:when test="$fundName='LHMC'">LHMC</xsl:when>
			<xsl:when test="$fundName='LVHHS'">LHS</xsl:when>
			<xsl:when test="$fundName='MC'">MC</xsl:when>
			<xsl:when test="$fundName='MDHF'">MDHF</xsl:when>
			<xsl:when test="$fundName='MU'">NONE</xsl:when>
			<xsl:when test="$fundName='NATMUT'">NONE</xsl:when>
			<xsl:when test="$fundName='NHBA'">NONE</xsl:when>
			<xsl:when test="$fundName='NHBS'">NAVY</xsl:when>
			<xsl:when test="$fundName='NRMA'">SGIO</xsl:when>
			<xsl:when test="$fundName='PWAL'">PWAL</xsl:when>
			<xsl:when test="$fundName='QCH'">QCH</xsl:when>
			<xsl:when test="$fundName='QTUHS'">QTUHS</xsl:when>
			<xsl:when test="$fundName='RBHS'">RBHS</xsl:when>
			<xsl:when test="$fundName='RTEHF'">RTEFS</xsl:when>
			<xsl:when test="$fundName='SAPOL'">NONE</xsl:when>
			<xsl:when test="$fundName='SGIC'">NONE</xsl:when>
			<xsl:when test="$fundName='SGIO'">SGIO</xsl:when>
			<xsl:when test="$fundName='SLHI'">SLMHB</xsl:when>
			<xsl:when test="$fundName='TFHS'">NONE</xsl:when>
			<xsl:when test="$fundName='TFS'">TFS</xsl:when>
			<xsl:when test="$fundName='UAOD'">UAOD</xsl:when>
			<xsl:otherwise>NONE</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
</xsl:stylesheet>