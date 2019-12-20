<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"  xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl" exclude-result-prefixes="#all" version="3.0">
  <xd:doc scope="stylesheet/MOCK">
    <xd:desc>
      <xd:p><xd:b>Application:</xd:b>Pise</xd:p>
      <xd:p><xd:b>Aim:</xd:b> Mock (or local) for URL management </xd:p>
      <xd:p><xd:b>XSLT engine:</xd:b> saxon PE</xd:p>
      <xd:p><xd:b>Last update:</xd:b> 201811 V.O. </xd:p>
      <xd:p><xd:b>Preview update:</xd:b> see SCM comments</xd:p>
      <xd:p><xd:b>Origin:</xd:b> 'xja-*' template extracted from ../v2_anchor-com.xsl</xd:p>
      <xd:p>TEMPLATE PREFIXE : 'xja-TypUrl' // Xalan Or Xternal Java methode encapsulated by 'tpl-TypUrl', parameters name's see org.epo.pise.url.Args</xd:p>
    </xd:desc>
  </xd:doc>

  <xsl:template name="xja-TypUrlRegister">
    <xsl:param name="uiLang"/>
    <xsl:param name="linkFormat"/>
    <xsl:param name="country"/>
    <xsl:param name="appNum"/>
    <xsl:param name="appDate"/>
    <xsl:param name="kind"/>
    <xsl:param name="pubCountry"/>
    <xsl:param name="pubNum"/>
    <xsl:param name="pubDate"/>
    <xsl:param name="docPart"/>

    <xsl:text>dbgURL!http//debug/url</xsl:text>
  </xsl:template>


  <xsl:template name="xja-TypUrlRegisterLink">
    <xsl:param name="uiLang"/>
    <xsl:param name="linkFormat"/>
    <xsl:param name="country"/>
    <xsl:param name="appNum"/>
    <xsl:param name="appDate"/>
    <xsl:param name="kind"/>
    <xsl:param name="pubCountry"/>
    <xsl:param name="pubNum"/>
    <xsl:param name="pubDate"/>
    <xsl:param name="docPart"/>

    <xsl:text>dbgURL!http//debug/url</xsl:text>
  </xsl:template>


  <xsl:template name="xja-TypUrlPatentscopePublication">
    <xsl:param name="uiLang"/>
    <xsl:param name="linkFormat"/>
    <xsl:param name="pubCountry"/>
    <xsl:param name="pubNum"/>
    <xsl:param name="pubDate"/>
    <xsl:param name="docPart"/>


    <xsl:text>dbgURL!http//debug/url</xsl:text>
  </xsl:template>


  <xsl:template name="xja-TypUrlPubServer">
    <xsl:param name="uiLang"/>
    <xsl:param name="linkFormat"/>
    <xsl:param name="kind"/>
    <xsl:param name="pubCountry"/>
    <xsl:param name="pubNum"/>
    <xsl:param name="pubDate"/>
    <xsl:param name="docPart"/>


    <xsl:text>dbgURL!http//debug/url</xsl:text>
  </xsl:template>


  <xsl:template name="xja-TypUrlEspacenet">
    <xsl:param name="uiLang"/>
    <xsl:param name="linkFormat"/>
    <xsl:param name="kind"/>
    <xsl:param name="pubCountry"/>
    <xsl:param name="pubNum"/>
    <xsl:param name="pubDate"/>
    <xsl:param name="docPart"/>

    <xsl:text>dbgURL!http//debug/url</xsl:text>
  </xsl:template>


</xsl:stylesheet>
