from django.contrib import admin
from django.urls import path, include
from .views import main_page, create_obj
urlpatterns = [
    path('', main_page),
    path('create/', create_obj)
]
