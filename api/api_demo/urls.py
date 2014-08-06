""" API demo URL configuraion"""
from django.conf.urls import patterns, include, url
from django.views.generic.base import TemplateView

from rest_framework import routers

from . import views

# pylint variable constant check bypass
# pylint: disable-msg=C0103
router = routers.DefaultRouter()
router.register(r'posts', views.PostView, 'list')

# pylint variable constant check bypass
# pylint: disable-msg=C0103
urlpatterns = patterns('',
                       url(r'^$',
                           views.BlofView.as_view(),
                           name='home'),
                       url(r'^/api/', include(router.urls)),
                       )
