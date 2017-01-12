<cfscript>
	function runquery (q, data){
			queryService = new query(); 
			/* set properties using implict setters */ 
			queryService.setDatasource(request.dsn); 
			queryService.setName("LocalQuery"); 
			/* Add sql queryparams using named and positional notation */ 

			for( i in arguments.data)
				queryService.addParam(name=i,value=arguments.data[i].value,cfsqltype=arguments.data[i].type); 

			/* invoke execute() on the query object to execute the query and return a component with properties result and prefix (which can be accessed as implcit getters) */ 
			result = queryService.execute(sql=arguments.q); 
			LocalQuery = result.getResult(); 
			if(not isdefined('localquery'))
				localQuery = result.getPrefix();
			return LocalQuery;
		}
		function getAllResults (q, data){
			queryService = new query(); 
			/* set properties using implict setters */ 
			queryService.setDatasource(request.dsn); 
			queryService.setName("LocalQuery"); 
			/* Add sql queryparams using named and positional notation */ 

			for( i in arguments.data)
				queryService.addParam(name=i,value=arguments.data[i].value,cfsqltype=arguments.data[i].type); 

			/* invoke execute() on the query object to execute the query and return a component with properties result and prefix (which can be accessed as implcit getters) */ 
			result = queryService.execute(sql=arguments.q); 
			LocalQuery = result.getResult(); 
			if(not isdefined('LocalQuery'))	
				LocalQuery = "";
			return {LocalQuery = LocalQuery, results = result.getPrefix()};
		}
		

</cfscript>
