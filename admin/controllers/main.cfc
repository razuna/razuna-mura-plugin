/*
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
*/ 
 
component persistent="false" accessors="true" output="false" extends="controller" {

	// *********************************  PAGES  *******************************************
	
	public any function before(required struct rc) {
		super.before(arguments.rc);
		muradsn			= $.globalConfig().getValue( "datasource" );
		muradsnusername	= $.globalConfig().getValue( "dbusername" );
		muradsnpassword	= $.globalConfig().getValue( "dbpassword" );
		
		rc.moduleid = rc.pluginconfig.getmoduleid();
		rc.settingObj = createobject("component","CFCs.settingsDAO").init(muradsn, muradsnusername, muradsnpassword);
	}
	
	public any function default(required rc) {
		
		rc.qSettings = rc.settingObj.getSettings(rc.moduleid);
		structSettings = settingsQueryToStruct(rc.qSettings);
		
		rc.settings.razuna_servertype = structkeydefault(structSettings,'razuna_servertype','');
		rc.settings.razuna_hostname = structkeydefault(structSettings,'razuna_hostname','');
		rc.settings.razuna_hostid = structkeydefault(structSettings,'razuna_hostid','');
		rc.settings.razuna_dampath = structkeydefault(structSettings,'razuna_dampath','');
		rc.settings.razuna_api_key = structkeydefault(structSettings,'razuna_api_key','');

	}
	
	public any function save(rc){

		rc.qSettings = rc.settingObj.getSettings(rc.moduleid);
		structSettings = settingsQueryToStruct(rc.qSettings);
		
			local.myList = rc.fieldnames;
			for(i=1;i lte listLen(local.myList);i=i+1){
				
				rc.name = listGetAt(local.myList,i);
				rc.settingValue = evaluate('rc.#rc.name#');
				
				if(structkeyExists(structSettings,rc.name)){
					rc.settingObj.update(rc);
				}
				else{
					rc.save = rc.settingObj.create(rc);
				}
			}
			fw.redirect('main');
				
	}

}