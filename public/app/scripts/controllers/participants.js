(function(){
'use strict';
var app = window.app;
angular.module('AhsApp')
    .controller('ParticipantsCtrl', function ($scope,$element,$attrs,Participants) {
        $scope.participants =  Participants.query({}, function(data) {});
    }
);
})();
