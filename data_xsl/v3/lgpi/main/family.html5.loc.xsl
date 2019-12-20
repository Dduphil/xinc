<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
    
 xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
 xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
 xmlns:xs="http://www.w3.org/2001/XMLSchema"

 xmlns:exch="http://www.epo.org/exchange"
 xmlns:ops="http://ops.epo.org"

xmlns:i_f="http://internalXslt/function"

 xmlns:emf="http://org.epo.mimosaserver.core.saxonextfct.ResourceBundleContainsKeyExtFct"
 xmlns:emg="http://org.epo.mimosaserver.core.saxonextfct.ResourceBundleGetStringExtFct"
 xmlns:emp="http://org.epo.mimosaserver.core.saxonextfct.URLToolGetTypUrlPubServerExtFct"
 xmlns:emq="http://org.epo.mimosaserver.core.saxonextfct.URLToolGetTypUrlRegisterLinkExtFct"
 xmlns:ems="http://org.epo.mimosaserver.core.saxonextfct.URLToolGetTypUrlPattentscopePublicationExtFct"
 
 exclude-result-prefixes="xd xs exch ops i_f emf emg emp emq ems"
    
    version="3.0">
<!-- [namespace-min]
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl" exclude-result-prefixes="xd"
-->

<!-- [namespace-all]
 xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
 xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
 xmlns:xs="http://www.w3.org/2001/XMLSchema"

 xmlns:exch="http://www.epo.org/exchange"
 xmlns:ops="http://ops.epo.org"
 
 xmlns:i_f="http://internalXslt/function"

 xmlns:emf="http://org.epo.mimosaserver.core.saxonextfct.ResourceBundleContainsKeyExtFct"
 xmlns:emg="http://org.epo.mimosaserver.core.saxonextfct.ResourceBundleGetStringExtFct"
 xmlns:emp="http://org.epo.mimosaserver.core.saxonextfct.URLToolGetTypUrlPubServerExtFct"
 xmlns:emq="http://org.epo.mimosaserver.core.saxonextfct.URLToolGetTypUrlRegisterLinkExtFct"
 xmlns:ems="http://org.epo.mimosaserver.core.saxonextfct.URLToolGetTypUrlPattentscopePublicationExtFct"
 
 exclude-result-prefixes="xd xs exch ops i_f emf emg emp emq ems"
    -->

    <xd:doc scope="stylesheet/lgpi">
        <xd:desc>
            <xd:p><xd:b>Application:</xd:b>Pise</xd:p>
            <xd:p><xd:b>Aim:</xd:b> LGPI OPS family</xd:p>
            <xd:p>Return sub part for 'family' (dynamic call)</xd:p>
            <xd:p><xd:b>Last update:</xd:b> 201812</xd:p>
            <xd:p><xd:b>History:</xd:b> see SCM comments</xd:p>
            <xd:p><xd:b>Origin:</xd:b>{collections}/lgpi/family.html.html5-embedded.xsl</xd:p>
        </xd:desc>
    </xd:doc>

    <xsl:output indent="no" encoding="UTF-8" method="xml" omit-xml-declaration="yes"/>

    <!-- ==== Gestion des espaces ==== -->
    <xsl:strip-space elements="date"/>
    <xsl:preserve-space elements="text str snm"/>
    
    
    <!-- ==== number format ==== -->
    <xsl:decimal-format name="de" decimal-separator=","
        grouping-separator="." />
    <xsl:decimal-format name="fr" decimal-separator=","
        grouping-separator=" " />
    <xsl:decimal-format name="en" decimal-separator="."
        grouping-separator="," />

    <!-- ==== all include ==== -->
    <!--old
    <x.l:include href="../commons/v2_com_txt.xsl"/>
    <x.l:include href="lib_temp_html5.xsl"/>
    <x.l:include href="../commons/v2_anchor-com.xsl"/>
-->    

    <xsl:include href="../../../v3/commons/param/params.xsl"/>
    <xsl:include href="../../../v3/commons/param/vars.xsl"/>

    <xsl:include href="../../../v3/lgpi/param/family_params.xsl"/>

    <xsl:include href="../../../v3/commons/lib/trace.lib.xsl"/>
    <xsl:include href="../../../v3/commons/lib/text.lib.xsl"/>
    <xsl:include href="../../../v3/commons/lib/patent.lib.xsl"/>
    <xsl:include href="../../../v3/commons/lib/label.lib.loc.xsl"/>
    <xsl:include href="../../../v3/commons/lib/anchorExtension.lib.loc.xsl"/>
    <xsl:include href="../../../v3/commons/lib/anchor.lib.xsl"/>
    <xsl:include href="../../../v3/pivot/lib/pivot.lib.xsl"/>
    <xsl:include href="../../../v3/lgpi/sub/lgpi.lib.xsl"/>
    <xsl:include href="../../../v3/ops/opsFam.pivot.xsl"/>


    <!-- ==== doc var ====  -->
	  <xsl:variable name="vRefCtry" select="//ops:world-patent-data/ops:patent-family/ops:publication-reference/document-id//country"/>


    <xd:doc scope="template">
        <xd:desc>
            <xd:p>main</xd:p>
        </xd:desc>
    </xd:doc>
    <xsl:template match="/">
        <p>
            <xsl:call-template name="attBiblioBlockPara"/>
            <xsl:apply-templates select="IFAM" />
        </p>
    </xsl:template>


</xsl:stylesheet>
