<cfsilent>
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
</cfsilent>
<cfoutput>
	<div class="fieldset-wrap">
		<cfif structkeyexists (rc, "success")>
           <div class="alert alert-success">
               <button type="button" class="close" data-dismiss="alert">&times;</button>
               <strong>Success!</strong> #rc.success#
           </div>
		</cfif>
	<h2>Razuna plugin</h2>
	<form action="#buildurl('main.save')#" class="form-horizontal" method="post">
		<div class="fieldset">
			<div class="control-group">
				<label class="control-label" for="razuna_servertype">Server Type</label>
				<div class="controls">
					<label for="razuna_servertype_hosted" class="radio inline">
						<input type="radio" name="razuna_servertype" onchange="checkServerType();"value="hosted" id="razuna_servertype_hosted" <cfif rc.settings.razuna_servertype eq "hosted">checked="checked"</cfif>> Hosted (razuna.com)
					</label>
					<label for="razuna_servertype_self" class="radio inline">
						<input type="radio" name="razuna_servertype" onchange="checkServerType();" value="self" id="razuna_servertype_self" <cfif rc.settings.razuna_servertype eq "self">checked="checked"</cfif>> Self hosted
					</label>
				</div>
			</div>
			<div class="control-group">
				<label class="control-label" for="razuna_hostname">Hostname</label>
				<div class="controls">
					<input type="text" class="regular-text code" value="#rc.settings.razuna_hostname#" id="razuna_hostname" name="razuna_hostname"> 
					<span class="help-block">Example: yourcompany.razuna.com or localhost:8080/razuna</span>
				</div>
			</div>
			
			<div class="control-group">
				<label class="control-label" for="razuna_hostid">Host ID</label>
				<div class="controls">
					<input type="text" class="regular-text code" value="#rc.settings.razuna_hostid#" id="razuna_hostid" name="razuna_hostid"> 
					<span class="help-block">Example: 496</span>
				</div>
			</div>
			
			<div class="control-group">
				<label class="control-label" for="razuna_dampath">DAM Path</label>
				<div class="controls">
					<input type="text" class="regular-text code" value="#rc.settings.razuna_dampath#" id="razuna_dampath" name="razuna_dampath"> 
					<span class="help-block">Example: /demo/dam</span>
				</div>
			</div>
			
			<div class="control-group">
				<label class="control-label" for="razuna_api_key">API Key</label>
				<div class="controls">
					<input type="text" class="regular-text code" value="#rc.settings.razuna_api_key#" id="razuna_api_key" name="razuna_api_key">
				</div>
			</div>
			
		</div>
			
		<div class="form-actions span8">
		    <button type="submit" class="btn">Save changes</button>
		    <button type="button" class="btn">Cancel</button>
	    </div>
		 
	</form>
	</div>
</cfoutput>