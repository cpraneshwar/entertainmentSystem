"""e_system URL Configuration

The `urlpatterns` list routes URLs to views. For more information please see:
    https://docs.djangoproject.com/en/4.1/topics/http/urls/
Examples:
Function views
    1. Add an import:  from my_app import views
    2. Add a URL to urlpatterns:  path('', views.home, name='home')
Class-based views
    1. Add an import:  from other_app.views import Home
    2. Add a URL to urlpatterns:  path('', Home.as_view(), name='home')
Including another URLconf
    1. Import the include() function: from django.urls import include, path
    2. Add a URL to urlpatterns:  path('blog/', include('blog.urls'))
"""
from django.contrib import admin
from django.urls import path
from django.urls import include
from rest_framework import permissions
from drf_yasg.views import get_schema_view
from drf_yasg import openapi
from drf_yasg.generators import OpenAPISchemaGenerator
from rest_framework.authtoken import views
from django.views.static import serve
from django.conf import settings

urlpatterns = [
    path('rewards/', include('rewards.urls')),
    path('users/', include('users.urls')),
    path('auth/', views.obtain_auth_token),
    path('admin/', admin.site.urls),
    path(r'^media/(?P<path>.*)$', serve,{'document_root': settings.MEDIA_ROOT}), 
    path(r'^static/(?P<path>.*)$', serve,{'document_root': settings.STATIC_ROOT})

]



schema_view = get_schema_view(
    openapi.Info(
        title="Entertainmaint System API",
        default_version='v1',
        description="Entertainment System REST API Documentation",
    ),
    public=True,
    permission_classes=(permissions.AllowAny,),
    generator_class=OpenAPISchemaGenerator
)
urlpatterns.append(path('api_doc/', schema_view.with_ui('swagger', cache_timeout=0), name='schema-swagger-ui'))