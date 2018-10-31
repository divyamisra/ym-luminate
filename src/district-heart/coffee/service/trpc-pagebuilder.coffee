angular.module 'trPcApp'
  .factory 'PageBuilderService', [
    '$rootScope'
    '$http'
    '$q'
    ($rootScope, $http, $q) ->
      getPageContent: (pbPageName, additionalArguments) ->
        if not $rootScope.pageBuilderCache
          $rootScope.pageBuilderCache = {}
        if $rootScope.pageBuilderCache[pbPageName]
          deferred = $q.defer()
          deferred.resolve $rootScope.pageBuilderCache[pbPageName]
          deferred.promise
        else
          dataString = 'pagename=getPageBuilderPageContent&pgwrap=n'
          dataString += '&pb_page_name=' + pbPageName if pbPageName
          if additionalArguments
            dataString += '&' + additionalArguments
          pageserver = "PageServer"
          if location.protocol == "https:"
            pageserver = "SPageServer"
          $http
            method: 'GET'
            url: pageserver + '?' + dataString
            headers:
              'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8'
          .then (response) ->
            if pbPageName
              $rootScope.pageBuilderCache[pbPageName] = response
              response
]
