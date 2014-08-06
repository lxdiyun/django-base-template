'use strict'

angular.module 'blof', ['ngResource', 'authAPI','ngAnimate', 'ngSanitize','ngToast']
	.config ['$httpProvider', ($httpProvider) ->
		$httpProvider.defaults.xsrfHeaderName = 'X-CSRFToken'
		$httpProvider.defaults.xsrfCookieName = 'csrftoken'
		return
	]

	.config ['ngToastProvider', (ngToast) ->
		ngToast.configure {
			verticalPosition: 'bottom',
			horizontalPosition: 'left'
		}
	]

	.factory 'api', ($resource) ->
		return {
			posts: $resource('api_demo/api/posts/#', {}, {
				list: { method: 'GET', isArray: true },
				create: { method: 'POST' },
				detail: { method: 'GET', url: 'api_demo/api/posts/:id' },
				delete: { method: 'DELETE', url: 'api_demo/api/posts/:id' }
			})
		}

	.controller 'authController', ($scope, authAPI, authState, ngToast) ->
		
		$scope.errorMessage = ""
		$scope.$watch 'errorMessage', (newValue, oldValue) ->
			if newValue
				ngToast.create({
					content: newValue,
					class: "warning"
				})

		$scope.authState = authState

		$scope.getCredentials = ->
			username: $scope.username, password: $scope.password

		$scope.login = ->
			authAPI.auth.login $scope.getCredentials()
			.$promise.then (data) ->
				authState.user = data.username
				return
			.catch (data) ->
				$scope.errorMessage = data.data.detail
				return
			return

		$scope.logout = ->
			authAPI.auth.logout ->
				authState.user = null
				return
			return

		$scope.register = ($event) ->
			$event.preventDefault()
			authAPI.users.create $scope.getCredentials()
				.$promise.then $scope.login
				.catch (data) ->
					if data.data.username
						$scope.errorMessage = data.data.username
					else if data.data.password
						$scope.errorMessage = data.data.password
					return

	.controller 'postController', ($scope, api, authState) ->
		$scope.authState = authState

		$scope.list = ->
			api.posts.list (data) ->
				$scope.posts = data
				return
			return
		$scope.list()

		$scope.create = ->
			data = body: $scope.body
			api.posts.create data, (data) ->
				$scope.body = ''
				$scope.posts.unshift(data)
				return
			return

		$scope.delete = (id) ->
			api.posts.delete {id: id}, ->
				$scope.posts.splice $scope.utils.getPostIndex(id), 1
				return
			return

		$scope.utils = getPostIndex: (id) ->
			return _.indexOf( $scope.posts, _.findWhere($scope.posts, {id: id}))
