(function(){
'use strict';
var app = window.app;
app.services
	.factory('Uploads', function($resource){
		return $resource('/ahs/settings/myquality', {}, {
			query: {method:'GET', isArray:false},
			remove: {
				method: 'DELETE',
				isArray: true
			}
		}
	);
});
})();