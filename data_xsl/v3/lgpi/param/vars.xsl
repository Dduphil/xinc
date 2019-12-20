<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"  xmlns:exch="http://www.epo.org/exchange" exclude-result-prefixes="xs xd exch" version="3.0">
    <xd:doc scope="stylesheet">
        <xd:desc>
            <xd:p>collection variables</xd:p>
            <xd:p>To complete with collection or 'data input' specific variables</xd:p>
        </xd:desc>
    </xd:doc>
    
    
    <!-- ==== Autres Variables ====  -->
    <xsl:variable name="vRefCtry"
        select="//document[@type='notice']//exch:bibliographic-data/exch:publication-reference[1]/document-id//country"/>
    <xsl:variable name="vRefDocNum"
        select="//document[@type='notice']//exch:bibliographic-data/exch:publication-reference[1]/document-id//doc-number"/>
    <xsl:variable name="vRefKind"
        select="//document[@type='notice']//exch:bibliographic-data/exch:publication-reference[1]/document-id//kind"/>
    <xsl:variable name="vRefDate"
        select="//document[@type='notice']//exch:bibliographic-data/exch:publication-reference[1]/document-id//date"/>
    
    <xsl:variable name="vPubFormat">
        <xsl:choose>
            <xsl:when test="//document[@type='notice']//exch:bibliographic-data/exch:publication-reference[@data-format='docdb']">docdb</xsl:when>
            <xsl:when test="//document[@type='notice']//exch:bibliographic-data/exch:publication-reference[@data-format='docdba']">docdba</xsl:when>
            <xsl:when test="//document[@type='notice']//exch:bibliographic-data/exch:publication-reference[@data-format='epodoc']">epodoc</xsl:when>
            <xsl:when test="//document[@type='notice']//exch:bibliographic-data/exch:publication-reference[@data-format='original']">original</xsl:when>
            <xsl:otherwise>none</xsl:otherwise>
        </xsl:choose>
    </xsl:variable>
    
    <xsl:variable name="vTitleFormat">
        <xsl:choose>
            <xsl:when test="//document[@type='notice']//exch:bibliographic-data/exch:invention-title[@data-format='docdb']">docdb</xsl:when>
            <xsl:when test="//document[@type='notice']//exch:bibliographic-data/exch:invention-title[@data-format='docdba']">docdba</xsl:when>
            <xsl:when test="//document[@type='notice']//exch:bibliographic-data/exch:invention-title[@data-format='epodoc']">epodoc</xsl:when>
            <xsl:when test="//document[@type='notice']//exch:bibliographic-data/exch:invention-title[@data-format='original']">original</xsl:when>
            <xsl:otherwise>none</xsl:otherwise>
        </xsl:choose>
    </xsl:variable>
    
    <xsl:variable name="vtitleLang">
        <xsl:choose>
            <xsl:when test="//document[@type='notice']//exch:bibliographic-data/exch:invention-title[@lang='en' and @data-format=$vTitleFormat]">en</xsl:when>
            <xsl:when test="//document[@type='notice']//exch:bibliographic-data/exch:invention-title[@lang='de' and @data-format=$vTitleFormat]">de</xsl:when>
            <xsl:when test="//document[@type='notice']//exch:bibliographic-data/exch:invention-title[@lang='fr' and @data-format=$vTitleFormat]">fr</xsl:when>
            <!-- Use national office language -->
            <xsl:when test="//document[@type='notice']//exch:bibliographic-data/exch:invention-title[@data-format=$vTitleFormat]"><xsl:value-of select="//document[@type='notice']//exch:bibliographic-data/exch:invention-title/@lang"/></xsl:when>
        </xsl:choose>
    </xsl:variable>
    
    
</xsl:stylesheet>
