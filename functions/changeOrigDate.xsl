<?xml version="1.0" encoding="UTF-8"?>
<xsl:transform xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" version="3.0">
    
    <!-- This template was written exclusively to support custom author actions in oXygen for the Wright manuscript project -->
    <xsl:param name="name-of-attr-desired" as="xs:string" select="'when'"/>
    <xsl:variable name="temporal-attributes" as="element()">
        <choice>
            <general>
                <choice>
                    <attr>when</attr>
                    <attr>when-custom</attr>
                </choice>
            </general>
            <from-to>
                <from>
                    <choice>
                        <attr>notBefore</attr>
                        <attr>notBefore-custom</attr>
                        <attr>from</attr>
                        <attr>from-custom</attr>
                    </choice>
                </from>
                <to>
                    <choice>
                        <attr>notAfter</attr>
                        <attr>notAfter-custom</attr>
                        <attr>to</attr>
                        <attr>to-custom</attr>
                    </choice>
                </to>
            </from-to>
        </choice>
    </xsl:variable>
    <xsl:variable name="temporal-attribute-node-picked"
        select="$temporal-attributes//attr[. = $name-of-attr-desired]"/>
    <xsl:variable name="attribute-rivals"
        select="$temporal-attribute-node-picked/parent::choice/(attr except $temporal-attribute-node-picked)"/>
    <xsl:variable name="other-attributes-to-suppress"
        select="$temporal-attribute-node-picked/parent::choice/ancestor::*[parent::choice]/(following-sibling::*, preceding-sibling::*)//attr"/>

    <xsl:variable name="diagnostics-on" select="false()"/>

    <xsl:template match="*">
        <xsl:if test="$diagnostics-on">
            <attr-desired><xsl:value-of select="$name-of-attr-desired"/></attr-desired>
            <attr-rivals><xsl:value-of select="string-join($attribute-rivals, ' ')"/></attr-rivals>
            <other-attrs-to-suppress><xsl:value-of select="string-join($other-attributes-to-suppress, ' ')"/></other-attrs-to-suppress>
        </xsl:if>
        <xsl:copy>
            <xsl:copy-of
                select="@*[not(name(.) = ($attribute-rivals, $other-attributes-to-suppress))]"/>
            <xsl:attribute name="{$name-of-attr-desired}"
                select="(@*[name(.) = $attribute-rivals])[1]"/>
            <xsl:copy-of select="node()"/>
        </xsl:copy>
    </xsl:template>
</xsl:transform>
