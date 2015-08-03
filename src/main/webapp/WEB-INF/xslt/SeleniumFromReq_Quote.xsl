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
		<tr>
			<td>open</td>
			<td>/ctm/health_quote.jsp</td>
			<td></td>
		</tr>
		<tr>
			<td>select</td>
			<td>id=health_situation_healthCvr</td>
			<td>value=<xsl:value-of select="situation/healthCvr" /></td>
		</tr>
		<tr>
			<td>select</td>
			<td>id=health_situation_state</td>
			<td>value=<xsl:value-of select="situation/state" /></td>
		</tr>
		<tr>
			<td>select</td>
			<td>id=health_situation_healthSitu</td>
			<td>value=<xsl:value-of select="situation/healthSitu" /></td>
		</tr>
		<tr>
			<td>click</td>
			<td>css=#next-step &gt; span</td>
			<td></td>
		</tr>
		<tr>
			<td>type</td>
			<td>id=health_contactDetails_firstName</td>
			<td><xsl:value-of select="contactDetails/firstName" /></td>
		</tr>
		<tr>
			<td>type</td>
			<td>id=health_contactDetails_lastname</td>
			<td><xsl:value-of select="contactDetails/lastname" /></td>
		</tr>
		<tr>
			<td>type</td>
			<td>id=health_contactDetails_email</td>
			<td><xsl:value-of select="contactDetails/email" /></td>
		</tr>
		<tr>
			<td>type</td>
			<td>id=health_contactDetails_contactNumber</td>
			<td><xsl:value-of select="contactDetails/contactNumber" /></td>
		</tr>
		<tr>
			<td>click</td>
			<xsl:choose>
			<xsl:when test="contactDetails/call='N'">
				<td>id=health_contactDetails_call_N</td>
			</xsl:when>
			<xsl:otherwise>
				<td>id=health_contactDetails_call_Y</td>
			</xsl:otherwise>
			</xsl:choose>
			<td></td>
		</tr>
		<tr>
			<td>type</td>
			<td>id=health_healthCover_primary_dob</td>
			<td><xsl:value-of select="healthCover/primary/dob" /></td>
		</tr>

		<tr>
			<td>click</td>
			<xsl:choose>
			<xsl:when test="healthCover/primary/cover='N'">
				<td>id=health_healthCover_primary_cover_N</td>
			</xsl:when>
			<xsl:otherwise>
				<td>id=health_healthCover_primary_cover_Y</td>
			</xsl:otherwise>
			</xsl:choose>
			<td></td>
		</tr>
		<tr>
			<td>click</td>
			<xsl:choose>
			<xsl:when test="healthCover/primary/healthCoverLoading='N'">
				<td>id=health_healthCover_primary_healthCoverLoading_N</td>
			</xsl:when>
			<xsl:otherwise>
				<td>id=health_healthCover_primary_healthCoverLoading_Y</td>
			</xsl:otherwise>
			</xsl:choose>
			<td></td>
		</tr>
		
		<xsl:if test="situation/healthCvr = 'C' or situation/healthCvr = 'F'">
		<tr>
			<td>type</td>
			<td>id=health_healthCover_partner_dob</td>
			<td><xsl:value-of select="healthCover/partner/dob" /></td>
		</tr>
		<tr>
			<td>click</td>
			<xsl:choose>
			<xsl:when test="healthCover/partner/cover='N'">
				<td>id=health_healthCover_partner_cover_N</td>
			</xsl:when>
			<xsl:otherwise>
				<td>id=health_healthCover_partner_cover_Y</td>
			</xsl:otherwise>
			</xsl:choose>
			<td></td>
		</tr>				
		<tr>
			<td>click</td>
			<xsl:choose>
			<xsl:when test="healthCover/partner/healthCoverLoading='N'">
				<td>id=health_healthCover_partner_healthCoverLoading_N</td>
			</xsl:when>
			<xsl:otherwise>
				<td>id=health_healthCover_partner_healthCoverLoading_Y</td>
			</xsl:otherwise>
			</xsl:choose>
			<td></td>
		</tr>
		</xsl:if>
		<tr>
			<td>click</td>
			<xsl:choose>
			<xsl:when test="healthCover/rebate='N'">
				<td>id=health_healthCover_rebate_N</td>
			</xsl:when>
			<xsl:otherwise>
				<td>id=health_healthCover_rebate_Y</td>
			</xsl:otherwise>
			</xsl:choose>
			<td></td>
		</tr>
		<xsl:if test="healthCover/dependants != ''">				
		<tr>
			<td>select</td>
			<td>id=health_healthCover_dependants</td>
			<td>label=<xsl:value-of select="healthCover/dependants" /></td>
		</tr>
		</xsl:if>
		<tr>
			<td>select</td>
			<td>id=health_healthCover_income</td>
			<td>value=<xsl:value-of select="healthCover/income" /></td>
		</tr>
		<tr>
			<td>click</td>
			<td>css=span.ui-button-text</td>
			<td></td>
		</tr>		
		<tr>
			<td>click</td>
			<xsl:choose>
			<xsl:when test="healthCover/contactDetails/call='N'">
				<td>id=health_contactDetails_call_N</td>
			</xsl:when>
			<xsl:otherwise>
				<td>id=health_contactDetails_call_Y</td>
			</xsl:otherwise>
			</xsl:choose>			
			<td></td>
		</tr>
		<tr>
			<td>click</td>
			<td>css=#next-step &gt; span</td>
			<td></td>
		</tr>
		</tbody></table>
		</body>
		</html>
	</xsl:template>
</xsl:stylesheet>