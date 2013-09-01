(function(){
	'use strict';
	var app = window.app;
	app.directives.directive('enterSubmit', function ($parse) {
		return {
			restrict: 'A',
			scope: '&save',
			link: function (scope, element, attrs) {
				var submit = $parse(attrs.enterSubmit);
		
				$(element).on({
					keydown: function (e) {
						if (e.which === 13 && !e.shiftKey) {
							scope.$apply(function(){
								console.log(submit);
								submit(scope);
							});
							e.preventDefault();
						}
					}
				});
			}
		};
	});
})();
//app.directive('ngBlur',function($parse){
//	return function(scope,element,attrs){
//		var ngFocusGet = $parse(attrs.ngBlur);
//		console.log(scope);
//		element.bind("blur",function(){
//			scope.$apply(function(){
//				ngFocusGet(scope,false);
//			});  
//		});    
//	};
//});