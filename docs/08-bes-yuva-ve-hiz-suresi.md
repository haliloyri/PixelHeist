# Beş yuva ve süreli 3×

Level 3'ün beş tablosunda artık beş kuyruk sütunu ve beş aktif yuva bulunur. Her kutu herhangi bir boş yuvaya çıkabilir; aynı sütundan birden çok taşıyıcı seçilebilir. 4 ve 5 tuşları yeni sütunları seçer. İlk iki level üçlü kalır. Alt giriş kuralı korunur.

`slot_count` bölüm verisinden okunur. Yuva, seçim düğmesi, arka sıra ve uçuş başlangıçları aynı `queue_layout.gd` geometrisini kullanır. Beşli düzende taşıyıcılar ve boş yuvalar aralıklara sığacak biçimde ölçeklenir. Küçük uçan dronların boyutu korunur. Level 3'ün renk sıraları beş sütunla gerçek Godot simülasyonunda yeniden üretildi.

Hız düğmesi 1×'te krem, 3×'te altın, kullanım hakkı bitince gri görünür. Kalan süre düğmenin içinde dakika:saniye olarak gösterilir. Yeni kayıtta 600 saniye verilir. Sayaç oyun genelindedir; yalnızca oyun ekranında, modal kapalıyken ve 3× seçiliyken gerçek geçen süre kadar azalır. Son hızlandırılmış kare, kalan sürenin ötesine taşmaz.

Güncel otomatik 3× koşulu: üstteki dolu yuvaların tamamındaki taşıyıcılar gerçekten çalışmalıdır. Her taşıyıcının ilk küçük dronu çıkmış olmalı ve devam eden bir uçuşu veya erişilebilir bir hedefi bulunmalıdır. Boş yuvalar hesaba katılmaz; alt kuyruğun bitmesi gerekmez. Bir taşıyıcı beklerse veya yeni kutu yerleştirilirse otomatik hız 1× olur. Hepsi yeniden çalışınca süre varsa tekrar 3× açılır. Oyuncunun elle açtığı 3× bu geçişlerde korunur. Elle 1× seçimi aynı çalışma durumu sürdükçe tekrar zorlanmaz. Süresi tükenmiş kullanım hakkını otomatik geçiş de açamaz. Geri alma, harcanan süreyi iade etmeden otomatik/elle hız durumunu geri yükler.

Kalan süre ilerleme kaydına yazılır. Menü geçişleri, hız seçimi, kullanım sırasındaki beş saniyelik aralıklar, tükenme ve normal pencere kapatmada kaydedilir. Yeniden başlatma, eser değişimi ve geri alma süreyi geri vermez. Eski kayıtlarda yeni alan yoksa 600 saniye ile başlar.

Godot 4.7.1 doğrulaması:

- `test_boost.gd`: 24 kontrol; beşli seçim, 4/5 klavye erişimi, otomatik geçiş, sayaç, duraklatma, geri alma ve kayıt.
- `test_flow.gd`: 6.965 kontrol; 15 tablonun tamamı 1× ve 3× uçuş simülasyonunda tamamlandı. Bu çözüm testi yeterli hız süresi verir; gerçek süre sınırı ayrı testte doğrulanır.
- `test_puzzle.gd`: 6.273 kontrol; kapasite, sıra, geri alma ve erişim.
- `test_drones.gd`, `test_columns.gd`, `test_bottom_entry.gd`: 120 kontrol; uçuşlar, paylaşılan yuvalar ve Level 3 alt kenarı.
- Toplam 13.382 kontrol, sıfır hata.
- `capture_boost.gd`: gerçek Godot penceresinde normal, hızlandırılmış, tükenmiş, üçlü ve beşli aktif düzenlerin ekran görüntüleri.

Testler oyuncunun kayıt dosyasını değiştirmez. Sayaç kayıt testi `/tmp/pixel-boost-<process-id>.cfg` adlı ayrı bir dosya kullanır.

Koşul düzeltmesi `test_boost.gd` içinde ayrıca doğrulanır: kuyruk hâlâ doluyken hızlanma, boş yuvaları göz ardı etme, çalışmayan tek taşıyıcının otomatik hızı engellemesi, yol açılınca hızlanma ve elle hız seçiminin korunması.
