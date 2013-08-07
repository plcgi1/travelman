(function() {
    'use strict';
    // <projectinfo mode="view|edit"/>
    var app = window.app;
    app.directives.directive('projectinfo', function(Mode) {
        return {
            restrict: 'E',
            transclude: true,
            scope: true,
            templateUrl: 'views/lib/projectinfo.html',
            link: function(scope, el, attr) {
                scope.mode = Mode.get(attr);
            }
        };
    });
})();