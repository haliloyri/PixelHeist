"""Paris paintings interpreted as tile art; Level 3 enters from below only."""
from build_content import canvas, rect, poly, ellipse


def gleaners():
    a = canvas(28,22,0)
    rect(a,0,7,28,15,1)
    for x in range(0,28,4):
        poly(a,[(x,9),(x+2,5),(x+5,9)],2)
    rect(a,0,11,28,11,2)
    for x,y,c in [(4,13,3),(12,14,4),(21,12,1)]:
        poly(a,[(x-2,y+2),(x,y-2),(x+3,y-2),(x+5,y),(x+3,y+2)],c)
        ellipse(a,x+4,y,1.4,1.3,5)
        poly(a,[(x+3,y+1),(x+5,y+1),(x+3,y+5),(x+2,y+5)],5)
        poly(a,[(x-2,y+1),(x+1,y+2),(x+1,y+6),(x-1,y+6)],4)
        rect(a,x-2,y+6,4,1,3)
    for x in range(1,28,3): rect(a,x,20-(x%3),2,1,1)
    return a


def magpie():
    a = canvas(28,22,0)
    rect(a,0,10,28,12,1)
    poly(a,[(0,16),(28,13),(28,16),(0,20)],2)
    rect(a,1,5,9,5,3)
    poly(a,[(0,5),(5,2),(11,5)],1)
    rect(a,21,0,1,12,4)
    poly(a,[(21,6),(15,1),(16,1),(22,5)],4)
    poly(a,[(21,4),(27,0),(28,0),(22,6)],4)
    rect(a,0,12,28,1,3);rect(a,0,15,28,1,3)
    for x in range(1,28,4):rect(a,x,11,1,7,3);rect(a,x-1,11,3,1,1)
    rect(a,10,11,7,1,1)
    rect(a,13,9,2,2,4);rect(a,14,8,1,1,4);rect(a,15,9,1,1,5)
    rect(a,11,10,3,1,4)
    for x in [2,9,18,24]:rect(a,x,19,3,1,5)
    return a


def star():
    a=canvas(24,26,0)
    poly(a,[(0,0),(12,0),(8,9),(3,17),(0,18)],1)
    poly(a,[(17,0),(24,0),(24,15),(19,10)],1)
    for x,y in [(3,5),(20,4),(5,11)]:ellipse(a,x,y,2,3,2)
    ellipse(a,12,9,2,2,4)
    rect(a,11,7,3,1,1)
    poly(a,[(10,11),(14,11),(15,16),(10,16)],3)
    poly(a,[(11,12),(6,10),(3,7),(4,6),(8,9),(12,10)],4)
    poly(a,[(14,11),(18,9),(21,6),(22,7),(19,11),(14,13)],4)
    poly(a,[(10,14),(15,14),(20,19),(17,21),(7,21),(4,19)],3)
    poly(a,[(10,16),(8,20),(10,20),(12,16)],5)
    poly(a,[(15,16),(18,20),(16,20),(13,16)],5)
    rect(a,11,21,2,4,4)
    poly(a,[(14,21),(15,21),(18,24),(17,25),(13,23)],4)
    rect(a,11,25,3,1,3)
    rect(a,12,12,2,1,5)
    return a


def dance():
    a=canvas(28,22,0)
    for x,y in [(2,1),(9,3),(18,1),(25,4)]:ellipse(a,x,y,5,4,1)
    for x in [3,15,25]:rect(a,x,0,1,9,2)
    for x,y in [(6,3),(20,4),(12,6)]:ellipse(a,x,y,1,1,5)
    for x,y in [(3,10),(9,9),(15,11),(22,9),(26,13),(5,17),(14,17),(21,17)]:
        ellipse(a,x,y,1.5,1.5,4)
        poly(a,[(x-2,y+2),(x+2,y+2),(x+3,y+6),(x-3,y+6)],2 if x%2 else 3)
        rect(a,x-2,y-2,4,1,5 if x%2 else 2)
        if x%2:rect(a,x,y+3,1,2,5)
    poly(a,[(11,20),(22,19),(27,22),(10,22)],0)
    rect(a,18,19,1,2,5);rect(a,23,20,1,1,5)
    return a


def fruit():
    a=canvas(28,22,0)
    poly(a,[(0,0),(8,0),(5,8),(0,14)],1)
    poly(a,[(23,0),(28,0),(28,20),(20,9)],1)
    rect(a,0,13,28,9,2)
    poly(a,[(4,10),(19,9),(26,15),(22,22),(7,22),(8,17),(1,15)],3)
    poly(a,[(9,12),(13,13),(11,22),(8,22),(10,16)],0)
    poly(a,[(19,12),(23,15),(18,21),(16,21),(20,16)],0)
    ellipse(a,20,7,3,4,3);ellipse(a,23,7,2,2,3);ellipse(a,23,7,1,1,0)
    rect(a,18,3,4,1,1)
    ellipse(a,11,11,6,2,0);ellipse(a,11,10,6,2,3)
    for x,y,c in [(7,9,4),(11,9,5),(15,9,4),(12,7,4),(5,15,5),(9,16,4),(18,16,5),(22,14,4)]:
        ellipse(a,x,y,1.7,1.5,c);rect(a,x,y-1,1,1,2)
    return a

META3=[
('Alt Eşik','Başak Toplayanlar','PARİS',['#c6c9b4','#c2a264','#a88548','#4f697b','#594f41','#d6b792'],gleaners,
 'Sprocket','Alttan ilerle. Bazı kutular henüz ulaşılamayan iç renkleri taşır. Yolu açacak renk için boş yuva bırak.', 'Rocco','İlk mühür aşıldı.', 'Üç kenar kapalı. Tek giriş aşağıda.'),
('Karın Sessizliği','Saksağan','PARİS',['#c7d1cf','#eee9d6','#9daec3','#9b8768','#414957','#d3c5a5'],magpie,
 'Rocco','Karın altından ilerliyoruz. Yan kenara yakın olmak artık kısa yol değil.', 'Sprocket','Sessiz kanatlar, sessiz bir kaçış.', 'Dronlar dönüşte de alt geçidi kullanır.'),
('Perde Aralığı','Yıldız','PARİS',['#bca47b','#4c625a','#768776','#f0e5cf','#dcb598','#c9bf9e'],star,
 'Sprocket','Sahneye yalnızca aşağıdan ulaşabiliriz. Önce alt sıradaki renkleri aç.', 'Rocco','Son selam bizim için.', 'Boşluklar yukarı doğru yeni rotalar açıyor.'),
('Son Dans','Moulin de la Galette','PARİS',['#879b9a','#596f64','#3c5063','#a5b9c7','#d5b89d','#e6d6b3'],dance,
 'Rocco','Kalabalık renkleri saklıyor. Soru işaretli kutu seçim sırasına gelince açılacak.', 'Sprocket','Müzik sürüyor. Tablo bizde.', 'Üst kenar açık görünse bile mühür geçit vermez.'),
('Meyve Kasası','Elmalar ve Portakallar','PARİS',['#828174','#596850','#b29367','#ece4d0','#d98641','#b45536'],fruit,
 'Sprocket','Bu katın son eseri. Alttan başlayıp son piksele kadar yolu aç.', 'Rocco','Üçüncü kat için beş eser daha.', 'Dar giriş, doğru renk ve sabır.')]

DETAILS3=[
 dict(artist='Jean-François Millet',date='1857',description='Hasattan sonra tarlada kalan başakları toplayan üç kadının yağlıboya resmi. Oyunda eserin sadeleştirilmiş piksel yorumu kullanılır.',facts=['Öndeki üç figür, eğilme, toplama ve doğrulma hareketlerini birbirini izler gibi gösterir.','Ön plandaki az miktarda başak, uzaktaki bol hasatla karşıtlık kurar.'],source='https://www.musee-orsay.fr/en/artworks/des-glaneuses-342'),
 dict(artist='Claude Monet',date='1868–1869',description='Karlı bir kır manzarası ve çitin üzerindeki küçük saksağan. Oyundaki kar, çit ve kuş altı renkle yorumlanmıştır.',facts=['Eser tuval üzerine yağlıboyadır; müze kaydı yapımını 1868–1869 aralığına tarihler.','Geniş kar manzarasına adını veren kuş, kompozisyonun küçük bir bölümünü kaplar.'],source='https://www.musee-orsay.fr/en/artworks/la-pie-715'),
 dict(artist='Edgar Degas',date='yaklaşık 1876',description='Yıldız, sahnede ışık altında dans eden bir balerini gösterir. Bu oyun görseli eserin küçük bir piksel yorumudur.',facts=['Orsay, eseri “Ballet, dit aussi L’Étoile” adıyla ve yaklaşık 1876 tarihiyle kaydeder.','Degas’nın opera çalışmaları yalnızca sahneyi değil, provaları ve kulis yaşamını da konu alır.'],source='https://www.musee-orsay.fr/fr/programme/agenda/expositions/presentation/degas-lopera'),
 dict(artist='Auguste Renoir',date='1876',description='Montmartre’daki açık hava dans bahçesinin kalabalığını ve ışığını gösteren yağlıboya. Oyunda kalabalık, küçük renk kümeleriyle yorumlanır.',facts=['1877’deki İzlenimci sergide gösterildi. Kalabalığın içinde Renoir’ın bazı arkadaşları da yer alır.','Resim, doğal ve yapay ışığın hareketli kalabalık üzerindeki etkisini bir araya getirir.'],source='https://www.musee-orsay.fr/en/artworks/bal-du-moulin-de-la-galette-497'),
 dict(artist='Paul Cézanne',date='yaklaşık 1899',description='Meyveler, beyaz örtü ve kaplardan oluşan bir natürmort. Piksel yorumunda turuncu ve kırmızı meyveler açık örtünün üzerinde öne çıkar.',facts=['Kapların ve masanın bakış açıları tam olarak aynı değildir; Cézanne tek bir perspektife bağlı kalmaz.','Beyaz örtü yalnızca beyaz boyayla anlatılmaz: çevresindeki renklerin yansımalarını da taşır.'],source='https://panoramadelart.com/analyse/pommes-et-oranges')]
for details in DETAILS3:
    details.update(museum='Musée d’Orsay · Paris, Fransa',fiction=False)
