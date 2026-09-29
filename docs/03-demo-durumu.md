# Pixel Heist — İlk oynanabilir demo

> Önceki sürümlerin tarihçesi. Güncel özellikler ve doğrulama: [Level 2 ve galeri](04-level-2-ve-galeri.md).

## Teslim edilen

Godot 4.7.1 için sıfırdan proje, ana sahne, beş sabit bölüm, Türkçe hikâye akışı, ana menü, koleksiyon ve final oluşturuldu. Oyun dış servis gerektirmez. Çalıştırma yönergeleri kökteki `README.md` dosyasındadır.

Renk ve kapasite seçimi, dış boşluktan hücre erişimi, beş aktif yuva, üç kuyruk sütunu, otomatik dron taşımaları, bekleme, kilitlenme, ücretsiz tek adım geri alma, yeniden başlatma, 1×/3× hız, yalnızca rakamlı kapsüller, azaltılmış hareket, ses ayarları ve tamamlanan bölümlerin kaydı çalışır.

## Gerçekleştirilen doğrulama

- **607 mekanik kontrolü, 0 başarısızlık:** Beş çözüm sırası, renk/kapasite toplamları, kısmi toplama sonrası geri alma, kapalı iç boşluklar, aynı renkte kapsül önceliği, dolu alan ve hatalı hamlelerin durumu değiştirmemesi.
- **401 oyun akışı kontrolü, 0 başarısızlık:** Gerçek Godot düğmelerinin sinyalleriyle seçim, duraklatma, uçuşta geri alma, beş bölümün sonuç ve geçiş ekranları, final, koleksiyon ve izole dosyada kayıt/yükleme. 1× ve 3× akışlarının son durumları eşit.
- Son iki bölümde iç renkleri önce beş yuvaya dolduran belirli yanlış sıralamalar kilitlenir. Geri alıp dış katman kapsülünü seçmek yeniden ilerleme sağlar.
- Her iki bölüm için denenmiş sekizer sabit tohumlu rastgele stratejinin tamamı kazanmıştır. Dolayısıyla zorluğun yeterli olduğu iddia edilmiyor; mevcut denge affedicidir ve oyuncu testi gerektirir.
- Godot'un gerçek OpenGL penceresinden ana menü, görev girişi, eser, taşıma, duraklatma, kilitlenme, sonuç, final, koleksiyon ve ipucu ekranlarının görüntüleri alındı. Yazı ve düğme yerleşimleri görsel olarak incelendi. Görüntüler `artifacts/` klasöründe.
- Son mekanik, akış ve ekran yakalama günlüklerinde Godot betik hatası görülmedi. İlk akış kontrolünde yakalanan, hızlı ekran geçişinde eski animasyonun silinmiş nesneye erişmesi sorunu giderildi.
- Ek işletim sistemi arayüz kontrolü aracı Godot uygulamasına bağlanamadı. Fiziksel fare tıklaması üzerinden uçtan uca doğrulama yapılmış sayılmıyor; kontrol sinyalleri ve gerçek görüntü üretimi Godot içinde doğrulandı.

## Tasarım belgesinden ilk uygulamaya farklar

- Resimlerin tanınabilirliği için öğretici olmayan eserlerin hücre sayısı başlangıç tahmininden artırıldı: İnci 672, Yıldızlar 884, Maske 526. İlk görev 101, ikinci görev 124 hücre.
- Boş yuvalara taşıma sürerken yeni kapsül seçilebilir. Hareket hâlindeyken geri alma, önceki kapsüllerin dron konumlarını ve ayrılmış piksellerini de geri yükler. Dronlar hedefe en yakın erişilebilir çerçeve kenarına dışarıdan gider; dolu pikseller üzerinden geçmez.
- Son iki haritada sökülebilen bir dış tarama halkası var; bu halka erişim sırası için kullanılır.
- Karakter anlatımı konuşmacı isimleri ve kısa metinlerle sunulur; karakter portre çizimleri bu sürümde yok.
- Tamamlanan bölümler ve ayarlar kaydedilir; yarım kalan görev baştan başlar.

## Editörde boş sahne düzeltmesi

İlk sürümde `main.tscn` yalnızca bir kök Control içeriyordu; ekranlar çalışma anında oluşturulduğu için editör boş görünüyordu. Ana menü, oyun ve koleksiyon `scenes/ui/` altında gerçek PackedScene dosyalarına taşındı. Ana sahne artık menüyü dosyada içerir; oyun da bu aynı sahneleri kullanır. Düğmeler, metinler, çerçeveler ve eser düğümleri 2D editöründe seçilebilir. Çizim betikleri güvenli, salt görsel `@tool` önizlemesi sağlar.

Sahne yokluğu ile oyunun çalışma hatası ayrı değerlendirildi: önceki açılış kontrolünde bir GDScript hatası yeniden üretilemedi. Boş editör sorunu düzeltildi; başka bir çalıştırma hatası varsa somut hata mesajıyla ayrıca teşhis edilmelidir.

Düzeltme sonrası gerçek `main.tscn` örneği üzerinden **403 akış kontrolü hatasız geçti**. Ana oyun betiği çıkarıldığında bile sahnedeki menünün göründüğü ayrı görüntüyle doğrulandı (`artifacts/00-serialized-scene.png`). Godot editörü doğrudan `main.tscn` ile başlatıldı.

## Referans UX ve sakin toplama güncellemesi

Oyun ekranı referanstaki ahşap yüzey, krem çerçeve, transfer deliği, beş yuva, rakamlı kuyruk ve üç yuvarlak alt kontrol düzenine geçti. Harf işaretleri ve müzik kaldırıldı. Her gerçek piksel alımı altı kısa ASMR tarzı efekt varyantından birini çalar; hız düğmesi ses perdesini değiştirmez. Sesler kodla üretilmiştir.

**607 mekanik, 403 akış ve 29 dron kontrolü hatasız geçti.** Dron kontrolleri; en yakın erişilebilir kenarı, dolu hücrelerden kaçınmayı, sabit yavaş hızı, eşzamanlı kapsül seçimini, uçuşta geri almayı, yeni boşalan yuvanın uçuş sürerken doldurulmasını ve piksel başına tek ses olayını sınar. Güncel görüntüler `artifacts/ux-pearl.png` ve `artifacts/ux-drones.png` içindedir.

## Büyük dron ve manyetik kavrama

Dronların açık alandaki yarıçapı 12 piksele çıkarıldı; dolu hücrelere yaklaşınca görünür gövde boşluğa sığar. Her alımda 0,55 saniyelik kavrama, yükselme ve drona çekilme animasyonu vardır. Altı alım sesi tok temas, kısa sönümlenen metal titreşimi ve hafif ikinci oturma darbesiyle yeniden üretildi. Yeni ses dosyalarında kırpılma yok; son 10 ms sessizliğe iner. İşitsel beğeni değerlendirmesi yapılmış değildir. Yeni animasyonla 29 dron ve 403 akış kontrolü hatasız geçti; görüntü `artifacts/ux-magnetic-lift.png` içindedir.

## Tepeden dron tasarımı, çantaya dönüş ve şehir desenleri

Küçük dronlar ve çantalardaki büyük taşıyıcılar ortak dört pervaneli tepeden çizimi kullanır. Küçük dronlar en az 0,32 saniye aralıkla çıkar ve aldıkları pikseli kendi çantalarına geri götürür. Ortadaki ortak teslimat deliği kaldırıldı. Çantanın kalan kapasitesi büyük dronun üzerinde görünür; son teslimde 0 gösteren taşıyıcı 1,25 saniyede yükselip kaybolur. Yuvası hemen kullanılabilir. Geri alma, duraklatma ve yeniden başlatma bu animasyonların durumunu da yönetir.

Beş özgün desen görseli imagegen ile üretildi ve `assets/backgrounds/` altına kaydedildi. Eşlemeler `data/locations.json` içinde. Ankara, İznik ve Luksor kurmaca eserlerin tasarım konumlarıdır. Lahey seçimi [Mauritshuis'in konumuna](https://www.mauritshuis.nl/en/visit), Saint-Rémy seçimi [Yıldızlı Gece'nin yapıldığı yere](https://www.moma.org/collection/works/79802) dayanır; bugünkü müze konumuyla karıştırılmaz. Desenler oyun alanının altında hafifletilir; şehir/ülke etiketi açık bir başlık yüzeyinde görünür.

Güncel taşıyıcı sürümünde **33 dron kontrolü ve 403 oyun akışı kontrolü** hatasız geçti. Beş desenli ekran ve sıfır rakamıyla kalkış anı gerçek Godot penceresinden görüntülendi (`artifacts/ux-city-0.png`–`ux-city-4.png`, `ux-carrier-departure.png`).

## Üç yuva, açılan pervaneler ve gerilim sesi — önceki sürüm

Aktif yuva sayısı beşten üçe indirildi. Çanta tabanları kaldırıldı; aktif birimler doğrudan dron gövdesidir. Kuyruktaki gövdeler pervanesizdir. Seçimde önce 0,38 saniyede aktif sıraya gelir, 0,75 saniyeye kadar pervanelerini açar; küçük dronlar bu tamamlanmadan çıkmaz. Çıkışlar arası en az 0,40 saniyedir. Uçuşan dron yarıçapı açık alanda 12'den 24'e çıkarıldı; dar geçitlerde dolu hücrelere taşmaması için boyutu uyarlanır.

Tamamlanan taşıyıcı 0 rakamını gösterir, kameraya doğru yaklaşık 1,82 kat büyür ve 1,8 saniyede sağ veya sol kenardan tamamen çıkar. Eski erken silinme/sönme kaldırıldı. Yuvası animasyon sırasında hemen kullanılabilir.

Düşük seviyede motor uğultusu ve gerilim müziği eklendi: Kenney / Sci-Fi Sounds, yd / Insistent. CC0 kaynakları ve işleme ayrıntıları `assets/audio/CREDITS.md` içinde. Toplama sesleri korunur; arka plan sesleri duraklatma/menüde yumuşakça susar, tüm sesleri kapatmak anında susturur. Müzik tercihi ayrıca kaydedilir. Bu değişiklik önceki müziksiz sürüm kararının yerine geçer.

Üç yuva ile beş özgün çözüm tamamlandı. **601 mekanik kontrolü** hatasız geçti; son iki bölümde sekizer sabit rastgele stratejinin üçü kilitlendi. Gerçek oyuncu zorluk ölçümü hâlâ yapılmadı.

**Son doğrulama:** 601 mekanik, 405 akış, 39 dron ve 8 ses kontrolü hatasız geçti. Ses testi gerçek macOS CoreAudio sürücüsüyle de doğrulandı. Godot başsız Dummy ses sürücüsünde aktif oynatma testinin kapanışında kaynak uyarısı oluşur; CoreAudio çalıştırmasında bu uyarı oluşmaz. Yeni görünüm, pervane açılması, kameraya kalkış ve kenardan çıkış gerçek Godot görüntüleriyle kontrol edildi.

## Platform sınırları

Bu bir ilk oynanabilir masaüstü demosudur. Piksel çizimleri ve sesler özgün, kodla üretilmiş demo varlıklarıdır. Mobil dokunma dönüşümü ve dikey ekran ölçeklemesi tanımlı, ancak gerçek Android/iOS cihaz testi ve mağaza dağıtımı yapılmadı. Sesin işitsel kalite değerlendirmesi ve gerçek oyuncularla süre/zorluk ölçümü yapılmadı.

Sonraki ürün çalışması, mevcut demo üzerinde oyuncu geri bildirimiyle bölüm zorluğunu ve sanat yönünü geliştirmektir.
