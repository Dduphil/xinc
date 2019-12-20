<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:i_f="http://internalXslt/function"
  xmlns:emq="http://org.epo.mimosaserver.core.saxonextfct.URLToolGetTypUrlRegisterLinkExtFct"
  xmlns:emp="http://org.epo.mimosaserver.core.saxonextfct.URLToolGetTypUrlPubServerExtFct"
  xmlns:ems="http://org.epo.mimosaserver.core.saxonextfct.URLToolGetTypUrlPattentscopePublicationExtFct"
  exclude-result-prefixes="xd xs i_f" version="3.0">

  <!-- [java namespace N/A]  xmlns:j.va="http://xml.apache.org/xslt/java"  -->

  <xd:doc scope="stylesheet/libXsl">
    <xd:desc>
      <xd:p><xd:b>Application:</xd:b>Pise</xd:p>
      <xd:p><xd:b>Aim:</xd:b> URL management </xd:p>
      <xd:p><xd:b>XSLT engine:</xd:b> saxon PE</xd:p>
      <xd:p><xd:b>Last update:</xd:b> 201811 V.O. </xd:p>
      <xd:p><xd:b>Preview update:</xd:b> see SCM comments</xd:p>
      <xd:p><xd:b>Origin:</xd:b> 'xja-*' template extracted from ../v2_anchor-com.xsl</xd:p>
      <xd:p>TEMPLATE PREFIXE : 'xja-TypUrl' // Xalan Or Xternal Java methode encapsulated by 'tpl-TypUrl', parameters name's see org.epo.pise.url.Args</xd:p>
    </xd:desc>
  </xd:doc>


  <!-- [OLD]
  <x.l:template name="xja-TypUrlRegister">
    <x.l:param name="uiLang"/>
    <x.l:param name="linkFormat"/>
    <x.l:param name="country"/>
    <x.l:param name="appNum"/>
    <x.l:param name="appDate"/>
    <x.l:param name="kind"/>
    <x.l:param name="pubCountry"/>
    <x.l:param name="pubNum"/>
    <x.l:param name="pubDate"/>
    <x.l:param name="docPart"/>

    <x.l:variable name="res">
      <x.l:value-of select="j.va:org.epo.pise.configuration.url.UrlTool.getTypUrlRegister($uiLang, $linkFormat, $country, $appNum, $appDate, $kind, $pubCountry, $pubNum, $pubDate, $docPart)"/>
    </x.l:variable>

    <x.l:choose>
      <x.l:when test="$ac_debug = '1'">
        <x.l:value-of
          select="concat( $res, '&amp;debug=fn(uiLang:', $uiLang, ' linkFormat:', $linkFormat, ' country:', $country, ' appNum:', $appNum, ' appDate:', $appDate, ' kind:', $kind, ' pubCountry:', $pubCountry, ' pubNum:', $pubNum, ' pubDate:', $pubDate, ' docPart:', $docPart, ')')"
        />
      </x.l:when>
      <x.l:when test="'' = $res">
        <x.l:text>_</x.l:text>
      </x.l:when>
      <x.l:otherwise>
        <x.l:value-of select="$res"/>
      </x.l:otherwise>
    </x.l:choose>
  </x.l:template>
-->

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

    <xsl:variable name="res">
      <xsl:choose>
        <xsl:when test="contains($vDbgXslt, ' _d_NoJavaExt ')">
          <xsl:text>dbgURL!http//debug/url</xsl:text>
        </xsl:when>
        <xsl:otherwise>
          <!-- copy existing code -->
          <xsl:value-of select="emq:getTypUrlRegisterLink($uiLang, $linkFormat, $country, $appNum, $appDate, $kind, $pubCountry, $pubNum, $pubDate, $docPart)"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:choose>
      <xsl:when test="$ac_debug = '1'">
        <xsl:value-of
          select="concat( $res, '&amp;debug=fn(uiLang:', $uiLang, ' linkFormat:', $linkFormat, ' country:', $country, ' appNum:', $appNum, ' appDate:', $appDate, ' kind:', $kind, ' pubCountry:', $pubCountry, ' pubNum:', $pubNum, ' pubDate:', $pubDate, ' docPart:', $docPart, ')')"
        />
      </xsl:when>
      <xsl:when test="'' = $res">
        <xsl:text>_</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$res"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>


  <xsl:template name="xja-TypUrlPatentscopePublication">
    <xsl:param name="uiLang"/>
    <xsl:param name="linkFormat"/>
    <xsl:param name="pubCountry"/>
    <xsl:param name="pubNum"/>
    <xsl:param name="pubDate"/>
    <xsl:param name="docPart"/>


    <xsl:variable name="res">
      <xsl:choose>
        <xsl:when test="contains($vDbgXslt, ' _d_NoJavaExt ')">
          <xsl:text>dbgURL!http//debug/url</xsl:text>
        </xsl:when>
        <xsl:otherwise>
          <!-- copy existing code -->
          <xsl:value-of select="ems:getTypUrlPatentscopePublication($uiLang, $linkFormat, $pubCountry, $pubNum, $pubDate, $docPart)"/>
        </xsl:otherwise>
      </xsl:choose>

    </xsl:variable>

    <xsl:choose>
      <xsl:when test="$ac_debug = '1'">
        <xsl:value-of select="concat( $res, '&amp;debug=fn(uiLang:', $uiLang, ' linkFormat:', $linkFormat, ' pubCountry:', $pubCountry, ' pubNum:', $pubNum, ' pubDate:', $pubDate, ' docPart:', $docPart, ')')"/>
      </xsl:when>
      <xsl:when test="'' = $res">
        <xsl:text>_</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$res"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>


  <xsl:template name="xja-TypUrlPubServer">
    <xsl:param name="uiLang"/>
    <xsl:param name="linkFormat"/>
    <xsl:param name="kind"/>
    <xsl:param name="pubCountry"/>
    <xsl:param name="pubNum"/>
    <xsl:param name="pubDate"/>
    <xsl:param name="docPart"/>


    <xsl:variable name="res">
      <xsl:choose>
        <xsl:when test="contains($vDbgXslt, ' _d_NoJavaExt ')">
          <xsl:text>dbgURL!http//debug/url</xsl:text>
        </xsl:when>
        <xsl:otherwise>
          <!-- copy existing code -->
          <xsl:value-of select="emp:getTypUrlPubServer($uiLang, $linkFormat, $kind, $pubCountry, $pubNum, $pubDate, $docPart)"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:choose>
      <xsl:when test="$ac_debug = '1'">
        <xsl:value-of select="concat( $res, '&amp;debug=fn(uiLang:', $uiLang, ' linkFormat:', $linkFormat, ' kind:', $kind, ' pubCountry:', $pubCountry, ' pubNum:', $pubNum, ' pubDate:', $pubDate, ' docPart:', $docPart, ')')"/>
      </xsl:when>
      <xsl:when test="'' = $res">
        <xsl:text>_</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$res"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>


  <xsl:template name="xja-TypUrlEspacenet">
    <xsl:param name="uiLang"/>
    <xsl:param name="linkFormat"/>
    <xsl:param name="kind"/>
    <xsl:param name="pubCountry"/>
    <xsl:param name="pubNum"/>
    <xsl:param name="pubDate"/>
    <xsl:param name="docPart"/>

<!-- [//TODO ]
    <x.l:variable name="res">
      <x.l:value-of select="concat('UrlEspacenet!http://NotYetImplemented/getTypUrlEspacenet/', $uiLang, $linkFormat, $kind, $pubCountry, $pubNum, $pubDate, $docPart)"/>
      <x.l:value-of select="j.va:org.epo.pise.configuration.url.UrlTool.getTypUrlEspacenet($uiLang, $linkFormat, $kind, $pubCountry, $pubNum, $pubDate, $docPart)"/>
</x.l:variable>

    <x.l:choose>
      <x.l:when test="$ac_debug = '1'">
        <x.l:value-of select="concat( $res, '&amp;debug=fn(uiLang:', $uiLang, ' linkFormat:', $linkFormat, ' kind:', $kind, ' pubCountry:', $pubCountry, ' pubNum:', $pubNum, ' pubDate:', $pubDate, ' docPart:', $docPart, ')')"/>
      </x.l:when>
      <x.l:when test="'' = $res">
        <x.l:text>_</x.l:text>
      </x.l:when>
      <x.l:otherwise>
        <x.l:value-of select="$res"/>
      </x.l:otherwise>
    </x.l:choose>
-->    
    
    <!-- // TODO Not Yet Implemented -->
    <xsl:value-of select="concat('UrlEspacenet!http://NotYetImplemented/getTypUrlEspacenet/', $uiLang,'/', $linkFormat,'/',  $kind,'/',  $pubCountry,'/',  $pubNum,'/',  $pubDate,'/',  $docPart)"/>
    
  </xsl:template>
</xsl:stylesheet>
