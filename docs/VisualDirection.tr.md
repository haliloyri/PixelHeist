# Pixel Heist — görsel yön ve referans incelemesi

Belge: `PH-VISUAL` · Revizyon: `2026-09-25-r13` · Dil: `tr`  
Asıl: [English](VisualDirection.md) · Tasarım: [Türkçe](10-pixel-heist-oyun-cercevesi-ve-ekranlar.md) · Görevler: [ToDoList.tr.md](../ToDoList.tr.md)

## 1. İstenen yön

Tablo pikselleri, küçük dronelar, taşıyıcı drone kutuları ve koleksiyon odaları üç boyutlu görünecek. Gece Müzesi içinde üç boyutlu geziyormuş hissi verecek. Ana giriş, başarı kutlaması ve oyuna özel modallar eğlenceli, canlı ve popüler kültürle ilişkili olacak. Bunlar temel oyun gereksinimidir; çıkış sonrası isteğe bağlı süsleme değildir. P03 yalıtılmış hacim prototipleri, ekran ve hareket çalışmalarını ekledi. P05 üretim soygunu/ekip, giriş, dönüş, birleşme, başarı ve modal sunumunu bütünleştirdi. Mevcut oynanabilir demo korundu; P07 perspektifli müzeyi fiziksel oda derinliği, kalın çerçeveler, spotlar, girintili asansörler ve tam/hafif çizim seçenekleriyle bütünleştirir.

Çalışma yönü: **gecede geçen, renkli tasarım oyuncakları estetiğinde bir soygun macerası**. Yuvarlak emaye drone gövdeleri, kalın koleksiyon pikselleri, kobalt/mor gece mimarisi, sıcak müze spotları, çıkartma gibi vurucu başlıklar ve esprili ekip ayrıntıları. Sanat eseri tanınır, soygun gizemli kalır. Koleksiyon oyuncakları, çizgi roman kapakları, sokak sanatı yazıları ve retro cihazlar görsel sözlük sağlar; özgün motifler kullanılır, lisanslı karakter veya geçici internet şakalarına dayanılmaz.

## 2. Gerçekte incelenen referanslar

İnceleme: 20 Eylül 2026. Bu nitel görsel araştırmadır; gelir, bağlılık veya oyunların tamamının oynandığı iddiası değildir.

| Referans / kanıt | Gözlem veya yayıncı açıklaması | Pixel Heist karşılığı |
| --- | --- | --- |
| Görsel olarak incelenen yerel `sc/unnamed.webp` | Kabarık renkli üst/yan yüzeyler, yumuşak gölgeler, yuvarlak tepsi, büyük kapasite sayıları, aktif/arka sıra ayrımı | Karar düzenini koruyup piksel ve taşıyıcıya hacim vermek |
| [Toon Blast resmî App Store sayfası](https://apps.apple.com/us/app/toon-blast/id1176027022), ekran görselleri incelendi | Pahlı renkli küpler, ayrı oyun alanı/HUD, ifadeli karakter ve kısa kalın tanıtım yazıları | Okunaklı yuvarlak parçalar ve canlı resimli çerçeve; kendi bulmacamızın kuralları korunur |
| [Peak resmî oyun sayfasındaki Match Factory](https://www.peak.com/games), bağlantılı resmî ikon incelendi | Oyuncak benzeri parlak yüzey, yuvarlak sarı ördek, pembe/turkuaz ayrımı ve hacim; yayıncı 3D eşleştirme oyunu diye tanımlıyor | Drone ve piksel malzeme araştırması; ikon, oyun içi modal davranışının kanıtı değildir |
| [Royal Match resmî dünya tasarımı](https://www.dreamgames.com/games/royal-match) | Yayıncı yuvarlak, cilalı biçimler ve retro ile güncel ayrıntıları birleştiren renkli dünya tarif ediyor | Ekranlar arasında tutarlı nesne, oda ve karakter dili |
| [Royal Kingdom resmî dünya tasarımı](https://www.dreamgames.com/games/royal-kingdom) | Yayıncı canlı renk ve eğlenceli çevre ayrıntıları tarif ediyor | Eser ve yol okunaklılığını koruyan, mekân gibi hissedilen odalar |

Dream Games sayfalarının resmî açıklamaları okundu; bağlantılı CDN görselleri görsel incelemeye açılamadı. Gerçek zafer/modal akışlarının oynandığı iddia edilmiyor. Aşağıdaki modal ve başarı tarifleri Pixel Heist için özgün öneridir. Yerel `artifacts/gallery-detail.png` eski demo örneği olarak incelendi: koyu katman ve düz metin yığını, yalnız kenarlık eklemenin neden yeterli olmayacağını gösteriyor.

## 3. Malzeme, ışık ve renk

İlk arayüz renkleri: gece mürekkebi `#17213F`, kobalt `#4775FF`, elektrik turkuazı `#3EDDE6`, mercan `#FF6B83`, sıcak altın `#FFC857`, sıcak kâğıt `#FFF4DF`. Gece odaları karanlık düz paneller yerine canlı vurgular ve sıcak ışık alanları kullanır. Büyük nötr yüzeyler eser rengini korur. Bu renkler arayüz içindir; tablonun eşleştirme paleti değiştirilmez.

Tutarlı ana ışık, koyu yan yüzey, sınırlı parlaklık ve yumuşak temas gölgesi kullanılır. İki görev rengini aynı gösteren beyaz parlamadan kaçınılır. Sayı yüzeyi yüksek kontrastlı ve sabittir. Hacim küçük telefonda da okunur. Dekoratif ışık, şehir deseni ve parçacıklar etkileşim alanıyla yarışmaz.

## 4. Çizim kararı ve bulmaca nesneleri

Deterministik 2D bulmaca durumu, rota, rezervasyon ve kayıt mantığı korunur; sunum ayrılır. P03’te gerçek zamanlı 3D ile prosedürel 2.5D tahta/ekip çizimi karşılaştırıldı ve gerçek perspektifli oda ölçüldü. Yerel dil arayüzü yanında gerçek zamanlı 3D tahta/ekip ve müze seçildi. 2.5D adayı vektör çizimidir; optimize sprite atlası değildir. Maliyetler, özgün görsel değerler ve ayrı mobil/cihaz bütçe kapısı [RenderingDecision.md](RenderingDecision.md) içinde kayıtlıdır. Renk geçişli düz dikdörtgen yeni görsel şartı karşılamaz.

- **Pikseller:** üst/yan yüzeyli, hafif pahlı bloklar ve temas gölgesi. Piksel gidince alt tepsi görünür. Kalkışta yükseklik, değişen gölge ve manyetik temas noktası belirgindir; mantıksal hücre yeniden açılmaz/çoğalmaz.
- **Küçük dronelar:** üstten belirgin siluet, yüksek gövde, pervane yuvaları, malzeme ışığı ve taşınan piksel. Görsel uçuş yüksekliği dolu hücreyi veya kapalı kenarı aşma izni vermez. Yavaş hareket ve ASMR korunur.
- **Taşıyıcı kutular:** seçilebilir nesnenin tamamı hacimli drone gövdesidir; büyük sayı yüzeyi vardır. Sıradaki/bekleyen gövdenin pervanesi kapalıdır; ilk küçük drone kalkınca açılır. Yük sıfırlanınca kameraya yükselip yandan çıkar; son teslimde yuva serbest kalır.
- **Kamera:** tahta yukarıya yakın açıyla görülür; perspektif hücre, sayaç veya sayıyı örtmez. Görsel kalınlık yeni yol algısı yaratmaz, dokunma hedefini değiştirmez. Beş yuva, gizli kutu, kapalı renk ve yalnız alttan giriş birlikte denenir.

## 5. Gece Müzesi gezintisi

Öncelikli prototip: kontrollü yatay rota üzerinde birinci şahıs kameralı stilize 3D oda. Beş çerçeve ve iki uçtaki asansör korunur. Oyuncu koridorda ilerler, seçili esere yaklaşır, asansöre girer; ekranda hırsız figürü ve zorunlu serbest kamera/joystick oyunu olmaz.

Zemin-duvar birleşimi, kalın çerçeve, değişen perspektif, yakın/uzak katman hareketi, spotlar, kapı derinliği ve kamera yaklaşması birlikte çalışır. Düz kartların arkasında kayan tek arka plan yeterli değildir. Eserden çıkınca kamera önceki koridor konumuna döner. Kat, odak, sahiplik ve seçilmiş boş çerçeve korunur.

Kısa yumuşak geçiş, sınırlı dönüş ve varsayılan olarak sallanmayan kamera kullanılır. Azaltılmış harekette kısa kararma veya anlık bakış değişimi yapılır; sabit sahnede hacim kalır. Düşük kalite gölge/yansıma maliyetini azaltabilir ama oda ve kamera kaynaklı mekân hissini korur. On kat üretilmeden performans denenir.

## 6. Giriş ve başarı akışı

**S01 giriş:** özgün hacimli logo, küçük müze/çatı dioraması, yavaş süzülen ve piksel taşıyan imza drone, şehir ışıkları ve son sergi. Güçlü Oyna/Devam Et, ikinci Müze ve ayarlar. Boşta animasyon girdiyi geciktirmez, zorunlu yeni açılış videosu olmaz. Demo level seçimi ulaşılır kalır.

**S08 soygun başarısı:** kalıcı kayıttan sonra son teslim oturur, eser kısa bir odak gösterimi alır, hacimli “Soygun tamam!” rozeti gelir, iki drone kenarlardan piksel konfeti taşır; temel ödeme ve Devam eylemi yerleşir. İlk kutlama 2–3 saniye hedefler, erken atlanabilir. Azaltılmış harekette son kompozisyon doğrudan görünür. Yumuşak müzikal çözülme ve hafif çan sesleri kullanılır; tiz fanfar ASMR'ı bastırmaz. Efekt ana düğmeyi örtmez, oyuncu parçacık sırası beklemez.

**S18 kampanya finali:** oyuncunun gerçek odası ve koleksiyonu, seçilen son ve paylaşılabilir kişisel portreyle kutlanır. Sıradan işten daha büyük hissedilir; alakasız genel kupa sahnesi kullanılmaz. Yalnız kazanılmış etiket ve ödüller gösterilir.

## 7. Oyuna özel modal ailesi

Genel koyu ekran üstüne metin yerine, varyantları olan ortak oyun modalı kurulur. Hacimli çerçeve/yüzey, resimli başlık, eser önizlemesi veya karakter rozeti, kısa bilgi sırası, dokunulası ana düğme, sakin ikinci eylem ve belirgin kapatma vardır. Arkadaki oda kararır veya hafif bulanıklaşır; pahalı bulanıklık isteğe bağlıdır.

Varyantlar: **hazırlık** cihaz dosyası; **eser inceleme** ışıklı çerçeve ve kaydırılabilir bilgi; **haber** eğlenceli kupür; **başarı** drone teslim rozeti; **ayarlar** küçük ekipman paneli; **eser kararı/satın alma** açık sonuç kartı. Düğme, gölge, yazı ve aralıklar aynı aileden gelir.

İlk giriş/çıkış hedefi 180–240 ms ve hafif yerleşmedir. Azaltılmış harekette kaldırılır. Gerekli oyun/sayaç duraklaması, arkaya tıklamayı önleme, klavye odağı, Geri/Escape ve açan denetime odak dönüşü sağlanır. Uzun içerik modal içinde kayar; eylemler görünür kalır. Dört dil ve güvenli ekran alanı test edilir. Eğlenceli çerçeve satış sonucunu, gerçek fiyatı, hatayı veya uygunluk nedenini saklamaz.

## 8. Kabul ve uygulama sırası

P03 renk/malzeme kurallarını, ana/oyun/müze/modal/başarı taslaklarını ve çizim prototiplerini kurar. P05 hacimli parça, ekip, giriş, başarı ve modalı uygular. P07 müze odası/kamera deneyimini tamamlar. P08 toplu eser üretiminden önce görsel kabul kapısıdır. P10/11 paylaşım ve varlık üretimine yayar; P13 cihaz performansı, hareket ve dili denetler.

Kabul hem sabit görüntü hem hareket kaydı ister: görüntü malzeme hacmini; hareket alım, perspektif gezinti, modal tepkisi ve kutlamayı kanıtlar. Tahta, beş taşıyıcı, esere yaklaşım, asansör, uzun çevrilmiş modal, giriş ve başarı karşılaştırılır. Normal ve azaltılmış hareket/düşük kalite denenir. Aynı girdide mevcut mantıksal test sonucu değişmez. P01 referans kabulü etkileşim sırasını korur; eski düz sanat stilini sabitlemez.

**Heist v2 — "Bit'lerin gece soygunu" (S06), aynı revizyon:** yalnızca oyun ekranı Royal
Match/Toon Blast tarzı oyuncak diline geçer: kalın beyaz + koyu kontur, yuvarlak köşeler, oynanışta
değişiklik yok. Arka plan üstten alta lavanta-pembe gradyan (`#C9C3F0` → `#F3D6E8`), üzerinde
levelin kendi deseni ~%8 ton-sur-ton opaklıkla, köşelerde yavaşça yanıp sönen yıldızlar (azaltılmış
harekette sabit) ve veri tablosundan gelen (asla şehre göre sabit kodlanmamış) kenarlık başına 1-2
müze silüeti. HUD: yuvarlak mor (`#8E7CE0`) duraklat düğmesi, `ui.level_badge` ("LEVEL {n}")
anahtarını gösteren kabarık altın kurdele rozet ve altında küçük eser adı, %33/%66/%100'de üç altın
(`#FFBD0D`) yıldızlı kalın yuvarlak ilerleme çubuğu (mevcut `ProgressFill`/`ProgressLabel`
değerlerine dokunulmadı) ve gök mavisi (`#3BA7F0`) hız hapı. Eser çerçevesi ekranın ~%92'sine
(662px) genişler; kalın parlak yuvarlak altın çerçeve, üstte yumuşak parıltı. Taşıyıcılar "Bit"
uğur böceklerine dönüşür (`bug_design.gd`, 3D yol için `volume_factory.gd`/`depth_heist.gd`'de
eşleşen düşük poligonlu mesh): kırmızı piksel karolu kubbe kabuk, siyah hırsız maskesi, büyük LED
gözler, uçuş yüksekliği/gölge büyümesi yerine iki karelik yürüyüş bacak salınımı, manyetik tutucu
çizgisi yok. Kovan drone'lar (`drone_design.gd`) oval kapasite ekranlı, dolulukla küçük Bit
silüetleri beliren cam kubbeli, üç iniş ayaklı, kuyrukta/bekleyen yuvada katlı kalıp kalkışta açılan
iki yan kollu (kolda tek pervane) yuvarlak emaye kapsüllere dönüşür. Alt bar kabarık lavanta
(`#9D95CF`/`#7D76AA`) çubuğa dönüşür; üç yuvarlak düğme ikonlarını korur ve yalnızca gerçekten
booster sayısı gösteren düğmede küçük altın rozet çizilir. Tüm yeni renkler tek yerde,
`data/design_tokens.json`'daki `heist_v2` bloğunda tutulur ve `game_theme.gd` üzerinden okunur;
diğer tüm ekranlar eski gece paletini korur. Referans: `artifacts/artifacts/heist-v2-level1.png`
(onaylı Higgsfield Level 1 taslağı). Dokunma hedefleri (`queue_layout.gd` dock/front geometrisi) ve
tüm bulmaca mantığı değişmedi.
