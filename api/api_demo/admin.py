""" api demo admin """
from django.contrib import admin

from .models import PostModel

admin.site.register(PostModel)
