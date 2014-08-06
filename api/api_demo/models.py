""" API demo models """
#!/usr/bin/env python

from django.db import models
from django.contrib.auth.models import User

class PostModel(models.Model):
    """ Post model """
    body = models.CharField(max_length=500)
    date = models.DateTimeField(auto_now_add=True)
    date.editable = True
    user = models.ForeignKey(User,
                             blank=True,
                             null=True,
                             related_name='posts')

    def __unicode__(self):
        return self.body

    class Meta:
        """ Post meta """
        ordering = ['-date']
