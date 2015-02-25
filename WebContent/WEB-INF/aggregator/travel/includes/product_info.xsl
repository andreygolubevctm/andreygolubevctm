<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:template name="productInfo">
		<xsl:param name="productId" />
		<xsl:choose>
			<!-- DUINSURE - COMPREHENSIVE -->
			<xsl:when test="$productId = 'DUIN-TRAVEL-49'">
				<info>
					<cxdfee>
						<label>Cancellation Fees</label>
						<desc>Cancellation Fees and Lost Deposits</desc>
						<value>10000.0</value>
						<text>$10,000</text>
						<order />
					</cxdfee>
					<excess>
						<label>Excess</label>
						<desc>Excess on Claims</desc>
						<value>100.0</value>
						<text>$100</text>
						<order />
					</excess>
					<liability>
						<label>Personal Liability</label>
						<desc>Personal Liability</desc>
						<value>5000000.0</value>
						<text>$5,000,000</text>
						<order />
					</liability>
					<luggage>
						<label>Luggage and PE</label>
						<desc>Luggage and Personal Effects</desc>
						<value>5000.0</value>
						<text>$5,000</text>
						<order />
					</luggage>
					<medical>
						<label>Overseas Medical</label>
						<desc>Overseas Emergency Medical and Hospital Expenses</desc>
						<value>9.99999999E8</value>
						<text>Unlimited</text>
						<order />
					</medical>
					<medicalAssi>
						<label>Overseas Medical Assistance</label>
						<desc>Overseas Emergency Medical Assistance</desc>
						<value>9.99999999E8</value>
						<text>Unlimited</text>
						<order />
					</medicalAssi>
					<traveldelay>
						<label>Travel Delay</label>
						<desc>Travel Delay</desc>
						<value>1000.0</value>
						<text>$1,000</text>
						<order />
					</traveldelay>
					<traveldocs>
						<label>Travel Documents, Credit Cards and Travellers Cheq
						</label>
						<desc>Travel Documents, Credit Cards and Travellers Cheques
						</desc>
						<value>1000.0</value>
						<text>$1,000</text>
						<order />
					</traveldocs>
				</info>
			</xsl:when>
			<xsl:when test="$productId = 'DUIN-TRAVEL-53'">
				<info>
					<cxdfee>
						<label>Cancellation Fees</label>
						<desc>Cancellation Fees and Lost Deposits</desc>
						<value>10000.0</value>
						<text>$10,000</text>
						<order />
					</cxdfee>
					<excess>
						<label>Excess</label>
						<desc>Excess on Claims</desc>
						<value>100.0</value>
						<text>$100</text>
						<order />
					</excess>
					<liability>
						<label>Personal Liability</label>
						<desc>Personal Liability</desc>
						<value>5000000.0</value>
						<text>$5,000,000</text>
						<order />
					</liability>
					<luggage>
						<label>Luggage and PE</label>
						<desc>Luggage and Personal Effects</desc>
						<value>5000.0</value>
						<text>$5,000</text>
						<order />
					</luggage>
					<medical>
						<label>Overseas Medical</label>
						<desc>Overseas Emergency Medical and Hospital Expenses</desc>
						<value>9.99999999E8</value>
						<text>Unlimited</text>
						<order />
					</medical>
					<medicalAssi>
						<label>Overseas Medical Assistance</label>
						<desc>Overseas Emergency Medical Assistance</desc>
						<value>9.99999999E8</value>
						<text>Unlimited</text>
						<order />
					</medicalAssi>
					<traveldelay>
						<label>Travel Delay</label>
						<desc>Travel Delay</desc>
						<value>1000.0</value>
						<text>$1,000</text>
						<order />
					</traveldelay>
					<traveldocs>
						<label>Travel Documents, Credit Cards and Travellers Cheq
						</label>
						<desc>Travel Documents, Credit Cards and Travellers Cheques
						</desc>
						<value>1000.0</value>
						<text>$1,000</text>
						<order />
					</traveldocs>
					<rescue>
						<label>Emergency Rescue</label>
						<desc>Emergency Rescue</desc>
						<value>9.99999999E8</value>
						<text>Unlimited</text>
						<order />
					</rescue>
					<skitheft>
						<label>Theft of/Damage to Own Ski Equipment</label>
						<desc>Theft of/Damage to Own Ski Equipment</desc>
						<value>1500</value>
						<text>$1,500</text>
						<order />
					</skitheft>
					<skihire>
						<label>Snow Ski Hire Equipment</label>
						<desc>Snow Ski Hire Equipment</desc>
						<value>1500</value>
						<text>$1,500</text>
						<order />
					</skihire>
					<skiPack>
						<label>Ski Pack</label>
						<desc>Ski Pack</desc>
						<value>750</value>
						<text>$750</text>
						<order />
					</skiPack>
					<pisteClosure>
						<label>Piste Closure</label>
						<desc>Piste Closure</desc>
						<value>1000</value>
						<text>$1,000</text>
						<order />
					</pisteClosure>
					<weatherClosure>
						<label>Bad Weather &amp; Avalanche Closure</label>
						<desc>Bad Weather &amp; Avalanche Closure</desc>
						<value>750</value>
						<text>$750</text>
						<order />
					</weatherClosure>
				</info>
			</xsl:when>
			<!-- DUINSURE - BACKPACKER -->
			<xsl:when test="$productId = 'DUIN-TRAVEL-50'">
				<info>
					<cxdfee>
						<label>Cancellation Fees</label>
						<desc>Cancellation Fees and Lost Deposits</desc>
						<value>2500.0</value>
						<text>$2,500</text>
						<order />
					</cxdfee>
					<excess>
						<label>Excess</label>
						<desc>Excess on Claims</desc>
						<value>100.0</value>
						<text>$100</text>
						<order />
					</excess>
					<liability>
						<label>Personal Liability</label>
						<desc>Personal Liability</desc>
						<value>2000000.0</value>
						<text>$2,000,000</text>
						<order />
					</liability>
					<luggage>
						<label>Luggage and PE</label>
						<desc>Luggage and Personal Effects</desc>
						<value>2000.0</value>
						<text>$2,000</text>
						<order />
					</luggage>
					<medical>
						<label>Overseas Medical</label>
						<desc>Overseas Emergency Medical and Hospital Expenses</desc>
						<value>9.99999999E8</value>
						<text>Unlimited</text>
						<order />
					</medical>
					<medicalAssi>
						<label>Overseas Medical Assistance</label>
						<desc>Overseas Emergency Medical Assistance</desc>
						<value>9.99999999E8</value>
						<text>Unlimited</text>
						<order />
					</medicalAssi>
					<traveldelay>
						<label>Travel Delay</label>
						<desc>Travel Delay</desc>
						<value>500.0</value>
						<text>$500</text>
						<order />
					</traveldelay>
					<traveldocs>
						<label>Travel Documents, Credit Cards and Travellers Cheq</label>
						<desc>Travel Documents, Credit Cards and Travellers Cheques</desc>
						<value>500.0</value>
						<text>$500</text>
						<order />
					</traveldocs>
				</info>
			</xsl:when>
			<!-- DUINSURE - AMT LEISURE -->
			<xsl:when test="$productId = 'DUIN-TRAVEL-51'">
				<info>
					<cxdfee>
						<label>Cancellation Fees</label>
						<desc>Cancellation Fees and Lost Deposits</desc>
						<value>9.99999999E8</value>
						<text>Unlimited</text>
						<order />
					</cxdfee>
					<excess>
						<label>Excess</label>
						<desc>Excess on Claims</desc>
						<value>100.0</value>
						<text>$100</text>
						<order />
					</excess>
					<liability>
						<label>Personal Liability</label>
						<desc>Personal Liability</desc>
						<value>5000000.0</value>
						<text>$5,000,000</text>
						<order />
					</liability>
					<luggage>
						<label>Luggage and PE</label>
						<desc>Luggage and Personal Effects</desc>
						<value>5000.0</value>
						<text>$5,000</text>
						<order />
					</luggage>
					<maxTravel>
						<label>Maximum Trip Duration</label>
						<desc>Maximum Trip Duration</desc>
						<value>37.0</value>
						<text>37 Days</text>
						<order />
					</maxTravel>
					<medical>
						<label>Overseas Medical</label>
						<desc>Overseas Emergency Medical and Hospital Expenses</desc>
						<value>9.99999999E8</value>
						<text>Unlimited</text>
						<order />
					</medical>
					<medicalAssi>
						<label>Overseas Medical Assistance</label>
						<desc>Overseas Emergency Medical Assistance</desc>
						<value>9.99999999E8</value>
						<text>Unlimited</text>
						<order />
					</medicalAssi>
					<rentalVeh>
						<label>Rental Vehicle</label>
						<desc>Rental Vehicle</desc>
						<value>3000.0</value>
						<text>$3,000</text>
						<order />
					</rentalVeh>
					<traveldelay>
						<label>Travel Delay</label>
						<desc>Travel Delay</desc>
						<value>2000.0</value>
						<text>$2,000</text>
						<order />
					</traveldelay>
					<traveldocs>
						<label>Travel Documents, Credit Cards and Travellers Cheq
						</label>
						<desc>Travel Documents, Credit Cards and Travellers Cheques
						</desc>
						<value>5000.0</value>
						<text>$5,000</text>
						<order />
					</traveldocs>
				</info>
			</xsl:when>
			<!-- DUINSURE - AMT BUSINESS -->
			<xsl:when test="$productId = 'DUIN-TRAVEL-52'">
				<info>
					<altStaff>
						<label>Alternative Staff</label>
						<desc>Alternative Staff</desc>
						<value>2500.0</value>
						<text>$2,500</text>
						<order />
					</altStaff>
					<busEquipment>
						<label>Business Equipment</label>
						<desc>Business Equipment</desc>
						<value>5000.0</value>
						<text>$5,000</text>
						<order />
					</busEquipment>
					<cxdfee>
						<label>Cancellation Fees</label>
						<desc>Cancellation Fees and Lost Deposits</desc>
						<value>9.99999999E8</value>
						<text>Unlimited</text>
						<order />
					</cxdfee>
					<excess>
						<label>Excess</label>
						<desc>Excess on Claims</desc>
						<value>100.0</value>
						<text>$100</text>
						<order />
					</excess>
					<income>
						<label>Loss of Income</label>
						<desc>Loss of Income</desc>
						<value>10400.0</value>
						<text>$10,400</text>
						<order />
					</income>
					<liability>
						<label>Personal Liability</label>
						<desc>Personal Liability</desc>
						<value>5000000.0</value>
						<text>$5,000,000</text>
						<order />
					</liability>
					<luggage>
						<label>Luggage and PE</label>
						<desc>Luggage and Personal Effects</desc>
						<value>5000.0</value>
						<text>$5,000</text>
						<order />
					</luggage>
					<maxTravel>
						<label>Maximum Trip Duration</label>
						<desc>Maximum Trip Duration</desc>
						<value>90.0</value>
						<text>90 Days</text>
						<order />
					</maxTravel>
					<medical>
						<label>Overseas Medical</label>
						<desc>Overseas Emergency Medical and Hospital Expenses</desc>
						<value>9.99999999E8</value>
						<text>Unlimited</text>
						<order />
					</medical>
					<medicalAssi>
						<label>Overseas Medical Assistance</label>
						<desc>Overseas Emergency Medical Assistance</desc>
						<value>9.99999999E8</value>
						<text>Unlimited</text>
						<order />
					</medicalAssi>
					<rentalVeh>
						<label>Rental Vehicle</label>
						<desc>Rental Vehicle</desc>
						<value>3000.0</value>
						<text>$3,000</text>
						<order />
					</rentalVeh>
					<traveldocs>
						<label>Travel Documents, Credit Cards and Travellers Cheq
						</label>
						<desc>Travel Documents, Credit Cards and Travellers Cheques
						</desc>
						<value>5000.0</value>
						<text>$5,000</text>
						<order />
					</traveldocs>
				</info>
			</xsl:when>
			<!-- DUINSURE - Australia -->
			<xsl:when test="$productId = 'DUIN-TRAVEL-54'">
				<info>
					<cxdfee>
						<label>Cancellation Fees</label>
						<desc>Cancellation Fees and Lost Deposits</desc>
						<value>10000</value>
						<text>$10,000</text>
						<order />
					</cxdfee>
					<excess>
						<label>Excess</label>
						<desc>Excess on Claims</desc>
						<value>0</value>
						<text>$0</text>
						<order />
					</excess>
					<luggage>
						<label>Luggage and PE</label>
						<desc>Luggage and Personal Effects</desc>
						<value>5000.0</value>
						<text>$5,000</text>
						<order />
					</luggage>
					<medical>
						<label>Overseas Medical</label>
						<desc>Overseas Emergency Medical and Hospital Expenses</desc>
						<value>0</value>
						<text>$0</text>
						<order />
					</medical>
					<expenses>
						<label>Additional Expenses</label>
						<desc>Additional Expenses</desc>
						<value>10000</value>
						<text>$10,000</text>
					</expenses>
					<death>
						<label>Accidental Death</label>
						<desc>Accidental Death</desc>
						<value>30000</value>
						<text>$30,000</text>
					</death>
					<disability>
						<label>Permanent Disability</label>
						<desc>Permanent Disability</desc>
						<value>50000</value>
						<text>$50,000</text>
						<order />
					</disability>
					<traveldocs>
						<label>Travel Documents, Transaction Cards and Travellers Cheques</label>
						<desc>Travel Documents, Transaction Cards and Travellers Cheques</desc>
						<value>1000</value>
						<text>$1,000</text>
						<order />
					</traveldocs>
					<luggagedel>
						<label>Luggage and PE Delay</label>
						<desc>Luggage and Personal Effects Delay Expenses</desc>
						<value>250</value>
						<text>$250</text>
						<order />
					</luggagedel>
					<traveldelayExp>
						<label>Travel Delay Expenses</label>
						<desc>Travel Delay Expenses</desc>
						<value>1000</value>
						<text>$1,000</text>
						<order />
					</traveldelayExp>
					<transport>
						<label>Alternative Transport Expenses</label>
						<desc>Alternative Transport Expenses</desc>
						<value>3000</value>
						<text>$3,000</text>
						<order />
					</transport>
					<liability>
						<label>Personal Liability</label>
						<desc>Personal Liability</desc>
						<value>5000000</value>
						<text>$5,000,000</text>
						<order />
					</liability>
					<cashtheft>
						<label>Theft of Cash</label>
						<desc>Theft of Cash</desc>
						<value>500</value>
						<text>$500</text>
						<order />
					</cashtheft>
				</info>
			</xsl:when>
			<!-- DUINSURE - Australia Ski -->
			<xsl:when test="$productId = 'DUIN-TRAVEL-55'">
				<info>
					<cxdfee>
						<label>Cancellation Fees</label>
						<desc>Cancellation Fees and Lost Deposits</desc>
						<value>10000</value>
						<text>$10,000</text>
						<order />
					</cxdfee>
					<expenses>
						<label>Additional Expenses</label>
						<desc>Additional Expenses</desc>
						<value>10000</value>
						<text>$10,000</text>
						<order />
					</expenses>
					<death>
						<label>Accidental Death</label>
						<desc>Accidental Death</desc>
						<value>30000</value>
						<text>$30,000</text>
						<order />
					</death>
					<disability>
						<label>Permanent Disability</label>
						<desc>Permanent Disability</desc>
						<value>50000</value>
						<text>$50,000</text>
						<order />
					</disability>
					<traveldocs>
						<label>Travel Documents, Transaction Cards and Travellers Cheques</label>
						<desc>Travel Documents, Transaction Cards and Travellers Cheques</desc>
						<value>1000</value>
						<text>$1,000</text>
						<order />
					</traveldocs>
					<cashtheft>
						<label>Theft of Cash</label>
						<desc>Theft of Cash</desc>
						<value>500</value>
						<text>$500</text>
						<order />
					</cashtheft>
					<luggage>
						<label>Luggage and PE</label>
						<desc>Luggage and Personal Effects</desc>
						<value>5000</value>
						<text>$5,000</text>
						<order />
					</luggage>
					<luggagedel>
						<label>Luggage and PE Delay</label>
						<desc>Luggage and Personal Effects Delay Expenses</desc>
						<value>250</value>
						<text>$250</text>
						<order />
					</luggagedel>
					<traveldelayExp>
						<label>Travel Delay Expenses</label>
						<desc>Travel Delay Expenses</desc>
						<value>1000</value>
						<text>$1,000</text>
						<order />
					</traveldelayExp>
					<transport>
						<label>Alternative Transport Expenses</label>
						<desc>Alternative Transport Expenses</desc>
						<value>3000</value>
						<text>$3,000</text>
						<order />
					</transport>
					<liability>
						<label>Personal Liability</label>
						<desc>Personal Liability</desc>
						<value>5000000</value>
						<text>$5,000,000</text>
						<order />
					</liability>
					<excess>
						<label>Excess</label>
						<desc>Excess on Claims</desc>
						<value>0</value>
						<text>$0</text>
						<order />
					</excess>
					<medical>
						<label>Overseas Medical</label>
						<desc>Overseas Emergency Medical and Hospital Expenses</desc>
						<value>0</value>
						<text>$0</text>
						<order />
					</medical>
				</info>
			</xsl:when>
			<xsl:otherwise>
				<info></info>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>