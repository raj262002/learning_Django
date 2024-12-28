# from django.http import HttpResponse
from django.shortcuts import render

from visits.models import PageVisit

#data
rooms = [
    {'id': 1, 'name': 'Lets learn python'},
    {'id': 2, 'name': 'lets learn Cpp'},
    {'id': 3, 'name': '1 is son of 2'}
]

def home_page_view(request, *args, **kwargs):
    queryset = PageVisit.objects.all()
    page_qs = PageVisit.objects.filter(path=request.path)
    context = {
                'rooms': rooms,
                'page_visit_count': page_qs.count(),
                'total_visit_count': queryset.count(),
             }
    PageVisit.objects.create()
    return render(request, 'home.html', context)

def room_page_view(request, pk):
    room = None
    for i in rooms:
        if i['id'] == int(pk):
            room = i
    context = {'room': room}
    return render(request, 'room.html', context)