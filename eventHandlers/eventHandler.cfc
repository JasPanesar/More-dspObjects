<cfcomponent extends="mura.plugin.pluginGenericEventHandler">
	<cffunction name="onApplicationLoad">
		<cfargument name="event" />
		<cfset variables.pluginConfig.addEventHandler(this) />
	</cffunction>

	<cffunction name="onRenderStart" output="false" returntype="any">
		<cfargument name="event" />
		<cfscript>
			// this allows users to call the dspFeatures() method by accessing 'event.moreDspObjects.dspFeatures('portalid')'
			event.moreDspObjects = this;
		</cfscript>
		<!--- Add CSS to header --->
		<cfsavecontent variable="PowerToolsHeader">
			<cfoutput>
				<link rel="stylesheet" type="text/css" href="/plugins/#variables.pluginConfig.getDirectory()#/css/global.css" media="all" />
			</cfoutput>			
		</cfsavecontent>
		<cfhtmlhead text="#PowerToolsHeader#">
	</cffunction>

	<!--- PUBLIC METHODS --->
	<cffunction name="dspFeatures" access="public" output="false" returntype="string">
		<cfargument name="portalid" type="string" required="true" />
		<cfset var features = '<!-- Portal ID not valid -->' />
		<cfset var iterator = application.contentManager.getKidsIterator(ParentID='#portalid#',siteid='#request.siteid#') />
		<cfset var local = structNew() />
		<cfsavecontent variable="features">
			<cfloop condition="iterator.hasNext()">
				<cfscript>
					local.itemNav = iterator.next();
					local.item = local.itemNav.getContentBean();
					local.class = 'feature grid_4 ';
					// Generate Alpha's and Omega's
					if((iterator.currentIndex() MOD 3) EQ 1){
						local.class = local.class & 'alpha';
					}else if((iterator.currentIndex() MOD 3) EQ 0){
						local.class = local.class & 'omega';
					}
				</cfscript>
				<cfoutput>
					<div class="feature grid_4 class">
						<div class="feature-inner">
							<h3>#item.getValue('title')#</h3>
							<div class="image">
								<img src="#createHREFforImage(item.getValue('siteID'),item.getValue('fileID'),item.getValue('fileEXT'),'medium')#" alt="#item.getValue('title')#" />
							</div>
							#item.getValue('summary')#
						</div>
					</div>
				</cfoutput>
			</cfloop>
		</cfsavecontent>
		
		<cfreturn features />
	</cffunction>
	
	<!--- PRIVATE METHODS --->
<cffunction name="createHREFForImage" output="false" returntype="any">
	<cfargument name="siteID">
	<cfargument name="fileID">
	<cfargument name="fileExt">
	<cfargument name="size" required="true" default="large">
	<cfargument name="direct" required="true" default="true">
	<cfargument name="complete" type="boolean" required="true" default="false">
	<cfset var imgSuffix=arguments.size>
	<cfset var returnURL="">
	<cfset var begin=iif(arguments.complete,de('http://#application.settingsManager.getSite(arguments.siteID).getDomain()##application.configBean.getServerPort()#'),de('')) />
	
	<cfif arguments.direct and application.configBean.getFileStore() eq "fileDir">
		<cfif imgSuffix eq "large">
			<cfset imgSuffix="">
		<cfelse>
			<cfset imgSuffix="_" & imgSuffix>
		</cfif>
		<cfset returnURL=application.configBean.getAssetPath() & "/" & arguments.siteID & "/cache/file/" & arguments.fileID & imgSuffix & "." & arguments.fileEXT>
	<cfelse>
		<cfif imgSuffix eq "large">
			<cfset imgSuffix="file">
		</cfif>
		<cfset returnURL=application.configBean.getContext() & "/tasks/render/" & imgSuffix & "/?fileID=" & arguments.fileID>
	</cfif>
	
	<cfreturn begin & returnURL>
	
</cffunction>

</cfcomponent>

