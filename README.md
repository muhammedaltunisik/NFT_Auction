# NFT AÇIK ARTTIRMA

Bu proje içerisinde NFT açık arttırma sitesi ve bunun için kullanılabilecek akıllı kontrat bulunur.
Site şu anlık tamamlanmamıştır.

## Kontrat 
Kontrat ilk deploy edildiğinde deploy eden kişi kontratın *sahibi* olur. Kontrat içerisinde 
her NFT nin özelliklerini kaydetmek için ***ItemForAuction*** struct yapısı, ***ItemForAuction***  nesnelerini tutan ***idToItemForAuction*** mappingi, Fonksiyon çağrılarından sonra bilgi vermek için 4 adet event ve 4 adet fonksiyon bulunur.

### Fonksiyonlar
- startNFTAuction()
- cancelNFTAuction()
- bidPriceToNFT()
- finishNFTAuction()

### Eventler
- NFTAuctionStart()
- NFTAuctionCancel()
- bidPrice()
- FinisNFtAuction()

### ItemforAuction yapısı 
İçerisinde

**address contractAddress:** NFT kontrat adresi
**address sellerAddress:** Satıcı adresi
**address buyerAddress:** Alıcı adresi
**uint startingPrice:** Başlangıç fiyati
**uint highestPrice:** En yüksek teklif
**uint tokenId:** NFT kontratın da ki tokenId si
**uint deadline:** Açık arttırma bitiş zamanı
**bool state:** Durumu

değerlerini tutar.

------------------------------------------------

#### Fonskiyon özellikleri

**function startNFTAuction():** Çağrılırken içerisine açık arttırmaya katılıcak NFT nin kontrat adresi, NFT kontratında ki tokenID si, başlangıç fiyatı ve bitiş tarihini alır. Bu bilgileri aldıktan sonra bir *ERC721* nesnesi oluşturur ve NFT yi kontrata transfer eder. Transfer edilen NFT ye ait bilgileri kontrat üzerine **ItemforAuction** struct yapısını kullanarak kayıt eder. Sonrasında bir event yayınlar.

**Not:** NFT yi yüklemeden önce yüklemek istediği kontratın adresini kullanarak NFT kontratında ki ***setApprovalForAll()*** fonksiyonu kullanmalıdır. 

**function cancelNFTAuction():** Çağrılırken içerisine kontrata kayıtlı NFT nin ***id*** numarasını alır. Bir *ERC721* nesnesi olusturur. require() fonksiyonu ile gerekli kontrolleri yapar. Eğer NFT teklif gelmemişse NFT yi sahibine geri yollar ve kontrat'a kayıtlı NFT bilgilerini siler. Sonrasında bir event yayınlar.

**function bidPrice():** Çağırlırken içerisine kontrata kayıtlı NFT nin **id** numarasını ve **msg.value** değerini alır. require() fonksiyonu ile gerekeli kontrolleri yapar *(NFT satılmış mı, Açık arttırma bitmiş mi vb.)*.İçerisine gönderilen teklif *highestPrice* teklifinden %5 daha fazla olmalıdır yoksa teklifi kabul etmez. Gönderilen teklif *highestPrice* dan %5 daha fazla ise NFT'ye ait en yüksek fiyat ve alıcı adresi bilgilerini değiştirir. 

**function finisNFtAuction():** Çağrılırken içerisine kontrata kayıtlı NFT nin ***id*** numarasını alır.
require() fonksiyonu ile kontrolleri yapar. Sonrasında NFT yi yeni alıcının adresine yollar. Satılan fiyattan %5 komisyon alır ve ücreti satıyıca, komisyon değerini de kontrat sahibinin adresine gönderir.  

-----------------------------
#### Event özellikleri
**event NFTAuctionStart():** startNFTAuction() fonksiyonu çağrıldıktan sonra içerisinde baslangicFiyati, tokenId ve bitişTarihi olan bir event yayınlar. Bu bilgiler web sitesinin *front-end* tarafında kullanılması için yayınlanır.

**event NFTAuctionCancel():**  cancelNFTAuction() fonksiyonu çağrıldıktan sonra içerisinde bu kontrat tarafından her NFT ye verilen benzersiz id değeri olan bir event yayınlar. Bu id ile kontratta ki hangi NFTnin satışının iptal edildiğini anlar ve *front-end* tarafında ki NFT yi kaldırırız. 

**event bidPrice():** bidPrice() fonksiyonu çağrıldıktan sonra içerisinde bu kontrat tarafından her NFT ye verilen benzersiz id değeri ve verilen teklif değeri olan bir event yayınlar. Bu event sayesinde *front-end* tarafında NFT nin yeni fiyatını değiştirebiliriz.

**event FinisNFtAuction():** finisNFtAuction()  fonksiyonu çağrıldıktan sonra içerisinde bu kontrat tarafından her NFT ye verilen benzersiz id değeri olan bir event yayınlar. Bu id ile kontratta ki hangi NFT nin satıldığını anlar ve *front-end* tarafında ki güncellemeleri yaparız.

