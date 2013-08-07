(function() {
	'use strict';
	var app = window.app;
	app.services.factory('Auth', function($resource, EventBus) {
		return $resource('/ahs/auth', {}, {
			logout: {
				method: 'DELETE',
				isArray: false,

				error: function(data, status, headers, config) {
					
					return false;
				}
			}
		});
	});
})();