(function(){
'use strict';
//angular.module('ahsServices', ['ngResource'])
var app = window.app;
app.services
	.factory('MyPassword', function($resource){
		return $resource('/ahs/settings/password', {}, {
			save: {
				method: 'POST',
				isArray: false
			}
		}
	);
});
})();