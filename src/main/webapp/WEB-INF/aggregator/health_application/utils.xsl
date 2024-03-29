<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xalan="http://xml.apache.org/xalan"
	exclude-result-prefixes="xalan">

	<xsl:variable name="LOWERCASE" select="'abcdefghijklmnopqrstuvwxyz'" />
	<xsl:variable name="UPPERCASE" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'" />

	<xsl:template name="mask_banknumber">
		<xsl:param name="banknumber" />
		<xsl:variable name="banknumberSpacesRemoved" select="normalize-space($banknumber)" />
		<xsl:variable name="length" select="string-length($banknumberSpacesRemoved)"/>
		<xsl:choose>
			<xsl:when test="$length > 4">
				<xsl:value-of select="translate(substring($banknumberSpacesRemoved,0, $length - 4), '0123456789', '**********')" />
				<xsl:value-of select="substring($banknumberSpacesRemoved,$length - 3, 4)"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="translate($banknumberSpacesRemoved, '0123456789', '**********')" />
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="mask_creditcard">
		<xsl:param name="creditcard" />
		<xsl:variable name="creditcardNormalizeSpace" select="normalize-space($creditcard)" />
		<xsl:variable name="length" select="string-length($creditcardNormalizeSpace)"/>
		<xsl:value-of select="substring($creditcardNormalizeSpace,0, 5)"/>
		<xsl:value-of select="translate(substring($creditcardNormalizeSpace,4, $length - 8), '0123456789', '**********')" />
		<xsl:value-of select="substring($creditcardNormalizeSpace,$length - 3, 4)"/>
	</xsl:template>

	<xsl:template name="format_date">
		<xsl:param name="eurDate"/>

		<xsl:variable name="day" 		select="substring-before($eurDate,'/')" />
		<xsl:variable name="month-temp" select="substring-after($eurDate,'/')" />
		<xsl:variable name="month" 		select="substring-before($month-temp,'/')" />
		<xsl:variable name="year" 		select="substring-after($month-temp,'/')" />

		<xsl:value-of select="$year" />-<xsl:value-of select="format-number($month,'00')" />-<xsl:value-of select="format-number($day,'00')" />
	</xsl:template>
	<xsl:template name="subtract_1_day">
		<xsl:param name="isoDate"/>

		<!-- Oh date fields - how I hate you that you make me write such hackery -->
		<xsl:variable name="year" 		select="substring-before($isoDate,'-')" />
		<xsl:variable name="monthTemp" select="substring-after($isoDate,'-')" />
		<xsl:variable name="month" 		select="substring-before($monthTemp,'-')" />
		<xsl:variable name="day" 		select="substring-after($monthTemp,'-')" />

		<xsl:variable name="days31">01 03 05 07 08 10 12</xsl:variable>
		<xsl:variable name="days30">04 06 09 11</xsl:variable>

		<xsl:variable name="prevYear" select="format-number(number($year)-1,'00')" />
		<xsl:variable name="prevMonth" select="format-number(number($month)-1,'00')" />
		<xsl:variable name="prevDay" select="format-number(number($day)-1,'00')" />

		<xsl:choose>
			<!-- 1st of the year -->
			<xsl:when test="$day='01' and $month='01'">
				<xsl:value-of select="concat($prevYear,'-12-31')" />
			</xsl:when>
			<!-- 1st of the month (prev month has 31 days) -->
			<xsl:when test="$day='01' and contains($days31,$prevMonth)">
				<xsl:value-of select="concat($year,'-',$prevMonth,'-31')" />
			</xsl:when>
			<!-- 1st of the month (prev month has 30 days) -->
			<xsl:when test="$day='01' and contains($days30,$prevMonth)">
				<xsl:value-of select="concat($year,'-',$prevMonth,'-30')" />
			</xsl:when>
			<!-- 1st of the month (prev month is february and a leap year) -->
			<xsl:when test="$day='01' and $prevMonth='02' and number($year) mod 4=0">
				<xsl:value-of select="concat($year,'-',$prevMonth,'-29')" />
			</xsl:when>
			<!-- 1st of the month (prev month is february and not a leap year) -->
			<xsl:when test="$day='01' and $prevMonth='02'">
				<xsl:value-of select="concat($year,'-',$prevMonth,'-28')" />
			</xsl:when>
			<!-- Any other day -->
			<xsl:otherwise>
				<xsl:value-of select="concat($year,'-',$month,'-',$prevDay)" />
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="streetNameLower">
		<xsl:param name="address"/>
		<xsl:choose>
			<xsl:when test="$address/fullAddressLineOne !=''">
				<xsl:value-of select="$address/fullAddressLineOne" />
			</xsl:when>
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
	</xsl:template>

	<xsl:template name="postal_streetNameLower">
		<xsl:param name="postalAddress"/>
		<xsl:choose>
			<xsl:when test="$postalAddress/fullAddressLineOne !=''">
				<xsl:value-of select="$postalAddress/fullAddressLineOne" />
			</xsl:when>
			<!-- Smart capture unit and street number -->
			<xsl:when test="$postalAddress/unitSel != '' and $postalAddress/houseNoSel != ''">
				<xsl:value-of select="concat($postalAddress/unitSel, ' / ', $postalAddress/houseNoSel, ' ', $postalAddress/streetName)" />
			</xsl:when>
			<!-- Manual capture unit, Smart capture street number -->
			<xsl:when test="$postalAddress/unitShop != '' and $postalAddress/houseNoSel != ''">
				<xsl:value-of select="concat($postalAddress/unitShop, ' / ', $postalAddress/houseNoSel, ' ', $postalAddress/streetName)" />
			</xsl:when>
			<!-- Manual capture unit and street number -->
			<xsl:when test="$postalAddress/unitShop != '' and $postalAddress/streetNum != ''">
				<xsl:value-of select="concat($postalAddress/unitShop, ' / ', $postalAddress/streetNum, ' ', $postalAddress/streetName)" />
			</xsl:when>
			<!-- Smart capture street number (only, no unit) -->
			<xsl:when test="$postalAddress/houseNoSel != ''">
				<xsl:value-of select="concat($postalAddress/houseNoSel, ' ', $postalAddress/streetName)" />
			</xsl:when>
			<!-- Manual capture street number (only, no unit) -->
			<xsl:otherwise>
				<xsl:value-of select="concat($postalAddress/streetNum, ' ', $postalAddress/streetName)" />
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="string-replace-all">
	<xsl:param name="text" />
	<xsl:param name="replace" />
	<xsl:param name="by" />
	<xsl:choose>
		<xsl:when test="contains($text, $replace)">
		  <xsl:value-of select="substring-before($text,$replace)" />
		  <xsl:value-of select="$by" />
		  <xsl:call-template name="string-replace-all">
			<xsl:with-param name="text"
			select="substring-after($text,$replace)" />
			<xsl:with-param name="replace" select="$replace" />
			<xsl:with-param name="by" select="$by" />
		  </xsl:call-template>
		</xsl:when>
		<xsl:otherwise>
		  <xsl:value-of select="$text" />
		</xsl:otherwise>
	</xsl:choose>
	</xsl:template>
</xsl:stylesheet>