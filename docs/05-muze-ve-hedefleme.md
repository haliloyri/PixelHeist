# Müze, eser seçimi ve hedefleme

Bu sürümün ardından gelen sütun/gizli kutu değişiklikleri: [Sütunlara bağlı kutular](06-sutunlar-ve-gizli-kutular.md).

## Güncel davranış

- Dronlar taşıyıcı çıkış noktasına en yakın, **aynı renkte**, dışarıdan erişilebilir ve başka drona ayrılmamış pikseli seçer. Mesafe piksel merkezine göre ölçülür. Eski taşıyıcının önceliği ve güvenli çerçeve rotası korunur; kapalı iç renkler hedeflenmez.
- Süre barı yalnızca eserin başlangıç paletinde kullanılmayan renklerdedir. Normal renkler için bar çizilmez, saat işlemez, renk sıradan düşmez. Dıştaki hücreleri bitmiş bir renk de başlangıçta eserde bulunduğu için yanlışlıkla süreli hâle gelmez.
- Yuva yazıları ve alt açıklama kaldırıldı. Her görevin yuva rengi `data/locations.json` içindeki `slot_color` ile eserin/şehrin tonuna uyar.
- Başlangıç ekranında iki level sekmesi ve beşer eser kartı var. Demo kilitleri kaldırıldı; bütün eserler seçilebilir. Sırasız tamamlanan eserler kayıtta korunur. Son sıradaki eseri önce bitirmek demoyu bitirmez.

## Müze döngüsü

Galeri, hırsız figürü olmadan göz hizasında yatay gezilen iki katlı müzedir. Her katta beş çerçeve ve koridorun iki ucunda birer asansör bulunur. Asansöre dokunma yaklaşmayı, kapı kapanmasını, kat değişimini ve kapı açılmasını başlatır. Hızlı tekrar tıklamak birden fazla yolculuk başlatmaz. Katlar arasında sekme düğmesi yoktur. Galeri etiketleri **1. Kat / 2. Kat**, oyun etiketleri **Level 1 / Level 2** olarak ayrılır.

Boş çerçevede üç farklı, henüz çalınmamış eser sunulur. Son iki/tek eserde teklif sayısı kalanla sınırlıdır. Başlangıçta çerçeve boş kalır; son drone teslimatından sonra seçilen eser tam olarak seçilen çerçeveye yerleşir. Aynı eser tekrar çalınsa bile kopyalanmaz. Ana menüden başlatılan eser ilk boş çerçeveye yerleşir. Bu nedenle müze katları level gruplarından bağımsız bir koleksiyon düzenidir.

Dolu çerçeve mevcut sanatçı, tarih, ilginç bilgiler ve müze kaynağı modalını açar. Yerleşim `gallery_slots` olarak ilerleme dosyasına kaydedilir. Eski kayıtlar tamamlanan eserlerini kaybetmeden taşınır. Tamamlanmamış görevlerin anlık durumu önceki gibi kaydedilmez.

## Doğrulama

Godot 4.7.1, macOS:

- `test_flow.gd`: 4379 kontrol, 0 hata; on eser, yeni en yakın hedefleme ve gerçek drone uçuşlarıyla hem 1× hem 3× tamamlandı.
- `test_drones.gd`: 39 kontrol, 0 hata; yollar dolu pikselleri kesmiyor, dönüşler kendi taşıyıcısına.
- `test_expansion.gd`: 24 kontrol, 0 hata; normal renkler süresiz, yanlış renkler süreli, geri alma/duraklatma ve mevcut galeri davranışı.
- `test_museum.gd`: 34 kontrol, 0 hata; yakınlık, renk eşleşmesi, rezervasyon, gerçek seçim düğmeleri, boş çerçeveden soyguna ve teslimata akış, her iki asansör, tekrar tıklama, sırasız kayıt/yükleme, eski kayıt geçişi ve son eserlerin teklifleri.
- `capture_museum.gd`: gerçek OpenGL görüntüleri gözle incelendi. Yeni başlangıç, yalnızca yanlış renk barı, boş/dolu çerçeveler, üçlü teklif, asansör ve ikinci kat görüntüleri `artifacts/museum-*.png` içinde.

Fiziksel telefon doğrulaması ve oyuncularla zorluk ölçümü henüz yapılmadı.
