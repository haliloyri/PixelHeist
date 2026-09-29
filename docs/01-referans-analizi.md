# Pixel Heist — Referans analizi

Tarih: 18 Eylül 2026

## İncelemenin sınırı

Referans oyun, kullanıcının netleştirmesiyle **Food Hunt: Pixel Puzzle**. `sc` klasöründeki dört ekran görüntüsü incelendi. Kullanıcı açıklamayı ilk istemde verdiğini belirtti; erişilebilen görev geçmişinde o ilk metin bulunamadı. Bunun yerine resmî mağaza açıklamaları incelendi. Bu belge görsel gözlemleri, yayımlanmış kuralları ve Pixel Heist için alınan tasarım kararlarını ayırır.

Çalışma klasörünün başlangıç içeriği: dört WebP dosyası ve `.DS_Store`. Kullanıcı bu klasörü Godot editörüyle açtığını ve oyunun burada sıfırdan geliştirilmesini istediğini netleştirdi. Godot projesini, sahneleri ve kodları Codex oluşturacak; mevcut proje dosyası veya başka klasör beklenmiyor.

## Resmî açıklamayla doğrulanan oyun çekirdeği

Alt taraftaki renkli yığınlara dokunarak eş renkli karıncalar etkinleştiriliyor; bunlar resimdeki eş renkli blokları otomatik topluyor. Bekleme yuvaları sınırlı; yanlış seçim sırası yuvaları tıkayarak başarısızlığa yol açabiliyor. Tahta tamamen temizlendiğinde bölüm bitiyor. App Store açıklaması zaman sınırı olmadığını ve 2× hız seçeneğini belirtiyor; sağlanan görsellerde ise 3× yazıyor. Bu farktan sürüm eşitliği sonucu çıkarılmamalı.

Kaynaklar (18 Eylül 2026): [App Store — Food Hunt: Pixel Puzzle](https://apps.apple.com/us/app/food-hunt-pixel-puzzle/id6769314786), [Google Play — Food Hunt: Pixel Puzzle](https://play.google.com/store/apps/details?id=com.vigafun.funfinity.foodhunt).

Kesin hücre erişim algoritması, kutu sayılarının ayrıntılı anlamı, aynı renkteki kutuların önceliği ve kuyruk açılma kuralı bu açıklamalarda teknik olarak belirtilmiyor. Tasarım dosyasındaki bu ayrıntılar Pixel Heist için öneridir.

## Görsellerin tek tek okunması

| Dosya | Görülen içerik | Tasarım açısından anlamı |
|---|---|---|
| `sc/unnamed.webp` | Civciv ve çiçek resmi; beyaz, pembe, petrol, turuncu ve kırmızı beş aktif kutu; altta dört sütunluk kuyruk; renkli karıncalar | Aynı sahnede çok renkli bir resim ile sınırlı aktif alanın birlikte yönetilmesi gerekiyor gibi görünüyor. |
| `sc/unnamed (1).webp` | Karpuz; üç kırmızı ve iki koyu renk aktif kutu; üç sütunluk kuyruk | Aynı renkten birden fazla kutu eşzamanlı bulunabiliyor. Kuyruk sütun sayısı dört görselin tamamında sabit değil. |
| `sc/unnamed (2).webp` | Kurbağa; siyah, yeşil, krem ve iki petrol kutu; dört sütunluk kuyruk | Benzer renkleri ayırmak ve arkada bekleyen renkleri görmek önemli. Resimde boşluklar ve ayrılan bölgeler var. |
| `sc/unnamed (3).webp` | Vazo, meyve, fincan ve kitap içeren natürmort; iki kahverengi kutu dahil beş aktif kutu | Karmaşık resimler de aynı arayüzde sunuluyor; büyük sayıların denge üzerindeki etkisi ayrıca incelenmeli. |

## Kesin gözlemler

- Dikey düzenin üst bölgesinde küçük, hafif kabartılı karelerden oluşan resim var.
- Karıncaların renkleri resim parçaları ve kutularla eşleşiyor. Bazı karıncalar renkli blok taşıyor.
- Resmin altında bir delik ve beş aktif kutu yuvası görünüyor.
- Aktif kutular sayılı; örneğin karpuz ekranında `45, 4, 5, 70, 42` yazıyor.
- Alttaki kuyrukta öndeki kutular belirgin, arkadakiler daha soluk çizilmiş.
- Sağ üstte `3x` düğmesi; altta artı, el ve araç benzeri üç yardımcı simgesi var.
- Görsellerde belirgin bir süre sayacı, can göstergesi veya hikâye paneli yok.

## Görsel çıkarımlar ve doğrulama durumu

| Çıkarım | Dayanak | Bilinmeyen |
|---|---|---|
| Kutular renklerine ait parçaları toplatıyor. | Görseller ve resmî açıklama. | Alt taraftaki yığınlara dokunma resmî açıklamayla doğrulandı. |
| Sayılar kalan kapasiteyi temsil ediyor olabilir. | Aynı renkte farklı sayılı kutular. | Kapasite, ajan sayısı veya başka bir miktar mı? |
| Ön sıra seçilerek arka sıra açılıyor olabilir. | Ön kutuların parlak, arkadakilerin soluk olması. | Her sütun bağımsız mı, sıra tüm satır için mi ilerliyor? |
| Erişilebilir kenarlardan sökme yapılıyor olabilir. | Resim kenarlarında düzensiz eksilmeler. | Tüm çevre mi, yalnızca belirli yönler mi erişilebilir? |
| Aktif alanı yanlış renklerle doldurmak kilitlenme yaratır. | Görseller ve resmî açıklama. | Kilitlenerek kaybetme doğrulandı; kurtarma araçlarının ayrıntıları belirsiz. |
| `3x` toplama animasyonunu hızlandırıyor olabilir. | Düğme üzerindeki simge ve metin. | Mantıksal süreyi veya kaynak tüketimini de değiştiriyor mu? |

Yardımcı düğmelerin işlevleri simgelerinden kesinleştirilemez. Referansın reklam, satın alma, ekonomi veya bölüm ilerleme sistemi bu görsellerden çıkarılamaz.

## Korunması önerilen oyun çekirdeği

1. Resim üzerinde renklerin aşamalı olarak açılması.
2. Sınırlı aktif alana kuyruktan renk seçme.
3. Seçimden sonra otomatik ve tatmin edici toplama.
4. Yeni renklere erişmek için seçim sırasını planlama.
5. Resmin tamamen toplanmasıyla açık bir bitiş.

Bu yapının karar noktası refleks değil, sınırlı alan ve renk erişimi. Pixel Heist'in ilk demosuna devriye gezme, karakteri serbest hareket ettirme, nişan alma veya gerçek zamanlı kaçış eklemek bu odağı dağıtır.

## Pixel Heist'e tematik dönüşüm

| Referansta görülen öğe | Pixel Heist karşılığı | Oyuncuya anlatımı |
|---|---|---|
| Renkli resim | Çalınacak eserin taşıma taraması | “Eseri tek bir parça bile kaybetmeden çıkar.” |
| Karıncalar | Hırsızın minyatür taşıma dronları | Seçimden sonra otomatik çalışan yardımcılar. |
| Renkli kutular | Renk kodlu taşıma kapsülleri | Her kapsül tek renkten, üzerindeki sayı kadar parça alır. |
| Beş kutu alanı | Kaçış hattının beş yükleme yuvası | Yanlış sırayla doldurmak operasyonu durdurabilir. |
| Delik | Kurmaca transfer geçidi | Parçaları sığınaktaki yeniden birleştirme tezgâhına taşır. |
| Boşalan resim | Müzedeki boş çerçeve veya boş kaide | Görsel başarı anı. |
| Hız düğmesi | Operasyon hızı | Düşünme baskısı yaratmadan beklemeyi azaltır. |

## Uygulamaya taşınan kararlar

Renk seçiminin yeri ve sınırlı yuvaların kilitlenme riski resmî açıklamayla doğrulandı. Hücre erişimi, kapasite, kuyruk ilerlemesi ve eş renkli kapsüllerin önceliği ana tasarım belgesindeki kurallarla uygulanacak; bunlar referansın birebir doğrulanmış ayrıntıları olarak sunulmayacak. İlk açıklamanın yeniden gönderilmesi veya mevcut Godot dosyalarının bulunması çalışmanın ön koşulu değil.
