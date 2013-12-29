	(function(){
'use strict';
var app = window.app;
app.controllers
    .controller('PulseCtrl', function ($scope,$http,$routeParams,$rootScope,$filter,Project,Mode,EventBus,ProjectInfo) {
        $scope.mode = 'pulse';
        function init (args) {
            $scope.project = Project.query(
                {project_id: $routeParams.project_id},
                function(data) {
                    $scope.project   = data[0];
                }
            );
        }
        
        $scope.$on('userDataLoaded',function(scope,data){
            $rootScope.loginStatus = data.loginStatus;
        });
                
        //setMode($routeParams.mode);
        if (!$scope.project) {
            init();
        }
    }
);
})();