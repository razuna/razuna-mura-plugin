if ('CKEDITOR' in window) {

    (function () {
    
    	razunaPluginAdded = false;
    	
    	CKEDITOR.on('instanceReady', function(){
	    	
	    	
	    	
	    	
	    	if (razunaPluginAdded == false){
	    		
	    		razunaPluginAdded = true;
	    		
	    		$('#bodyContainer').prepend('<a href="javascript:renderRazunaWindow()">Razuna</a>');
	    		
	    		
				CKEDITOR.plugins.add( 'razuna', {
				    icons: 'razuna_icon',
				    init: function( editor ) {
				    	
				        editor.addCommand( 'razunaDialog', new CKEDITOR.dialogCommand( 'razunaDialog' ) );
				        
				        
		
				        editor.ui.addButton( 'Razuna', {
						    label: 'Insert image from razuna',
						    command: 'razunaDialog'
						});
						
				    }
				});	
				
				CKEDITOR.plugins.addExternal('razuna', '/plugins/RazunaPlugin/assets/js/CKEditor/razuna/plugin.js');
	    	}	
    	
		});
		
	})();

	function renderRazunaWindow(){
		
	}
}