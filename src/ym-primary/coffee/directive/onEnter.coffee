angular.module 'ahaLuminateApp'
  .directive 'ngEnter', [
    'APP_INFO'
    (APP_INFO) ->
        return function(scope, element, attrs) {
            element.bind("keydown keypress", function(event) {
                if(event.which === 13) {
                        scope.$apply(function(){
                                scope.$eval(attrs.ngEnter);
                        });
                        
                        event.preventDefault();
                }
            });
        };
  ]
