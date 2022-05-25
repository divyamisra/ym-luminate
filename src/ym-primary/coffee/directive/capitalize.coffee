angular.module 'ahaLuminateApp'
  .directive 'ngCapitalize', ->
    (scope, element, attrs) ->
      element.bind 'blur', (el) ->
        if this.el.nativeElement.value
          arr: this.el.nativeElement.value.split('')
          arr[0] = arr[0].toUpperCase()
          this.el.nativeElement.value = arr.join('');
