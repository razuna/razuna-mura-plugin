<!---

Copyright (C) 2005-2008 Razuna Ltd.
 
  This file is part of Razuna - Enterprise Digital Asset Management.
 
  Razuna is free software: you can redistribute it and/or modify
  it under the terms of the GNU Affero Public License as published by
  the Free Software Foundation, either version 3 of the License, or
  (at your option) any later version.
 
  Razuna is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  GNU Affero Public License for more details.
 
  You should have received a copy of the GNU Affero Public License
  along with Razuna. If not, see <http://www.gnu.org/licenses/>.
 
  You may restribute this Program with a special exception to the terms
  and conditions of version 3.0 of the AGPL as described in Razuna's
  FLOSS exception. You should have received a copy of the FLOSS exception
  along with Razuna. If not, see <http://www.razuna.com/licenses/>.
 
 
  HISTORY:
  Date US Format		User					Note
  2013/04/10			CF Mitrah		 	Initial version
--->
<cfinclude template="../includes/fw1config.cfm" />
<cfoutput><plugin>
	<name>#variables.framework.package#</name>
	<package>#variables.framework.package#</package>
	<directoryFormat>packageOnly</directoryFormat>
	<provider>Razuna</provider>
	<providerURL>http://www.razuna.com</providerURL>
	<loadPriority>5</loadPriority>
	<version>#variables.framework.packageVersion#</version>
	<category>Application</category>
	<ormcfclocation />
	<customtagpaths />
	<mappings />
	<settings />
	<eventHandlers>
		<eventHandler event="onApplicationLoad" component="includes.eventHandler" persist="false" />
	</eventHandlers>
	<DisplayObjects />
</plugin></cfoutput>