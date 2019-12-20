<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:i_f="http://internalXslt/function" 
  xmlns:emf="http://org.epo.mimosaserver.core.saxonextfct.ResourceBundleContainsKeyExtFct"
  xmlns:emg="http://org.epo.mimosaserver.core.saxonextfct.ResourceBundleGetStringExtFct"
exclude-result-prefixes="xd xs i_f emf emg" version="3.0">
    <xd:doc scope="stylesheet/libXsl">
        <xd:desc>
            <xd:p><xd:b>Application:</xd:b>Pise</xd:p>
            <xd:p><xd:b>Aim:</xd:b> labels management use ressouceBundel</xd:p>
            <xd:p><xd:b>Last update:</xd:b> 201811 V.O. </xd:p>
            <xd:p><xd:b>Preview update:</xd:b> see SCM comments</xd:p>
            <xd:p><xd:b>Origin:</xd:b>../v2_com_wp-html5.xsl</xd:p>

        </xd:desc>
    </xd:doc>
  
    
    <!-- ==== include ou param (dans la XSL appelante) ====  -/->
  <use#x.l:include href="v2_com_param.xsl"/>
  <!-/- -->
    
    
    <xsl:template name="get-label">
      <xsl:param name="id"/>
      <xsl:choose>
        <xsl:when test="boolean($pUseResourceBundle) and emf:containsKey($pResourceBundle, concat('xsl.field.',$id))">
          <xsl:value-of select="emg:getString($pResourceBundle, concat('xsl.field.',$id))"/>
        </xsl:when>
        <xsl:when test="boolean($pUseResourceBundle) and emf:containsKey($pResourceBundle, concat('field.',$id))">
          <xsl:value-of select="emg:getString($pResourceBundle, concat('field.',$id))"/>
        </xsl:when>
        <xsl:when test="boolean($pUseResourceBundle) and emf:containsKey($pResourceBundle, concat('index.',$id))">
          <xsl:value-of select="emg:getString($pResourceBundle, concat('index.',$id))"/>
        </xsl:when>
        
        <xsl:otherwise>
          <xsl:value-of select="$id"/>
        </xsl:otherwise>
      </xsl:choose> 
    </xsl:template>   
    
    <!-- ==== lib_temp_html5 old  ==== env[vLang ] tpl[get-label]-->
    <!-- """""""""""""SR""""""""""""""" -->
    <xsl:template name="tpl-Label-sr">
      <xsl:param name="vFieldName"/>
      <xsl:variable name="vField" select="name()"/>
      <xsl:variable name="fieldName">
        <xsl:choose>
          <xsl:when test="string-length($vFieldName)!=0"><xsl:value-of select="$vFieldName"/></xsl:when>
          <xsl:otherwise><xsl:value-of select="$vField"/></xsl:otherwise>
        </xsl:choose>
      </xsl:variable>
      <xsl:variable name="vLabel">
        <xsl:call-template name="get-label">
          <xsl:with-param name="id" select="$fieldName"/>
        </xsl:call-template>
      </xsl:variable>
      <span class="sr_label"><xsl:attribute name="lang"><xsl:value-of select="$vLang"/></xsl:attribute><xsl:value-of select="$vLabel"/><xsl:text>: </xsl:text></span>
    </xsl:template>
    

<xd:doc scope="template" id="tpl-LabelTxt">
  <xd:desc>return label(vFildName or local-name())</xd:desc>
</xd:doc>
  <xsl:template name="tpl-LabelTxt">
      <xsl:param name="vFieldName"/>
    <xsl:variable name="vField" select="local-name()"/>
      <xsl:variable name="fieldName">
        <xsl:choose>
          <xsl:when test="string-length($vFieldName)!=0"><xsl:value-of select="$vFieldName"/></xsl:when>
          <xsl:otherwise><xsl:value-of select="$vField"/></xsl:otherwise>
        </xsl:choose>
      </xsl:variable>
      <xsl:variable name="vLabel">
        <xsl:call-template name="get-label">
          <xsl:with-param name="id" select="$fieldName"/>
        </xsl:call-template>
      </xsl:variable>
    <xsl:value-of select="$vLabel"/>
  </xsl:template>
  

<xd:doc scope="template" id="tpl-Label">
  <xd:desc>return 'h1'</xd:desc>
</xd:doc>
  <xsl:template name="tpl-Label">
    <xsl:param name="vFieldName"/>
    <h1 class="skiptranslate" lang="{$vLang}">
      <xsl:text><!-- NoSpaceInBetween --></xsl:text>
      <xsl:call-template name="tpl-LabelTxt">
        <xsl:with-param name="vFieldName" select="$vFieldName"/>
      </xsl:call-template>
    </h1>
    </xsl:template>
    
    <xsl:template name="tpl-loading">
      <xsl:param name="script"/>
      <img src="{$script}" />
    </xsl:template>
    
    

      
</xsl:stylesheet>
