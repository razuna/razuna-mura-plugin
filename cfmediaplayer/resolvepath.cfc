<!---
	Document:		resolvepath.cfc
	Author:			Stephen J. Withington, Jr. (steve [at] stephenwithington [dot] com)
	Version:		20100223.01
	Purpose:		I convert my absolute directory path into my url equivalent path.
					If you place me outside of the webroot, then please pass the
					'virtual directory' (iis) or 'alias' (apache) path to 
					init(basedir='/YourVirtualOrAliasDirectoryNameHere').
	Notes:			No longer assume this is installed on a Windows machine, getting
					file separator from java.io.File. (Thanks Matt Levine!)
--->
<cfcomponent displayname="resolvepath" output="false">

	<cffunction name="init" access="public" output="false" returntype="any">
		<cfargument name="basedir" required="false" default="" />
		<cfscript>
			variables.attributes = structNew();
			variables.attributes.basedir = arguments.basedir;
			variables.attributes.urlpath = "";
			variables.attributes.fileObj = createObject('java','java.io.File');
			variables.attributes.fileDelim = variables.attributes.fileObj.separator;
			setURLPath();
		</cfscript>
		<cfreturn this />
	</cffunction>

	<cffunction name="getURLPath" access="public" output="false" returntype="string">
		<cfreturn variables.attributes.urlpath />
	</cffunction>

	<cffunction name="setURLPath" access="private" output="false" returntype="void">
		<cfscript>
			var local = structNew();			
			if ( structKeyExists(variables.attributes, "basedir") and len(trim(variables.attributes.basedir)) ) {
				variables.attributes.urlpath = variables.attributes.basedir;
				// let's make sure we're getting an absolute url path
				if ( left(variables.attributes.urlpath, 1) neq "/" ) {
					variables.attributes.urlpath = "/" & variables.attributes.urlpath;
				}
			} else {
				local.basedir 	= ExpandPath("/");
				local.baselen 	= listlen(local.basedir, variables.attributes.fileDelim);
				local.thispath	= getDirectoryFromPath(getCurrentTemplatePath());		
				if ( local.baselen gt 0 ) {
					for ( i=1; i lte local.baselen; i=i+1 ) {
						local.thispath = listDeleteAt(local.thispath, 1, variables.attributes.fileDelim);
					};
					local.thispath 	= listChangeDelims(local.thispath, "/", variables.attributes.fileDelim);
					local.thispath 	= "/" & local.thispath;
					// sometimes you get '//directory/name' so let's clean that up, just in case
					if ( left(local.thispath, 2) eq "//" ) {
						removeChars(local.thispath, 1, 1);
					}
				} else {
					local.thispath 	= "";
				}
				variables.attributes.urlpath = local.thispath;
			}
		</cfscript>
	</cffunction>

</cfcomponent>