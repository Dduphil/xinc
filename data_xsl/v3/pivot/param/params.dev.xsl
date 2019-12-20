<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl" xmlns:fo="http://www.w3.org/1999/XSL/Format" exclude-result-prefixes="xs xd" version="3.0">
    <xd:doc scope="stylesheet">
        <xd:desc>
            <xd:p>parameters for developpment</xd:p>
            <xd:p>extraction of global paramter and variables</xd:p>
            <xd:p><xd:b>params</xd:b> already define in '../../commons/param/params.xsl'</xd:p>
            <xd:p><xd:b>vars</xd:b> already define in '../../commons/param/vars.xsl'</xd:p>
        </xd:desc>
    </xd:doc>

<!-- ======== parameters ====== -->
    <xsl:param name="vDbgXslt"/>
    <xsl:param name="pLang">fr</xsl:param>
    <xsl:param name="pOutputFormat"/>


<!-- ======== variables ====== -->
    <xsl:param name="vLang">fr</xsl:param>
    <xsl:variable name="vCurrentLang" select="upper-case($vLang)"/>

    <xsl:variable name="vListAsTable4Rtf">
        <xsl:choose>
            <xsl:when test="'RTF' = $pOutputFormat">table</xsl:when>
            <xsl:otherwise>list</xsl:otherwise>
        </xsl:choose>
    </xsl:variable>

</xsl:stylesheet>
