(function(){
'use strict';
//angular.module('ahsServices', ['ngResource'])
var app = window.app;
app.services
	.factory('Participants', function($resource){
		return $resource('/ahs/projects/project/participants', {}, {
			query: {method:'GET', isArray:true},
			save: { method:'POST',isArray:false }
		}
	);
});
})();