//(function(){
//'use strict';
//
//function ParticipantsCtrl($scope,$element,$attrs,Participants) {
//    $scope.participants =  Participants.query({}, function(data) {});
//    $scope.dialog = $('#ParticipantsDlg');
//    
//    $scope.open = function (part) {
//        $scope.part = part;
//        $scope.dialog.modal('show');
//    };
//
//    $scope.close = function () {
//        $scope.dialog.modal('hideWithTransition');
//    };
//}
//})();

(function(){
'use strict';
var app = window.app;
angular.module('AhsApp')
    .controller('ParticipantsCtrl', function ($scope,$element,$attrs,Participants) {
        $scope.participants =  Participants.query({}, function(data) {});
        $scope.dialog = $('#ParticipantsDlg');
        
        $scope.open = function (part) {
            $scope.part = part;
            $scope.dialog.modal('show');
        };
    
        $scope.close = function () {
            $scope.dialog.modal('hideWithTransition');
        };
    }
);
})();
