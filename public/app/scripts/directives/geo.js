// <geo ng-model="project.geo" mode="view"></geo>
// in controller
(function(){
var app = window.app;
app.directives
.directive('geo', function(Mode,Project,ProjectGeo) {
    return {
        restrict: 'E',
        transclude: true,
        scope: true,
        templateUrl: 'views/lib/geo.html',
		controller: function($scope,$http,$element,$attrs,$q){
			
			var init = function(project){
				/** google map init code **/
				var position = new google.maps.LatLng(55.167596, 28.248897);
				
				var map_options = {
					zoom: 4,
					center: position,
					mapTypeId: google.maps.MapTypeId.ROADMAP
				};
				
				$scope.markers = [];
				$scope.loaded = {};
				$scope.map = new google.maps.Map($element.children()[0], map_options);
			};
			
			var geoModelLoaded = 0;

			init();		
			
			$scope.placeMarkers = function(markers){
				//console.log(markers)
				for (var i=0;i<markers.length;i++) {
					var location = new google.maps.LatLng(markers[i].lattitude,markers[i].longtitude,$scope.map);
					$scope.addMarker( location,$scope.map);
				}
			}
			
			$scope.placeMarker = function(event,map){
				$scope.addMarker(event.latLng);
			}
			$scope.addMarker = function(location){
				var marker = new google.maps.Marker({
					position: location, 
					map: $scope.map,
					//draggable: true,
					clickable: true
				});
				//$scope.map.setCenter(location);
				$scope.markers.push(marker);
				
				if ( $scope.mode === 'edit') {
					google.maps.event.addListener(marker, 'rightclick', function() {
						$scope.removeMarker(marker);
					});
									
				}
														
				return marker;
			}
			$scope.removeMarker = function(marker){
				var arr = [];

				for (var i=0;i<$scope.markers.length;i++ ) {
					var m = $scope.markers[i];

					if (m.getPosition().jb === marker.getPosition().jb && m.getPosition().kb === marker.getPosition().kb) {
						m.setMap(null);
						ProjectGeo.remove({
							id : $scope.project.id,
							lattitude: m.getPosition().jb,
							longtitude: m.getPosition().kb
						});
					}
					else {
						arr.push(m);
					}
				}
				$scope.markers = arr;
			}
			$scope.markMarker = function(marker,el){
				marker.setAnimation(google.maps.Animation.BOUNCE);
			};
			$scope.unmarkMarker = function(marker){
				marker.setAnimation(null);
			};
			
			$scope.$on('geoModelLoaded',function(evt,model){
				if (geoModelLoaded == 0) {
					geoModelLoaded = 1;
				}
				$scope.placeMarkers(model.geo,$scope.map);
				
			});
			$scope.$watch('markers',function(evt,model){
				console.log('makker add');
				console.log($scope.markers);
				if ($scope.markers.length == 0) {
					return;
				}
				
				for (var i=0;i<$scope.markers.length;i++ ) {
					if ( !$scope.loaded[i]) {
						ProjectGeo.save({
							id : $scope.project.id,
							lattitude: $scope.markers[i].jb,
							longtitude: $scope.markers[i].kb
						})
						$scope.loaded[i] = 1;
					}
				}
				
			});
			
			$scope.$watch('mode',function(){
				if (!angular.isDefined($scope.mode)) {
					return;
				}
				if ( $scope.mode === 'edit') {
					var listener = google.maps.event.addDomListener($scope.map, 'click', function(evt){
						$scope.placeMarker(evt,$scope.map);
					});
				}	
			});
				
		},
        link: function($scope,$el,$attr){
			$scope.mode 	= Mode.get($attr);
        }
    };
});

})();