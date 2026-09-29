# Pixel Heist — Oyun tasarımı ve hikâye dosyası

Tarih: 18 Eylül 2026  
Aşama: Kodlama öncesi tasarım önerisi  
Dayanak: Food Hunt: Pixel Puzzle'ın resmî mağaza açıklamaları ve `01-referans-analizi.md` içindeki dört ekran görüntüsü  
Geliştirme kararı: Pixel Heist bu çalışma klasöründe sıfırdan Godot ile oluşturulacak. Hazır proje dosyası beklenmiyor.

**Uygulama notu:** Bu dosya ilk tasarım kararlarını saklar. İlk oynanabilir demo artık oluşturuldu; uygulanan kapsam, tasarımdan farklılıklar ve test sonuçları `03-demo-durumu.md` dosyasındadır. Aşağıdaki “henüz yapılmadı” ifadeleri tasarımın yazıldığı aşamaya aittir.

## 1. Oyunun tek cümlelik vaadi

**Dünyanın en tanınan tablolarını ve tarihi eserlerini piksel piksel kaçıran bir hırsız ol; doğru taşıma kapsüllerini sıraya koy, eseri eksiksiz çıkar ve soygunun arkasındaki büyük koleksiyonu keşfet.**

Tür: Renk eşleştirme, kuyruk yönetimi ve alan planlama bulmacası. Önerilen ilk hedef, tek parmakla oynanan dikey mobil düzen; geliştirme sırasında masaüstünde fareyle aynı kontrol. Platform, kullanıcı tarafından henüz kesinleştirilmedi.

Temel duygu: “Gözümün önündeki pahalı eseri kimse anlamadan kaçırıyorum.” Karar anları sakin, taşıma hareketleri canlı, bölüm sonu kısa ve gösterişli. Başlangıçta süre baskısı yok.

## 2. Ana fikir: Boş Çerçeveler

Yakın geleceğin stilize dünyasında sanat, görünür zenginliğin en büyük simgesi olmuştur. Koleksiyoner **Viktor Voss**, halka açık sergiler düzenler; fakat en değerli eserlerini geceleri dolaşan özel bir koleksiyon için toplar. Galerilerde görünen ile gerçekten sahip olduğu eserler birbirine karışmıştır.

Oyuncu **Ada “Piksel” Koral**'ı yönetir. Ada küçük sanat hırsızlıklarında ustadır; büyük bir soygunla borcunu kapatmak ve adını duyurmak ister. Eski restorasyon teknisyeni ortağı **Milo**, katı nesneleri geçici renk hücrelerine ayırıp başka yerde yeniden birleştiren kurmaca bir cihaz geliştirmiştir. Ada'nın mesleği bu cihazla değişir: Duvara asılı dev bir tablo, avuç içi büyüklüğündeki kapsüllerle çıkarılabilir.

İlk büyük işi veren kişi yalnızca **Küratör** adıyla konuşur. İstek basittir: Voss'un özel galerisinden bir tablo ve iki eser çal. Ada bunun karşılığında özgürlüğünü satın alacak parayı alacaktır.

Fakat her hedefin arkasında küçük bir envanter damgası vardır. Son hedefin kaidesinden çıkan kayıt, çalınacak eserlerin listesinin yanında Ada'nın kendi cihazını da içerir. Küratör bir koleksiyon toplatmaktadır ve Ada'nın elindeki teknoloji de koleksiyonun son parçasıdır.

Demo sonunda Ada, son eseri müşteriye göndermek yerine kendi gizli rafına yönlendirir. Bu davranış gelecekteki hikâyeyi başlatır: Bir hırsız, başka birinin planında taşınan parça olmayı reddeder.

### Karakterlerin işlevleri

| Karakter | İsteği ve kusuru | Oynanıştaki işlevi |
|---|---|---|
| Ada “Piksel” Koral | Para ve ün ister; iyi yaptığı işe fazla güvenir. | Oyuncunun bakış açısı; kısa, kendinden emin bölüm açılışları. |
| Milo | İcadının işe yaradığını kanıtlamak ister; cihazın sonuçlarını küçümser. | Kapsül, erişim ve sıkışma kurallarını gündelik dille öğretir. |
| Küratör | Eserleri ve taşıma teknolojisini tek elde toplamak ister. | Hedefleri verir; ilk yardımseverliği giderek kontrol arzusuna dönüşür. |
| Viktor Voss | Sahip olduğu şeylerle hatırlanmak ister. | Demo mekânının sahibi ve görünür rakip; demoda doğrudan karşılaşılmaz. |

Ada başlangıçta para için çalan bir hırsızdır. Her soygunu otomatik olarak iyilik eylemine çevirmemek karakteri daha ilginç kılar. Sonraki bölümlerde satma, saklama ve iade etme gerilimi hikâyede işlenebilir; demo için dallanan ahlak sistemi önerilmiyor.

### Evrenin değişmez kuralları

- Piksele ayırma kurmaca bir taşıma teknolojisidir; eseri yakmaz, boyasını kazımaz veya parçalarını yok etmez.
- Taşınan hücreler sığınakta doğru konumlarında yeniden birleşir. Tablolar ve heykeller aynı taşıma sistemiyle açıklanır.
- Farklı renkte hücreler farklı kapsül kanalları kullanır. Ekrandaki renk, fotoğraf gerçekçiliği iddiası taşımayan sınırlı bir tarama paletidir.
- Kapasite, kapsülün alabileceği hücre miktarıdır. Dron adedi değildir.
- Dünyanın teknolojisi stilizedir. Gerçek müzelerin güvenlik yapısı veya gerçek bir soygunun uygulanış ayrıntıları oyunun konusu değildir.
- Ünlü eserlerin özel galeriye gelişleri alternatif kurguya aittir; gerçek müze koleksiyonları hakkında iddia kurulmaz.

## 3. Mekaniğin önerilen kesin kuralları

Bu bölüm, Food Hunt'ın resmî açıklamasındaki renk seçimi, otomatik toplama ve sınırlı yuva çekirdeğini esas alır. Hücre erişimi, sayıların kapasite olarak kullanılması ve kuyruk önceliği gibi açıklanmayan ayrıntıları Pixel Heist için tanımlar. Kaynaklar ve doğrulama sınırları referans analizi dosyasında kayıtlıdır.

### Oyuncunun yaptığı tek temel eylem

Oyuncu kuyruğun erişilebilir en ön kapsüllerinden birine dokunur. Kapsül boş bir aktif yuvaya gider. Dronlar o renkte ulaşabildikleri hücreleri otomatik toplar. Kapsül dolunca sığınağa gönderilir ve yuvası boşalır. Oyuncu bir sonraki kapsülü seçer.

Resmin tek tek hücrelerine dokunulmaz. Resim okuma, kuyruk seçimi ve sonuç izleme arasında sürekli bir döngü oluşur.

### Kuyruk ve aktif alan

- Ana oyunda beş aktif yuva vardır. İlk iki öğretici bölüm, azaltılmış renk ve kuyruk karmaşıklığıyla aynı beş yuvayı kullanır.
- Kuyruk bağımsız sütunlardan oluşur; her sütunun yalnızca en öndeki kapsülü seçilebilir.
- Bir kapsül seçildiği anda kendi sütunundaki sonraki kapsül görünür ve seçilebilir hâle gelir; diğer sütunlar değişmez.
- Demoda üç kuyruk sütunu kullanılır. Dört sütun, ana mekanik anlaşıldıktan sonra değerlendirilebilir.
- Renk, kalan kapasite ve en az iki sonraki kapsül okunabilir olmalıdır. Bilgi saklama, ilk demonun zorluk aracı değildir.
- Dolu bir aktif alana dokunmak kaynak harcatmaz. Kısa bir “Önce bir kapsül dolmalı” geri bildirimi verir.

### Bir hücreye erişim

Öneri: Resmin dışındaki boşlukla, yukarı-aşağı-sağ-sol komşulukları üzerinden bağlantılı boş alana yüzü olan hücreler erişilebilirdir. Çapraz temas yeterli değildir.

Örneğin sarı bir hücre mavi hücrelerle çevriliyse sarı kapsül bekler. Mavi hücreler sökülüp sarıya kadar bir açıklık oluşunca sarı toplama başlar. Dışarıya bağlı olmayan kapalı iç boşluklar erişim yaratmaz.

Bir hücre çıkarıldıkça erişim yeniden hesaplanır. Böylece tek kapsül, kendi renginin art arda açılan katmanlarını kapasitesi yettiği sürece toplar. Bu kural hem tablo kenarlarını hem kaide üstündeki düzensiz eser siluetlerini kapsar.

### Kapasite ve toplama sırası

- Bir hücre, bir kapasite birimi tüketir. `20` yazan kapsül aynı renkten yirmi hücre alır.
- Kapsül üzerindeki sayı kalan kapasitedir; toplama ilerledikçe azalır.
- Kapasitesi sıfırlanan kapsül hemen çıkış işlemine girer ve kısa animasyonun ardından yuvasını boşaltır.
- Erişilebilir eş renk kalmadığında kapsül kaybolmaz; aktif yuvada bekler.
- Aynı renkte birden fazla kapsül varsa önce daha önce etkinleştirilen doldurulur. Hücreler, sabit satır/sütun sırasıyla seçilir. Animasyon veya cihaz hızı sonucu değiştirmez.
- Bir hücre iki drona birden atanamaz. Uçuşa çıkan hücre ayrılmış sayılır; mantıksal toplama ile görsel taşıma ayrılır.
- Demodaki hazırlanmış bölümlerde, her rengin toplam kapsül kapasitesi o rengin toplam hücre sayısına eşittir. Son kapsülde artan kapasite sorunu içerik hazırlığında önlenir.

### Kazanma, bekleme ve kilitlenme

Kazanma: Tüm eser hücreleri alınmış ve taşınmakta olan son hücre de teslim edilmiş olmalıdır. Ardından kısa yeniden birleştirme animasyonu oynar.

Bekleme: Hiçbir aktif kapsül toplayamıyor fakat boş yuva ve seçilebilir kuyruk kapsülü varsa oyuncunun seçim yapması beklenir. Bu durum başarısızlık değildir.

Kilitlenme: Uçuşta parça yoktur, hiçbir aktif kapsül erişilebilir hücre alamıyordur ve yeni kapsül yerleştirilebilecek boş yuva yoktur. Oyun kısa açıklamayla durur: “Bu renkler içeride kaldı. Son seçimi geri al.”

Boş yuva olduğu hâlde kuyruk bitmiş ve eser kalmışsa hazırlanmış bölüm verisinde hata vardır. Oyuncuya normal bir bulmaca yenilgisi gibi sunulmamalı; geliştirmede doğrulama bunu yakalamalıdır.

Demoda tek adım geri alma ve bölümü yeniden başlatma ücretsizdir. Geri alma, son kapsül seçilmeden hemen önceki bütün mantıksal durumu geri yükler; o seçimden sonra gerçekleşen otomatik toplamaları da geri sarar. Böylece animasyon zamanlaması geri alma sonucunu değiştirmez.

### Mantığı gösteren küçük örnek

Dış halkası 12 mavi, ortası 4 sarı hücreden oluşan 4×4 bir şekil düşün:

```text
M M M M
M S S M
M S S M
M M M M
```

Mavi `12` kapsülü dış halkayı alır ve sarılar açılır. Sarı `4` kapsülü ardından işi bitirir. Sarı önceden etkinleştirilmişse mavi açıklık oluşana kadar bekler. Bu örnek erişimi anlatır; tek başına beş yuvalı oyunda yenilgi bulmacası değildir. Asıl zorluk, çok renkli katmanlar ile kuyruk önlerinin birlikte tasarlanmasından gelir.

### Hız, baskı ve ödül

`1× / 3×` yalnızca toplama sunumunu hızlandırır; kapasiteyi, sırayı veya başarı ihtimalini etkilemez. Demoda sürekli yükselen alarm veya zorunlu zaman sınırı bulunmaz. Atmosfer, yumuşak toplama sesleri ve karakterlerin kısa sözleriyle kurulur; arka plan müziği kullanılmaz.

Ödül: Çalınan eserin sığınakta sergilenmesi, yeni görev ve kısa hikâye parçası. İlk demoda para ekonomisi, enerji, reklam, günlük görev veya satın alınabilir kurtarma yok. Bunları tasarımın eğlenceli olup olmadığı anlaşılmadan eklemek ölçümü bulanıklaştırır.

## 4. Demo hikâyesi: Voss Galerisi'nde Bir Gece

Tek bina, tek gece, beş bulmaca; hedeflenen ilk tam oynama süresi yaklaşık 10–15 dakika. Bu süre bir üretim tahminidir, kullanıcı testinde ölçülecek. İlk iki görev hazırlık odasında, son üç görev ana sergide geçer. Yeni mekân gösterimi, yeni hareket sistemi gerektirmez.

| Bölüm | Hedef | Öğrettiği karar | Hikâye ilerlemesi | Başlangıç içerik bütçesi |
|---|---|---|---|---|
| 1 — Sessiz Giriş | Özgün küçük mühür | Kapsül seç, aynı rengi topla, dolunca yuva açılır. | Milo cihazı başlatır; Ada ilk parçayı kaçırır. | 3 renk; 50–90 hücre; yaklaşık 1 dakika. |
| 2 — Camın Ardında | Özgün seramik kupa | Dış renk açılmadan iç renge ulaşılamaz. | Küratör, teslim edilen parçaları beklediğinden hızlı doğrular. | 4 renk; 90–140 hücre; 1–2 dakika. |
| 3 — İnci | İnci Küpeli Kız'ın stilize yorumu | Aynı renkten iki kapsül ve farklı kapasiteler. | Çerçevenin arkasında sıra dışı envanter damgası görülür. | 5 renk; 160–240 hücre; 2–3 dakika. |
| 4 — Yıldızlar | Yıldızlı Gece'nin stilize yorumu | Kuyrukta ileriyi okuma ve bir yuvayı gerektiğinde boş bırakma. | Damga ikinci kez çıkar; Milo cihazın da aynı numaralama düzenini taşıdığını fark eder. | 6 renk; 220–320 hücre; 2–3 dakika. |
| 5 — Son Parça | Kurmaca tarihî eser: Ay Kapısı Maskesi | Erişim, kapasite ve kuyruk sırasını birlikte yönetme. | Kaidenin kaydında cihazın teslim emri çıkar. Ada rotayı değiştirir. | 6 renk; 280–400 hücre; 3–4 dakika. |

Hücre sayıları aktif, taşınan hücrelerdir. Görselin arka planı her seviyede doldurulmak zorunda değildir. Tablolar önce küçük paletli okunabilir eskizlerde değerlendirilir; tanınabilirlik zayıfsa hücre sayısı kontrollü artırılır. Zorluk yalnızca hücre sayısı büyütülerek artırılmaz.

Ünlü eser adları yaratıcı hedef seçimidir. Üretimde özgün stilize çizimler hazırlanmalı; kullanılacak dış görsel kaynağı ve kullanım koşulları ayrıca kaydedilmelidir. Bu aşamada hiçbir eser dosyası indirilmedi veya lisans doğrulaması yapıldığı iddia edilmedi.

### Hazırlanmış bölüm kuralları

- Her seviyenin baştan sona bir çözüm sırası içerik dosyasında tutulmalı.
- İlk bölümde erişilebilir renkler ve kuyruk açık olmalı; bir açıklama okumadan ilk başarı mümkün olmalı.
- İkinci bölüm güvenli bir bekleyen kapsül örneği göstermeli; oyuncu renk beklemesinin nedenini görmeli.
- İlk gerçek kilitlenme olasılığı üçüncü bölümden önce gelmemeli.
- Dördüncü ve beşinci bölümde en az bir anlamlı seçim olmalı: Her parlak kapsüle rastgele dokunmak güvenilir biçimde çözüm sağlamamalı.
- Hiçbir çözüm, ekranda görünmeyen rastgele renk veya sonradan satın alınan bir araç gerektirmemeli.
- Yanlış bir seçim hemen kaçınılmaz yenilgiye dönüşmek zorunda değil; sonraki seçimlerle toparlanabilecek durumlar tasarlanmalı.
- Bu belge bölüm tarifini belirler. Kesin hücre haritaları ve kanıtlanmış kuyruk dizileri, uygulama öncesindeki ilk içerik üretim işidir; henüz hazırlanmış ve çözülmüş değiller.

## 5. Anlatının oyuna yerleştirilmesi

İlk uzun açıklama yerine tek görsel ve iki kısa replik kullanılır. İlk dokunuşa kadar hedef en fazla 15 saniyedir. Bölüm başlangıcında en fazla iki kısa konuşma balonu; bölüm sonunda tek ipucu kartı. Tüm anlatı atlanabilir ve görev dosyasından yeniden okunabilir.

### Açılış

**Milo:** “Kapsülü seç. Dronlar aynı rengi toplar.”  
**Ada:** “Bir tablo için fazla küçük.”  
**Milo:** “Tabloyu tek seferde götürmüyoruz.”

İlk kapsül dolar, hücreler transfer geçidinden kaybolur. Öğretim metni: **“Dolan kapsül gider. Boşalan yere yenisini koy.”**

### İlk engelli renk

**Ada:** “Sarı ekip neden bekliyor?”  
**Milo:** “Yolu kapalı. Önündeki rengi çıkar.”

Bekleyen kapsülde küçük yol simgesi görünür; ilgili erişilebilir dış bölge kısa süre vurgulanır. Uyarı renk dışında simgeyle de anlaşılır.

### Üçüncü bölümün ipucu

**Ada:** “Çerçevenin arkasında başka bir envanter numarası var.”  
**Küratör:** “Çerçeveyle ilgilenme. Siparişi tamamla.”

Bu konuşma kuşkuyu başlatır; müşterinin bütün planını erken açıklamaz.

### Demo sonu

Maskenin altından açılan kayıt: **“Son teslim: aktarım çekirdeği. Operatör gerekli değil.”**

**Milo:** “Aktarım çekirdeği… Bizim cihaz.”  
**Küratör:** “Son kapsülü gönder, Piksel.”  
**Ada:** “Teslimat adresi değişti.”

Oyuncu son kapsülü kendi sığınağına gönderen belirgin düğmeye dokunur. Bu tek anlatısal eylemdir; ayrıca bir refleks oyunu açılmaz. Eserler sığınakta birleşir. Beş eserlik rafın yanında kapalı bir görev dosyası görünür: **“Koleksiyonun sahibi kim?”** Demo burada tamamlanır; olmayan bir bölüm oynanabilir gibi sunulmaz.

## 6. Görsel ve ses yönü

Oyun sahnesi referanstaki sıcak ahşap yüzey, krem çerçeve ve renkli hücreleri kullanır. Ana menü ve koleksiyon koyu galeri kimliğini korur. Arayüz büyük, sade ve yüksek kontrastlıdır. Eserin tanınabilirliği dekorasyondan önce gelir.

Piksel sözcüğü bütün arayüzü düşük çözünürlüklü yapma zorunluluğu taşımaz. Resimler kare hücrelerden oluşur; kapsüller, yazılar ve kontrol simgeleri temiz çizilebilir. Hafif gölge ve kabartı ile referanstaki dokunsal his korunur. İlk demo için 2D çizim ve sınırlı derinlik etkisi yeterli bir tasarım yönüdür.

Karıncaların yerine küçük kutu biçimli dronlar kullanılır. Karakterler resim üzerinde yürütülmez; Ada ve Milo kısa portrelerle görünür. Böylece renkli toplama hareketi okunaklı kalır ve karakter animasyonu üretimi büyümez.

### Ekran hiyerarşisi

1. Üst şerit: görev adı, duraklatma, hız.
2. Ana alan: eserin çerçevesi ve toplanan hücreler.
3. Transfer alanı: ortada teslimat deliği ve beş aktif kapsül. Boş yuvalar her an doldurulabilir.
4. Kuyruk: üç sütun, ön sıra ve en az iki sonraki seçim.
5. Alt şerit: geri al, ses ve yardım düğmesi. Yeniden başlatma duraklatma menüsünde.

Kullanıcının güncel tercihiyle kapsüllerde yalnızca kapasite rakamları bulunur; hücrelerde harf yoktur. Rakamlar kontrastlı konturla gösterilir. Renk dışı eşleştirme işaretleri bu sürümde bulunmaz.

Sesler: seçmede yumuşak bir temas, her pikselin alındığı anda kısa bir ASMR tarzı tık, dolan kapsülde hafif kapanma sesi. Altı alım varyantı tekdüzeliği azaltır; arka plan müziği yoktur. Efektler kapatılabilir; hareket azaltma seçeneği alım parçacıklarını gizler. Dronlar düşük sabit hızla, hedefe en yakın erişilebilir çerçeve kenarına dışarıdan gider ve içerde yalnızca boş hücrelerden geçer.

## 7. Demo kapsamı ve üretime geçiş

### Dahil

- Açılış, beş hazırlanmış bulmaca, sonuç ve basit sığınak koleksiyonu.
- Renk/kapasite/erişim sistemi; üç sütun kuyruk; beş aktif yuva.
- Otomatik taşıma, 1×/3× hız, kilitlenme açıklaması, tek adım geri alma ve yeniden başlatma.
- Kısa hikâye kartları; özgün iki küçük eser, iki ünlü tablonun yorumu ve özgün final maskesi.
- Bölüm tamamlanma kaydı, temel ses ayarları, fare ve dokunma için aynı etkileşim.

### Demo sonrasına bırakılanlar

Serbest dolaşma, polis takibi, farklı hırsız sınıfları, ekipman yükseltmeleri, dallanan hikâye, çevrim içi hesap, mağaza, reklam, enerji, liderlik tablosu, prosedürel bölüm üretimi ve 3D heykel döndürme. Tarihî eserler demoda aynı 2D tarama bulmacasıyla oynanır.

### Godot için sorumluluk ayrımı

Godot projesi bu klasörde sıfırdan kurulacak; proje ayarları, sahneler, GDScript kodları ve bölüm verileri Codex tarafından oluşturulacak. Uygulamaya başlarken kurulu Godot sürümü kontrol edilecek. Sorumluluklar şöyle ayrılacak:

- **Bölüm verisi:** hücreler, renk paleti, kuyruk sütunları, kapasite değerleri, hikâye kartı ve örnek çözüm.
- **Bulmaca durumu:** erişilebilir hücreler, aktif kapsüller, kuyruklar, kazanma/kilitlenme ve geri alma görüntüsü.
- **Sunum:** hücre çizimi, dron hareketleri, kapsül animasyonları ve sesler.
- **Akış:** görev seçimi, anlatı kartları, sığınak ve tamamlanma kaydı.

Bulmacanın sonucu animasyon tamamlanma sırasına bağlı olmamalı. Aynı seçimler aynı sonuçları üretmeli. Önce basit geometrik hücrelerle bu doğrulanmalı; görsel üretim ve taşıma efektleri sonra eklenmeli. Bu bir uygulama sırasıdır; bu aşamada kod yazılmadı.

### Uygulama sırası

1. Food Hunt ile doğrulanan ortak çekirdeği ve bu belgede tanımlanan Pixel Heist kurallarını uygulama sözleşmesi olarak kullan.
2. Kurulu Godot sürümünü kontrol et ve mevcut PixelHeist klasöründe projeyi sıfırdan oluştur.
3. Beş bölümün hücre haritalarını, kapasite toplamlarını ve çözüm sıralarını hazırla.
4. Tek bölümde seçim, toplama, dolma, bekleme, kilitlenme ve geri alma döngüsünü çalıştır.
5. Beş bölüm, kısa hikâye ve koleksiyon ekranını bağla.
6. Görsel/ses düzenini ekle ve ilk oyuncu oturumlarını gözle.

## 8. Demoyu değerlendirme ölçütleri

Bunlar ölçülmüş sonuç değil, kabul hedefleridir.

| Soru | Kabul hedefi | Kontrol yöntemi |
|---|---|---|
| Oyuncu ne yapacağını anlıyor mu? | İlk doğru seçim, en fazla iki kısa yönlendirmeyle yapılabiliyor. | İlk oynayış gözlemi. |
| Bekleyen kapsül anlaşılır mı? | Oyuncu “Bu renk içeride; yolu açmalıyım” bağlantısını kurabiliyor. | İkinci bölüm sonrası tek kısa soru. |
| Bulmaca gerçek karar üretiyor mu? | Son iki bölümde oyuncu kuyruk ve erişimi birlikte değerlendiriyor. | Seçim ve geri alma noktalarını gözleme. |
| Soygun duygusu var mı? | Oyuncu hedefini “resmi bitirmek” yanında “eseri çalmak/kaçırmak” diye de anlatıyor. | Oynayış sonrası serbest anlatım. |
| Kurallar tutarlı mı? | Aynı seçim sırası, 1× ve 3× hızda aynı hücre/kapsül sonucunu veriyor. | Uygulama sırasında anlamlı mekanik doğrulama. |
| Bölümler çözülebilir mi? | Beş örnek çözüm tamamlanıyor; renk/kapasite toplamları eşleşiyor. | Veri doğrulama ve tam oynama. |
| Sonraki bölüme ilgi var mı? | Oyuncu demoyu bitirdiğinde Küratör ve koleksiyon hakkında bir soru taşıyor. | Kısa görüşme; zorunlu başarı yüzdesi uydurulmaz. |

## 9. Başlıca tasarım riskleri ve karşılıkları

**Sadece tema değiştirilmiş hissi:** Boş çerçeve, sığınakta yeniden birleşen eser ve her hedefin bıraktığı ipucu oynanışın sonucuna bağlanır. Hikâye yalnız menü metni olarak kalmaz.

**Rastgele kutu seçerek kazanma:** Kuyruk ve dış renk yerleşimi birlikte hazırlanır. Son iki bölümün anlamlı sıralama gerektirdiği elle kontrol edilir.

**Sıkışmanın sebebini anlayamama:** Bekleyen kapsül işareti, erişilebilir kenar vurgusu ve ücretsiz geri alma birlikte sunulur. Oyuncu bekleyen kapsülle bozuk oyunu ayırt edebilmelidir.

**Resimlerin tanınmaması:** Eserler önce oyun boyutunda ve sınırlı palette incelenir. Ayrıntı artırmadan önce siluet ve baskın renk kütleleri düzeltilir.

**Otomatik taşımanın uzaması:** Hücre ve kapsül sayıları kısa bölüm hedefiyle dengelenir; 3× hız sunulur. Çok sayıda görsel dron üretmek yerine sınırlı taşıyıcı hareketleri kullanılır.

**Hikâyenin oyunu durdurması:** Anlatı ilk eylemi geciktirmez, balonlar kısa tutulur ve atlanabilir. Demo gizemin bir sorusunu açar, birini kapatır: Ada eserleri çıkarır ama müşteriye teslim etmez.

## 10. Tasarım kararı özeti

Pixel Heist'in önerilen kimliği, **renk ve kuyruk bulmacasıyla oynanan stilize bir sanat soygunu**. İlk demoda yenilik ek mekanik sayısından değil; hücre toplamanın eser kaçırmaya dönüşmesinden, sığınakta fiziksel bir koleksiyon oluşmasından ve beş görev boyunca ilerleyen müşteri gizeminden gelir.

Hikâye omurgası, karakterler, beş görevlik demo akışı ve önerilen oynanış kuralları bu dosyada tanımlandı. Referans Food Hunt olarak kesinleşti ve ortak oyun çekirdeği resmî açıklamalardan doğrulandı. Godot geliştirmesi mevcut klasörde sıfırdan yapılacak; başka proje veya açıklamanın yeniden gönderilmesi beklenmiyor. Kesin bölüm haritaları, görsel varlıklar ve oyun uygulaması bu tasarım çalışmasının ardından üretilecek.
