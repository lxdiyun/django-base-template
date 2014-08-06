""" demo views """
from django.views.generic.base import TemplateView
from django.contrib.auth.models import User
from rest_framework import viewsets

from . import models, serializers
from ..auth import permissions

# pylint: disable=too-many-ancestors, too-many-public-methods
class PostView(viewsets.ModelViewSet):
    """view that serves posts"""
    model = models.PostModel
    serializer_class = serializers.PostSerializer
    permission_classes = (permissions.IsOwner,)

    def pre_save(self, obj):
        # add user to object if user is logged in
        if isinstance(self.request.user, User):
            obj.user = self.request.user

class BlofView(TemplateView):
    template_name = "blof.html"

    def get(self, request, *args, **kwargs):
        print request.META
        return super(BlofView, self).get(request, args, kwargs)

