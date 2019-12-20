<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl" exclude-result-prefixes="xd" version="3.0">
    <xd:doc scope="stylesheet">
        <xd:desc>
            <xd:p>Commons variables</xd:p>
        </xd:desc>
    </xd:doc>

    <xd:doc scope="variable" id="vLang">
        <xd:desc>
            <xd:p>Latin language ('ja' to 'en')</xd:p>
        </xd:desc>
    </xd:doc>
    <xsl:variable name="vLang">
        <xsl:choose>
            <xsl:when test=" $pLang = 'de' or  $pLang = 'es' or $pLang = 'fr'">
                <xsl:value-of select="$pLang"/>
            </xsl:when>
            <xsl:otherwise>en</xsl:otherwise>
        </xsl:choose>
    </xsl:variable>
    

    <xd:doc scope="variable" id="vCurrentLang">
        <xd:desc>
            <xd:p>upper case latin language</xd:p>
        </xd:desc>
    </xd:doc>
    <xsl:variable name="vCurrentLang" select="upper-case($vLang)"/>


    <xd:doc scope="variable/pdf" id="vListAsTable4RtfLang">
        <xd:desc>
            <xd:p>For RTF list numbering, convert-it to 'table'</xd:p>
        </xd:desc>
    </xd:doc>
    <xsl:variable name="vListAsTable4Rtf">
        <xsl:choose>
            <xsl:when test="'RTF' = $pOutputFormat">table</xsl:when>
            <xsl:otherwise>list</xsl:otherwise>
        </xsl:choose>
    </xsl:variable>
        
</xsl:stylesheet>
