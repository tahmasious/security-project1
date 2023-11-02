from django.db import models
import jsonfield

# Create your models here.

class BackdoorData(models.Model):
    data = jsonfield.JSONField()
