component extends="taffy.core.api" {
	this.mappings['/resources'] = expandPath('/Taffy/resources');
	this.mappings['/taffy'] = expandPath('/Taffy');
	
	
	variables.framework.exceptionLogAdapter = "taffy.bonus.LogToScreenAndFile";
	
	
	function onrequeststart(page){
		request.dsn = 'mura_events';
		super.onrequeststart(arguments.page);
	}
}