<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
	xmlns:xs="http://www.w3.org/2001/XMLSchema"
	xmlns:i_f="http://internalXslt/function"
	exclude-result-prefixes="xd xs i_f" version="3.0">
	<xd:doc scope="stylesheet/libXsl">
		<xd:desc>
			<xd:p>
				<xd:b>Application:</xd:b>
				Pise
			</xd:p>
			<xd:p>
				<xd:b>Aim:</xd:b>
				debug functions or templates
			</xd:p>
			<xd:p>
				<xd:b>Last update:</xd:b>
				201811 V.O.
			</xd:p>
			<xd:p>
				<xd:b>Preview update:</xd:b>
				see SCM comments
			</xd:p>
			<xd:p>
				<xd:b>Origin:</xd:b>
				lib_temp_com.xsl
			</xd:p>
		</xd:desc>
	</xd:doc>



	<xsl:template name="formatbnum">
		<xsl:param name="bnum" />
		<xsl:param name="higlighted" />
		<xsl:choose>
			<xsl:when test="$higlighted='yes'">
				<xsl:value-of select="'['" />
				<span class="cHit" id="hitmimosa_{generate-id()}">
					<xsl:value-of
						select="concat(substring($bnum,1,4), '-',substring($bnum,5))" />
				</span>
				<xsl:text>]</xsl:text>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of
					select="concat('[',substring($bnum,1,4), '-',substring($bnum,5),']')" />
			</xsl:otherwise>

		</xsl:choose>

	</xsl:template>

</xsl:stylesheet>
