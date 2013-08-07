(function(){
'use strict';
//angular.module('ahsServices', ['ngResource'])
var app = window.app;
app.services
	.factory('Settings', function($resource){
		return $resource('/ahs/settings', {}, {
			query: {method:'GET', isArray:false}
		}
	);
});
})();