from django.shortcuts import render
from .models import BackdoorData
from django.http.response import JsonResponse
from json.encoder import JSONEncoder
from django.views.decorators.csrf import csrf_exempt


def main_page(request):
    all_data_objs = BackdoorData.objects.all()
    print(all_data_objs)
    return render(request, 'main.html', {'datas': all_data_objs})

@csrf_exempt
def create_obj(request):
    if request.method == 'POST':
        BackdoorData.objects.create(data=request.POST)
        return JsonResponse({'status': 'ok'}, encoder=JSONEncoder, status=200)
    else:
        return JsonResponse({'status': 'bad request'}, encoder=JSONEncoder, status=400)
