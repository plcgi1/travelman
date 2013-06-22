// <goals mode="view|edit"/>
var app = window.app;
app.directives
.directive('goals', function(Mode,ProjectGoals) {
    return {
        restrict: 'E',
        transclude: true,
        scope: true,
        templateUrl: 'views/lib/goals.html',
		controller: function($scope,$attrs){
		  $scope.addGoal = function(project){
			if (!project && !project.goals) {
				project = {};
				project.goals = [];
			}
			project.goals.push({name:''});
		  },
		  $scope.remove = function(project,goal){
			var arr = [];
			for (var i=0;i<project.goals.length;i++ ) {
				console.log(project.goals[i]);
				if ( goal.name != project.goals[i].name ) {
					arr.push(project.goals[i]);
				}
			}
			project.goals = arr;
			ProjectGoals.save($scope.project);
		  };
		},
        link: function(scope,el,attr){
		  scope.mode = Mode.get(attr);
        }
    };
});