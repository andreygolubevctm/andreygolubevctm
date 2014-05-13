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
			<xsl:otherwise>
				<info></info>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>