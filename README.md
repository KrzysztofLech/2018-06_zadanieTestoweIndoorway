# Zadanie testowe dla firmy **INDOORWAY**
Czerwiec 2018  
<br> 

## Treść zadania:

**Jeden ViewController:**

* z dwoma przyciskami na dole ekranu:
   * dodaj element
   * wyczyść listę
* na pozostałej części ekranu UICollectionView zawierające elementy listy

**Źródło danych:**

* dane do przykładu należy pobrać ze strony: *https://jsonplaceholder.typicode.com*
* endpoint do wykorzystania to *photos*

**Pobieranie elementów:**

* wciskając przycisk ***dodaj element*** pobieramy kolejny element (zaczynając od pierwszego zdjęcia) i dodajemy je na listę
* miniaturki należy pobrać asynchronicznie i cacheować do poźniejszego wykorzystania

**Prezentacja danych na liście (UICollectionView)**  

* Pojedynczy element kolekcji zawiera:
   * tytuł
   * miniaturkę pobraną z API

 
* Pomiędzy elementami Collection View są separatory (osobne, jako decoration view).
* Zawsze kiedy lista jest jest pusta należy wyświetlić tekst: *Brak miniaturek do wyświetlenia*

**Czyszczenie listy:**

* usuwa wszystkie elementy z UICollectionView
* resetuje pobieranie danych tak by ponownie zacząć ładować od pierwszego elementu z endpointu.


## Realizacja

Xcode 9.4.1, Swift 4.1

Dostępne są dwa branch'e:

* **MVP-version** - wersja z funkcjonalnościami określonymi w treści zadania
   * wsparcie dla systemu iOS 9
   * obsługa iPhona w orientacji pionowej oraz poziomej
   * dostosowanie do wymogów iPhona X
   * brak bibliotek zewnętrznych
* **master** - wersja rozszerzona
   * wsparcie dla systemu iOS 11
   * wykorzystanie bibliotek zewnętrzych

## Dzaiałanie aplikacji
### UI:
* Każdorazowo po uruchomieniu aplikacji pobierany jest komplet danych o elementach do wyświetlenia.  
* Po pobraniu miniaturki elementu i jej wyświetleniu, informacja o tym zostaje zapisana w *UserDefaults*. Dzięki temu, przy ponownym uruchomieniu, wcześniej wyświetlone elementy są domyślnie prezentowane na liście. 
* Miniaturki zdjęć są zapisywane w pamięci podręcznej wykorzystującej  ***NSCache*** - pobierane są tylko nowe dane.
* Wielkość *celki* jest dostosowywana do wielkości ekranu urządzenia, tak aby odstępy pomiędzy poszczególnymi elementami listy zawsze były takie same.
* W układzie pionowym na liście wyświetlane są 2 elementy, a w układzie poziomym 4. Zmiana orientacji urządzenia powoduje odświeżenie interfejsu i odpowiednie dostosowanie ilości wyświetlanych elementów.
* Nad listą wyświetlana jest informacja o ilości wyświetlonych elementów.
* Przy czystej liście pokazywana jest zaślepka z stosowną informacją.
* Przycisk *Clear* jest dostępny dopiero po wyświetleniu pierwszego elementu.
* Każde pobieranie danych z sieci sygnalizowane jest poprzez *Activity Indicator*.
* W projekcie posługuję się kolorami zdefiniowanymi w ***Color Assets***.
* Aby zmienić domyślny wygląd kontrolek systemowych użyto właściwości klasy ***CALayer*** oraz metod ***Core Graphics***.

### API

* Komunikacja z API zrealizowana jest poprzez ***URLSession***.
   * Mógłbym wykorzystać bibliotekę ***Alamofire***, jednak jeśli tylko czas mi na to pozwala, to staram się nie korzystać z bibliotek zewnętrznych. 
* Do rozkodowania pobranych danych wykorzystano protokół ***Codable***.

### Offline:

* Wykorzystując ***CocoaPods*** zainstalowano bibliotekę ***ReachabilitySwift***.
* Przy próbie pobrania danych i braku dostępu do sieci zostaje wyświetlony alert z odpowiednim komunikatem.
* Utrata dostępu do Internetu / jego przywrócenie jest komunikowane popup'em, który podaje również sposób dostępu do sieci wifi/cellular.

### Animacje

* Wykorzystano animacje z famework'ów *UIKit* oraz ***Core Animation***.
* Pomiędzy początkowym kontrolerem a głównym zastosowano ***Custom Presentation Transition***.