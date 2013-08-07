(function(){
'use strict';
var app = window.app;
app.services
	.factory('Project', function($resource){
		return $resource('/ahs/projects?id=:project_id', {}, {
			query: {method:'GET', isArray:false}
		}
	);
});
})();