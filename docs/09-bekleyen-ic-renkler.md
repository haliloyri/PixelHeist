# Bekleyen iç renkler

Level 3'ün beş renk kuyruğu artık sırayla daima hemen çalışacak kutular sunmaz. Seçim satırına, tabloda bulunan fakat alt girişle henüz bağlantısı olmayan renkler de gelir. Bunlar seçilebilir ve aktif bir yuvayı tutar. Küçük dronlar hareket etmez, büyük taşıyıcının pervaneleri kapalı kalır. Önlerindeki renkler toplanıp yol açıldığında otomatik çalışırlar.

Bu kutuların süre barı yoktur ve beklerken kaybolmazlar. Tabloda hiç bulunmayan süreli kutularla aynı şey değildir. Oyuncu beş yuvayı da yolu kapalı renklerle doldurursa geri alma gerekebilir.

İçerik üretimi `tools/rebuild_queues.gd` içinde gerçek Godot uçuş simülasyonunu kullanır. Her birkaç seçimde, mevcut erişim sınırının en fazla beş hücre gerisindeki kapalı bir renk seçilir. Oluşturulan çözümde aynı anda en fazla iki böyle taşıyıcı bekletilir ve açıcı renkler için yer bırakılır. Bu sınır oyuncunun serbest seçimini kısıtlamaz. Her üçüncü açıcı seçimde küçük bir görünür renk grubu tercih edilerek sadece başlangıçta değil, ilerleyen sıralarda da kapalı renk kararları oluşur.

Bekleyen taşıyıcının kapasitesi kalan piksel hesabından düşülür; fazladan yük veya eksik renk üretilmez. `anticipation` içerik işareti yalnızca üretim/doğrulama içindir; oyunda özel bir bonus, kilit veya gösterge oluşturmaz. Görünür ve gizli kutular önceki kurallarla çalışır.

Yeni Level 3 sıraları:

| Eser | Erken sunulan kapalı renk kutusu |
| --- | ---: |
| Başak Toplayanlar | 6 |
| Saksağan | 9 |
| Yıldız | 9 |
| Moulin de la Galette | 14 |
| Elmalar ve Portakallar | 6 |

Bunlar doğrulanmış çözüm sırasındaki sayılardır; oyuncunun farklı seçimlerinde erişilebilirlik değişebilir. İlk on görevin verileri korunmuştur.

Doğrulama: `test_anticipation.gd` 962 kontrolde tüm 44 özel kutunun gerçekten yolu kapalıyken seçilebilir olduğunu, piksel almadan beklediğini, süreyle silinmediğini ve sonrasında dron çıkartarak görev sonuna kadar teslim edildiğini doğrular. `test_puzzle.gd` 6.612 kapasite ve içerik kontrolü içerir. `test_flow.gd`, 7.333 kontrolle 15 görevi gerçek uçuşlarla 1× ve 3× hızda sonuca kadar oynatır. Üç testte toplam 14.907 kontrol, sıfır hata. `capture_anticipation.gd` bekleme ve yol açılma durumlarını gerçek Godot ekranından kaydeder.
