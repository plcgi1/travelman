'use strict';

function ParticipantsCtrl($scope,$element,$attrs,Participants) {
    $scope.participants =  Participants.query({}, function(data) {});
    $scope.dialog = $('#ParticipantsDlg');
    
    $scope.open = function (part) {
        $scope.part = part;
        $scope.dialog.modal('show');
    };

    $scope.close = function () {
        $scope.dialog.modal('hide');
    };
}
