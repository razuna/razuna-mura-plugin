<!---
 *
 * Copyright (C) 2005-2008 Razuna Ltd.
 *
 * This file is part of Razuna - Enterprise Digital Asset Management.
 *
 * Razuna is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Affero Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * Razuna is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Affero Public License for more details.
 *
 * You should have received a copy of the GNU Affero Public License
 * along with Razuna. If not, see <http://www.gnu.org/licenses/>.
 *
 * You may restribute this Program with a special exception to the terms
 * and conditions of version 3.0 of the AGPL as described in Razuna's
 * FLOSS exception. You should have received a copy of the FLOSS exception
 * along with Razuna. If not, see <http://www.razuna.com/licenses/>.
 *
 *
 * HISTORY:
 * Date US Format		User					Note
 * 2013/04/10			CF Mitrah		 	Initial version
 
--->

<cfcomponent output="false">
	
	<cffunction name="init" access="public" output="false" returntype="settingsDAO">
		<cfargument name="dsn" type="string" required="true">
		<cfargument name="dsnusername" type="string" required="true">
		<cfargument name="dsnpassword" type="string" required="true">

		<cfset variables.dsn = arguments.dsn>
		<cfset variables.dsnusername = arguments.dsnusername>
		<cfset variables.dsnpassword = arguments.dsnpassword>
		
		<cfreturn this>
	</cffunction>
	
	<cffunction name="create" output="false" returntype="Any">
		<cfargument name="setting" type="any" required="false">
		
		<cfset var qry = "">
		<cfquery name="qry" datasource="#variables.dsn#" username="#variables.dsnusername#" password="#variables.dsnpassword#">
			insert into tpluginsettings ( moduleID, name, settingValue )
			values
				(
					<cfqueryparam value="#arguments.setting.moduleID#" cfsqltype="cf_sql_char">,
					<cfqueryparam value="#arguments.setting.name#" cfsqltype="cf_sql_varchar">,
					<cfqueryparam value="#arguments.setting.settingValue#" cfsqltype="cf_sql_longvarchar">
				)
	 
		</cfquery>
			
		<cfreturn />
	</cffunction>
	
	<cffunction name="update" output="false" returntype="Any">
		<cfargument name="setting" type="any" required="false">
		
		<cfset var qry = "">
		<cfquery name="qry" datasource="#variables.dsn#" username="#variables.dsnusername#" password="#variables.dsnpassword#">
			update tpluginsettings set settingValue = <cfqueryparam value="#arguments.setting.settingValue#" cfsqltype="cf_sql_longvarchar">
			where name = <cfqueryparam value="#arguments.setting.name#" cfsqltype="cf_sql_char">
			and moduleID = <cfqueryparam value="#arguments.setting.moduleID#" cfsqltype="cf_sql_char">
		</cfquery>
		
	</cffunction>
	
	
	<cffunction name="getSettings" output="false" returntype="Any">
		<cfargument name="moduleID" type="any" required="true" >
		
		<cfset var qry = "">
		<cfquery name="qry" datasource="#variables.dsn#" username="#variables.dsnusername#" password="#variables.dsnpassword#">
			select * from tpluginsettings 
			where moduleID = <cfqueryparam value="#arguments.moduleID#" cfsqltype="cf_sql_varchar">
		</cfquery>
		
		<cfreturn qry>
	</cffunction>
	
</cfcomponent>