(function(){
'use strict';
var app = window.app;
app.controllers
    .controller('ProjectCtrl', function ($scope,$http,$routeParams,$rootScope,Project,Mode,EventBus,ProjectInfo,ProjectGoals,ProjectGeo) {
        var save = $('.save');
        var map = {
            'ProjectInfo' : ProjectInfo,
            'ProjectGoals' : ProjectGoals,
            'ProjectGeo' : ProjectGeo
        };
        function init (args) {
            $scope.project = Project.query(
                {project_id: $routeParams.project_id},
                function(data) {
                   
                    $scope.project   = data;
                    EventBus.prepForBroadcast('geoModelLoaded','model',$scope.project);
                },
                function (args) {
                    
                }
            );
        }
        
        $scope.dateOptions = { format: 'yyyy-mm-dd' };
       
        $scope.setMode = function(mode){
            $scope.mode = mode;
            $scope.canProjectSaved = false;
        };
        
        $scope.save = function(action,data){
            map[action].save($scope.project,function(data){
                if (!(data.goals && data.goals.length>0)) {
                    data.goals = [];
                }
                if (!(data.geo && data.geo.length>0)) {
                    data.geo = [];
                }
                $scope.project = data;
            });
        };
        
        $scope.$on('userDataLoaded',function(scope,data){
            $rootScope.loginStatus = data.loginStatus;
        });
        
        $scope.setMode($routeParams.mode);
        
        if (!$scope.project) {
            init();
        }
    }
);
})();