(function(){
	'use strict';
// <navbar position="" model=""/>
var app = window.app;
app.directives
.directive('participants', function(Mode,Participants) {
    return {
        restrict: 'E',
        transclude: true,
        scope: true,
        templateUrl: 'views/lib/participants.html',
		controller: function($scope){
			$scope.addPartToProject = function(participant,index){
				
				if ( $scope.project.participants[index].selected === 'selected') {
					delete $scope.project.participants[index].selected;
				}
				else {
					$scope.project.participants[index].selected = 'selected';
				}
				Participants.save($scope.project);
			};
		},
        link: function(scope,el,attr){
			scope.mode = Mode.get(attr);
        }
    };
});
})();