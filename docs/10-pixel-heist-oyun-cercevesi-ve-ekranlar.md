# Pixel Heist — Kayıp Envanter

**Oyun, hikâye, ekran ve ekonomi tasarımının Türkçe okuma karşılığı**

Belge: `PH-DESIGN` · Revizyon: `2026-09-25-r13` · Dil: `tr`  
Tarih: 25 Eylül 2026  
İngilizce asıl ve AI uygulama kaynağı: [GameDesign.md](GameDesign.md). Çatışmada en son kullanıcı talimatı, ardından İngilizce belge esas alınır.  
Görevler: [ToDoList.tr.md](../ToDoList.tr.md)  
Önceki revizyon: [r12 arşivi](archive/10-pixel-heist-oyun-cercevesi-ve-ekranlar-r12.md) (yalnız tarihçe; artık davranışı belirlemez)

**r13 bir ürün dönüşümüdür (Halil, 25 Eylül 2026).** Oyun, Food Hunt tarzında, hikâyeli ve sade bir piksel bulmaca oyununa döner: Safehouse'tan tek dokunuşla soyguna, tek ekranlık ödül, geri dönüş. Hedef seçimi, eser başına karar, dört gelişim yolu, haberler, dava dosyası, anı stüdyosu ve ara ekranların çoğu kalkar. Hikâye, kadro, yirmi bölüm, beş arşiv parçası ve üç yollu son kalır.

## 1. Ürün vaadi ve kararlaştırılan yön

**Robot böcek ekibinle ünlü tabloları piksel piksel çal ve birinin silmeye çalıştığı envanteri ortaya çıkar.**

- **100 level, her biri 10 eserlik 10 isimli stage; sabit sıra.** Her stage on müze katından birine karşılık gelir. Mevcut 20 beş-level hikâye durağı dahili kimlik olarak korunur: stage başına iki durak, perde başına iki stage. 27 Eylül değişikliği önceki oyuncuya görünen bölüm yapısının yerini alır.
- **Toplam 13 ekran: 6 tam ekran ve 7 açılır pencere.** Her ekran tek bir iş yapar. Metin en azdadır (bölüm 15).
- Mevcut renk ve dock bulmacası çekirdek olarak kalır. Güçlendiriciler, enerji ve altın onu sarar (bölüm 3 ve 12).
- Gelir: altın paketleri, tek seferlik Starter Pack, No Ads, süreli teklifler, ödüllü reklamlar ve sınırlı geçiş reklamları (bölüm 13 ve 14). Ana hikâye asla ödeme istemez; enerji için beklemek gerekebilir.
- **Oyuncunun gördüğü her metin İngilizcedir.** Başka dil yoktur (bölüm 16).
- Ana kampanyanın eksiksiz bir sonu vardır. Sonraki içerik için hiçbir şey saklanmaz.

Sayılar ve süreler tasarım hedefidir, ölçülmüş sonuç değildir.

## 2. r12'nin yerini alan kararlar

On kararın tamamı Halil tarafından 25 Eylül 2026'da kabul edildi. Açık soruların varsayılanları (enerji üst sınırı 10; alt menüde "Upgrades" yerine "Gallery") aynı gün onaylandı.

| # | Konu | r12 | r13 |
| --- | --- | --- | --- |
| 1 | Enerji | Yok; kaybetmek bedelsiz | 10 enerji; yalnız kaybedince veya soygundan çıkınca gider |
| 2 | Hedef seçimi | 6 adaydan 4'ünü seç, sonra final | Doğrusal bölümler; seçilmeyen 40 aday çıkarılır |
| 3 | Eserin kaderi | İncele, sonra sat / sakla / iade / ödünç ver | Çalınan her tablo doğrudan Gallery'ye gider |
| 4 | Gelişim | Wealth, Renown, Research, Collecting yolları | Kalkar; yerine yıldız, sandık ve Crew |
| 5 | Undo ve Restart | Ücretsiz ve sınırsız | Kalkar; yerine Zap güçlendiricisi ve Out of Space |
| 6 | Hız | 600 saniyelik ortak 3× bütçesi, krediyle dolum | Ücretsiz 2×; isteğe bağlı 300 altınlık beş dakikalık 3× |
| 7 | Para ve paketler | Satın alınabilir para yok; yalnız kozmetik paket | Altın paketleri, No Ads, Starter Pack, süreli teklifler |
| 8 | Reklam | Tek isteğe bağlı ödüllü reklam yeri | Dört ödüllü yer ve sınırlı geçiş reklamı |
| 9 | Yan sistemler | Haber albümü, dava dosyası, anı stüdyosu, kişi güveni, sergi temaları, van görünümleri | Kalkar; hikâye Story ekranında ve kazanma balonlarında |
| 10 | Ekranlar | 20 ekran kabuğu ve ayrı modallar | 6 tam ekran ve 7 açılır pencere |

## 3. Bulmaca sözleşmesi

r12'den korunanlar:

- Tek tek piksel değil, öndeki bir renk taşıyıcısı seçilir. Geçerli taşıyıcı **boş herhangi bir aktif dock'a** girebilir.
- İzciler eşleşen, erişilebilir ve ayrılmamış pikselleri toplar; dolu piksellerin üstünden geçmez; en yakın izinli çerçeve girişinden yaklaşır.
- İçeride mühürlü duran gerçek bir eser rengi seçilebilir kalır; taşıyıcısı bir izci çalışabilene kadar bekler. Pervaneler platformda çalışırken kapalı kalır, yalnız işi biten taşıyıcının kalkışında açılır.
- Bazı arka paketler "?" gösterir; rengi ve kapasitesi ön sıraya gelince açılır.
- Yalnız eserde olmayan renklerin süre çubuğu vardır. Gerçek renkler asla süresi dolup gitmez.
- Yeni soygunlar beş ortak dock kullanır. Yazılmış kuyruklar Bölüm 1–2’de üç, Bölüm 3’te beş şerit kalır; beş şeritli kuyruklar sıraları değiştirilmeden üç sütunluk sayfalarda gösterilir. Kayıtlı eski soygunlar tamamlanana kadar önceki dock kapasitesini korur. **Her tabloya yalnız alttan girilir** (Halil, 26 Eylül 2026): çerçevenin yan ve üst kenarları hep kapalıdır. Sonraki düzenler mevcut kuralları birleştirir; refleks veya kovalamaca yoktur.
- Taşıyıcılar, kalkışlar ve sayaçlar için temel hız r12'deki ikiye katlanmış hızdır; karıncaların 1× hızı bunun yarısıdır (26 Eylül 2026). Sessiz pervane sesi, hafif titreşimli yumuşak tahta toplama sesleri ve azaltılmış hareket kalır.

r13'te değişenler:

- **Undo ve Restart butonları kalkar.** Dock'ları tıkayan oyuncuya Out of Space penceresi (P2) açılır.
- **Hız:** ücretsiz 1×/2× geçişi ve ayrı bir 3× düğmesi **yalnız karıncaların hızını** (yürüme, çıkış sıklığı, piksel kaldırma) etkiler. 3× için 300 oyun altını ödenir; açılan süre soygunlar arasında geçerli beş gerçek dakika sürer, duraklatma ve arka planda da işler. Bitiş zamanı kayda yazılır, kalan süre 3× düğmesinde görünür, ödemeden önce P6 tarzı onay gösterilir; süre dolunca ücretsiz 2× hıza dönülür. Süre bitmeden yeniden 3× seçmek ücretsizdir. Taşıyıcılar, kalkışlar, tuzak ve kuyruk sayaçları temel hızda kalır. Eski ortak 600 saniyelik bütçe, 240 kredilik dolum ve otomatik hızlanma kaldırılmış olarak kalır.
- **Soygun sunumu eklemeleri (Halil, 26 Eylül 2026):**
  - Karıncalar taşıyıcıdan oyuncuya bakan yüzdeki kapıdan çıkar ve aynı kapıdan girer, küpün yanından dolaşır; karıncalar çalışırken kapı taşıyıcının renginde parlar; platform ışıkları sönük kalır (27 Eylül son geri bildirimi).
  - Karıncalar tabloya, alt çerçevede her köşe ile isim plakası arasının ortasında açılan, 3–5 tablo pikseli genişliğinde iki geçitten girer. İlk karınca çerçeveyi üç kez didikler, sonra geçit açılır (bu sırada diğerleri altında bekler) ve soygun boyunca açık kalır.
  - Taşıyıcının pervaneleri aktif dock ve bekleme kuyruğunda kapalıdır, yalnız kalkışta açılır (27 Eylül son geri bildirimi); kalkan taşıyıcı çıktığı yöne yan yatar.
  - İstenmeyen paketler (tabloda olmayan renkler) yalnız pembe değil, birkaç renkte gelir. Süre çubukları incedir ve küpün hemen altındadır; küpe dokunulduğunda çevresinde seçim/odak çerçevesi çizilmez.
- **27 Eylül 2026 / onaylı v4 ekranı:** lacivert müze, eskitilmiş pirinç kenarlar, kutu renginde üstten görünen robot karıncalar, statik Lora Bold rakamları ve ortak model kullanan kısa-geniş taşıyıcılar. Karıncalar havada salınmadan, sırayla yere basan bacaklarla yürür. Üçlü bacak gruplarının adımı gerçekten yürünmüş yol mesafesini izler: 2× hareket 2× adım üretir; duraklatma, geçitte bekleme ve piksel alma sırasında ayaklar durur. Azaltılmış harekette sabit duruş kullanılır. Yüzey sayacı sıfıra inince yerini aynı üstten karınca simgesi alır; işi biten taşıyıcı pervanelerini açıp kalkar. Gövdenin renkli yüzeyi tablonun gerçek paletini izler; pirinç ve fildişi rakamlar sabit kalır. Tablo ile beş ayrı karanlık platform arasında geniş karınca geçiş alanı bırakılır. Beklemede üç sütunlu üç tam sıra ve dördüncü sıranın yalnız üstleri görünür. Dokunulan veya seçilebilir kutuların etrafında seçim çerçevesi çizilmez. Uzun dikey ekranlarda fazladan yükseklik karınca alanına eklenir; kutular ve kuyruk alt menüye bağlı kalır.
- **Büyük kapasiteler (27 Eylül son geri bildirimi):** gerçek renk paketleri 20–45 aralığında; 20/24/30/32/37/40/45 ve bütçeye tam uyan kalan değerlerle hazırlanır. 20’ye ulaşmak için piksel uydurulmaz: tabloda 20’den az pikseli olan renk gerçek toplamını kullanır; aktif sayaçlar toplama sırasında doğal olarak 20’nin altına iner. Bekleyen ve teslim edilmemiş gerçek renk kapasitesinin toplamı, kalan tablo ve karıncaların taşıdığı piksellere eşittir. Görünen aktif sayaç, alınmış ama hâlâ dönüşteki pikselleri içermez. Tuzaklar eser bütçesi tüketmez; görünen miktarları kalan toplam tablo pikseliyle sınırlanır.
- Büyük kuyruk sürümü eski yazılmış bölümlerden ayrı tutulur. Eski kayıt özeti yalnız aynı eski eser için kabul edilir; çözüm simülasyonu tamamlanmayı kanıtladığında sadece gönderilmemiş kuyruklar yeniden paketlenir. Tablo, aktif kutular, ayrılmış pikseller, para ve yıldızlar korunur; çözülemeyen dönüşüm eski kuyruğu korur. Dönüşüm bir kez uygulanır. Eski dock sayısı ve ücretli ek yerler korunur.
- **Kısa alt menüde üç büyük, yalnız ikonlu özellik** (1280 tasarım yüksekliğinin 102 birimi); stok kayıtlı kalır, ipucu/Get Booster içinde görülebilir. İki eski özellik Pause üzerinden kullanılabilir; satın alınmış stok ve sabit kimlikler korunur:

| Yer / ikon | Güçlendirici (sabit kimlik) | Etkisi |
| --- | --- | --- |
| Alt menü / artılı platform | Extra Dock (`extra_dock`) | Soygun boyunca bir ortak dock ekler; en fazla iki ek dock |
| Alt menü / yatay ışın | Row Beam (`row_beam`) | En alttaki dolu piksel satırını temizler; o satırda karıncanın ayırdığı piksel varsa stok harcamaz. Eşleşen kuyruk/boşta aktif kapasitesini düşürür, piksel iki kez toplanamaz |
| Alt menü / dönüş oku | Recall (`zap`) | Seçilen boşta taşıyıcıyı geldiği kuyruğa döndürür; eski Zap kayıt kimliği korunur |
| Pause / eski özellik | Scout Fly (`scout_fly`) | Tüm gizemli paketleri açar |
| Pause / eski özellik | Master Key (`master_key`) | Sonraki taşıyıcı giriş yönü kuralına takılmaz |

- **Row Beam geri bildirimi (27 Eylül):** temizlenen satır kısa süre parlar, ardından her kaldırılan piksel aşağıdaki drone kutularına doğru kademeli, kıvrımlı bir yol izler. Aynı renkteki izler kutuya varmadan küçülüp dağılır; bu görsel bir etkidir, ikinci teslimat değildir. Duraklatma/askıya alma efekti dondurur. Son satırın dağılması bitince Level Complete açılır. Azaltılmış harekette yerel ve kısa bir sönme kullanılır. Efektin okunabilir sabit süresi, yalnız karıncaları etkileyen 2× hızından bağımsızdır.

- Row Beam mevcut stok/300 altın kuralını kullanır. Eski kayıtlara sıfır Row Beam stoğu eklenir; para, enerji, ilerleme ve eski stoklar korunur. Yeni ürün kimliği eklenmez; mevcut “her güçlendirici” ödülleri Row Beam’i de içerir, önceden işlenen satın almalar yeniden verilmez.

- Stoğu sıfır olan güçlendiriciye dokununca Get Booster (P6) açılır.
- **Kaybetme:** her aktif dock çalışamayan bir taşıyıcıyla dolu ve boş dock kalmamışsa soygun tıkanır ve P2 açılır.
- **Yıldızlar:** hiç güçlendirici ya da devam kullanılmadıysa 3, bir kez kullanıldıysa 2, daha fazlaysa 1 yıldız.

## 4. Kampanya yapısı

| Terim | Tanım | Miktar |
| --- | --- | --- |
| Stage | Adı olan on eserlik level grubu | 10 |
| Level / Soygun | Bir eser bulmacası | 100 |
| Hikâye durağı (dahili bölüm kimliği) | Korunan hikâye/ödül durağı | Her beş level'da bir, toplam 20 |
| Müze katı | Aynı stage'in kalıcı sergisi | 10 kat × 10 çerçeve |
| Özel koleksiyon | Oyuncunun kazandıklarından seçtiği eserler; katlardaki kopyalar kalır | Bir oda, en fazla 10 farklı eser |

27 Eylül onayıyla oyuncuya gösterilen yapı artık **10 stage × 10 level** olur. Önceki 20 bölüm, kayıt ve hikâye kimlikleri korunarak ikişerli eşlenir; beş perde ikişer stage içerir. Stage adları `data/stages.json` içinde sabittir: The First Commission (1–10), Hidden Routes (11–20), Sealed Shipment (21–30), The Silent Auction (31–40), Double Entry (41–50), Missing Voices (51–60), Behind the Labels (61–70), The Cost of Trust (71–80), The Last Offer (81–90), Whose Museum? (91–100).

Her beş level'daki hikâye/ödül durağı korunur; beşinci ara durak, onuncu stage finalidir. Mevcut ödül kimlikleri ve miktarları korunarak geçişte tekrar ödül verilmesi engellenir. Beş ipucu Level 10/30/50/75/100'de kalır. Stage adları hikâye temasıdır, katı sanat dönemi sınırlaması değildir. Mevcut 15 bulmaca değişmez. Level 16–100 için asıl görsel yerleştirmek oynanabilir içerik oluşturmaz. 27 Eylül tarihli yalnız görsel isteğiyle 100 müze yeri doldurulur; yeni piksel panoları ve kuyruklar sonraya bırakılır.


- Soygunlar kesin sırayla açılır. Kazanılmış soygun tekrar oynanabilir, düşük ödül verir (bölüm 12).
- Her bölümün beşinci soygunu **finaldir** ve r12'deki final eserlerini kullanır (bölüm 6).
- Mevcut 15 eser mevcut sıralarıyla Bölüm 1–3'ü doldurur; üç finali Moon Gate Mask, Water Lilies ve Apples and Oranges olarak kalır.
- Heist'teki level kurdelesinde zorluk etiketi: yok, **HARD** (kırmızı) veya **SUPER HARD** (mor). Bölüm 2'den itibaren bölüm başına yaklaşık bir HARD, II. perdeden itibaren perde başına bir SUPER HARD.
- Soygun başına 2–5 dakika hedeflenir. Oyun süresi dronları yavaşlatarak uzatılmaz.
- Tüm eserleri açık 15 eserlik demo geliştirici menüsüne taşınır; oyuncuya görünmez.

**Asıl görsel yerleşimi güncellemesi (27 Eylül):** İlk 15 kimlik ve bunların üç kurmaca hikâye eseri korunarak 100 level/kat yerinin tamamına asıl görsel atanır. Gelecekteki eser kazanılmadan adı, sanatçısı, tarihi ve kaynak müzesiyle incelenebilir. Piksel panosu bulunmayan eserde kat görünümü asıl görseli korur (piksel modunda Original etiketi); ayrıntısında piksel düğmesi olmaz. İncelemek soygun açmaz veya koleksiyon sahipliği vermez.

**Doğrudan karınca yolları (27 Eylül):** Karıncalar küpün iki yanını ve boş hücre yolunu değerlendirip izin verilen en kısa yaklaşımı seçer; açık alanda çapraz ve doğrudan yürür. Geçitlerin genişliğini kullanır; ortak yatay yaklaşım patikası bulunmaz. Gövde ve bacaklar aynı boyda, %20 daha incedir.

**Sun Seal bitişik piksel düzeltmesi (27 Eylül):** Level 1, The Gleaners'ın aynı 436×290 oyun alanındaki 28×22 hücresinin ekran piksel ölçüsünü kullanır: 290/22 ≈ 13,18 ekran birimi. Sun Seal'in kare aslına orantılı pano bu yüzden 22×22 hücre (484 piksel) ve 290×290 ekran birimidir; yatayda ortalanıp yükseltilen üst çerçevenin altında durur. Piksel/dron/taşınan küpte ortak beş ana oyun rengi korunur; asıl görselle birebir benzerlik gerekmez. Üst, daha belirgin aşağı bakan ön ve sağ yüzler her hücreyi tamamen doldurur; oyun ve müze görünümünde dolu küplerin arasında zemin boşluğu kalmaz. Oyun paletinde bulunmayan soğuk lavanta mavisi zemin (`#7c87b7`) yalnız pikseller toplanınca açığa çıkar. Mevcut 15×15, 32×32, 18×18, 16×16 ve daha eski kayıtlar kendi mantıksal pano ve kuyruklarıyla devam eder.

**Sapphire Cup kaynak piksel düzeltmesi (27 Eylül):** Level 2, Sun Seal ile aynı kare 22×22 / 484 hücreli panoyu ve ekrandaki hücre ölçüsünü kullanır. Mevcut kurmaca asıl görsel beş ortak oyun rengine örneklenir: müze laciverdi, koyu kobalt, safir mavisi, porselen fildişi ve altın. İnce altın kenarlar kaynak renk kapsamıyla korunur. Boşluksuz kabarık küpler, ayrı soğuk zemin, üst çerçeve konumu, yalnız alttan giriş kuralları ve çözülebilir yazılmış paket kuyruğu Sun Seal ile aynıdır. Müze ile heist aynı panoyu gösterir. Eski Sapphire Cup kayıtları kendi pano ve kuyruklarıyla devam eder; yeni girişimler kaynak görselden türetilen panoyu kullanır.

**Stage 1 okunur piksel sunumu (27 Eylül, Halil'in son geri bildirimi):** Level 3–10, asıl görsellerinden türetilmiş 32 piksel yüksekliğinde ve tabloya göre değişen 16–24 renkli piksel sanatını gösterir. Belirgin mavi, altın ve kırmızı alanlar gerçek soygun ve müze çerçevesi boyutunda kolay ayırt edilmeli; her piksel reddedilen 48 satırlık sürümdekinden belirgin biçimde büyük görünmelidir. Bu görseller mevcut yazılmış bulmaca hücrelerinin, taşıyıcı paletlerinin ve kuyrukların üstündeki katmandır: oyun piksel bütçesi, temposu ve kayıt kimliği değişmez. Soygunda toplanan her mantıksal hücre görseldeki karşılık gelen alanı gizler; müzenin piksel modunda tam görsel gösterilir. İlk iki onaylı kaynak panonun görünümü korunur. Müze ayrıntısında her asıl görsel doğal oranıyla kalır. Reddedilen 22 satırlık pano değişimi ayırt edici biçimleri kaybetmişti; sonraki 48 satırlık görsel katman ise pikselleri küçültüp renk ayrımını zayıflatmıştı.

**27 Eylül sunum güncellemesi:** Level 1 karıncaları biraz büyüktür ve farklı kısa yollarını korur. Sun Seal arka paketlerinin yalnız küçük bir bölümü gizli “?” gösterir; diğerleri gerçek tablo rengindedir. Üçlü bekleme sıraları birbirine yakındır. Eski kayıttan sürdürülen panolar dahil her heistte eser adı üst çerçevede, piksel sayısı ve çubuğu level plakası ile çerçeve arasındadır. İnce ilerleme çubuğu müzenin pirinç tonunda dolar; sayı çubuğun altında ortalanır. Eski panoların boyutu değişmez; çerçeve ve pano yalnızca ortak üst alanı açık tutacak kadar aşağı taşınır.

## 5. Hikâye: Kayıp Envanter

### Öncül

Rocco "Pixel" para ve tanınmak için iş alır. Ortağı Sprocket, sanat eserini taşınabilir parçalara ayırıp yeniden kuran bir piksel aktarım cihazını uyarlamıştır. Taşıma işini robot böcek ekibi yapar.

İsimsiz bir müşteri, **Küratör**, Baron Glimmer'ın özel koleksiyonundan eserler sipariş eder. Bölüm 1'in sonunda Rocco kendi cihazını teslimat envanterinde görür. Teslimatı bozar ve eserleri Safehouse galerisinde tutar. Bu, başlatıcı olaydır; son açıklama değildir.

Yıllar önce bir restorasyon ağı sahiplik geçmişlerini değiştirmiştir. Glimmer bunu kurmaca **Atlas Vakfı** üzerinden finanse eder. Restoratör **Barnaby Bramble** özgün kayıtları kurtarmış, beş küçük arşive bölüp beş belirli eserin içine saklamıştır. Envanter bir kanıttır, hazine haritası değildir.

Sprocket'in cihazı bir eserin yüzeyini, taşıyıcısını ve sonradan eklenen koruma katmanlarını ancak tam aktarımdan sonra okuyabilir; eserin bütünüyle çalınmasının nedeni budur. Bu uydurma bir öncüldür ve bir kez söylenir.

Küratör, eski bir kültürel varlık araştırmacısı olan **Mr. Frost**'dir; arşivi ve cihazı kendi denetiminde ister. Gazeteci **Quill** iddiaları doğrular. Tüm suçlu sahipler ve kurumlar kurmacadır; gerçek sanatçılar ve müzeler asla suçlanmaz.

### Kadro ve ses

> **Kadro (Halil, 25 Eylül 2026):** hikâyedeki tüm karakterler İngilizce çizgi film isimli erkek hayvanlardır — Rocco (gelincik), Sprocket (fare), Quill (peçeli baykuş), Mr. Frost (kutup tilkisi), Baron Glimmer (saksağan), Tuck (kaplumbağa), Barnaby Bramble (porsuk). Tür, görünüm ve ses: [Characters.md](Characters.md).

| Karakter | İsteği ve çatışması | Oyuncunun onunla karşılaştığı yer |
| --- | --- | --- |
| Rocco "Pixel" | Özgürlük ve tanınma; sahip olmayı korumakla karıştırabilir | Kazanma balonları, Story kareleri |
| Sprocket | Cihazı korumak ve anlamak | Kazanma balonları, Story kareleri |
| Quill | Silinmiş bir geçmişi bulmak ve doğrulamak | II. perdeden itibaren Story kareleri |
| Mr. Frost / Küratör | Arşivi denetlemek | Şifreli mesajlar, sonra doğrudan sahneler |
| Baron Glimmer | Koleksiyoncu statüsünü korumak | Story kareleri, son yüzleşme |
| Tuck | Safehouse galerisini yürütür; Rocco'nun zevkiyle takılır | Ara sıra kazanma balonları |
| Barnaby Bramble | Envanteri koruyan, hayatını kaybetmiş restoratör | Arşiv parçaları |

Mizah, zevkin pratik dertlerle karşılaşmasından doğar; mağdurlar ve iadeler asla şaka konusu olmaz. Örnekler (oyunda İngilizce): Sprocket: "The client asked for something small." Rocco: "They meant the budget." — Sprocket: "You left the frame?" Rocco: "I respect their decorating choices."

## 6. Beş perde ve yirmi bölüm

Bu yirmi dahili hikâye durağı kimliklerini korur ve on oyuncu stage'ine ikişerli eşlenir (bölüm 4).

Her bölümde dört hikâye soygunu ve bir sabit final vardır. Final adları, gerçek eser yorumu olarak belirtilmedikçe kurmacadır.

| Bölüm | Vaka / atmosfer | Final eseri | Hikâye sonucu | Bulmaca vurgusu |
| --- | --- | --- | --- | --- |
| 1 | İlk Sipariş — Glimmer'ın örnek koleksiyonu | Moon Gate Mask | Cihaz siparişte çıkar; Rocco teslimatı yönlendirir | Üç dock, güvenli bekleme |
| 2 | Sahte Sahipler — özel Avrupa sergileri | Water Lilies | 1. parça; etiket ve geçmiş çelişir | Küçük yükler, gizemler, yemler |
| 3 | Alt Eşik — Paris restorasyon zinciri | Apples and Oranges | Kopyalanmış bir işaret bulunur | Beş dock, yalnız alttan giriş |
| 4 | Liman Koleksiyonu — kurmaca İstanbul depoları | Shore Ledger | Atlas'ın sevkiyat bağlantısı doğrulanır | Kopuk şekiller, dar geçitler |
| 5 | Yanlış Adres — ulaşım koleksiyonu | Return Ticket | Sahte etiket gerçek rotadan ayrılır | Akıcı kuyruk okuma |
| 6 | Mühürlü Sevkiyat — liman arşivi | Blue Shipping Plate | 2. parça; aktarım ağı | İç renkleri açma |
| 7 | Sessiz Müzayede — özel Viyana daveti | Gold-Faced Clock | Alıcıların etkisi; Küratör'ün eski imzası | Yakın tonlar, kuyruk planı |
| 8 | İmzasız Mektup — sergi tasarımcısının deposu | Half an Invitation | Quill imzayı doğrular | Tanıdık kurallarla perde kapanışı |
| 9 | İki Koleksiyon — Amsterdam salonları | Double-Labeled Landscape | Tek kayıt iki esere verilmiş | Adalar, yedek dock planı |
| 10 | Çift Kayıt — restorasyon arşivi | Twice-Written Portrait | 3. parça; Mr. Frost kendini açık eder | Erken iç renk sonuçları |
| 11 | Kayıp Sesler — aile/topluluk arşivi | Entrusted Chest | Kayıtlar yaşayan insanlara bağlanır | Sakin renk grupları |
| 12 | Açık Kapı — kapalı sergi deposu | Exhibition No. 12 | Rocco'nun ilk halka açık gösterimi | Ilımlı, akıcı kapanış |
| 13 | Kibar Tehdit — Atlas daveti | Silver Card Case | Glimmer basın üzerinden Rocco'ya saldırır | Gizemli paketler |
| 14 | Kimin Hikâyesi? — yayıncı koleksiyonu | Before the Press | Tanıklığın nasıl değiştirildiği | Kısa nefes alanı |
| 15 | Karanlıkta Baskı — kapalı sergi | Closed Window | 4. parça; çıkar sağlayanlar belirlenir | Kenar kuralları ve gizemler |
| 16 | Güvenin Bedeli — koruma ağı | Three-Key Box | Mr. Frost'un denetimine alternatif | Planlı perde kapanışı |
| 17 | Kayıp Sayfa — taşınan Atlas arşivi | Cut Album | İmha emri bulunur | İç renkler ve geçitler |
| 18 | Son Teklif — Glimmer'ın pazarlık odası | Untitled Bust | Susma teklifi | Kısa, net baskı |
| 19 | Son Envanter — özel vitrin | Study No. 0 | Cihazın kökeni Barnaby'nin işinde | Tanıdık kurallarda ustalık |
| 20 | Kimin Müzesi? — Glimmer'ın ana koleksiyonu | Night Atlas | 5. parça; tam arşiv; son seçim | Yazılmış final kuyruğu |

| Perde | Bölümler | Amaç | Karşılığı |
| --- | --- | --- | --- |
| I — Siparişten Şüpheye | 1–4 | Cihazı korumak, müşteriyi sorgulamak | İlk parça, bağımsız hedef |
| II — Koleksiyonun İzinde | 5–8 | Eserlerin hareketini bağlamak | İkinci parça, doğrulanmış imza |
| III — Kimin Geçmişi? | 9–12 | Kayıtlardaki insanları anlamak | Üçüncü parça, Mr. Frost'un kimliği |
| IV — Geceye Karşı | 13–16 | Anlatıyı savunmak, müttefik kazanmak | Dördüncü parça, basın çatışması |
| V — Son İş | 17–20 | Kanıtı tamamlamak ve karar vermek | Tam arşiv, kesin son |

## 7. Hikâye nasıl anlatılır

Hikâye tam olarak üç yerde yaşar:

1. **Story ekranı (S4):** Bölüm 1'in başında ve her bölüm finalinden sonra; üç çizgi roman karesi, karede bir ya da iki balon, balon başına en fazla sekiz kelime, her zaman atlanabilir. Parça bölümleri (2, 6, 10, 15, 20) beş yuvalı bir kanıt panosuyla biter: "Fragment 2 / 5".
2. **Level Complete'teki kazanma balonu (S3):** Rocco, Sprocket veya Tuck'tan tek satır, en fazla sekiz kelime, her soygun için yazılmış (100 satır). Bulunan ipucu burada söylenir: "That's not the artist's mark."
3. **Painting Detail (P7):** eserin adı, sanatçısı, yılı ve tek satırlık bilgi. Gerçek eser bilgileri kurmaca iddialardan ayrı tutulur.

**Son.** Bölüm 20 finalinden sonra Story ekranı üç yolu tek satırlık büyük kartlar halinde sunar: **Open Inventory** (Rocco'yu zora sokanlar dahil her şeyi yayımla), **Custodian Network** (kaydı bağımsız araştırmacılara ve topluluklara emanet et), **Final Bargain** (Glimmer ve Mr. Frost'u gizli bir anlaşmayla çökert). Bu, oyundaki tek hikâye seçimidir. Her yolun kendi kapanış kareleri vardır. Gallery sonrasında da oynanabilir kalır.

Süreklilik kuralları: parça taşıyan eserler sabittir; bulunmuş bir gerçek geri alınmaz; Glimmer her şeyi bilmez, basından öğrenir; Barnaby hikâye başlamadan ölmüştür; cihazın Barnaby ile bağı Bölüm 19'da doğrulanır.

**Stage 1 görsel sahne değişikliği (28 Eylül, P16-60):** ilk açılış yeni çatı görseli ve iki onaylı replikle gösterilir; Start Heist mevcut açılış bayrağını kullanarak oyunu başlatır. İlk Level 10 zaferinden sonra Level Complete Continue doğrudan yeni Safehouse keşif sahnesini açar. Dönüş eylemi mevcut false_owners sandığını bir kez verir, aynı hikâye kimliğini işaretler ve normal ödül bildirimiyle Safehouse’a döner; bu stage bitişindeki eski tamamlama/metin/parça gezinmesinin yerini alır. Parça aynı Level 10 dönüm noktasına bağlı kalır. Level 5 dönüm noktası/ödülü ve sonraki stage’ler değişmez. Stage 1 görsel/metinleri data/stage_scenes.json içinde tanımlanır ve salt okunur Case File ile paylaşılır. Tekrar kazanılan seviyeler bitişi otomatik oynatmaz.

**Stage 1 konuşma balonları (29 Eylül, P16-61):** başlangıç/bitiş konuşmaları görsel üzerinde, karakter adı ve kuyruğu olan konuşma balonlarında gösterilir; yüzler ve ipuçları kapanmaz. Görselin altındaki ayrı metin alanı kaldırılır. Canlı S4 ve Case File tekrarı aynı sunumu kullanır; görsel kırpılmaz ve gezinme düğmeleri görselin dışında kalır.

## 8. Ekip (Crew)

- On robot böcek. Bölüm 1, 3, 5, 7, 9, 11, 13, 15, 17 ve 19'un sonunda birer yenisi katılır; o finalin Level Complete ekranında gösterilir ("New crew member!").
- Böcekler yalnız görünümdür: ad, görünüş, bekleme animasyonu, tek satırlık tanıtım. Kapasiteyi, hızı, erişimi veya kuralları asla değiştirmez; renkler ve numaralar okunur kalır.
- Seçili böcek Gallery'de gösterilir; soygunlarda izci olarak ve Safehouse kahraman grubunda görünmesi ekip görselleriyle (P16-26) gelir.
- Drone ve taşıyıcı kutu görünümleri Shop'ta altınla alınır.

## 9. Ekranlar ve içerikleri

Kodlar: S = tam ekran, P = açılır pencere. Tüm pencereler tek kalıbı kullanır: kurdele başlık, ortada görsel, en fazla iki buton, sağ üstte X.

### S1 — Safehouse

- **Üst çubuk:** avatar (Crew'u açar), Energy (kalp, "5/10", dolum zamanlayıcısı), Gold (altın, bakiye), ayar dişlisi.
- **Sade Safehouse arka planı (29 Eylül, P16-63):** onaylanan `assets/lobby/v2/museum_simple.png` kullanılır: sakin lacivert müze duvarları, merkezde tek piksel tablo, birlikte Rocco–Sprocket ve bir robot böcek. Sade yan alanlar altı görsel kısayolun okunmasını sağlar; alt alan ilerleme ve Play için ayrılır. Pixel Heist logosu görselde kalır. Değişken sayılar yerel Lora Bold ile çizilir. Bu görsel yalnız S1’de ayrıntılı 27 Eylül arka planının yerini alır; önceki görsel tarihsel referans olarak korunur.
- **İlerleme ve Play (P16-65, 29 Eylül):** görsel Case File yanında stage adı ve on ilerleme parçası içeren daha geniş canlı seviye kartı. Start Heist; ince sıcak pirinç kenarlı, hafif derinlikli, Lora başlıklı ve küçük oynat simgeli yerel saten-turkuaz düğme kullanır. Sonraki hazırlanmış soygun yoksa More Soon yazar ve devre dışı kalır. Referansın örnek bakiye/seviye/ilerleme değerleri oyuncu verisi olarak kullanılmaz.
- **Görsel ödüller (29 Eylül, P16-62):** merkez görselinin iki yanında sıcak pirinç detaylı, çerçevesiz altı büyük saten-emaye obje ikonu yer alır (P16-64 süslü madalyonların yerini alır): solda Daily, No Ads ve Milestones; sağda Watch Ad, Offers ve Star Chest. Başlıklar obje siluetlerinin altında yer alır; yerel yazılar gerçek hazır olma, seviye/yıldız gereksinimi, günlük reklam hakkı veya sahiplik durumunu gösterir. Sandıklar ödül genel görünümünü açar; Watch Ad isteğe bağlı ödüllü reklamı açıkça başlatır; No Ads satın alma yapmadan tam ilgili ürünü incelemeye açar. Alınmış No Ads ve tükenmiş reklam hakkı devre dışıdır; bulunmayan teklifler gizlenir. Bölüm kartının yanındaki gereksiz bakır sandık kaldırılır (P16-65); Daily, Milestones ve Star Chest genel görünümü açmaya devam eder. Eski dikey metin menüsü yerine büyük hazine görseli ve iki sütunda altı görsel kart kullanılır. Sezon bileti, ücretli ödül yolu veya yeni ekran eklenmez. Ödül kimlikleri, stok, sınırlar ve miktarlar korunur; P4/P5 açılmadan genel görünüm kapanır. Event gizli kalır.
- **Case File (28 Eylül, P16-60 değişikliği):** S4 içinde görsel ağırlıklı stage dizini kullanılır. Stage kartına dokunmak açılış görselini ve iki kısa konuşmayı doğrudan açar; uzun giriş/rapor sayfası kaldırılır. Devam eden vaka yalnızca açılışı, on eseri tamamlanan vaka açılış ve bitişi gösterir; eski kayıtlarda görülmüş hikâye bayrağı olmasa da mevcut tamamlanma kimliklerinden belirlenir. Previous/Next açık sahneleri gezdirir; Back kaydırma/odağı koruyarak dizine, ardından Safehouse’a döner. Arşiv okumak ödül vermez veya kaydı değiştirmez. Bu çalışma yalnızca Stage 1 sahnelerini üretir; diğer kartlar Scenes coming soon gösterir ve yer tutucu hikâye açmaz. Oynanışları ve dahili bölüm verileri korunur. Yeni ekran kimliği eklenmez.
- **Alt sekmeler (P16-65):** **Shop / Home / Museum**; sakin lacivert tabanda renkli saten-emaye obje ikonları ve yerel yazılar kullanır. Shop turkuaz/mercan dükkân, Home turkuaz/petrol ev, Museum sıcak pirinç ve mürdüm detaylı fildişi sütunlardır. Seçim hafif turkuaz alan ve alt çizgiyle belirtilir. Case File aynı görsel setinden petrol dosya, fildişi kâğıtlar, mercan mühür ve pirinç büyüteç kullanır; eski altın klasör görseli değiştirilir. Museum mevcut S5 Paintings sekmesini, avatar Crew'u açar. Kalıcı ekran/kayıt kimlikleri değişmez. Uzun dikey ekranlarda alt kontroller alt kenara bağlı kalır.

### S2 — Heist

**27 Eylül 2026 — kızıl arı açılışı:** Her yeni soygunda önce eserin piksellere
bölünmemiş hali görünür. Büyük kızıl arı taşıyıcı tam tepeden görünür; başı yukarı,
karnı aşağı bakar. Kanat çırparak ekranın altından gelir ve alt küp kuyruğu
bölgesinde bekler. Görünen kapağından çıkan on küçük kızıl robot arı tabloya uçar;
ışınları tabloyu tarayıp piksel panosunu açığa çıkarır. Sonra on arının tamamı aynı
kapaktan taşıyıcının içine döner. Taşıyıcı son arıyı bekler, ardından ekranın üst
kenarından çıkar. Küp dronlar ancak bu çıkıştan sonra görünür; girişler ve sayaçlar
başlar. Akış S2'nin parçasıdır, yeni ekran değildir. Dönüş/toplanma aşamasıyla
birlikte yaklaşık sekiz saniye sürer. Duraklatma ve uygulamanın arka plana
alınması animasyonu dondurur. Azaltılmış hareket kısa bir sabit görsel geçişi
kullanır. Yarım kalan soyguna dönüşte doğrudan kayıtlı bulmaca açılır. İki görünüm
aynı kalıcı eser kimliğine bağlıdır; kaynak görsel hakları ve dosya özetleri bulmaca
verisinden ayrı kaydedilir. Üretimdeki 100 eserin tamamı için asıl görsel ve piksel
panosu çifti gerekir. Mevcut 15 demo panosu stilize çizimler olarak korunur; bu
açılış hücre bütçelerini, kuyrukları veya kayıtları yeniden üretmez. İlk üç eski
eser oyuna özel kurgudur ve ayrıntılı görselleri yeni üretilmiştir.

- **Üst:** Pause (P1'i açar), varsa HARD / SUPER HARD etiketli, yan okları olmayan ince lacivert-altın "LEVEL 12" plakası, ayrı ücretsiz 1×/2× ve altınla açılan süreli 3× düğmeleri. X ve rakam aynı puntoyla çizilir.
- **Orta:** oymalı altın çerçeve, piksel tablo, isim ve ince ilerleme çubuğu; geniş karınca geçiş boşluğu; beş aktif platform ve sayfalı üç sütunlu bekleme kuyruğu (bölüm 3).
- **Alt:** kısa, üç düğmeli, yalnız ikonlu menü: Extra Dock, Row Beam, Recall. Düğmelerin altında yazı yok.
- Bölüm 1–4'te el işaretli tek satırlık ipuçları ("Tap to send the ants."). Ayrı yardım ekranı yoktur.

### S3 — Level Complete

**28 Eylül kutlama güncellemesi (P16-57):** S3, müze üzerinde ortalanmış lacivert/pirinç başarı kartı olarak, ortak Lora yazı tipi ve emaye düğmelerle sunulur. Rocco ve Sprocket kazanılan tablonun yanında kendinden emin ve sevinçli yüz ifadeleriyle kutlar. Yıldızlar sırayla gelir, tablo çerçevesine yerleşir ve tek, kısa, sonlu renkli konfeti patlaması başarıyı vurgular. Konfeti eylem alanını kapatmaz veya dokunuşları engellemez. Continue hemen kullanılabilir. Reduced motion, parçacıklar ve giriş hareketleri olmadan tamamlanmış sabit düzeni gösterir; uygulamanın askıya alınması ve açık pencereler kutlamayı duraklatır. Ödül yenilemeleri kutlamayı yeniden başlatmaz veya ödül vermez. Kanonik kazanma balonu, ayrı yeni ekip kartı, kayıtlı altın/en iyi yıldız sözleşmesi, açık Watch Ad yazılı isteğe bağlı eylem ve ilk kilometre taşının Story yönlendirmesi korunur.

Normal kazanmalarda View in Museum sunulur; ilk kez tamamlanan hikâye durakları, hikâyenin atlanmaması için Continue akışını korur.

- "Level Complete!" kurdelesi ve 1–3 yıldız.
- Çalınan tablo çerçevesine uçar; altında adı.
- Tek kazanma balonu (bölüm 7). Ekip bölümlerinde yeni böcek kartı.
- Ödül satırı: kazanılan altın ve yıldız.
- Butonlar: büyük "Continue", küçük "2× Coins" (ödüllü reklam).

### S4 — Story

- Her beş-level durağında: "Halfway There" veya "Stage N Complete", yeni kazanılan beş eser ve sandık → "Open Chest" (P4). Beşinci level ödülü Milestone Chest, onuncu Stage Chest olarak gösterilir; mevcut ödül kimlikleri ve miktarları korunur.
- Üç çizgi roman karesi, kaydırarak ilerlenir, sağ üstte "Skip".
- Parça bölümleri kanıt panosuyla biter.
- Son kare sonraki bölümün adını söyler ("Chapter 4: Harbor Collection") → "Continue".
- Bölüm 20 üç son kartını, ardından seçilen sonun karelerini gösterir.

### S5 — Gallery

**Ortak görsel stil güncellemesi (27 Eylül, P16-53):** S1 orijinal görselli alt menüsünü korur. S5 artık alt menü yerine sol üst geri düğmesini kullanır (P16-55, 27 Eylül onayı). Müze hacimli pirinç/turkuaz kontrol görselleri, güçlü sıcak altın başlıklar ve aydınlık müze arka planı kullanır. Sonraki ekran tasarımları ortak görsel uygulama kaynağı [ScreenStyleGuide.md](ScreenStyleGuide.md) kurallarını izler; eski düz görünümler geçersizdir.


- S5 içinde üç görünüm: **Floors / Collection / Crew**. Kat seçici on isimli stage'i listeler. Her katta level sırasıyla okunan, iki sütunlu ve aşağı kaydırılan sergide on kalıcı yer bulunur. Çerçeve, eserin doğal en-boy oranına kırpma ve esnetme olmadan uyar; satırın yüksekliğini uzun eser belirler ve kısa eser satır içinde ortalanır. Tabloya dokunmak büyük ayrıntıyı açar; ayrı View düğmesi yoktur. Kaynağı belirlenmiş orijinali olan kilitli eserlerin tüm görseli, köşedeki küçük kilit rozetiyle birlikte görünür; kazanılmış eserlerde tik rozeti bulunmaz. Görseli olmayan yerde kilitli "Coming soon" alanı gösterilir. Kilitli orijinal incelenebilir, fakat kazanılmadan özel koleksiyona eklenemez. Piksel modu yazılmış bulmacalarda geçerlidir; henüz piksel tahtası olmayan gelecek eserler orijinal önizlemesini korur.
- **Müze gezinme güncellemesi (27 Eylül):** Üst Floors / Collection / Crew sekmeleri ana sayfanın malzeme stilini izler: kesintisiz lacivert emaye zemin, ince pirinç kenar ve ayırıcılar, altın simge ve yazılar, seçili hedefte turkuaz parıltı ve alt çizgi. Alt Shop / Home / Museum menüsü üç Müze sekmesinden de kaldırılır; içeriğe 146 tasarım birimi kazandırılır. Sol üstteki temalı geri oku Safehouse’a döner. Collection Edit içinde önce düzenlemeden çıkar ve güncel oda adını kaydeder; Photo geri düğmesi önce koleksiyon görünümüne döner. Escape de aynı sırayı izler; açık tablo ayrıntısı veya kat listesi önce kapanır. Geniş dokunma alanlarının açıklamaları korunur. Sağdaki tek asansör düğmesi, önceki/sonraki okları ve sistem listesinin yerine hemen altında ekran içi lacivert-pirinç kat rehberini açar. On katın adı, numarası ve toplanan eser sayısı görünür; seçili kat vurgulanır ve görünür alana kaydırılır. Satır seçimi listeyi kapatıp katı baştan açar; dışarı dokunma, kapatma veya Escape listeyi kapatır. Gezinmek içerik açmaz. Orijinal/piksel ve koleksiyon/fotoğraf işlemleri simgeli kalır. Sergi başlığı tek kompakt satırdır: küçük kat numarası rozeti, stage adı ve görünüm/kat düğmeleri. Toplam ve kat başına toplanan eser sayıları yalnız kat rehberinde gösterilir; eserlerin üstünde tekrarlanan metinler yer almaz. Fotoğraf oranı görünür kalır.
- Varsayılan eserlerin orijinal halidir. **Show Pixels / Show Originals** kat/oda görünümünü değiştirir; sahiplik ve ilerleme değişmez. Eser ayrıntısında geçiş, var olan modal içindeki yalnızca tablo görselini değiştirir; çerçeve, bilgiler, kontroller ve modal aynı kalır. Görsel oranı korunur. Kurgu oyun eserleri katalogda kurgu olarak tanımlı kalır; üretilmiş yorumlar tarihî orijinal olarak etiketlenmez.
- İlk eserle koleksiyon kullanılabilir: en fazla on farklı kazanılmış eser, ücretsiz ekleme/çıkarma/sıralama. **Spotlight + pairs** (üstte tek büyük tablo, altında ikili sıralar), **Two per row** veya **Three per row** düzeni seçilir. Canlı oda, eserleri küçültmemek için kaydırılır; Photo Mode aynı kayıtlı dizilişi çıktı boyutuna sığdırır. Edit gerçek oda önizlemesini kullanır: önce bir tabloya, ardından diğerine dokunmak yerlerini değiştirir; önceki/sonraki/ilk sıra kontrolleri de vardır. İlk sıra büyük tablonun yeridir; görünür sırayı değiştiren gizli sıralama yoktur. Oda önizlemesinin altından kazanılmış eserler eklenebilir. Katlardaki eser kaldırılmaz. Kalıcı eser kimlikleri, sıra, düzen kimliği, 1–32 karakterlik oda adı ve midnight/emerald/burgundy teması kaydedilir. Eski odalar varsayılan spotlight düzenine geçerken öne çıkan eserlerini ilk sırada korur. Kayıt başarısızsa kaydedilmemiş seçim tamamlanmış gibi gösterilmez. Edit, Photo ve görünüm kontrolleri ekranın altında 28 birim kenar boşluklu ayrı bir araç satırında yer alır; üst sekmelerin alt çizgileri yazılara değmez. Tablo ayrıntısı, Play again ve Close dahil ortak lacivert/turkuaz mine düğme bileşenini kullanır.
- **Photo Mode**, S5 içinde temiz oda görünümüdür. Orijinal/piksel ve 4:5 (1080×1350) / 9:16 (1080×1920) kadrajları sunar. Ayrı çizilen PNG yalnızca odayı, eserleri, adı ve küçük Pixel Heist imzasını içerir; kontrol, bakiye ve özel kimlik içermez. On eserden azsa boş kilitler yerine yerleşim uyarlanır. Kayıt yerini oyuncu seçer. Yerel mobil paylaşım için gerçek platform adaptörü/cihaz testi gerekir; masaüstü PNG dışa aktarımı yerel paylaşım sayılmaz. Otomatik gönderi veya paylaşım için ilerleme ödülü yoktur.
- Crew'un on açılımı ve donanım kimlikleri korunur; açılma koşulu dahili bölüm yerine level olarak yazılır. Dikey kaydırılan geniş lacivert/pirinç kartlarda her robot böceğin kendi görseli, adı ve kısa tanımı bulunur. Kilitli kart gereken level’ı gösterir; açık kartta Equip, seçili üyede Equipped durumu görünür. Seçim yalnız başarılı kayıttan sonra uygulanır.

### S6 — Shop

- Üstte altın bakiyesi. Bölümler: öne çıkan teklif, "No Ads", "Coins" (dört paket), "Boosters" (altınla), "Looks" (drone ve kutu görünümleri, altınla). Altta küçük "Restore Purchases".

### P1 — Settings

**28 Eylül stil/UX güncellemesi (P16-56):** Ortak lacivert/emaye pencere, Lora yazı tipi ve kısa açıklamalı dört geniş anahtar kullanılır. Her anahtar başarılı kayıttan sonra yerinde güncellenir; kayıt başarısızsa önceki durum korunur. Done ve Close ayarları kapatır. Pause içinde Resume ana eylemdir; ayrı Safehouse eylemi −1 enerji bedelini gösterir, iki eski güçlendirici korunur. İşlevsiz Privacy/Support yazısı çalışan bağlantı gibi gösterilmez.


- Sound, Music, Vibration, Reduced Motion anahtarları ve sürüm. Privacy ve Support bağlantıları gerçek sayfaları hazır olunca eklenir.
- Soygundan açılınca başlığı "Paused" olur; "Resume" (büyük) ve "−1 energy" notlu "Safehouse" gösterir.

### P2 — Out of Space

- Tıkalı dock'ların küçük görseli, "Out of space!".
- "Continue +1 Dock" (900 altın), "Watch Ad" (soygun başına bir kez), küçük "Retry" ve "Home" (her biri −1 enerji).

### P3 — Out of Energy

- Boş kalp, "Next energy in 12:40". "Refill" (900 altın), "Watch Ad" (+1 enerji), X.

### P4 — Reward

**28 Eylül ödül kutlaması (P16-58):** Başarılı ödül kaydından sonra P4, Level Complete renkleriyle tek ve kısa renkli konfeti patlaması ve sandıkta hafif büyüyüp yerine oturma hareketi oynatır. Efekt başlık/günlük şeridin altında ve Collect üzerinde kalır; tüm düğmeler hemen kullanılabilir. Reduced motion sabittir, uygulamanın askıya alınması efekti duraklatır ve sonlu animasyon 3,2 saniyede biter. Pencere kapatılınca efekt temizlenir ve ek ödül verilmez.

**28 Eylül stil/UX güncellemesi (P16-56):** Safehouse içindeki mevcut Rewards alanı, iki sütunda görsel kartlar içeren kapatılabilir lacivert/pirinç katmana dönüşür (P16-62 eski satır düzeninin yerine geçer): Daily, Star chest, Milestone chest, ücretsiz altın için açık Watch Ad, Offers ve No Ads. Hazır, alınmış, kilitli/ilerleme, tümü alınmış ve günlük sınır durumları gösterilir; hazır olmayan talepler devre dışıdır. Dışarı dokunma, Close ve Escape odağı pencereyi açan kısayola döndürür; genel görünüm açıkken arka plan düğmeleri klavye odağı alamaz. P4 gerektiğinde yedi günlük şeridi; gerçek altını, adetleri birleştirilmiş güçlendiricileri, satın alınan hakları ve enerjiyi ayrı ödül kutularında gösterir. Collect önceden kaydedilen ödülü onaylar, ikinci kez vermez. Otomatik reklam veya gerçek satın alma eklenmez.


- Sandık açılır, ödüller uçar. Günlük sürümde yedi günlük şerit görünür. "Collect".

### P5 — Offer

- Starter Pack, süreli Special Offer ve No Ads için tek kalıp: paket görseli, içerik ikonları, varsa kalan süre, fiyat butonu, X.

### P6 — Get Booster

- Güçlendirici görseli, adı, etkisini anlatan tek satır, 300 altına al, X.

### P7 — Painting Detail

- Büyük orijinal eser, ad, sanatçı/yıl ve tek gerçek bilgi; orijinal/piksel geçişi, koleksiyona ekleme/çıkarma ve koleksiyonu açma. Kazanılmış ve oyun panosu hazırlanmış eserlerde **Play Again** düğmesi, aynı kalıcı eser kimliğiyle yeni heisti başlatır; mevcut enerji denetimi ve tekrar oynama ödülü geçerlidir. Kilitli önizlemelerle henüz oynanabilir panosu olmayan eserlerde düğme görünmez. Photo Mode odayı gerçek PNG olarak kaydeder; metni panoya kopyalamak görsel paylaşımı değildir.

## 10. Geçişler

Ana döngü: Safehouse → Play → Heist → Level Complete → Safehouse; her bölüm finalinden sonra Level Complete → Story → Safehouse.

| Nereden | Eylem | Nereye |
| --- | --- | --- |
| S1 Safehouse | Play (enerji > 0) | S2 Heist |
| S1 Safehouse | Play (enerji 0) veya enerji çubuğu | P3 Out of Energy |
| S1 Safehouse | Avatar | S5 Gallery, Crew sekmesi |
| S1 Safehouse | Dişli | P1 Settings |
| S1 Safehouse | Hazır herhangi bir sandık | P4 Reward |
| S1 Safehouse | Offers / No Ads ikonu veya ödül kartı | P5 Offer (seçilen ürün; otomatik satın alma yok) |
| S1 Safehouse | Watch Ad ikonu veya ödül kartı | Ödüllü reklam → P4 Reward |
| S1 Safehouse | Altın çubuğu veya Shop sekmesi | S6 Shop |
| S1 Safehouse | Museum sekmesi | S5 Gallery, Paintings sekmesi |
| S1 Safehouse | Case File | S4 stage kartları → açık başlangıç/bitiş görselleri → stage kartları → Home (Stage 1 hazır) |
| S2 Heist | Pause | P1 Settings (Resume / Home −1 enerji) |
| S2 Heist | Stoğu sıfır güçlendirici | P6 Get Booster |
| S2 Heist | Son piksel teslim edildi | S3 Level Complete |
| S2 Heist | Dock'lar tıkandı | P2 Out of Space |
| P2 Out of Space | Continue (altın veya reklam) | +1 dock ile S2 Heist |
| P2 Out of Space | Retry / Home | Baştan S2 Heist / S1 (her biri −1 enerji) |
| S3 Level Complete | Continue | S1; bölüm finalinden sonra S4 Story |
| S4 Story | Open Chest → Continue veya Skip | P4 → S1 |
| S5 Gallery | Tabloya dokun | P7 Painting Detail |
| P7 Painting Detail | Play Again (kazanılmış oynanabilir eser, enerji var) | Aynı eser için S2 Heist |
| P7 Painting Detail | Play Again (enerji yok) | P3 Out of Energy |
| S6 Shop | Fiyat butonu | Platformun satın alma penceresi → onay bildirimi |
| P3 Out of Energy | Refill / Watch Ad | S2 Heist |

Normal ekran görünümünde Geri Safehouse'a döner. Müze içinde önce açık tablo ayrıntısı/kat listesi kapanır veya Photo/Edit modundan çıkılır; sonraki geri Safehouse'a döner. Hiçbir ekran üst üste birden fazla pencere açmaz. Aktif bir soygunun üstünde yalnız P1, P2 ve P6 açılabilir.

## 11. İlk oturum

1. İlk açılış Safehouse'u atlar: tek karelik Story (Rocco: "Five paintings. One night." / Sprocket: "Let's go.") → Soygun 1.
2. Soygun 1: el işareti, "Tap to send the ants."
3. Level Complete → Safehouse ilk kez açılır, Play parlar.
4. Soygun 2: "?" paket ipucu. Soygun 3: "Colors can wait." (mühürlü renkler).
5. Soygun 4: iki ücretsiz Extra Dock ve çubuğu gösteren el işareti.
6. Soygun 5: ilk bölüm finali → Story, sandık, ilk ekip üyesi.
7. Sandık ve Shop rozetleri Soygun 5'ten sonra görünür. Soygun 8'den önce reklam veya teklif çıkmaz.

## 12. Ekonomi

Tek para birimi (altın), enerji ve uyumlu beş güçlendirici stoğu (oyun alt menüsünde üç, Pause içinde iki eski özellik). Başlangıç değerleridir; oynanış testinden sonra ayarlanır.

| Kalem | Başlangıç değeri |
| --- | --- |
| Enerji | En fazla 10; 20 dakikada +1; yalnız kaybedince, Retry'da veya soygundan Home'da −1 |
| Kazanma ödülü | Normal 40, HARD 80, SUPER HARD 120 altın; tekrar oynayışlar 10 |
| Yıldızlar | Kazanış başına 1–3 (bölüm 3); her soygunda yalnız en iyi sonuç sayılır |
| Güçlendirici | Tanesi 300 altın |
| P2'de devam | 900 altın veya soygun başına bir ödüllü reklam |
| Enerji dolumu | Tam dolum 900 altın; ödüllü reklamla +1 |
| Star Chest | Her 10 yeni yıldızda açılır: altın + 1 güçlendirici |
| Milestone / Stage Chest | Her beşinci / onuncu level: mevcut altın + 2 güçlendirici |
| Daily sandığı | Yedi günlük döngü; 7. gün büyük sandık |

Başlangıç hediyeleri: ilk açılışta 200 altın, Soygun 4'te iki Extra Dock (bölüm 11). Ücretli altın asla hikâye erişimi, ipucu veya son satın almaz.

## 13. Reklamlar

Food Hunt'ın en sık şikâyeti her bölümden sonra çıkan reklamdır; bu yüzden sıklık sınırlıdır.

- **Ödüllü (her zaman isteğe bağlı):** Level Complete'te 2× Coins, P2'de Continue, P3'te +1 enerji, 50 altın için Watch Ads (günde en fazla 5).
- **Geçiş reklamı:** yalnız kazanmadan sonra, Soygun 8'den itibaren, en fazla iki soygunda bir ve üç dakikada bir. Kaybettikten sonra, soygun sırasında veya Story'den önce asla.
- Ödül, reklamı kapatmakla değil, sağlayıcının doğrulanmış ödül olayıyla bir kez verilir. Çevrimdışı veya başarısız reklam ana akışı asla durdurmaz.
- Reklam oynarken oyun, ses ve zamanlayıcılar durur.
- **No Ads** yalnız geçiş reklamlarını kaldırır; ödüllü reklamlar isteğe bağlı kalır.

## 14. Satın almalar

Fiyatlar Food Hunt'ın kullandığı Türkiye App Store kademeleridir ve başlangıç referansıdır; platform yerel fiyatı gösterir.

| Paket | İçerik | Fiyat (TRY) |
| --- | --- | --- |
| Starter Pack | 1.000 altın, her güçlendiriciden 2, 1 saat sınırsız enerji; oyuncu başına bir kez | 49,99 |
| Coins S | 1.200 altın | 99,99 |
| Coins M | 6.000 altın | 399,99 |
| Coins L | 14.000 altın | 799,99 |
| No Ads | Geçiş reklamlarını kaldırır | 399,99 |
| No Ads Pack | No Ads + 3.000 altın + her güçlendiriciden 3 | 499,99 |
| Special Offer | Süreli: altın + güçlendiriciler + bir drone görünümü | 249,99 |

- İçerikler sabittir ve satın almadan önce gösterilir; rastgele ganimet yoktur.
- Satın alma platformun penceresinden geçer. Bekleyen, başarılı, iptal, hata ve geri yükleme ayrı ele alınır. Kalıcı öğeler (No Ads, görünümler) yeniden kurulumda geri yüklenir.
- Önce sahte sağlayıcılı bir sağlayıcı arayüzü yapılır. Testler asla gerçek satın alma yapmaz.
- Sezon kartı kendi ekranını gerektirdiği için çıkış kapsamında değildir.

## 15. Görsel, ses ve metin kuralları

1. Başlık en fazla üç kelime; ekran başına en fazla bir açıklama satırı, en fazla on kelime; buton metni bir ya da iki kelime.
2. Sayılar ikonla birlikte görünür (altın ikonuyla "+50"), asla cümle olarak değil.
3. Hikâye metni yalnız S4'te ve S3 kazanma balonunda görünür (bölüm 7).
4. Görsel dil Safehouse'tan gelir: bakır ve pirinç yuvarlak butonlar, ahşap ve metal paneller, müze salonu arka planı, altın yazılar. Düz lacivert form panelleri kullanılmaz.
5. Pencereler bölüm 9'daki kalıbı izler.
6. Aktif bir soygunun üstünde P1, P2 ve P6 dışında hiçbir şey açılmaz.
7. Sessiz pervaneler, yumuşak tahta toplama notaları, hareketli macera müziği (isteğe bağlı), titreşim ve azaltılmış hareket korunur.

Malzeme, ışık ve hareket ayrıntıları bu bölümle çelişmediği yerde [VisualDirection.tr.md](VisualDirection.tr.md) içinde kalır.

## 16. Dil ve kimlik

**Oyuncunun gördüğü tüm metin yalnız İngilizcedir** (Halil, 25 Eylül 2026): menüler, göstergeler, butonlar, hikâye, diyaloglar, bildirimler, mağaza ögeleri ve yeni görsellerin içindeki yazılar. Oyun cihaz dilini izlemez ve dil seçicisi yoktur. Halil ile konuşma dili Türkçe kalır; bu kural yalnız oyun içeriğini kapsar.

Mevcut tr/es/de katalogları depoda kalır ama gönderilmez ve bakımı yapılmaz. İngilizce metinler kararlı yerelleştirme anahtarlarını korur; içerik hiçbir zaman görünen metne bağlı değildir.

| Kararlı karakter kimliği | Görünen ad | Rol |
| --- | --- | --- |
| `rocco` | Rocco “Pixel” | Oyuncu hırsız |
| `sprocket` | Sprocket | Teknik ortak |
| `quill` | Quill | Gazeteci |
| `frost` | Mr. Frost | Küratör / müşteri |
| `glimmer` | Baron Glimmer | Atlas koleksiyoncusu |
| `tuck` | Tuck | Safehouse galeri sorumlusu |
| `barnaby` | Barnaby Bramble | Hayatını kaybetmiş restoratör |

`art_id`, `chapter_id`, `character_id`, `crew_id`, `booster_id` ve `product_id` kaydedilir; görünen metin asla kaydedilmez.

## 17. Kayıtlar ve r12'den geçiş

- P02'deki atomik birincil/yedek kayıt ve soygun ortasında devam korunur. Devam asla ödülü çoğaltmaz.
- Tamamlanmış soygunlar `art_id` ile doğrusal sıraya eşlenir. İlk tamamlanmamış soygun sıradaki Play olur.
- Bir kez edinilmiş her eser, r12'deki durumu ne olursa olsun (saklanan, satılan, iade edilen, ödünç verilen veya depodaki) Gallery'de görünür.
- r12 kredileri 1:1 altına dönüşür. Hız bütçesi, yol puanları, kişi güveni, haberler, etiketler ve notlar yok sayılır ama dosyada bırakılır.
- Yeni kaydedilen durum: altın, enerji ve zaman damgası, güçlendirici stoğu, soygun başına yıldız, sandık ilerlemesi, seçili ekip ve görünümler, satın alma hakları, günlük sandık günü, geçiş reklamı sayaçları.
- Testler yalıtılmış kayıt kullanır ve oyuncunun `user://progress.cfg` dosyasına asla dokunmaz.

## 18. Mühendislik ve yayın sınırı

[ToDoList.tr.md](../ToDoList.tr.md) fazları ve görevleri tanımlar; **P16** fazı bu revizyonu uygular ve önceki fazlardaki çelişen bekleyen görevlerin yerini alır.

- Platformlar: dikey iOS ve Android; geliştirme ortamı macOS. Godot 4, GL Compatibility çizici.
- Çekirdek oyun çevrimdışı çalışmalıdır; reklam ve satın alma sorunsuzca devre dışı kalır.
- Satın alma ve reklam, gerçek SDK entegrasyonu ayrıca onaylanana kadar sahte sağlayıcılı arayüzler kullanır.
- Kaldırılan r12 sistemleri (hedef seçimi, inceleme, eser kararı, yollar, haberler, dava dosyası, anı stüdyosu, atölye, sergiler) P16'da, önce kayıt geçişi yapılarak çalışma kodundan silinir.
- AI iş akışı: `AGENTS.md`, İngilizce `GameDesign.md` ve `ToDoList.md` okunur; seçilen P16 görevi uygulanır, doğrulanır ve iki görev listesi birlikte güncellenir.

P16 uygulama durumu ve kanıtı: [P16-Implementation.md](P16-Implementation.md). Bölüm 4–20'nin hikâyesi, finalleri ve kazanma satırları hazır; ancak 85 soygun bulmacası ve eserleri henüz üretilmedi. O zamana kadar Safehouse, Level 15'ten sonra (Stage 2 ortasında) "More heists coming soon!" gösterir.

Önceki uygulama kayıtları neyin yapıldığına dair geçerli tarihçedir: [P01](P01-Implementation.md), [P02](P02-Implementation.md), [P03](P03-Implementation.md), [P04](P04-Implementation.md), [P05](P05-Implementation.md), [P06](P06-Implementation.md), [P07](P07-Implementation.md), [kayıt sözleşmesi](Persistence.md), [çizim kararı](RenderingDecision.md).

Satın alma ve geri yükleme kuralları için [Apple In-App Purchase](https://developer.apple.com/in-app-purchase/) ve [Google Play Payments](https://support.google.com/googleplay/android-developer/answer/9858738?hl=en) kaynaklarına bakılır. [Google'ın ödüllü reklam rehberi](https://developers.google.com/admob/android/rewarded) test reklamlarını ve doğrulanmış ödül olaylarını anlatır. Tasarım referansı [Food Hunt: Pixel Puzzle](https://apps.apple.com/tr/app/food-hunt-pixel-puzzle/id6769314786).
