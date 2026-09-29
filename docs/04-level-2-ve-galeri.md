# Level 2 ve gezilebilir galeri

Bu belge önceki Level 2 iterasyonunu tanımlar. Güncel değişiklikler: [Müze, eser seçimi ve hedefleme](05-muze-ve-hedefleme.md).

## Oynanış

- Level 1, mevcut beş eserden oluşur. Normal kapsüller 5–9 piksel; son kalan gruplar daha küçük olabilir.
- Level 2: Mona Lisa, Öpücük, Çığlık, Venüs’ün Doğuşu, Nilüferler. Normal kapsüller 3–7 piksel; artan seçim sıklığına süreli sıra ve ilgisiz renkler eşlik eder.
- Sadece seçilebilir ön sıranın üç bağımsız barı işler. Eser sırasıyla 9, 8,5, 8, 7,5, 7 saniye. Boşalma soldan sağa ilerler. Yerine gelen gövde kısa bir yükselme hareketi yapar ve tam süre alır.
- Gerekli renk süre sonunda kuyruğun sonuna döner; gereksiz renk atılır. Gerekli taşıma kapasitesi kaybolmaz. Gereksiz bir renk seçilirse 5 oyun saniyesi boyunca bir yuva tutar, ardından ayrılır.
- Menü, modal ve duraklatmada süre işlemez. Üç yuva doluyken seçim yapılamadığı için barlar bekler. Uçuşun 3× hızlandırılması seçim barlarını hızlandırmaz.
- Geri alma; kuyrukları, bar sürelerini, dronları, teslimatları ve pervane açılmasını birlikte geri yükler.
- Yerleştirme yuvaları açık renkli, belirgin çerçeveli ve artı işaretli. Kuyruk gövdeleri kapalıdır. Üst sıraya varmak pervaneyi açmaz: ilk küçük dron hareket edince açılma başlar. İçteki rengi bekleyen taşıyıcı kapalı kalır.

## İki salonlu galeri

`scenes/ui/gallery.tscn` içinde on eser, duvar panelleri, ışıklar, perspektif zemin ve Ada karakteri bulunur. A/D, yön tuşları, ekrandaki basılı tutulan oklar ve zemine dokunma hareketi desteklenir. Kamera Ada'yı izler; salonun uçlarında hareket sınırlanır. Salon düğmeleri beşli gruplar arasında konum değiştirir.

Tabloya tıklanınca büyük piksel yorum, sanatçı, tarih, güncel müze ve Türkçe bilgiler açılır. Uzun metin kaydırılabilir. Gerçek eserlerin yedi resmî kaynak bağlantısı `data/artwork_details.json` içindedir. Üç özgün oyun nesnesi kurmaca olarak işaretlenir. Galeride bütün eserler incelenebilir; oynama kilitleri sırayla açılır.

Müze bilgileri Louvre, Mauritshuis, MoMA, Belvedere, Nasjonalmuseet, Uffizi ve Art Institute of Chicago kaynaklarından derlendi. Giverny ve Saint-Rémy, resimlerin üretildiği yerleri temsil eder; güncel müze konumu oldukları söylenmez. Yeni beş şehir deseni imagegen ile üretildi. Tablolar kodla çizilmiş stilize piksel yorumlarıdır.

## Başarı ekranı

Her eserde piksel konfeti, iki taşıyıcı dron, tamamlanmış eser, piksel/seçim sayısı, sonraki eser ve galeride gör düğmeleri bulunur. Beşinci eser Level 2'yi açar; onuncu eserden sonra demo finali gelir. Azaltılmış hareket ayarında konfeti ve dron salınımı sabittir.

## Doğrulama

Godot 4.7.1 / macOS üzerinde:

- `test_puzzle.gd`: 6862 kontrol, 0 hata. On haritanın çözümü, kapasite toplamı, küçük gruplar, yanıltıcı renkler, erişim, geri alma ve gerçek kilitlenmeler.
- `test_flow.gd`: 4379 kontrol, 0 hata. On eserin gerçek drone uçuşlarıyla tamamlanması, sonuç/geçiş ekranları, 1×/3× eşdeğerliği, galeri, kayıt ve ayarlar. Bu test uçuşu bağımsız doğrulamak için seçim saatlerini uzun tutar.
- `test_drones.gd`: 39 kontrol, 0 hata. Güvenli rotalar, açılma sırası, eşzamanlı seçim, kalkış ve tek ses olayı.
- `test_expansion.gd`: 26 kontrol, 0 hata. Gerçek zamanlı barlar, süre dolması, kapasite korunması, modallar, geri alma, üç gereksiz rengin yuvayı açması, erişilemeyen renkte pervanelerin kapalı kalması, 1×/3× canlı süreli teslimat, galeri hareketi/sınırları ve iki level arasında geçiş.
- `capture_expansion.gd`: gerçek OpenGL penceresinden beş yeni tablo, süreli seçim, galeri salonu, detay modalı ve konfeti ekranı görüntülendi; yazı ve yerleşim gözle kontrol edildi.

Görüntüler `artifacts/level2-art-1.png`–`level2-art-5.png`, `level2-timed-queue.png`, `gallery-hall.png`, `gallery-detail.png`, `drone-celebration.png`.

Dokunma etkileşimleri için fiziksel telefon testi ve gerçek oyuncularla zorluk/süre ölçümü henüz yapılmadı. Genel oyun sayfalarının sonraki tasarım turu bu sürümün kullanıcı değerlendirmesinden sonra yapılacak.
