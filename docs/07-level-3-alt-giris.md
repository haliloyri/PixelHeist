# Level 3 — Alt giriş

> Güncelleme: Sütuna özel yuva kısıtı kaldırıldı. Geçerli renkler herhangi bir boş yuvaya yerleşebilir; aynı sütundan birden çok taşıyıcı çalışabilir. Aşağıdaki sütun sahipliği notları önceki sürümü anlatır.

Level 3, Paris'teki Musée d’Orsay koleksiyonundan beş eserin özgün piksel yorumunu içerir: Başak Toplayanlar, Saksağan, Yıldız, Moulin de la Galette, Elmalar ve Portakallar. Eser bilgileri ve kaynak bağlantıları `data/artwork_details.json` içindedir.

## Kural

`entry_mode: "bottom"` yalnızca yeni beş göreve uygulanır. Erişim taraması alt sınırdan başlar; üst, sol ve sağ dış sınırlar taramaya kapalıdır. İçerideki boş alanlar ancak alt girişle bağlantı kurduklarında erişilebilir olur. Uçuş rotası aynı kuralı uygular: hedefe en yakın izin verilen alt girişten girer, dolu hücrelerin üzerinden geçmez ve yükü aynı alt rotadan kendi taşıyıcısına getirir. İlk iki level dört kenarlı erişimi sürdürür.

Kapanan üç çerçeve kenarı bakır taramalarla, açık alt kenar yeşil oklarla gösterilir. Her eser küçük kapasiteleri, sütun sahipliğini, gizli kutuları ve yalnızca tabloda olmayan renklerde 7 saniyelik süreyi korur.

## İçerik ve ilerleme

Renk sıraları `tools/rebuild_queues.gd -- --from-level=10` ile gerçek Godot uçuş simülasyonundan üretildi. İlk on görevin sıraları yeniden oluşturulmadı. Tüm içerik üretimi için `tools/build_content.py` artık `chapter_three.py` tanımlarını da içerir.

Ana menüde üç level sekmesi vardır. Müze 15 çerçeveyle üç kata genişletildi. Orta katta sol asansör aşağıya, sağ asansör yukarıya gider. En alt/üst katta her iki asansör de komşu kata gider. Eski on çerçeveli kayıtlar yerleşimler değiştirilmeden genişletilir. Tüm görevler demoda açıktır.

## Doğrulama

Godot 4.7.1, macOS:

- `test_bottom_entry.gd`: 38 kontrol; kapalı üç kenar, bağlantısız boşluklar, beş tablonun tüm piksellerine alt erişim, canlı eşzamanlı uçuşlar, geri alma, üçüncü kat ve on yuvalı kayıt geçişi.
- `test_flow.gd`: 6.969 kontrol; 15 eserin tamamını 1× ve 3× hızlarda gerçek uçuşlarla bitirme, sonuç ekranları ve kayıt.
- `test_puzzle.gd`: 6.251 içerik ve mekanik kontrolü.
- `test_drones.gd`, `test_expansion.gd`, `test_museum.gd`, `test_columns.gd`: 130 mevcut davranış kontrolü.
- Toplam 13.388 kontrol, sıfır hata.
- `capture_level_three.gd`: gerçek grafik ortamında üçüncü level menüsü, beş oyun ekranı, alt girişte uçuş ve üçüncü kat ekran görüntüleri. Görseller `artifacts/level3-*.png` altındadır.

Testler oyuncunun ilerleme dosyasına yazmaz. Oyuncu tercihleriyle tüm olası seçim dizilerini bitirmek garanti edilmez; yanlış renk sırası hâlâ geri alma gerektirebilir.
