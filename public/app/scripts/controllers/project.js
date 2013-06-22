'use strict';
var app = window.app;
app.controllers
    .controller('ProjectCtrl', function ($scope,$http,$routeParams,$rootScope,Project,Mode,EventBus,ProjectInfo,ProjectGoals,appLoading) {
        var save = $('.save');
        var map = {
            'ProjectInfo' : ProjectInfo,
            'ProjectGoals' : ProjectGoals
        };
        
        //appLoading.loading();
        Project.get(
            {project_id: $routeParams.project_id},
            function(data) {
                //$scope.project   = {};
                //
                //for (var key in data) {
                //    $scope.project[key] = data[key];
                //}
                $scope.project   = data;
                //$scope.$broadcast('geoModelLoaded',data);
                EventBus.prepForBroadcast('geoModelLoaded','model',$scope.project);
                //appLoading.ready();
            },
            function (args) {
                
            }
        );
        $scope.dateOptions = { format: 'yyyy-mm-dd' };
        
        $scope.setMode = function(mode){
            $scope.mode = mode;
            $scope.canProjectSaved = false;
        };
        
        $scope.save = function(action,data){
            //appLoading.loading();
            map[action].save($scope.project,function(data){
                if (!(data.goals && data.goals.length>0)) {
                    data.goals = [];
                }
                if (!(data.geo && data.geo.length>0)) {
                    data.geo = [];
                }
                $scope.project = data;
                //appLoading.ready();
            });
        };
        
        $scope.$on('userDataLoaded',function(scope,data){
            $rootScope.loginStatus = data.loginStatus;
        });
        
        setTimeout(function(){
            $scope.setMode($routeParams.mode);
        },0);        
    }
);
