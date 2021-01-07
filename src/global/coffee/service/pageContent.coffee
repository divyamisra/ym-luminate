angular.module 'ahaLuminateApp'
  .factory 'PageContentService', [
    '$http'
    ($http) ->
      getPageContent: (page) ->
        requestUrl = luminateExtend.global.path.nonsecure
        if window.location.protocol is 'https:'
          requestUrl = luminateExtend.global.path.secure + 'S'
        $http
          method: 'GET'
          url: requestUrl + 'PageServer?pagename=getPageContent&pgwrap=n&get_pagename='+ page
        .then (response) ->
          response.data
          
  ]
