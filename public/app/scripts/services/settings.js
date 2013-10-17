(function(){
'use strict';
//angular.module('ahsServices', ['ngResource'])
	var app = window.app;
	app.services
		.factory('Settings', function($resource){
			return $resource('/ahs/settings/mydata', {}, {
				query: {method:'GET', isArray:false},
				save: {
					method: 'POST',
					isArray: false
				}
			}
		);
	});
	
	app.services.factory('PassportInfo', function($resource) {
		return $resource('/ahs/settings/passport', {}, {
			save: {
				method: 'POST',
				isArray: false
			}
		});
	});
})();