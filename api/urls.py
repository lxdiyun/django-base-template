""" API URLs configuraion """
from django.conf.urls import patterns, url, include
from rest_framework import routers

from .auth import views as auth_views


# pylint variable constant check bypass
# pylint: disable-msg=C0103
router = routers.DefaultRouter()
router.register(r'users', auth_views.UserView, 'list')


urlpatterns = patterns(
    '',
    url(r'^/', include(router.urls)),
    url(r'^/auth/$', auth_views.AuthView.as_view(), name='authenticate')
)
