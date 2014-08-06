angular.module 'authAPI', ['ngResource']
	.config ['$httpProvider', ($httpProvider) ->
		$httpProvider.defaults.xsrfHeaderName = 'X-CSRFToken'
		$httpProvider.defaults.xsrfCookieName = 'csrftoken'
		return
	]

	.service 'authState', ->
		user: null

	.factory 'authAPI', ($resource) ->
		add_auth_header = (data, headersGetter) ->
			headers = headersGetter()
			headers['Authorization'] = ('Basic ' + btoa(data.username + ':' + data.password))
			return

		return {
			auth: $resource('api/auth/#', {}, {
				login: { method: 'POST', transformRequest: add_auth_header },
				logout: { method: 'DELETE' }
			}),
			users: $resource('api/users/#', {}, {
				create: { method: 'POST' }
			})
		}
