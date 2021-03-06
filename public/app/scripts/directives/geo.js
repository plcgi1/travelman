// <geo ng-model="project.geo" mode="view"></geo>
// in controller
(function() {
	'use strict';
	var app = window.app;
	app.directives.directive('geo', function($compile, Mode, Project, ProjectGeo) {
		return {
			restrict: 'E',
			transclude: true,
			scope: true,
			templateUrl: 'views/lib/geo.html',
			controller: function($scope, $http, $element, $attrs, $q) {
				var infoWindow;
				var geoModelLoaded = 0;

				this.setInfowindow = function(infoWnd) {
					infoWindow = infoWnd;
				};

				$scope.$on('geoModelLoaded', function(evt, model) {
					if (geoModelLoaded === 0) {
						geoModelLoaded = 1;
					}
					placeMarkers(model.geo, $scope.map);
				});

				$scope.$watch('mode', function() {
					if (!angular.isDefined($scope.mode)) {
						return;
					}
					if ($scope.mode === 'edit') {
						google.maps.event.addDomListener($scope.map, 'click', function(evt) {
							var marker = $scope.addMarker(evt.latLng);
							openInfoWindow({marker:marker});
						});
					}
				});

				function openInfoWindow(obj) {
					if (!obj.marker) {
						var center = $scope.map.getCenter();
						obj.marker = new google.maps.Marker({
							position: new google.maps.LatLng({
								lat: center.lat(),
								lng: center.lng()
							}),
							map: $scope.map,
							//draggable: true,
							clickable: true
						});

					}
					$scope.currentMarker = {
						lat: obj.marker.getPosition().lat(),
						lng: obj.marker.getPosition().lng(),
						name: obj.marker.getTitle(),
						id: obj.id
					};

					if (!$scope.$$phase) {
						$scope.$apply();
					}
					infoWindow.open($scope.map, obj.marker);
				}

				function addMarker(location, id, name) {
					var marker = new google.maps.Marker({
						position: location,
						map: $scope.map,
						//draggable: true,
						clickable: true
					});

					marker.setTitle(name);
					$scope.markers.push({
						marker: marker,
						id: id,
						name: marker.getTitle(),
						lat: marker.getPosition().lat(),
						lng: marker.getPosition().lng()
					});

					if ($scope.mode === 'edit') {
						marker.setDraggable(true);

						google.maps.event.addDomListener(marker, 'click', function(evt) {
							infoWindow.setPosition(location);
							$scope.openInfoWindow({
								marker: marker,
								id: id
							});
						});
						google.maps.event.addDomListener(marker, 'dragend', function(evt) {
							$scope.currentMarker = {
								lat: evt.latLng.lb,
								lng: evt.latLng.mb,
								name : marker.getTitle(),
								id: id
							};
							$scope.openInfoWindow({
								marker: marker,
								id: id
							});
							if (!$scope.$$phase) {
								$scope.$apply();
							}
						});
					}
					return marker;
				}

				function placeMarkers(markers) {
					for (var i = 0; i < markers.length; i++) {
						var location = new google.maps.LatLng(markers[i].lattitude, markers[i].longtitude, $scope.map);
						addMarker(location, markers[i].id, markers[i].name);
					}
					if (markers.length > 0) {
						$scope.map.setCenter(new google.maps.LatLng(markers[0].lattitude, markers[0].longtitude, $scope.map));
					} else {
						var position = new google.maps.LatLng(55.167596, 28.248897);
						$scope.map.setCenter(position);
					}
				}

				function removeMarker(marker) {
					var arr = [];

					for (var i = 0; i < $scope.markers.length; i++) {
						var m = $scope.markers[i].marker;
						if (m.getPosition().lat() === marker.marker.getPosition().lat() && m.getPosition().lng() === marker.marker.getPosition().lng()) {
							m.setMap(null);
							ProjectGeo.remove({
								id: $scope.project.id,
								lattitude: m.getPosition().lat(),
								longtitude: m.getPosition().lng()
							});
						} else {
							arr.push($scope.markers[i]);
						}
					}
					$scope.markers = arr;
				}

				function markMarker(marker, el) {
					marker.marker.setAnimation(google.maps.Animation.BOUNCE);
				}

				function unmarkMarker(marker) {
					marker.marker.setAnimation(null);					
				}

				function saveGeo() {
					var arr = [];

					for (var i = 0; i < $scope.markers.length; i++) {
						var m = $scope.markers[i].marker;
						arr.push($scope.markers[i]);
						if ( $scope.markers[i].id === $scope.currentMarker.id ) {
							$scope.markers[i].name	= $scope.currentMarker.name;
							$scope.markers[i].lat	= $scope.currentMarker.lat;
							$scope.markers[i].lng	= $scope.currentMarker.lng;
							
							ProjectGeo.save({
								id:			$scope.project.id,
								lattitude:	m.getPosition().lat(),
								longtitude: m.getPosition().lng(),
								name:		$scope.currentMarker.name,
								location_id: $scope.currentMarker.id
							});
							
							infoWindow.close();
						}
					}
					$scope.markers = arr;
					
				}

				$scope.placeMarkers = placeMarkers;
				$scope.openInfoWindow = openInfoWindow;
				$scope.addMarker = addMarker;
				$scope.removeMarker = removeMarker;
				$scope.markMarker = markMarker;
				$scope.unmarkMarker = unmarkMarker;
				$scope.saveGeo = saveGeo;
			},
			link: function($scope, $element, $attr, $ctrl) {
				$scope.mode = Mode.get($attr);

				var map_options = {
					zoom: 4,
					//center: position,
					mapTypeId: google.maps.MapTypeId.ROADMAP
				};

				$scope.markers = [];
				$scope.map = new google.maps.Map($element.children()[0], map_options);

				var infoWindowTemplate = $element.find('#geoplaceDlg')[0].innerHTML.trim();
				var infoWindowElem = $compile(infoWindowTemplate)($scope);

				var infowindow = new google.maps.InfoWindow({
					content: infoWindowElem[0]
				});
				$ctrl.setInfowindow(infowindow);

				var placeInfoTemplate = $element.find('#geoplaceData')[0].innerHTML.trim();
				var placeInfoElem = $compile(placeInfoTemplate)($scope);
				$scope.map.controls[google.maps.ControlPosition.RIGHT_TOP].push(placeInfoElem[0]);
			}
		};
	});

})();