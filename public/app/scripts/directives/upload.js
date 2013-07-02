// <navbar position="" model=""/>
var app = window.app;
app.directives
.directive('upload', function(Mode,EventBus) {
    return {
        restrict: 'E',
        transclude: true,
        scope: true,
        templateUrl: 'views/lib/upload.html',
		controller: function($scope){
			
		},
        link: function(scope,el,attr){
			var url = attr.target;
			
			scope.upload = function() {
				var loader = el.find('.progressbar')[0];
				loader.value = 0;
				var f = el.find('.user-file')[0];
				
				var upl = fileuploader({
					selector: '.user-file',
					url: url,
					onprogress: function(e){
						loader.value = Math.round((e.loaded / e.total) * 100);
					},
					oncomplete: function(e){
						var resp = eval ('('+e.target.response+')');
						
						loader.value = 100;
						f.value = '';
						EventBus.prepForBroadcast('uploadComplete','upload',resp);
					},
					onerror: function(e){
						loader.value = 0;
						//console.log(e);
					}
				});
			}
        }
    };
});