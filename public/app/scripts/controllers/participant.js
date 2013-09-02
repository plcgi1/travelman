(function(){
'use strict';
var app = window.app;
app.controllers
    .controller('ParticipantCtrl', function ($scope,$routeParams,Participants,EventBus) {
        $scope.participant =  Participants.query({ id : $routeParams.user_id }, function(data) {
			$scope.participant = data[0];
		});
    }
);
})();
