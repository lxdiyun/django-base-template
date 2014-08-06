""" Default urlconf for {{ project_name }} """

from django.conf import settings
from django.conf.urls import include, patterns, url
from django.contrib import admin
admin.autodiscover()


def bad(request):
    """ Simulates a server error """
    1 / 0

# pylint variable constant check bypass
# pylint: disable-msg=C0103
urlpatterns = patterns('',
                       # Examples:
                       # url(r'^$', '{{ project_name }}.views.home', name='home'),
                       # url(r'^blog/', include('blog.urls')),
                       url(r'^admin/', include(admin.site.urls)),
                       url(r'^bad/$', bad),
                       url(r'', include('base.urls')),
                       url(r'api', include('api.urls')),
                       url(r'api_demo', include('api.api_demo.urls')),)


if settings.DEBUG:
    import debug_toolbar
    urlpatterns += patterns('',
                            url(r'^__debug__/', include(debug_toolbar.urls)),
                            )
