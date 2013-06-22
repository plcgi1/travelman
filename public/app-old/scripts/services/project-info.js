'use strict';
var app = window.app;
app.services.factory('ProjectInfo', function($resource){
		return $resource('/ahs/projects/project/info', {}, {
			save: { method:'POST', isArray:false}
		}
	)
});
app.services.factory('ProjectGoals', function($resource){
		return $resource('/ahs/projects/project/goals', {}, {
			save: { method:'POST',isArray:false }
		}
	)
});
app.services.factory('ProjectGeo', function($resource){
		return $resource('/ahs/projects/project/place', {}, {
			save: { method:'POST',isArray:false }
		}
	)
});
