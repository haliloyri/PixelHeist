"""Five original low-resolution interpretations of documented paintings."""
from build_content import canvas,rect,poly,ellipse
import math

def mona():
    a=canvas(24,30,0)
    for y in [3,7,10]:
        for x in range(24):
            if y+round(math.sin(x*.5)*2)<13:rect(a,x,y+round(math.sin(x*.5)*2),1,2,1)
    poly(a,[(0,17),(7,10),(10,12),(4,20),(0,21)],2)
    poly(a,[(24,13),(18,16),(20,21),(24,20)],2)
    poly(a,[(2,30),(3,22),(7,17),(17,17),(22,23),(23,30)],3)
    ellipse(a,12,11,6,8,3)
    ellipse(a,12,11,4,6,4)
    rect(a,10,16,5,4,4)
    poly(a,[(6,21),(10,19),(14,21),(19,22),(19,25),(9,24)],2)
    poly(a,[(5,25),(8,23),(13,25),(18,25),(18,27),(10,27)],4)
    rect(a,10,10,2,1,3);rect(a,14,10,2,1,3);rect(a,12,13,2,1,2)
    rect(a,11,15,4,1,2);rect(a,12,15,2,1,5)
    return a

def kiss():
    a=canvas(26,28,0)
    for y in range(1,26,4):
        for x in range((y%3),26,5):rect(a,x,y,1,1,1)
    ellipse(a,12,26,14,4,4)
    for x in range(0,26,3):rect(a,x,26+(x%2),1,1,5)
    poly(a,[(6,27),(5,11),(10,5),(16,5),(21,13),(20,26)],1)
    poly(a,[(6,26),(7,10),(12,7),(14,16),(12,26)],2)
    for y in range(13,25,4):
        for x in [8,11]:rect(a,x,y,1,2,3)
    poly(a,[(13,11),(18,10),(20,14),(20,26),(12,26)],1)
    for x,y in [(15,15),(17,19),(15,23),(19,24)]:ellipse(a,x,y,1,1,5)
    ellipse(a,15,9,3,3,5);poly(a,[(9,8),(10,4),(14,3),(17,5),(15,9)],3)
    poly(a,[(14,5),(17,6),(18,8),(16,10),(14,9)],5)
    rect(a,17,9,2,1,3);rect(a,17,11,1,1,3)
    poly(a,[(12,11),(13,9),(15,10),(16,14),(15,15)],5)
    return a

def scream():
    a=canvas(24,30,0)
    for y,c in [(2,1),(5,2),(8,1),(11,2)]:
        for x in range(24):rect(a,x,y+round(math.sin(x*.35)*1.5),1,2,c)
    poly(a,[(24,10),(17,12),(20,15),(13,20),(24,21)],3)
    poly(a,[(0,12),(24,27),(24,30),(0,30)],4)
    for off in [0,4,8]:poly(a,[(0,12+off),(24,27+off),(24,28+off),(0,13+off)],5)
    rect(a,2,12,1,6,5);rect(a,5,14,1,6,5)
    poly(a,[(9,30),(8,24),(10,20),(15,20),(17,26),(16,30)],5)
    ellipse(a,12,19,3,4,2)
    rect(a,10,18,1,1,5);rect(a,14,18,1,1,5);ellipse(a,12,21,1,1.8,5)
    poly(a,[(7,24),(8,19),(9,19),(10,25)],2)
    poly(a,[(15,24),(16,19),(17,19),(17,25)],2)
    return a

def venus():
    a=canvas(34,22,0)
    for y in range(7,20,3):
        for x in range(0,27,4):rect(a,x+(y%2),y,2,1,1)
    poly(a,[(26,0),(34,0),(34,22),(27,19),(29,8)],4)
    for y in range(1,16,4):ellipse(a,31,y,2,2,3)
    ellipse(a,17,20,9,2,2)
    for x in [10,13,16,19,22]:poly(a,[(17,18),(x,21),(x+1,21)],5)
    poly(a,[(16,20),(15,16),(15,10),(14,7),(16,4),(19,4),(20,9),(19,13),(19,19),(18,21)],2)
    ellipse(a,17,4,2,2.5,5);ellipse(a,17,4,1.3,1.9,2)
    poly(a,[(19,4),(21,9),(19,14),(18,13),(20,8)],5)
    rect(a,17,4,1,1,4);poly(a,[(16,9),(20,10),(19,11),(16,10)],5)
    poly(a,[(18,12),(17,17),(18,19),(19,14)],5)
    ellipse(a,6,8,2,2,2);poly(a,[(3,10),(6,6),(10,9),(8,14)],3)
    poly(a,[(2,4),(7,5),(5,8),(1,8)],2)
    ellipse(a,28,7,1.5,2,2);poly(a,[(26,10),(29,8),(32,19),(26,19)],3)
    poly(a,[(23,8),(27,8),(28,14),(21,12)],5)
    return a

def lilies():
    a=canvas(32,22,0)
    for y in range(22):
        for x in range(32):
            f=math.sin(x*.4+y*.6)+math.sin(x*.7-y*.3)
            if f>.65:a[y][x]=1
            elif f<-.9:a[y][x]=2
    for x,y,rx in [(4,5,3),(13,8,4),(25,4,3),(6,16,4),(19,17,4),(27,13,3)]:
        ellipse(a,x,y,rx,1.4,3)
        rect(a,x,y,1,1,0)
        ellipse(a,x-1,y-1,1,1,4);rect(a,x-1,y-2,1,1,5)
    for x in [1,8,18,29]:
        for y in range(0,5+(x%4)):rect(a,x+(y//3),y,1,1,3)
    return a

META2=[
('Sessiz Gülümseme','Mona Lisa','PARİS', ['#5c7773','#89a499','#a88955','#303c35','#dfbf82','#b69564'],mona,
 'Sprocket','Yalnızca tabloda olmayan renklerin barı var. Bar bitince bu renk sıradan çıkar.', 'Rocco','Gülümsemenin sırrı hâlâ onda.', 'Kuyrukta her renk işe yaramaz.'),
('Altın Temas','Öpücük','VİYANA',['#9a8354','#e8c765','#bd9d51','#303c38','#647c54','#eed4a2'],kiss,
 'Rocco','Altın tonları birbirine yakın. Seçmeden önce resmin kenarını kontrol et.', 'Sprocket','Altın yapraklar güvenli kasada.', 'Göründüğü kadar basit bir altın değil.'),
('Sessiz Çığlık','Çığlık','OSLO',['#c57543','#e9a75e','#e8c68a','#526e7d','#9d6847','#303d43'],scream,
 'Sprocket','Tabloda olmayan renk seçilemez. Barı bitince sıradaki kutu açılır.', 'Rocco','Bu gece alarm sustu.', 'Manzaranın kıvrımları bile huzursuz.'),
('Denizden Gelen','Venüs’ün Doğuşu','FLORANSA',['#82adae','#b9d0bd','#f1d4a4','#c69479','#557b68','#b98b4b'],venus,
 'Rocco','Açık tonları karşılaştır. Tablodaki renkler seni bekler; süreleri dolmaz.', 'Sprocket','Kıyıya sağ salim ulaştı.', 'Bir doğumdan çok, bir varış anı.'),
('Suyun Hafızası','Nilüferler','GIVERNY',['#708c9f','#91a6b7','#677a99','#789b75','#e8c5cd','#ede5c8'],lilies,
 'Sprocket','Son tablo. Yansımaları renklerle karıştırma.', 'Rocco','Galeri artık ışıkla dolu.', 'Gökyüzü görünmez; yansıması bütün resmi doldurur.')]
