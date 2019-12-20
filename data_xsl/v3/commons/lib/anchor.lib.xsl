<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl" xmlns:xs="http://www.w3.org/2001/XMLSchema"
 exclude-result-prefixes="xd xs"
 version="3.0">
  
<!-- see anchorExtension
x.lns:emp="http://org.epo.mimosaserver.core.saxonextfct.URLToolGetTypUrlPubServerExtFct"
x.lns:emq="http://org.epo.mimosaserver.core.saxonextfct.URLToolGetTypUrlRegisterLinkExtFct"
x.lns:ems="http://org.epo.mimosaserver.core.saxonextfct.URLToolGetTypUrlPattentscopePublicationExtFct"
  -->  
  
    <xd:doc scope="stylesheet/libXsl">
        <xd:desc>
            <xd:p><xd:b>Application:</xd:b>Pise</xd:p>
          <xd:p><xd:b>Aim:</xd:b> build @href (should replace {collections}/commons/anchor.lib.xsl)</xd:p>
            <xd:p><xd:b>Last update:</xd:b> 201811 V.O. </xd:p>
            <xd:p><xd:b>Preview update:</xd:b> see SCM comments</xd:p>
            <xd:p><xd:b>Origin:</xd:b>{collections}/commons/v2_anchor[].xsl </xd:p>
            <xd:ul>
              <xd:li><xd:b>v2_anchor_param.xsl</xd:b> 'pLang' </xd:li>
              <xd:li><xd:b>v2_anchor-com.xsl</xd:b> use 'configuration' and 'server' java lib </xd:li>
              <xd:li><xd:b>v2_anchor_wp-html5.xsl </xd:b> generate 'span' and 'a' (wp: With Param)</xd:li>
              <xd:li><xd:b>v2_anchor_ipc7-frm.xsl</xd:b> old xsl template only </xd:li>
              <xd:li><xd:b>v2_anchor-html5.xsl</xd:b>old xsl template only </xd:li>
            </xd:ul>
                
        </xd:desc>
    </xd:doc>


<xsl:param name="pUrlPubServer">{pUrlPubServer}</xsl:param>
<xsl:param name="pUrlEPORegister">{pUrlEPORegister}</xsl:param>
<xsl:param name="pUrlServletIMG">{pUrlServletIMG}</xsl:param>
<xsl:param name="pUrlWipoPatsco">{pUrlWipoPatsco}</xsl:param>
<xsl:param name="pUrlEspacenet">{pUrlEspacenet}</xsl:param>
<xsl:param name="pUrlGpiExternal">{pUrlGpiExternal}</xsl:param>
<xsl:param name="pUrlMimo">{pUrlMimo}</xsl:param>
<xsl:param name="pUrlXgpiService">{pUrlXgpiService}</xsl:param>
<xsl:param name="pUrlIpc8Wipo">{pUrlIpc8Wipo}</xsl:param>
<xsl:param name="pUrlIpc7Wipo">{pUrlIpc7Wipo}</xsl:param>




<!-- ======== v2_anchor-com.xsl ======== -->
    
      <!-- ======================
_maj 20190515 ajout de "$ac_debug= '2'"  (noLibJava)
ATTENTION A NE PAS COMMITE !!!! version sans lib java => sans 'xja-TypUrl'
TEMPLATE PREFIXE : 'tpl-LnkUrl' // return "<url>"
TEMPLATE PREFIXE : 'tpl-TypUrl' // return "<data-type>!<url>"
VARIABLE GLOBAL AU FICIER : 'ac_'  
BUT : regroupement de la construction des URL ou contenu de l'attribut 'href'
========================= -->

  <?xHis date="20161118" msg=" add links IPC, CPC" ?>

  <!-- ==== Local debug variable ====  -->
  <!-- XX $ac_debug : [0:no debug|1: debug| 2: noLibJava] -->
  <!--[NOR]-->
  <xsl:param name="ac_debug" select="'0'"/>
  <!--[NOR]-->
  <!--[DBG]-/->
  <xsl:param name="ac_debug" select="'2'"/>
  <!-/-[/DBG]-->


  <!-- ==== definition de variables globale aux fichiers (c-a-d ne devant pas être utilisées ailleurs) ====  -->

  <xsl:variable name="ac_pUrlIpc7Wipo">http://www.wipo.int/classifications/fulltext/new_ipc/ipc7</xsl:variable>
  <xsl:variable name="ac_pUrlIpc8Wipo">http://www.wipo.int/ipcpub</xsl:variable>
  <xsl:variable name="ac_espacenetPub">http://worldwide.espacenet.com/publicationDetails</xsl:variable>
  <xsl:variable name="ac_register">https://register.epo.org/advancedSearch</xsl:variable>


  <!-- ==== include (to realise in main XSL) ====  -/->
  <use#x.l:include href="../commons/v2_com_txt.xsl OR ../epab/lib_temp_com.xsl OR ..." msg="fun  />
  <!-/- -->


  <!-- ==== template harmoniser  ====  -->

  <!-- Ajoute des zeros a droite d'une chaine (sans ajout d'un '0' lorsque end=0 )-->
  <xsl:template name="ac_add-rigth-zeros">
    <xsl:param name="begin" select="0"/>
    <xsl:param name="end" select="0"/>
    <xsl:param name="string" select="j"/>

    <xsl:if test="$begin = $end">
      <xsl:value-of select="$string"/>
    </xsl:if>

    <xsl:if test="$begin != $end">
      <xsl:call-template name="ac_add-rigth-zeros">
        <xsl:with-param name="begin" select="($begin)+1"/>
        <xsl:with-param name="end" select="$end"/>
        <xsl:with-param name="string" select="concat($string,'0')"/>
      </xsl:call-template>
    </xsl:if>
  </xsl:template>



  <!-- ==== template ====  -->

  <!-- ==== classification IPC7 (http://www.wipo.int/classifications/fulltext/new_ipc/ipc7...) -->
  <xsl:template name="tpl-LnkUrlIpc7-OLD">
    <!--xx msg="TODO changes arg"-->
    <xsl:param name="suffix"/>
    <!--
      <xsl:value-of select="concat($ac_pUrlIpc7Wipo, $suffix)"/>
    -->
    <xsl:value-of select="concat('_OLD_CLASSIF_', $suffix)"/>
  </xsl:template>

  <!-- ==== classification IPC* result list(http://www.wipo.int/ipcpub) -->
  <xsl:template name="tpl-LnkUrlIpcRl">
    <?xd his : 20161115 from v2_anchor_ipc7-frm.xsl / tpl-lnkIpc7
		env : vLang 
	?>
    <xsl:param name="ipc"/>
    <?xd input-ipc7 "B24B  7/22",
			input-ipc8 ">B24B   7/00 (2006.01)", "B24B  53/017 (2012.01)"
		?>

    <xsl:variable name="vmSep">
      <xsl:choose>
        <xsl:when test="contains($ipc, ':')">:</xsl:when>
        <xsl:otherwise>/</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:variable name="vmIpc">
      <xsl:choose>
        <xsl:when test="contains($ipc,'(')">
          <xsl:value-of select="normalize-space( substring-before($ipc,'('))"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="normalize-space($ipc)"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:variable name="vmPcl" select="1"><!--xx msg="Position Start Class (depend on edition)"-->
    </xsl:variable>

    <xsl:variable name="vClass" select="translate(substring($vmIpc,$vmPcl,5), ' ','')"/>

    <xsl:variable name="vGroup" select="translate(substring-before(substring($vmIpc,$vmPcl +5 ),$vmSep), ' ','')"/>

    <xsl:variable name="vSousGroup" select="translate(substring-after($vmIpc,$vmSep),' ABCDEFGHIJKLMNOPQRSTUVWXYZ-','')"/>

    <xsl:variable name="vSymbol">
      <!--xx msg="[digit]{4|14}"-->
      <xsl:value-of select="$vClass"/>
      <xsl:if test="''!=$vGroup">
        <xsl:value-of select="format-number(number($vGroup),'0000')"/><!-- uosss add number()-->
        <xsl:choose>
          <xsl:when test="'' != $vSousGroup">
            <xsl:value-of select="substring(concat($vSousGroup,'000000'),1,6)"/>
            <!--xx msg=" right padding "-->
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="'000000'"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:if>
    </xsl:variable>

    <xsl:variable name="vEditionDate">
      <xsl:choose>
        <xsl:when test="contains($ipc,'(')">
          <xsl:value-of select="concat(translate(substring-before(substring-after($ipc,'('),')'),'.',''),'01')"/>
        </xsl:when>
        <xsl:otherwise>20000101</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:variable name="vLangIpc">
      <xsl:choose>
        <xsl:when test="$vLang = 'de'">en</xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$vLang"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:value-of select="concat($ac_pUrlIpc8Wipo, '/?version=',$vEditionDate,'&amp;symbol=',normalize-space($vSymbol),'&amp;priorityorder=yes&amp;lang=',$vLangIpc)"/>
  </xsl:template>


  <!-- ==== classification IPC6 IPC7 (http://www.wipo.int/ipcpub) -->
  <xsl:template name="tpl-LnkUrlIpc7">
    <!--xx msg="TODO changes arg"-->
    <xsl:param name="suffix"/>
    <xsl:value-of select="concat($ac_pUrlIpc8Wipo, $suffix)"/>
  </xsl:template>

  <!-- ==== classification IPC8 (http://www.wipo.int/ipcpub) -->

  <xsl:template name="tpl-LnkUrlIpc8">
    <xsl:param name="ipc"/>

    <xsl:variable name="sousGroupLenght" select="14"/>

    <xsl:variable name="c1" select="substring($ipc,1,16)"/>

    <xsl:variable name="vSymbol" select="translate(substring(translate($ipc,'/',''),1,$sousGroupLenght),' /','00')"/>

    <xsl:variable name="defsymbol" select="$sousGroupLenght - string-length($vSymbol)"/>

    <xsl:variable name="vSymbolOk">
      <xsl:choose>
        <xsl:when test="not(contains($c1,'/'))">
          <xsl:value-of select="normalize-space($c1)"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:call-template name="ac_add-rigth-zeros">
            <xsl:with-param name="begin" select="0"/>
            <xsl:with-param name="end" select="$defsymbol"/>
            <xsl:with-param name="string" select="$vSymbol"/>
          </xsl:call-template>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:variable name="vEdition" select="concat(substring($ipc,20,4),'.',substring($ipc,24,2))"/>

    <xsl:variable name="vEditionL" select="substring($ipc,20,8)"/>

    <xsl:variable name="vLevel" select="lower-case(substring($ipc,28,1))"/>
    <xsl:variable name="vLevelOk">
      <xsl:choose>
        <xsl:when test="$vLevel = 's'">c</xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$vLevel"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="vLangIpc">
      <xsl:choose>
        <xsl:when test="$vLang = 'de'">en</xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$vLang"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:value-of select="concat($ac_pUrlIpc8Wipo,'/?level=',$vLevelOk,'&amp;lang=',$vLangIpc,'&amp;symbol=',$vSymbolOk,'&amp;priorityorder=yes&amp;refresh=page&amp;version=',$vEditionL)"/>
  </xsl:template>


  <!-- ==== classification CPC (espacenet.com)-->
  <xsl:template name="tpl-LnkUrlClassif-cpc">
    <xsl:param name="classification"/>
    <xsl:param name="value"/>
    <xsl:param name="hit"/>
    <xsl:param name="lang"/>

    <!-- TODO -->

  </xsl:template>



  <!-- ==== classification CPC for ResultList Input (espacenet.com) (http://worldwide.espacenet.com/classification?CPC=...) -->
  <xsl:template name="tpl-lnkClassif-cpc-vRL">
    <?xslDoc env="vLang" loc="http://worldwide.espacenet.com/classification?locale={$vLang}&CPC=..." ?>
    <xsl:param name="current-cla"/>
    <?xd @value= ?>

    <xsl:variable name="classification">
      <xsl:choose>
        <xsl:when test="contains($current-cla, '(')">
          <xsl:value-of select="normalize-space(substring-before($current-cla,'('))"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$current-cla"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:variable name="separateur">
      <xsl:choose>
        <xsl:when test="contains($classification, ':')">:</xsl:when>
        <xsl:otherwise>/</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:variable name="vNorm">
      <xsl:value-of select="substring($classification,1,4)"/>
    </xsl:variable>
    <xsl:variable name="vP1" select="substring($classification,1,4)"/>
    <xsl:variable name="vP2" select="substring-before(substring($classification,5),$separateur)"/>
    <xsl:variable name="vP3" select="substring-after($classification,$separateur)"/>
    <xsl:variable name="vP4">
      <xsl:choose>
        <xsl:when test="contains($vP3,'(')">
          <xsl:value-of select="substring-before($classification,'(')"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$vP3"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>


    <xsl:value-of select="concat('http://worldwide.espacenet.com/classification?locale=',$vLang,'_EP#!/CPC=',$vP1,$vP2,'/',$vP4)"/>
  </xsl:template>



  <!--  ========================= APN ========================= -->

  <!-- ==== Register for 'APN'  in 'result list'  (no more 'PUN')  -->
  <xsl:template name="tpl-TypUrlRegister">
    <xsl:param name="fLang"/>
    <!-- xx Lang of the interface ..-->
    <xsl:param name="fLinkFormat"/>
    <!-- xx linkFormat EPAB,LGPI, register, ..-->
    <xsl:param name="fCountry"/>
    <xsl:param name="fAppNumber"/>
    <xsl:param name="fAppDate"/>
    <xsl:param name="fKind"/>
    <xsl:param name="fPubCountry"/>
    <xsl:param name="fPubNumber"/>
    <xsl:param name="fPubDate"/>
    <xsl:param name="fDocPart"/>

    <xsl:choose>
      <xsl:when test="$ac_debug = '2'">
        <xsl:value-of select="concat('UrlRegister!http://UrlRegister?lang=' , $fLang )"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="xja-TypUrlRegisterLink">
          <xsl:with-param name="uiLang" select="string($fLang)"/>
          <xsl:with-param name="linkFormat" select="string($fLinkFormat)"/>
          <xsl:with-param name="country" select="string($fCountry)"/>
          <xsl:with-param name="appNum" select="string($fAppNumber)"/>
          <xsl:with-param name="appDate" select="string($fAppDate)"/>
          <xsl:with-param name="kind" select="string($fKind)"/>
          <xsl:with-param name="pubCountry" select="string($fPubCountry)"/>
          <xsl:with-param name="pubNum" select="string($fPubNumber)"/>
          <xsl:with-param name="pubDate" select="string($fPubDate)"/>
          <xsl:with-param name="docPart" select="string($fDocPart)"/>
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>



  <!-- ==== RegisterLink for 'APN' LGPI and EPAB 'Document' see:   -->

  <xsl:template name="tpl-TypUrlRegisterLink">
    <xsl:param name="fLang"/>
    <!-- xx Lang of the interface ..-->
    <xsl:param name="fLinkFormat"/>
    <!-- xx linkFormat EPAB,LGPI, ..-->
    <xsl:param name="fCountry"/>
    <xsl:param name="fAppNumber"/>
    <xsl:param name="fAppDate"/>
    <xsl:param name="fKind"/>
    <xsl:param name="fPubCountry"/>
    <xsl:param name="fPubNumber"/>
    <xsl:param name="fPubDate"/>
    <xsl:param name="fDocPart"/>

    <xsl:choose>
      <xsl:when test="$ac_debug = '2'">
        <xsl:value-of select="concat('UrlRegisterLink!http://UrlRegisterLink?lang=' , $fLang )"/>
      </xsl:when>
      <xsl:otherwise>

        <xsl:call-template name="xja-TypUrlRegisterLink">
          <xsl:with-param name="uiLang" select="string($fLang)"/>
          <xsl:with-param name="linkFormat" select="string($fLinkFormat)"/>
          <xsl:with-param name="country" select="string($fCountry)"/>
          <xsl:with-param name="appNum" select="string($fAppNumber)"/>
          <xsl:with-param name="appDate" select="string($fAppDate)"/>
          <xsl:with-param name="kind" select="string($fKind)"/>
          <xsl:with-param name="pubCountry" select="string($fPubCountry)"/>
          <xsl:with-param name="pubNum" select="string($fPubNumber)"/>
          <xsl:with-param name="pubDate" select="string($fPubDate)"/>
          <xsl:with-param name="docPart" select="string($fDocPart)"/>
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>



  <!--  ========================= APN or PUN ========================= -->


  <!-- ==== Register for 'APN' or 'PUN' (to keep for PDF and resutlt list)-->
  <!-- tpl-LnkUrlRegister or <registerSimpleApn, registerSimplePun>
  param
  * fUrlFormat : a completer 
  * fAppId : APC+APN 
  * fPubId : PUC+PUN
  * fLang : uiLang, pLang
  
@Deprecated use tpl-TypUrlRegister
  -->
  <xsl:template name="tpl-LnkUrlRegister">
    <xsl:param name="fUrlFormat"/>
    <xsl:param name="fPubId"/>
    <xsl:param name="fAppId"/>
    <xsl:param name="fLang"/>

    <xsl:variable name="vUrlPart1">
      <xsl:choose>
        <xsl:when test="$fPubId">
          <xsl:value-of select="concat('pn=',$fPubId)"/>
        </xsl:when>
        <xsl:when test="$fAppId">
          <xsl:value-of select="concat('ap=',$fAppId)"/>
        </xsl:when>
      </xsl:choose>
    </xsl:variable>

    <xsl:variable name="vUrlPart2">
      <xsl:choose>
        <xsl:when test="$fLang">
          <xsl:value-of select="concat('&amp;lng=', $fLang)"/>
        </xsl:when>
      </xsl:choose>
    </xsl:variable>

    <xsl:value-of select="concat($ac_register,'?',$vUrlPart1,$vUrlPart2)"/>
  </xsl:template>


  <xsl:template name="tpl-TypUrlPatenscopePublication">
    <xsl:param name="fLang"/>
    <!-- xx Lang of the interface ..-->
    <xsl:param name="fLinkFormat">patentscope</xsl:param>
    <!-- xx linkFormat patanscope, EPAB,LGPI, , ...-->
    <xsl:param name="fPubCountry">WO</xsl:param>
    <xsl:param name="fPubNumber"/>
    <xsl:param name="fPubDate"/>
    <xsl:param name="fDocPart"/>

    <xsl:choose>
      <xsl:when test="$ac_debug = '2'">
        <xsl:value-of select="concat('UrlPatentscopePublication!http://UrlPatentscopePublication?lang=' , $fLang )"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="xja-TypUrlPatentscopePublication">
          <xsl:with-param name="uiLang" select="string($fLang)"/>
          <xsl:with-param name="linkFormat" select="string($fLinkFormat)"/>
          <xsl:with-param name="pubCountry" select="string($fPubCountry)"/>
          <xsl:with-param name="pubNum" select="string($fPubNumber)"/>
          <xsl:with-param name="pubDate" select="string($fPubDate)"/>
          <xsl:with-param name="docPart" select="string($fDocPart)"/>
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>


  



  <!--  ========================= PUN ========================= -->

  <!-- ==== PUN  Espacenet / hitlist(or result list)
  @Deprecated
  -->
  <xsl:template name="tpl-LnkUrlHitListEspacenet">
    <xsl:param name="pCtry"/>
    <xsl:param name="pPubnum"/>
    <xsl:param name="pKind"/>
    <xsl:param name="pLang"/>
    <xsl:variable name="pLangOk">
      <xsl:choose>
        <xsl:when test="($pLang = 'es') or ($pLang = 'jp')">en</xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$pLang"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:value-of select="concat($ac_espacenetPub,'/originalDocument?CC=', $pCtry, '&amp;NR=', $pPubnum, $pKind,'&amp;KC=', $pKind, '&amp;locale=', $pLangOk, '_EP&amp;date=&amp;FT=D')"/>
  </xsl:template>


  <!-- ==== PUN Espacenet / originalDocument (source GPI)
  @Deprecated
  -->
  <xsl:template name="tpl-LnkUrlPdfEspacenet">
    <xsl:param name="fUrlFormat" select="concat($ac_espacenetPub,'/originalDocument?CC={COUNTRY}&amp;NR={DOC_NUMBER}&amp;KC={KIND_CODE}&amp;locale={LOCALE_LANG}&amp;date=&amp;FT=D')"/>
    <xsl:param name="fLang"/>
    <xsl:param name="fCountry"/>
    <xsl:param name="fDocNumber"/>
    <xsl:param name="fKind"/>

    <xsl:variable name="vLangOk">
      <xsl:choose>
        <xsl:when test="($fLang = 'es') or ($fLang = 'jp')">en</xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$fLang"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:variable name="urlPart1" select="concat(substring-before($fUrlFormat, '{COUNTRY}'), $fCountry)"/>

    <xsl:variable name="urlPart2" select="concat(substring-before(substring-after($fUrlFormat, '{COUNTRY}'),'{DOC_NUMBER}'), $fDocNumber, $fKind)"/>

    <xsl:variable name="urlPart3" select="concat(substring-before(substring-after($fUrlFormat, '{DOC_NUMBER}'),'{KIND_CODE}'), $fKind)"/>

    <xsl:variable name="urlPart4" select="concat(substring-before(substring-after($fUrlFormat, '{KIND_CODE}'),'{LOCALE_LANG}'), $vLangOk,'_EP')"/>

    <xsl:variable name="urlPart5" select="substring-after($fUrlFormat, '{LOCALE_LANG}')"/>

    <xsl:value-of select="concat($urlPart1,$urlPart2,$urlPart3,$urlPart4,$urlPart5)"/>

  </xsl:template>


  <!-- ==== PUN  PublicationServer  -->
  <xsl:template name="tpl-TypUrlPubServer">
    <xsl:param name="fLang"/>
    <!-- xx Lang of the interface ..-->
    <xsl:param name="fLinkFormat"/>
    <!-- xx linkFormat EPAB,LGPI, register, ..-->
    <xsl:param name="fKind"/>
    <xsl:param name="fPubCountry"/>
    <xsl:param name="fPubNumber"/>
    <xsl:param name="fPubDate"/>
    <xsl:param name="fDocPart"/>

    <xsl:choose>
      <xsl:when test="$ac_debug = '2'">
        <xsl:value-of select="concat('UrlPubServer!http://UrlPubServerAAAA?lang=' , $fLang )"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="xja-TypUrlPubServer">
          <xsl:with-param name="uiLang" select="string($fLang)"/>
          <xsl:with-param name="linkFormat" select="string($fLinkFormat)"/>
          <xsl:with-param name="kind" select="string($fKind)"/>
          <xsl:with-param name="pubCountry" select="string($fPubCountry)"/>
          <xsl:with-param name="pubNum" select="string($fPubNumber)"/>
          <xsl:with-param name="pubDate" select="string($fPubDate)"/>
          <xsl:with-param name="docPart" select="string($fDocPart)"/>
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>


  


  <!-- ==== PUN  Espacenet  -->
  <xsl:template name="tpl-TypUrlEspacenet">
    <xsl:param name="fLang"/>
    <!-- xx Lang of the interface ..-->
    <xsl:param name="fLinkFormat"/>
    <!-- xx linkFormat EPAB,LGPI, register, ..-->
    <xsl:param name="fKind"/>
    <xsl:param name="fPubCountry"/>
    <xsl:param name="fPubNumber"/>
    <xsl:param name="fPubDate"/>
    <xsl:param name="fDocPart"/>


    <xsl:choose>
      <xsl:when test="$ac_debug = '2'">
        <xsl:value-of select="concat('UrlEspacenet!http://UrlEspacenet?lang=' , $fLang )"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="xja-TypUrlEspacenet">
          <xsl:with-param name="uiLang" select="string($fLang)"/>
          <xsl:with-param name="linkFormat" select="string($fLinkFormat)"/>
          <xsl:with-param name="kind" select="string($fKind)"/>
          <xsl:with-param name="pubCountry" select="string($fPubCountry)"/>
          <xsl:with-param name="pubNum" select="string($fPubNumber)"/>
          <xsl:with-param name="pubDate" select="string($fPubDate)"/>
          <xsl:with-param name="docPart" select="string($fDocPart)"/>
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>


  

    

<!-- ======== v2_anchor_wp-html5.xsl ======== -->
    
<!-- ======================
BUT : regroupement des template des liens externes, commun a GPI, EPAB, XBUL pour le html/html5 : 

FICHIER : wp : with param 'lib_anchor_wp_html5.xsl' 
TEMPLATE PREFIXE = 'tpl-Lnk' pour Template Lib Anchor

201503 - add PI for doc :   <?xslDoc env="pUrlEspacenet,vLang" ?>

========================= -->

  <!-- ==== include (A realiser dans la XSL appelante) ====  -/->
  <use#x.l:include href="v2_anchor_param.xsl"/>
  <use#x.l:include href="v2_com_txt.xsl"/>
  <!-/- -->


  <!-- ==== template ==== -->
<!--
<xsl:template name="dbg_archor_param">
  <p>$pUrlPubServer = <xsl:value-of select="$pUrlPubServer"/></p>
  <p>pUrlEPORegister = <xsl:value-of select="$pUrlEPORegister"/></p>
  <p>pUrlServletIMG = <xsl:value-of select="$pUrlServletIMG"/></p>
  <p>pUrlWipoPatsco = <xsl:value-of select="$pUrlWipoPatsco"/></p>
  <p>pUrlEspacenet = <xsl:value-of select="$pUrlEspacenet"/></p>
  <p>pUrlGpiExternal = <xsl:value-of select="$pUrlGpiExternal"/></p>
  <p>pUrlMimo = <xsl:value-of select="$pUrlMimo"/></p>
  <p>pUrlXgpiService = <xsl:value-of select="$pUrlXgpiService"/></p>
  <p>pUrlIpc8Wipo = <xsl:value-of select="$pUrlIpc8Wipo"/></p>
  <p>pUrlIpc7Wipo = <xsl:value-of select="$pUrlIpc7Wipo"/></p>
</xsl:template>
  -->
  <!-- ==== Espacenet === env[pUrlEspacenet,vLang] -->
  
  <xsl:template name="tpl-LnkEspacenet">
    <xsl:param name="pStyle"/>
    <xsl:param name="pCtry"/>
    <xsl:param name="pDocNum"/>
    <xsl:param name="pKind"/>
    <xsl:param name="pDate"/>
    <xsl:param name="pName"/>
    <xsl:param name="pText"/>
    <xsl:param name="pHit"/>
    <xsl:param name="pId"/>
    
    <?xslDoc env="pUrlEspacenet,vLang" ?>
    
    <xsl:variable name="pLangOk">
      <xsl:choose>
        <xsl:when test="($vLang = 'es') or ($vLang = 'jp')">en</xsl:when>
        <xsl:otherwise><xsl:value-of select="$vLang"/></xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    
    <xsl:variable name="vRef">
      <xsl:choose>
        <xsl:when test="string-length($pText) &gt; 0">
          <xsl:call-template name="set-non-beaking-spaces"><xsl:with-param name="data" select="$pText"/></xsl:call-template>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$pCtry"/>
          <xsl:call-template name="carNbsp"/>
          <xsl:value-of select="$pDocNum"/>
          <xsl:call-template name="carNbsp"/>
          <xsl:value-of select="$pKind"/>
          <xsl:if test="(string-length($pDate)  &gt; 0) and (string-length($pName) &lt; 1)">
            <xsl:call-template name="carNbsp"/>
            <xsl:value-of select="$pDate"/>
          </xsl:if>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    
    <xsl:element name="a">
      <xsl:attribute name="href">
        <xsl:value-of select="concat($pUrlEspacenet,'?locale=',$pLangOk,'_EP&amp;CC=',encode-for-uri($pCtry),'&amp;NR=',encode-for-uri(translate($pDocNum,'/-','')),'&amp;KC=',encode-for-uri($pKind))"/>
      </xsl:attribute>
      <xsl:attribute name="class"><xsl:value-of select="$pStyle"/></xsl:attribute>
      <xsl:attribute name="target">_blank</xsl:attribute>
      <xsl:attribute name="data-link-type">espacenet</xsl:attribute>
      <xsl:choose>
        <xsl:when test="(string-length($pId) &gt; 0) and ($pHit='yes')">
          <span class="cHit" id="hitmimosa_{generate-id()}"><span id="{$pId}"><xsl:value-of select="$vRef" disable-output-escaping="yes"/></span></span>
        </xsl:when>
        <xsl:when test="string-length($pId) &gt; 0">
          <span id="{$pId}"><xsl:value-of select="$vRef" disable-output-escaping="yes"/></span>
        </xsl:when>
        <xsl:when test="$pHit='yes'">
          <span class="cHit" id="hitmimosa_{generate-id()}"><xsl:value-of select="$vRef" disable-output-escaping="yes"/></span>
        </xsl:when>
        <xsl:otherwise><xsl:value-of select="$vRef" disable-output-escaping="yes"/></xsl:otherwise>
      </xsl:choose>
    </xsl:element>
    <xsl:if test="string-length($pName) &gt; 0">
      <xsl:call-template name="carNbsp"/>
      <xsl:value-of select="$pName"/>
      <xsl:call-template name="carNbsp"/>
      <xsl:value-of select="$pDate"/>
    </xsl:if>
  </xsl:template>
  
  
  <xsl:template name="tpl-LnkEspacenet-sr">
    <!--xx Use "$pDocNum" or "$pDocNumFull" but not both -->
    <xsl:param name="pCtry"/>
    <xsl:param name="pDocNum"/><!-- xx $pDocNum:<num> -->
    <xsl:param name="pDocNumFull"/><!-- xx $pDocNumFull:<cc><num><ki> -->
    <xsl:param name="pKind"/>
    <xsl:param name="pDate"/>
    <xsl:param name="pName"/>
    <xsl:param name="pHit"/>
    
    <?xslDoc env="pUrlEspacenet,vLang" ?>
    
    
    <xsl:variable name="pLangOk">
      <xsl:choose>
        <xsl:when test="($vLang = 'es') or ($vLang = 'jp')">en</xsl:when>
        <xsl:otherwise><xsl:value-of select="$vLang"/></xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:variable name="v_DocNum">
      <xsl:choose>
        <xsl:when test="$pDocNum">
          <xsl:value-of select="$pDocNum"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="substring($pDocNumFull,3,string-length($pDocNumFull)-4)"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    
    <xsl:variable name="v_DocNumFull">
      <xsl:choose>
        <xsl:when test="$pDocNum">
          <xsl:value-of select="concat($pCtry,$pDocNum,$pKind)"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$pDocNumFull"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    
    <xsl:element name="a">
      <xsl:attribute name="href">
        <xsl:value-of select="concat($pUrlEspacenet,'?locale=',$pLangOk,'_EP&amp;CC=',encode-for-uri($pCtry),'&amp;NR=',encode-for-uri(translate($v_DocNum,'/-','')),'&amp;KC=',encode-for-uri($pKind))"/>
      </xsl:attribute>
      <xsl:attribute name="class">cExternalFullTextLnk</xsl:attribute>            
      <xsl:attribute name="target">_blank</xsl:attribute>
      <xsl:attribute name="data-link-type">espacenet</xsl:attribute>
      <xsl:choose>
        <xsl:when test="$pHit='yes'">
          <span class="cHit" id="hitmimosa_{generate-id()}"><xsl:value-of select="$v_DocNumFull" disable-output-escaping="yes"/></span>
        </xsl:when>
        <xsl:otherwise><xsl:value-of select="$v_DocNumFull" disable-output-escaping="yes"/></xsl:otherwise>
      </xsl:choose>
    </xsl:element>
    <xsl:if test="string-length($pDate) &gt; 0">
      <xsl:text>&#160;</xsl:text><xsl:apply-templates select="$pDate"/>
    </xsl:if>
    <xsl:if test="string-length($pName) &gt; 0">
      <xsl:text>&#160;-&#160;</xsl:text>
      <xsl:apply-templates select="$pName"/>
    </xsl:if>
  </xsl:template>
  
  
  <!-- == Espacenet ifam === env[pUrlEspacenet,vLang] -->
  <xsl:template name="tpl-LnkEspacenet-ifam">
    <xsl:param name="pStyle"/>
    <xsl:param name="pCtry"/>
    <xsl:param name="pDocNum"/>
    <xsl:param name="pKind"/>
    
    <?xslDoc env="pUrlEspacenet,vLang" ?>
    
    <xsl:variable name="pLangOk">
      <xsl:choose>
        <xsl:when test="($vLang = 'es') or ($vLang = 'jp')">en</xsl:when>
        <xsl:otherwise><xsl:value-of select="$vLang"/></xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    
    <xsl:element name="a">
      <xsl:attribute name="href">
        <xsl:value-of select="concat($pUrlEspacenet,'?locale=',$pLangOk,'_EP&amp;FT=D&amp;CC=',encode-for-uri($pCtry),'&amp;NR=',encode-for-uri($pDocNum),encode-for-uri($pKind),'&amp;KC=',encode-for-uri($pKind))"/>
      </xsl:attribute>
      <xsl:attribute name="class"><xsl:value-of select="$pStyle"/></xsl:attribute>
      <xsl:attribute name="target">_blank</xsl:attribute>
      <xsl:attribute name="data-link-type">espacenet</xsl:attribute>
      <xsl:value-of select="$pCtry"/>
      <xsl:call-template name="carNbsp"/>
      <xsl:value-of select="$pDocNum"/>
      <xsl:call-template name="carNbsp"/>
      <xsl:value-of select="$pKind"/>
    </xsl:element>
  </xsl:template>
  
  <!-- == Espacenet isfam === env[pUrlEspacenet,vLang] -->
  <xsl:template name="tpl-LnkEspacenet-isfam">
    <xsl:param name="pStyle"/>
    <xsl:param name="pCtry"/>
    <xsl:param name="pDocNum"/>
    
    <?xslDoc env="pUrlEspacenet,vLang" ?>
    
    <xsl:variable name="pLangOk">
      <xsl:choose>
        <xsl:when test="($vLang = 'es') or ($vLang = 'jp')">en</xsl:when>
        <xsl:otherwise><xsl:value-of select="$vLang"/></xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    
    <xsl:variable name="vRef">
      <xsl:value-of select="concat($pCtry,$pDocNum)"/>
    </xsl:variable>
    
    <xsl:element name="a">
      <xsl:attribute name="href">
        <xsl:value-of select="concat($pUrlEspacenet,'?locale=',$pLangOk,'_EP&amp;CC=',encode-for-uri($pCtry),'&amp;NR=',encode-for-uri($pDocNum))"/>
      </xsl:attribute>
      <xsl:attribute name="class"><xsl:value-of select="$pStyle"/></xsl:attribute>
      <xsl:attribute name="target">_blank</xsl:attribute>
      <xsl:attribute name="data-link-type">espacenet</xsl:attribute>
      <xsl:value-of select="$vRef"/>
    </xsl:element>
  </xsl:template>
  
  <!-- == Espacenet textDoc === env[vLang] == [ToSup] -/->
  <xsl:template name="tpl-LnkEspacenetTextDoc">
    <xsl:param name="pStyle"/>
    <xsl:param name="pCtry"/>
    <xsl:param name="pDocNum"/>
    <xsl:param name="pKind"/>
    
    <xsl:variable name="pLangOk">
      <xsl:choose>
        <xsl:when test="($vLang = 'es') or ($vLang = 'jp')">en</xsl:when>
        <xsl:otherwise><xsl:value-of select="$vLang"/></xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    
    <xsl:variable name="vRef" select="concat($pCtry,$pDocNum,$pKind)"/>
    
    <xsl:element name="a">
      <xsl:attribute name="data-link-type">espacenet</xsl:attribute>
      <xsl:attribute name="class"><xsl:value-of select="$pStyle"/></xsl:attribute>
      <xsl:attribute name="href">
        <xsl:value-of select="concat('http://v3.espacenet.com/textdoc?locale=',$pLangOk,'&amp;IDX=',$pCtry,translate($pDocNum,'/',''),'&amp;CY=ep&amp;LG=',$vLang)"/>
      </xsl:attribute>
      <xsl:attribute name="target">
        <xsl:text>_blank</xsl:text>
      </xsl:attribute>
      <xsl:value-of select="$vRef"/>
    </xsl:element>
  </xsl:template>
  <!-/-[/ToSup]-->
  
  <!-- ==== patentscope === env[pUrlWipoPatsco]-->
  <xsl:template name="tpl-LnkWipoPatsco">
    <xsl:param name="p_ref"/>
    <xsl:param name="p_txt"/>
    
    <?xslDoc env="pUrlWipoPatsco" ?>
    
    <a>
      <xsl:attribute name="href">
        <xsl:value-of select="concat($pUrlWipoPatsco,$p_ref)"/>
      </xsl:attribute>
      <xsl:attribute name="data-link-type">patentscope</xsl:attribute>
      <xsl:attribute name="target">_blank</xsl:attribute>
      <xsl:attribute name="class">cInterPub cExternalLnk</xsl:attribute>      
      <xsl:copy-of select="$p_txt"/>
    </a>
  </xsl:template>


  <!-- ==== PubServer === env[pUrlPubServer] -->
  <xsl:template name="tpl-LnkPubServer">
    <xsl:param name="p_ref"/>
    <xsl:param name="p_txt"/>
    
    <?xslDoc env="pUrlPubServer" ?>
    
    <a>
      <xsl:attribute name="href">
        <xsl:value-of select="concat($pUrlPubServer,$p_ref)"/>
      </xsl:attribute>
      <xsl:attribute name="data-link-type">publication</xsl:attribute>
      <xsl:attribute name="target">_blank</xsl:attribute>
      <xsl:attribute name="class">cPubNumber cExternalLnk</xsl:attribute>      
      <xsl:copy-of select="$p_txt"/>
    </a>
  </xsl:template>
  
  
  <!-- ==== lib_temp_html5 old ===  env[vLang,pUrlIpc8Wipo] -->
  
  <!-- ==== IPC8 SR === env[pUrlIpc8Wipo,vLang] -->
  <xsl:template name="tpl-Ipc8-sr">
    <xsl:param name="ipc"/>
    <xsl:param name="hit"/>
    
    <?xslDoc env="pUrlIpc8Wipo,vLang" ?>
    
    <xsl:variable name="vSymbol"><xsl:value-of select="$ipc"/></xsl:variable>
    
    <xsl:element name="a">
      <xsl:attribute name="href"><xsl:value-of select="concat($pUrlIpc8Wipo,'/?lang=',encode-for-uri($vLang),'&amp;symbol=',encode-for-uri($vSymbol),'&amp;priorityorder=yes&amp;refresh=page')"/></xsl:attribute>
      <xsl:attribute name="class">cExternalLnk</xsl:attribute>
      <xsl:attribute name="target">_blank</xsl:attribute>
      <xsl:attribute name="data-link-type">wipo</xsl:attribute>
      <xsl:choose>
        <xsl:when test="$hit='yes'">
          <span class="cHit" id="hitmimosa_{generate-id()}">
            <xsl:call-template name="set-non-beaking-spaces">
              <xsl:with-param name="data" select="normalize-space($vSymbol)"></xsl:with-param>
            </xsl:call-template>
          </span>
        </xsl:when>
        <xsl:otherwise>
          <xsl:call-template name="set-non-beaking-spaces">
            <xsl:with-param name="data" select="normalize-space($vSymbol)"></xsl:with-param>
          </xsl:call-template>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:element>
  </xsl:template>
  

<!-- ======== v2_anchor_ipc7-frm.xsl ======== -->

  <!-- ======================
FIC: v2_anchor_ipc7-frm.xsl INT.PREFIX: 'tpl-lnkIpc7' EXT.PREFIX: 'vac7_' 
AIM: Ipc7 link with format param (@style)
KWL: lib ipc7 fo html5 
======================
YYYYMMDD Main changes (see also SVN comment's)
201408dd New : extract from mv v2_anchor-html5.xsl
201503dd - add PI for doc :   <?xslDoc env="pUrlEspacenet,vLang" loc="" encasulate="" msg=""?>
====================== -->

  <!-- ==== #include or #param (in parent XSL) ====  -/->
  <use#include href="v2_com_txt.xsl"/>
  <use#include href="v2_anchor_com.xsl"/>
  <use#include href="{collection}/style.xsl"/>
  <!-/- -->


  <!-- ==== internal prefix template to share ====  -->

  
  <!-- ==== template ====  -->

  <!-- ==== classification IPC7 (http://www.wipo.int/classifications/fulltext/new_ipc/ipc7...) 
** input.ipc : " 7A 01N 47:36 J" 
  -->
  
  <!-- ==== IPC 6 et  7 ==== 
  ** input.ipc
** input.ipc : 
" 7A 01N 47:36 J" 
" 7A 01N 43/58 A"

** output.text | output.url
"A01N 47/36" | http...&symbol=A01N0047360000
"A01N 47"    | http...&symbol=A01N0047000000
"A01N"       | http...&symbol=A01N

  -->
  <xsl:template name="tpl-lnkIpc7"><!--xx msg=" from IGPI"-->
    <xsl:param name="ipc"/><!--xx msg=""concatated value"-->
    <xsl:param name="style"><!-- uoss N/A --></xsl:param>

    <?xslDoc see="tpl-LnkUrlIpc7"?>

    <!-- LINK paramaters -->

    <xsl:variable name="vmSep">
      <xsl:choose>
        <xsl:when test="contains($ipc, ':')">:</xsl:when>
        <xsl:otherwise>/</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:variable name="vmIpc" select="normalize-space($ipc)"/>

    <xsl:variable name="vmEdition">
      <xsl:choose>
        <xsl:when test=" 'NaN' != string(number(substring($vmIpc,1,1)))">
          <xsl:value-of select="substring($vmIpc,1,1)"/>
        </xsl:when>
      </xsl:choose>
    </xsl:variable>

    <xsl:variable name="vmPcl"><!--xx msg="Position Start Class (depend on edition)"-->
      <xsl:choose>
        <xsl:when test=" '' = $vmEdition ">1</xsl:when>
        <xsl:otherwise>2</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:variable name="vClass" select="translate(substring($vmIpc,$vmPcl,5), ' ','')"/>

    <xsl:variable name="vGroup" select="translate(substring-before(substring($vmIpc,$vmPcl +5 ),$vmSep), ' ','')"/>

    <xsl:variable name="vSousGroup" select="translate(substring-after($vmIpc,$vmSep),' ABCDEFGHIJKLMNOPQRSTUVWXYZ-','')"/>

    <xsl:variable name="vSymbol"><!--xx msg="[digit]{4|14}"-->
      <xsl:value-of select="$vClass"/>
      <xsl:if test="''!=$vGroup">
        <xsl:value-of select="format-number(number($vGroup),'0000')"/>
        <xsl:choose>
          <xsl:when test="'' != $vSousGroup">
            <xsl:value-of select="substring(concat($vSousGroup,'000000'),1,6)"/><!--xx msg=" right padding "-->
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="'000000'"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:if>
    </xsl:variable>

    <xsl:variable name="vEditionDate">
      <xsl:choose>
        <xsl:when test="$vmEdition = 1">19680901</xsl:when>
        <xsl:when test="$vmEdition = 2">19740701</xsl:when>
        <xsl:when test="$vmEdition = 3">19800101</xsl:when>
        <xsl:when test="$vmEdition = 4">19850101</xsl:when>
        <xsl:when test="$vmEdition = 5">19900101</xsl:when>
        <xsl:when test="$vmEdition = 6">19950101</xsl:when>
        <xsl:otherwise>20000101</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:variable name="vLangIpc">
      <xsl:choose>
        <xsl:when test="$vLang = 'de'">en</xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$vLang"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:variable name="ipc-norm">
      <xsl:choose>
        <xsl:when test=" '' != $vmEdition ">
          <xsl:value-of select="$vmIpc"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="concat('7 ',$vmIpc)"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:variable name="vUrl">
      <xsl:call-template name="tpl-LnkUrlIpc7">
        <xsl:with-param name="suffix" select="concat('/?version=',$vEditionDate,'&amp;symbol=',normalize-space($vSymbol),'&amp;priorityorder=yes&amp;lang=',$vLangIpc)"/>
      </xsl:call-template>
    </xsl:variable>


    <xsl:variable name="ipc-br">

      <xsl:value-of select="$vClass"/>
        <xsl:if test=" '' != $vGroup">
          <xsl:value-of select="concat('&#160;', $vGroup)"/>
          <xsl:if test=" '' != $vSousGroup">
            <xsl:value-of select="concat('/',$vSousGroup)"/>
          </xsl:if>
        </xsl:if>
    </xsl:variable>


        <xsl:element name="a">
          <xsl:attribute name="data-link-type">wipo</xsl:attribute>
          <xsl:attribute name="href">
            <xsl:value-of select="$vUrl"/>
          </xsl:attribute>
          <xsl:attribute name="target">_blank</xsl:attribute>
          <xsl:attribute name="class">
            <xsl:value-of select="$style"/>
            <xsl:text> cExternalLnk</xsl:text>
          </xsl:attribute>

          <xsl:value-of select="$ipc-br"/>
        </xsl:element>

  </xsl:template>



<!-- ======== v2_anchor-html5.xsl ======== -->

	<!-- ======================
FICHIER : v2_anchor-html5.xsl 
BUT : regroupement des template des liens externes & crossref , commun a GPI, EPAB, XBUL pour le html/html5 
TEMPLATE PREFIXE = 'tpl-Lnk' pour Template Lib Anchor
========================= -->
	<?xHis date="20161118" msg=" add links IPC, CPC" ?>

	<!-- ==== include (A realiser dans la XSL appelante) ====  -/->
  <use#x.l:include href="v2_com_txt.xsl"/>
  <use#x.l:include href="v2_anchor-com.xsl"/>
  <!-/- -->

	<!-- ==== template ====  -->


	<!-- ==== Espacenet / originalDocument (http://worldwide.espacenet.com/publicationDetails/originalDocument?..) -->

	<xsl:template name="tpl-LnkPdfEspacenet">
		<xsl:param name="pLang"/>
		<xsl:param name="pStyle"/>
		<xsl:param name="pCtry"/>
		<xsl:param name="pDocNum"/>
		<xsl:param name="pKind"/>

		<?xslDoc see="tpl-LnkUrlPdfEspacenet"?>

		<xsl:variable name="vRef" select="concat($pCtry,$pDocNum,$pKind)"/>

		<xsl:element name="a">
			<xsl:attribute name="data-link-type">espacenet</xsl:attribute>
			<xsl:attribute name="class">
				<xsl:value-of select="$pStyle"/>
			</xsl:attribute>
			<xsl:attribute name="href">
				<xsl:call-template name="tpl-LnkUrlPdfEspacenet">
					<xsl:with-param name="fLang" select="$pLang"/>
					<xsl:with-param name="fCountry" select="$pCtry"/>
					<xsl:with-param name="fDocNumber" select="$pDocNum"/>
					<xsl:with-param name="fKind" select="$pKind"/>
				</xsl:call-template>
			</xsl:attribute>
			<xsl:attribute name="target">
				<xsl:text>_blank</xsl:text>
			</xsl:attribute>
			<xsl:value-of select="$vRef"/>
		</xsl:element>

	</xsl:template>


	<!-- ==== classification ECLA (http://worldwide.espacenet.com/eclasrch?ECLA=...) -->

	<xsl:template name="tpl-lnkClassif">
		<xsl:param name="classification"/>
		<xsl:param name="hit"/>

		<?xslDoc loc="http://worldwide.espacenet.com/eclasrch?locale=" ?>

		<xsl:variable name="pLangOk">
			<xsl:choose>
				<xsl:when test="($vLang = 'es') or ($vLang = 'jp')">en</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$vLang"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="separateur">
			<xsl:choose>
				<xsl:when test="contains($classification, ':')">:</xsl:when>
				<xsl:otherwise>/</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="vNorm">
			<xsl:value-of select="substring($classification,1,4)"/>
		</xsl:variable>
		<xsl:variable name="vMin" select="lower-case($classification)"/>
		<xsl:variable name="vP1" select="substring($vMin,1,4)"/>
		<xsl:variable name="vP2" select="substring-before(substring($vMin,5),$separateur)"/>
		<xsl:variable name="vP3" select="substring-after($vMin,$separateur)"/>
		<xsl:variable name="vP3upper" select="substring-after($classification,$separateur)"/>
		<a>
			<!-- example: http://worldwide.espacenet.com/eclasrch?locale=en_ep&ECLA=c22c38/16&classification=ecla -->
			<xsl:attribute name="href">
				<xsl:value-of select="concat('http://worldwide.espacenet.com/eclasrch?locale=',encode-for-uri($pLangOk),'_EP&amp;ECLA=',encode-for-uri($vP1),encode-for-uri($vP2),'/',encode-for-uri($vP3),'&amp;classification=ecla')"/>
			</xsl:attribute>
			<xsl:attribute name="class">cExternalLnk</xsl:attribute>
			<xsl:attribute name="target">_blank</xsl:attribute>
			<xsl:attribute name="data-link-type">ecla</xsl:attribute>
			<xsl:choose>
				<xsl:when test="$hit='yes'">
					<span class="cHit" id="hitmimosa_{generate-id()}">
						<xsl:call-template name="set-non-beaking-spaces">
							<xsl:with-param name="data" select="normalize-space(concat($vNorm,$vP2,$separateur,$vP3upper))"/>
						</xsl:call-template>
					</span>
				</xsl:when>
				<xsl:otherwise>
					<xsl:call-template name="set-non-beaking-spaces">
						<xsl:with-param name="data" select="normalize-space(concat($vNorm,$vP2,$separateur,$vP3upper))"/>
					</xsl:call-template>
				</xsl:otherwise>
			</xsl:choose>
		</a>
	</xsl:template>


	<!-- ==== classification CPC (http://worldwide.espacenet.com/classification?CPC=...)-->
	<xsl:template name="tpl-lnkClassif-cpc">
		<xsl:param name="classification"/>
		<?xd @value= ?>
		<xsl:param name="value"/>
		<?xd @value=[I:inventive|(A,'',#def):additionel]?>
		<xsl:param name="hit"/>
		<?xd @value=[yes|'']?>

		<?xslDoc env="vLang" loc="http://worldwide.espacenet.com/classification?locale=" ?>

		<xsl:variable name="pLangOk">
			<xsl:choose>
				<xsl:when test="(substring($vLang,1,2) = 'es') or (substring($vLang,1,2) = 'jp')">en</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="substring($vLang,1,2)"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="separateur">
			<xsl:choose>
				<xsl:when test="contains($classification, ':')">:</xsl:when>
				<xsl:otherwise>/</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="vP1" select="substring($classification,1,4)"/>
		<xsl:variable name="vP2" select="substring-before(substring($classification,5),$separateur)"/>
		<xsl:variable name="vP3" select="substring-after($classification,$separateur)"/>
		<a>
			<xsl:attribute name="href">
				<xsl:value-of select="concat('http://worldwide.espacenet.com/classification?locale=',$pLangOk,'_EP#!/CPC=',$vP1,$vP2,'/',$vP3)"/>
			</xsl:attribute>
			<xsl:attribute name="codeParameter">CPC</xsl:attribute>
			<xsl:attribute name="class">
				<xsl:choose>
					<xsl:when test="$value = 'I'">cClassCpcI cExternalLnk</xsl:when>
					<xsl:otherwise>cExternalLnk</xsl:otherwise>
				</xsl:choose>
			</xsl:attribute>
			<xsl:attribute name="data-link-type">cpc</xsl:attribute>
			<xsl:attribute name="target">_blank</xsl:attribute>
			<xsl:choose>
				<xsl:when test="$hit='yes'">
					<span class="cHit" id="hitmimosa_{generate-id()}">
						<xsl:call-template name="set-non-beaking-spaces">
							<xsl:with-param name="data" select="normalize-space($classification)"/>
						</xsl:call-template>
					</span>
				</xsl:when>
				<xsl:otherwise>
					<xsl:call-template name="set-non-beaking-spaces">
						<xsl:with-param name="data" select="normalize-space($classification)"/>
					</xsl:call-template>
				</xsl:otherwise>
			</xsl:choose>
		</a>
	</xsl:template>


	<!-- ==== classification IPC8 (http://www.wipo.int/ipcpub...) -->
	<xsl:template name="tpl-Ipc8">
		<xsl:param name="ipc"/>
		<xsl:param name="hit"/>
		<!--xsl:param name="isGpi"/-->
		<!--xsl:param name="isBull"/-->

		<?xslDoc see="tpl-LnkUrlIpc8" ?>

		<xsl:variable name="c1" select="substring($ipc,1,16)"/>

		<xsl:variable name="vEdition" select="concat(substring($ipc,20,4),'.',substring($ipc,24,2))"/>

		<span>
			<xsl:element name="a">
				<xsl:attribute name="href">
					<xsl:call-template name="tpl-LnkUrlIpc8">
						<xsl:with-param name="ipc" select="$ipc"/>
					</xsl:call-template>
				</xsl:attribute>
				<xsl:variable name="cssClassValue">
					<xsl:choose>
						<xsl:when test="substring($ipc,28,1) = 'A' and substring($ipc,30,1) = 'I'">
							<xsl:value-of select="'cClassAIpc8Inv'"/>
						</xsl:when>
						<xsl:when test="substring($ipc,28,1) = 'A' and substring($ipc,30,1) = 'N'">
							<xsl:value-of select="'cClassAIpc8Add'"/>
						</xsl:when>
						<xsl:when test="substring($ipc,30,1) = 'I'">
							<xsl:value-of select="'cClassIpc8Inv'"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="'cClassIpc8Add'"/>
						</xsl:otherwise>
					</xsl:choose>
					<xsl:text> cExternalLnk</xsl:text>
				</xsl:variable>
				<xsl:attribute name="class">
					<xsl:value-of select="normalize-space($cssClassValue)"/>
				</xsl:attribute>
				<xsl:attribute name="target">_blank</xsl:attribute>
				<xsl:attribute name="data-link-type">wipo</xsl:attribute>
				<xsl:choose>
					<xsl:when test="$hit='yes'">
						<span class="cHit" id="hitmimosa_{generate-id()}">
							<xsl:call-template name="set-non-beaking-spaces">
								<xsl:with-param name="data" select="normalize-space($c1)"/>
							</xsl:call-template>
						</span>
					</xsl:when>
					<xsl:otherwise>
						<xsl:call-template name="set-non-beaking-spaces">
							<xsl:with-param name="data" select="normalize-space($c1)"/>
						</xsl:call-template>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:element>
			<xsl:call-template name="carNbsp"/>
			<span class="cClassIpc8">(<xsl:value-of select="$vEdition"/>)</span>
		</span>
	</xsl:template>

	<!-- ==== Register ($p_href) -->

	<!-- NO MORE USED    x.l:template name="tpl-LnkRegister" -->


	<!-- ==== Crossref ( @data-link-ref )-->
	<xsl:template name="tpl-LnkCrossref">
		<xsl:param name="pNumber"/>
		<xsl:param name="pHref"/>
		<xsl:param name="pDockey"/>
		<xsl:param name="pHit"/>

		<?xslDoc see="javascript.client(@data-link-ref)"?>

		<xsl:text>&#32;</xsl:text>
		<xsl:text>[</xsl:text>
		<xsl:choose>
			<xsl:when test="$pHit='yes'">
				<span class="cHit" id="hitmimosa_{generate-id()}">
					<xsl:element name="a">
						<xsl:attribute name="data-link-ref">
							<xsl:value-of select="concat($pDockey,'#',$pHref,'#',$vLang)"/>
						</xsl:attribute>
						<xsl:attribute name="data-link-type">DESCRIPTION</xsl:attribute>
						<xsl:attribute name="class">cInternalLnk</xsl:attribute>
						<xsl:value-of select="translate($pNumber,'[]','')"/>
					</xsl:element>
				</span>
			</xsl:when>
			<xsl:otherwise>
				<xsl:element name="a">
					<xsl:attribute name="data-link-ref">
						<xsl:value-of select="concat($pDockey,'#',$pHref,'#',$vLang)"/>
					</xsl:attribute>
					<xsl:attribute name="data-link-type">DESCRIPTION</xsl:attribute>
					<xsl:attribute name="class">cInternalLnk</xsl:attribute>
					<xsl:value-of select="translate($pNumber,'[]','')"/>
				</xsl:element>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:text>]</xsl:text>
	</xsl:template>

</xsl:stylesheet>
