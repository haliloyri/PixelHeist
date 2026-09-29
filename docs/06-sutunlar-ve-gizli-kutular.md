# Sütunlara bağlı kutular

> Güncelleme: Sütuna özel yuva kısıtı kaldırıldı. Geçerli renkler herhangi bir boş yuvaya yerleşebilir; aynı sütundan birden çok taşıyıcı çalışabilir. Aşağıdaki sütun sahipliği notları önceki sürümü anlatır.

- Sol, orta ve sağ kuyruk yalnızca kendi üstündeki yuvaya yerleşir. Dolu sütunun düğmesi kapanır; klavye veya düğme sinyali de kuralı aşamaz. Kuyruk, önizleme ve yuva merkezleri aynı x koordinatındadır.
- Tabloda bulunmayan renkler seçilemez. Süre dolunca çıkar; bu bekleyiş yuvalar doluyken de sürer. Modal ve duraklatmada durur. Normal renklerde bar yoktur.
- Sayaç 15 piksel yüksekliğinde, açık çerçeveli ve kutunun rengindedir. Koyu iz, renkli doluluk ve küçük saat simgesi kullanılabilir olmamasının nedenini gösterir.
- Alt sıradaki normal kutuların rengi matlaştırılmaz; gerçek paletteki renk ve tam opaklık kullanılır.
- Bazı arka sıra kutuları nötr renkli **?** gövdesidir. Ön seçim sırasına çıktıkları anda gerçek renk ve sayı görünür. Gizleme yalnızca önizlemededir; miktar/renk yeniden rastgele belirlenmez. Geri alma kimliği korur.
- Kendi sütununda kilitlenme, başka bir sütunda boş yer kalsa bile tespit edilir; son seçim geri alınabilir.

Eski kuyruklar serbest yuva ve önceki hedef sırasına göre hazırlanmıştı. On eserin kuyrukları gerçek Godot uçuş simülasyonuyla yeniden üretildi. `tools/rebuild_queues.gd` her paketin kendi sütununda tamamen toplanabildiğini doğrular; `tools/build_content.py` bu adımı otomatik çağırır. Eser pikselleri ve paletleri değişmedi.

Godot 4.7.1 / macOS doğrulaması:

- 4395 akış kontrolü: on eser, gerçek uçuş ve son teslimatla 1× / 3× tamamlandı; hata yok.
- 29 yeni sütun kontrolü: sütun sahipliği, yanlış renk engeli, klavye, kilitlenme, gizli kutunun açılması, geri alma ve görsel hizalama; hata yok.
- 3870 içerik/kural kontrolü: toplam kapasite, kuyruk/çözüm eşlemesi, temel erişim ve geri alma; hata yok. Anlık model adımları, zamanlı uçuş sırasının yerine çözüm doğrulaması olarak kullanılmaz; tam çözüm akış testinde çalışır.
- 39 drone, 23 genişleme ve 34 müze kontrolü hatasız geçti.
- `capture_columns.gd` ile gerçek oyun ekranından alınan gizli kutu, renkli sayaç ve bağımsız sütun görüntüleri gözle incelendi: `artifacts/columns-*.png`.
