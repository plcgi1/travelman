(function() {
	'use strict';
	var app = window.app;
	
	app.services.factory('Project', function($resource){
			return $resource('/ahs/projects?id=:project_id', {}, {
				query: {method:'GET', isArray:true}
			}
		);
	});
		
	app.services.factory('ProjectInfo', function($resource) {
		return $resource('/ahs/projects/project/info', {}, {
			save: {
				method: 'POST',
				isArray: true
			}
		});
	});
	app.services.factory('ProjectGoals', function($resource) {
		return $resource('/ahs/projects/project/goals', {}, {
			save: {
				method: 'POST',
				isArray: true
			}
		});
	});
	app.services.factory('ProjectGeo', function($resource) {
		return $resource('/ahs/projects/project/place', {}, {
			save: {
				method: 'POST',
				isArray: true
			},
			remove: {
				method: 'DELETE',
				isArray: true
			}
		});
	});
	app.services.factory('ProjectPhoto', function($resource) {
		return $resource('/ahs/projects/project/photo', {}, {
			save: {
				method: 'POST',
				isArray: true,
				headers: { 'Content-Type': false },
				transformRequest: angular.identity
			}
		});
	});
})();