(function() {
	'use strict';
	// <goals mode="view|edit"/>
	var app = window.app;
	app.directives.directive('uploads', function(Mode,Uploads,EventBus) {
		return {
			restrict: 'E',
			transclude: true,
			//<uploads target="/ahs/settings/myquality" name="myquality" uploadns="myqualityUploaded" model="scope.myquality"></uploads>
			scope: {
				target : '@target',
				name : '@name',
				uploadns : '@uploadns',
				model : '=model'
			},
			templateUrl: 'views/lib/uploads.html',
			controller: function($scope, $attrs,$http) {
						
				/*
				после успешной загрузки - показать кнопу - Добавить
				*/
								
				function removeUpload(item) {
					Uploads.remove(item,function(data){
						$scope.model=data;
					});
				}
				$scope.removeUpload = removeUpload;
			},
			link: function(scope, el, attr) {
				scope.mode = Mode.get(attr);
				scope.my_name = attr.name;
				var upload_ns = attr.uploadns;
				var url = attr.target;
				function upload() {
					var loader = el.find('.progressbar')[0];
					loader.value = 0;
					var f = el.find('[upload-name="'+scope.my_name+'"]')[0];

					var upl = fileuploader({
						selector: '[upload-name="'+scope.my_name+'"]',
						url: url,
						onprogress: function(e) {
							loader.value = Math.round((e.loaded / e.total) * 100);
						},
						oncomplete: function(e) {
							var resp = JSON.parse(e.target.response);

							loader.value = 0;
							f.value = '';
							EventBus.prepForBroadcast(upload_ns, 'upload', resp);
						},
						onerror: function(e) {
							loader.value = 0;
						}
					});
				}
				scope.upload = upload;
			}
		};
	});
})();