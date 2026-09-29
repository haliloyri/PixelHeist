# Pixel Heist

Tam oyun için asıl tasarım [İngilizce GameDesign.md](docs/GameDesign.md), okuma karşılığı [Türkçe tasarım](docs/10-pixel-heist-oyun-cercevesi-ve-ekranlar.md) dosyasındadır. Fazlı uygulama: [ToDoList.md](ToDoList.md) / [Türkçe](ToDoList.tr.md). AI modeller önce İngilizce belgeleri okumalıdır; giriş kuralları [AGENTS.md](AGENTS.md) içindedir. Aşağıdaki yönergeler mevcut demoyu anlatır; planlanan tam oyun özellikleri uygulanmış sayılmaz.

Food Hunt'ın renk seçimi ve sınırlı yuva bulmacasından esinlenen, sanat soygunu temalı **Godot demosu**. Bu klasörde sıfırdan oluşturuldu. Godot 4.7.1 ile doğrulandı.

Güncel uygulama P06’ya kadar ilerledi: ilk hikâye vakası, kalıcı eser kararları, dört gelişim yönü, kişisel anılar/profil ve krediyle altı görünüm çalışıyor. [P06 teslim raporu](docs/P06-Implementation.md) doğrulama ve sınırları kaydeder. Girişten veya müzedeki **Profil** düğmesinden anılara ve **Krediyle görünümler** ekranına ulaşılır. P07 ile on katlı mekânsal müze, sergiler, dosya ve haber arşivi eklendi ([P07 raporu](docs/P07-Implementation.md)). P08 tam kesit doğrulaması sürüyor ([P08 raporu](docs/P08-Implementation.md)); tam kampanya henüz tamamlanmadı.

## Oyna

Godot'ta `project.godot` dosyasını aç. Dosya Sistemi panelinden `scenes/main.tscn` dosyasına çift tıkla ve üstte **2D** görünümünü seç. Ana menü editörde doğrudan görünür. **F5** ile tüm projeyi çalıştır; ana sahne zaten ayarlı.

Arayüzler gerçek sahne dosyalarıdır:

- `scenes/main.tscn`: Ana giriş; menü sahnesini içerir. Bu sahne açıkken F6 da çalışır.
- `scenes/ui/home.tscn`: Düzenlenebilir ana menü, başlıklar, eserler ve düğmeler.
- `scenes/ui/heist.tscn`: Düzenlenebilir oyun ekranı; editörde Yıldızlı Gece örneği gösterilir.
- `scenes/ui/gallery.tscn`: Sağ-sol gezilebilir sanat galerisi; editör önizlemesi vardır.

Alt ekranlar birer arayüz bileşenidir; oynanış için **F5** kullan. Eserleri editörde göstermek için yalnızca çizim betikleri `@tool` kullanır; oyun mantığı, ses ve kayıt işlemleri editörde çalışmaz. Önceki boş sahne hâlâ açıksa `main.tscn` sekmesini kapatıp yeniden aç.

Bu bilgisayarda terminalden:

```sh
/Users/hoyri/Downloads/Godot.app/Contents/MacOS/Godot --path /Users/hoyri/Documents/Projects/PixelHeist
```

Başlangıçta **Level 1 / Level 2 / Level 3** sekmesini ve beş eserden birini seç; **Seçili Esere Git** düğmesiyle başla. Demo için on beş eserin tamamı açıktır. Kuyruktaki ön dronlardan birine dokun veya tıkla. Dron gövdelerinde yalnızca kapasite sayıları görünür; gövde rengi toplanacak pikselleri belirtir. Dronlar dışarıdan erişilen eş renkli parçaları toplar. İçte kalan renkler, önlerindeki parçalar açılana kadar bekler. Bütün aktif yuvalar dolup hiçbir dron çalışamazsa son seçimi geri alabilirsin.

- **1 / 2 / 3:** Kuyruk sütununu seç. Level 3’te **4 / 5** de kullanılabilir.
- **Z:** Son seçimi ve o seçimden sonraki toplamaları geri al.
- **Esc:** Görevi duraklat / bilgi penceresini kapat.
- **1× / 3×:** Taşıma hızını değiştir. Krem/altın düğme, kalan 3× hakkını dakika:saniye olarak gösterir.
- **Hoparlör:** Tüm sesleri aç / kapat.
- Duraklatma menüsünde tüm sesler, bağımsız müzik ayarı, azaltılmış hareket ve yeniden başlatma var. Hafif motor uğultusu ve düşük seviyede gerilim müziği oyuna eşlik eder.

Her geçerli renk kutusu herhangi bir boş yuvaya yerleşebilir. Önce kendi üstündeki boş yuva tercih edilir; orası doluysa başka bir boş yuvaya geçer. Aynı sütundan boş yuva sayısı kadar kutu art arda seçilebilir. Her küçük dron, pikseli çıktığı taşıyıcı drona geri getirir. Aktif alanda Level 1–2’de üç, Level 3’te beş tam dron gövdesi vardır; çanta tabanı yoktur. Kuyruktaki gövdeler pervanesizdir. Seçilince üst sıraya taşınır. İlk küçük dron hareket etmeye başladığında taşıyıcının pervaneleri açılır; çalışacak erişilebilir rengi olmayan taşıyıcı kapalı bekler. Çıkışlar arasında en az 0,40 saniye bırakılır. Sayı sıfıra indiğinde taşıyıcı kameraya doğru büyüyerek yükselir ve sağdan ya da soldan ekranı tamamen terk eder. Son piksel teslim edildiği anda yuva yeniden kullanılabilir. Her taşıyıcı, kendi rengine uyan erişilebilir ve henüz ayrılmamış pikseller arasından kendisine en yakınını seçer. Dronlar hedef piksele en yakın erişilebilir çerçeve kenarına dışarıdan gider, içeride yalnızca boş hücrelerden geçer. Piksel, dron yanına ulaştığında manyetik kolla kavranır; 0,55 saniyelik yükselme ve drona çekilme animasyonu oynar. Her alımda mıknatısın küçük bir metal parçaya hafifçe temasını andıran ince, kısa ve yumuşak bir ASMR efekti çalar. Uçuşan dronların açık alandaki boyutu iki katına çıkarıldı; dar boşluklarda dolu hücrelere taşmamak için çizim boyutları uyarlanır. Varsayılan hareket yavaştır; istersen 3× seçebilirsin.

3× hız için oyun genelinde **10 dakika** kullanım hakkı vardır. Süre yalnızca 3× açıkken gerçek saniyelerle azalır; 1×’te, duraklatmada ve menülerde bekler. 00:00’da hız 1× olur ve düğme kapanır. Kullanım hakkı kaydedilir; yeniden başlatma ve geri alma süreyi yenilemez. Üstteki dolu yuvaların tamamındaki taşıyıcılar çalışmaya başlayınca, süre varsa otomatik 3× açılır. Boş yuvalar ve alttaki kuyrukta kalan kutular buna engel değildir. Bir taşıyıcı beklemeye geçerse veya yeni kutu yerleştirilirse otomatik hız 1× olur; hepsi çalışınca tekrar 3× açılır. Elle seçilen 3× korunur. Oyuncu otomatik hızlanmayı 1× seçerek kapatabilir; aynı çalışma durumu sürdükçe tekrar açılmaz.

## Demo içeriği

**Level 1:** Güneş Mührü, Safir Kupa, İnci Küpeli Kız, Yıldızlı Gece, Ay Kapısı Maskesi. Kapasiteler çoğunlukla 5–9, son kalan gruplar 1–4 pikseldir; seçim süresi yoktur.

**Level 2:** Mona Lisa, Öpücük, Çığlık, Venüs’ün Doğuşu, Nilüferler. Kapasiteler çoğunlukla 3–7 pikseldir. Süre barı yalnızca tabloda bulunmayan renklerde görünür. Bar 9 / 8,5 / 8 / 7,5 / 7 saniyede soldan sağa boşalır. Tabloda kullanılan renkler süresiz bekler ve kendiliğinden kuyruktan çıkmaz. İlgisiz renkler seçilemez; süresi dolunca sıradan çıkar. Bar 15 piksel yüksekliğinde, kutunun gerçek rengindedir. Süre yalnızca duraklatma/modallarda bekler; 3× düğmesi seçim süresini hızlandırmaz. Geri alma, kuyruk sayaçlarını da eski hâline getirir.

**Level 3:** Başak Toplayanlar, Saksağan, Yıldız, Moulin de la Galette, Elmalar ve Portakallar. Yan yana **beş seçim sütunu ve beş paylaşılan yuva** bulunur. Bu beş Paris görevinin tek girişi tablonun alt kenarıdır. Üst, sol ve sağ kenarlar mühürlüdür; dronlar alttan girip boşalan hücrelerden yukarı ilerler ve yine alttan döner. Bakır renkli üç kapalı kenar ve yeşil alt oklar bu kuralı gösterir. Küçük kapasite, gizli kutu ve yalnızca ilgisiz renklerde 7 saniyelik süre barı devam eder. Sıralara, henüz ulaşılamayan iç renklerden kutular da karışır: seçilebilirler, fakat önlerindeki pikseller temizlenene kadar yuvada pervaneleri kapalı beklerler. Yol açılınca otomatik çalışırlar; süreyle kaybolmazlar. Bütün yuvaları bekleyen renklerle doldurmamak için sonraki kutulara ve tablonun açık kenarına bak.

Alt sıradaki kutular kendi gerçek rengini taşır. Bazı kutuların önizlemesi nötr renkte **?** olarak görünür; seçim yapılabilen ön sıraya gelince gerçek rengi ve sayısı açılır. Bu bilgi geri alma sırasında rastgele değişmez.

Her eser sonrası piksel konfeti, eseri taşıyan iki drone ve sonraki eser / galeri düğmeleri bulunan başarı ekranı açılır. Demoda üç level de baştan açıktır. Yalnızca tüm eserler toplanınca demo tamamlanmış sayılır.

**Gece Galerisi / Müze:** Ana menüdeki **Müze** düğmesinden gir. Görüş hırsızın göz hizasındadır; ekranda hırsız figürü yoktur. A/D, yön tuşları, ekrandaki oklar veya zemine dokunmayla kat boyunca ilerle. Her katta beş çerçeve, en solda ve en sağda birer asansör bulunur. Asansöre dokununca yaklaşılır; kapılar kapanır ve diğer kata çıkılır/inilir. Orta katta sol asansör aşağıya, sağ asansör yukarıya gider; en alt ve en üst katlarda iki asansör de komşu kata gider. Eski on yuvalı kayıtlar yerleşimleri korunarak on beş yuvaya genişletilir. Galeride **1. Kat / 2. Kat / 3. Kat**, oyunda **Level** yazılır.

Çalınmamış eserlerin çerçeveleri boştur. Boş çerçeveye dokununca henüz çalınmamış üç farklı eser önerilir; kalan sayı üçten azsa yalnızca kalanlar gösterilir. **Çalmaya Git** seçimi o eserin soygununu başlatır. Tamamlanınca eser seçilen çerçeveye yerleşir ve yeri kaydedilir. Ana menüden tamamlanan bir eser ilk boş çerçeveye yerleşir; tekrar oynama kopya oluşturmaz. Dolu çerçeveye dokununca eser büyür, müze kaynaklı bilgiler açılır.

Yerleştirme yuvaları eser/şehir paletine özel renktedir; yuva üzerinde veya altında açıklama yazısı yoktur.

İlerleme ve ayarlar `user://progress.cfg` içinde saklanır. **Bölüm tamamlanmaları kaydedilir; yarım kalan bulmacanın anlık durumu kaydedilmez.** Ana menüye dönüp devam ettiğinde tamamlanmamış görev baştan açılır.

## Yapı

- `scripts/core/puzzle_state.gd`: Deterministik erişim, kapsül, kuyruk, kilitlenme ve geri alma kuralları.
- `scripts/core/drone_routes.gd`: Çerçeve dışındaki yol ve boş hücrelerden hedefe ulaşım.
- `scripts/main.gd`: Ekran akışı, kontroller, ses ve görsel zamanlama; kayıt/platform bileşenlerini çağırır.
- `scripts/services/legacy_save_store.gd`: Mevcut kayıt biçimini koruyan okuma/yazma sınırı.
- `scripts/platform/capabilities.gd`: Kaynak bağlantıları ve sağlayıcı bulunmayan platform işlemleri.
- `scripts/ui/`: Piksel eser, galeri arka planı ve dron çizimleri.
- `data/artwork_details.json`: Galeride gösterilen Türkçe bilgiler ve resmî müze kaynakları.
- `data/locations.json`: Bölümlerin şehir/ülke temaları ve görsel eşlemeleri. Kurmaca eserlerin konumları hikâye seçimidir.
- `assets/backgrounds/`: On görev konumu için şehir desenleri.
- `data/levels.json`: On beş sabit harita, paletler, kapsül sütunları, diyaloglar ve çözüm sıraları.
- `tools/build_content.py`: Haritaları/sesleri üretir, ardından `tools/rebuild_queues.gd` ile gerçek dron simülasyonu üzerinden paylaşılan yuvalara uygun kuyrukları oluşturur. Godot yolu bulunamazsa `GODOT_BIN` tanımlanır. Oyun çalışırken Python gerekmez.
- `tests/`: Godot içinde çalışan mekanik ve ekran akışı testleri.
- `docs/`: Referans analizi, hikâye tasarımı ve demo doğrulama notu.

Oyun dış ağ, eklenti veya Python bağımlılığı kullanmaz. Piksel yorumları, dron çizimleri ve toplama sesleri kodla; on şehir desenli arka plan imagegen ile proje için üretildi; referans ekran görüntüleri oyun varlığı olarak kullanılmaz. Arka plan sesleri Kenney ve yd tarafından CC0 ile yayımlanmıştır; kaynaklar ve düzenlemeler `assets/audio/CREDITS.md` dosyasındadır. On iki ünlü tablo stilize yorumdur; tarihî mühür, kupa ve maske özgün kurmacadır.

## Doğrulama

P01 için önerilen tek komut, temiz geçici proje ve yalıtılmış kayıtlarla bütün testleri çalıştırır:

```sh
python3 tools/validate_project.py --visual
```

macOS üzerinde CoreAudio varsayılandır; görsel olmayan doğrulama için `--visual` seçeneğini çıkar. Çıktılar `artifacts/validation/` altındadır. [Geliştirme ve yedekleme yönergesi](docs/Development.md), [mimari sınırlar](docs/Architecture.md) ve [P01 sonuçları](docs/P01-Implementation.md) ayrıntıları tutar. Sıradaki iş P02 kayıt şeması ve yarım soyguna devamdır.

Godot yürütülebilir dosyasını `godot` olarak erişilebilir yaptıysan:

```sh
godot --headless --path . --script res://tests/test_puzzle.gd
godot --headless --path . --script res://tests/test_flow.gd
godot --headless --path . --script res://tests/test_drones.gd
godot --headless --path . --script res://tests/test_expansion.gd
godot --headless --path . --script res://tests/test_museum.gd
godot --headless --path . --script res://tests/test_columns.gd
godot --headless --path . --script res://tests/test_bottom_entry.gd
godot --headless --path . --script res://tests/test_boost.gd
godot --headless --path . --script res://tests/test_anticipation.gd
godot --headless --audio-driver CoreAudio --path . --script res://tests/test_ambience.gd
godot --path . --script res://tests/capture_museum.gd
```

On test de görsel pencere gerektirmez. Ses testi macOS üzerinde gerçek CoreAudio sürücüsüyle çalışır. Ekran görüntüsü kontrolü gerçek grafik ortamı ister ve `artifacts/` altına görüntü yazar. Testler oyuncunun ilerlemesini değiştirmez; kayıt testi kendi geçici dosyasını kullanır ve siler. `--test-mode --level=3` gibi kullanıcı argümanları bir görevi kayıtsız incelemeyi sağlar; indeksler 0'dan başlar.

Mevcut doğrulama macOS masaüstü üzerinde yapıldı. Dikey düzen ve dokunmadan fareye olay dönüşümü hazır; Android/iOS cihaz testi, imzalama ve dağıtım paketi bu demo teslimine dahil değil. Bölüm zorluğu ve ilk oynayış süresi gerçek oyuncu oturumlarında henüz ölçülmedi.

Godot API başvuruları: [Özel 2D çizim](https://docs.godotengine.org/en/stable/tutorials/2d/custom_drawing_in_2d.html), [AudioStreamWAV](https://docs.godotengine.org/en/stable/classes/class_audiostreamwav.html).
