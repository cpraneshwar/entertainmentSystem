from django.urls import path
from ms_graph.views import GetGraphAuthUrl, GraphRedirectUri, DemoNotify

urlpatterns = [
    path('get_graph_auth_api/', GetGraphAuthUrl.as_view()),
    path("graph_redirect_uri", GraphRedirectUri.as_view()),
    path("demo_notify", DemoNotify.as_view())
]
