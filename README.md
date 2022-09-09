# 오픈 마켓 프로젝트
## 프로젝트 소개
- 네트워크 통신으로 상품 목록화면 / 상세화면 / 등록화면을 나타냅니다.
- Architecture : MVC
- Deployment Target : iOS 13.2
- 팀원 (iOS 개발) : [허황](https://github.com/HJEHA), [애플사이다](https://github.com/just1103)
- 진행 기간 : 2022.01.03 ~ 2022.01.31
- 관련 Pull Requeset : [STEP1](https://github.com/yagom-academy/ios-open-market/pull/84) / [STEP2](https://github.com/yagom-academy/ios-open-market/pull/96) / [STEP3](https://github.com/yagom-academy/ios-open-market/pull/114) / [STEP4](https://github.com/yagom-academy/ios-open-market/pull/131)

## 주요 화면 및 기능
### 🛍️ 상품 목록화면

> * 목록 최상단에서 위로 Scroll하면 상품 목록을 업데이트해요.  
> * 상단 `SegmentedControl`로 보기 모드를 List (목록형) 또는 Grid (격자형)로 바꿀 수 있어요.  
> * 데이터 로딩 시 `Acticity Indicator`를 나타냅니다.  
> * 새로운 상품이 추가되면 상단에 버튼을 띄워 알려줍니다.

|목록 업데이트|List-Grid 전환|신상품 등록 알림|무한 Scroll|
|-|-|-|-|
|<img width="180" src="https://user-images.githubusercontent.com/70856586/189278678-8d333322-43b3-4409-8405-5738cd062655.gif">|<img width="180" src="https://user-images.githubusercontent.com/70856586/189278403-f49ac43c-ee21-4cfd-a39e-e5f47aa6d815.gif">|<img width="180" src="https://user-images.githubusercontent.com/70856586/189279165-6999c4e2-013f-47ef-98ea-525429370620.gif">
||

### 🛍️ 상품 상세화면
> * 목록화면의 상품을 탭하면 상세화면을 나타냅니다.  
> * 이미지를 좌우로 Scroll해서 확인해요.
> * 우상단 버튼으로 해당 상품을 수정/삭제할 수 있어요.  

|상세 화면|
|-|
|<img width="180" src="https://user-images.githubusercontent.com/70856586/189276763-b96e1498-6b6b-45f6-a9c6-d3d857ab7753.gif">|

### 🛍️ 상품 등록화면
> * `+ 버튼`으로 이미지를 추가하고, 이미지 우상단의 `- 버튼`으로 이미지를 삭제해요.  
> * 이미지 크기가 큰 경우 300KB로 축소하여 등록합니다.  
> * 입력값이 적절한지 검증하고 필요 시 `Alert`를 나타내요.  
> * `TextView` 입력 텍스트가 키보드 뒤로 숨겨지지 않도록 처리했어요.  

|이미지 추가|이미지 수정/삭제|상품 등록 실패|상품 등록 성공|키보드 입력 처리|
|-|-|-|-|-|
|<img width="180" src="https://i.imgur.com/KsqBnFP.gif">|<img width="180" src="https://i.imgur.com/QoqzYq6.gif">|<img width="180" src="https://i.imgur.com/pcxnzgE.gif">|<img width="180" src="https://i.imgur.com/k1mBXL0.gif">|<img width="180" src="https://i.imgur.com/0Llsy78.gif">|

## 목차
- [STEP1 : 모델/네트워킹 타입 구현](##STEP1-모델/네트워킹-타입-구현)
    + [키워드](#1-1-키워드)
    + [구현 내용](#1-2-구현-내용)
    + [Trouble Shooting](#1-3-trouble-shooting)

## STEP1 모델/네트워킹 타입 구현
### 1-1 키워드
* 네트워크 : URLSession, HTTP Request/Response, 서버 API
* 비동기 작업 : completionHandler, escaping closure, Result
* Unit Test : Mock Data/Mock URLSession, XCTestExpectation
* 라이브러리 : SwiftLint, CocoaPods
* JSON : Decoding, CodingKey, convertFromSnakeCase

### 1-2 구현 내용
Parsing한 JSON 데이터를 Mapping할 Model 타입을 설계했습니다. 그리고 서버와 통신하기 위해 URLSession을 활용했습니다. Mock Data 및 Mock URLSession을 통해 이에 대한 Unit Test를 진행했습니다.

### 1-3 Trouble Shooting
**서버 데이터를 비동기로 Load하는 방법**
Trouble Shooting 과정은 아래 순서로 진행했습니다.
1) semaphore 사용 전
    - URLSession이 데이터 Loading 작업을 비동기로 처리하므로 `getHealthChecker` 메서드의 반환값 반영이 안되는 문제가 발생했습니다. 이를 해결하기 위해 semaphore를 활용해 반환 값을 받기 전까지 다른 스레드의 접근을 차단하는 방식을 사용했습니다.
2) semaphore 사용 후
    - 반환타입이 있으면 MockURLSession을 통한 테스트가 불가능한 문제가 발생했습니다. 따라서 `getHealthChecker` 메서드의 매개변수 타입을 탈출클로저로 변경하고, semaphore를 삭제하고 메서드의 반환 타입을 변경했습니다. 그리고 이 방식을 다른 GET 관련 메서드들에 적용했습니다.
3) semaphore 삭제, `탈출 클로저` 및 `Result<Data, Error>` 사용
```swift
// 수정 전 - semaphore 및 반환타입 사용
let semaphore = DispatchSemaphore(value: 0)

private func getHealthChecker() -> Bool {
    guard let url = URL(string: "\(self.url)healthChecker") else {
        return false
    }
    var result: Bool = false

    var urlRequest = URLRequest(url: url)
    urlRequest.httpMethod = "GET"

    let dataTask = URLSession.shared.dataTask(with: urlRequest) { _, response, _ in 
        let successStatusCode = 200

        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == successStatusCode else {
                  semaphore.signal()
                  return
              }
        result = true  // data 존재 유무를 로컬변수에 할당
        semaphore.signal()
    }
    dataTask.resume()
    semaphore.wait()

    return result   
}

// 수정 후 - 함수 분리 후 탈출 클로저 사용
private func loadData(request: URLRequest, completionHandler: @escaping ((Result<Data, NetworkError>) -> Void)) {
    let task = session.dataTask(with: request) { data, response, _ in
        let successStatusCode = 200..<300
        guard let httpResponse = response as? HTTPURLResponse,
              successStatusCode.contains(httpResponse.statusCode) else {
                  completionHandler(.failure(.statusCodeError))
                  return
              }

        if let data = data {
            completionHandler(.success(data))  // data를 completionHandler에 전달
            return
        }

        completionHandler(.failure(.unknownError))
    }
    task.resume()
}

func getHealthChecker(completionHandler: @escaping ((Result<Data, NetworkError>) -> Void)) {
    guard let urlRequest = URLRequest(url: OpenMarketURL.healthChecker, method: .get) else {
        return
    }
    loadData(request: urlRequest, completionHandler: completionHandler)
}

// MockURLSession 관련 테스트 코드
class NetworkDataTransferTests: XCTestCase {
    func test_MockURLSession의_StatusCode가_200번일때_정상동작_하는지() {
        let mockSession = MockURLSession(isRequestSuccess: true)
        let netWorkDataTransfer = NetworkDataTransfer(session: mockSession)

        let expectation = XCTestExpectation(description: "MockURLSession의 getHealthChecker 비동기 테스트")
        
        netWorkDataTransfer.getHealthChecker { result in  // 탈출 클로저가 있어야 실행 가능한 구조
            switch result {
            case .success(let data):
                let resultString = String(data: data, encoding: .utf8)
                let successString = #""OK""#
                XCTAssertEqual(resultString, successString)
            case .failure(_):
                XCTFail()
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 10.0)
    }
}
```

### 1-5 피드백 반영
**1. URLProtocol / OpenMarketURL 관련**
기존 방식은 아래의 문제점을 가질 수 있습니다.
* API가 추가될 경우 열거형의 크기가 점점 비대해집니다.
* 여러 개발자가 동시에 OpenMarketURL 파일을 수정할 때 충돌이 발생할 수 있습니다.
* 새로운 API가 추가될 경우 case를 계속 생성하고 switch문을 매번 수정해야 합니다.

```swift
// 개선 전 코드
protocol URLProtocol {  
    var url: URL? { get }
}

extension URLRequest {
    init?(url: URLProtocol, method: HttpMethod) {
        guard let url = url.url else {
            return nil
        }
        self.init(url: url)
        self.httpMethod = method.description
    }
}

enum OpenMarketURL: URLProtocol {   
    private static let apiHost = "https://market-training.yagom-academy.kr/"
    case healthChecker
    case productDetail(id: Int)
    case productPage(_ pageNumber: Int, _ itemsPerPage: Int)
    
    var url: URL? {
        switch self {
        case .healthChecker:
            return URL(string: "\(OpenMarketURL.apiHost)healthChecker")
        case .productDetail(let id):
            return URL(string: "\(OpenMarketURL.apiHost)api/products/\(id)")
        case .productPage(let pageNumber, let itemsPerPage):
            var urlComponents = URLComponents(string: "\(OpenMarketURL.apiHost)api/products?")
            let pageNumberQuery = URLQueryItem(name: "page_no", value: "\(pageNumber)")
            let itemsPerPageQuery = URLQueryItem(name: "items_per_page", value: "\(itemsPerPage)")
            urlComponents?.queryItems?.append(pageNumberQuery)
            urlComponents?.queryItems?.append(itemsPerPageQuery)
            
            return urlComponents?.url
        }
    }
}
```

**개선 방향**   
기존 URL 프로퍼티만 가지던 URLProtocol을 HttpMethod까지 가진 APIProtocol로 변경했습니다.
서버와 통신하기 위한 API 별로 구조체 타입을 새로 생성하고 APIProtocol을 채택했습니다.
이렇게 개선하게 되면 새로운 API가 추가되더라도 기존의 코드를 수정할 필요가 없어집니다.
또, 여러 개발자들이 각자 맞은 API 구조체 타입만 만들면 되기 때문에 충돌이 일어날 확률도 줄어듭니다.
```swift 
// 개선 후 코드
protocol APIProtocol {
    var url: URL? { get }
    var method: HttpMethod { get }
}

extension URLRequest {
    init?(api: APIProtocol) {
        guard let url = api.url else {
            return nil
        }
        
        self.init(url: url) 
        self.httpMethod = "\(api.method)"
    }
}

struct HealthCheckerAPI: APIProtocol {
    var url: URL?
    var method: HttpMethod = .get
    
    init(baseURL: BaseURLProtocol = OpenMarketBaseURL()) {
        self.url = URL(string: "\(baseURL.baseURL)healthChecker")
    }
}

struct ProductDetailAPI: APIProtocol {
    var url: URL?
    var method: HttpMethod = .get
    
    init(_ id: Int, baseURL: BaseURLProtocol = OpenMarketBaseURL()) {
        self.url = URL(string: "\(baseURL.baseURL)api/products/\(id)")
    }
}
```

**2. decode 메서드 반환타입 개선**   
decoding 결과를 명확히 나타내기 위해 `decode` 메서드의 반환타입을 옵셔널 `Item?`에서 `Result<Item, JSONParserError>`로 개선했습니다. Result는 `제네릭 열거형`으로 구현되어 있으며, decoding 성공 시 `Item` 타입의 decoding된 데이터를 반환하고, 실패 시 열거형으로 구현한 `Error` 타입을 반환합니다.

```swift  
// 개선 전 코드
func decode(from json: Data?) -> Item? {
    guard let data = json else {
        return nil
    }

    let decoder = JSONDecoder()
    decoder.keyDecodingStrategy = .convertFromSnakeCase

    let decodedData = try? decoder.decode(Item.self, from: data)

    return decodedData
}

// 개선 후 코드
func decode(from json: Data?) -> Result<Item, JSONParserError> {
    guard let data = json else {
        return .failure(.decodingFail)
    }

    let decoder = JSONDecoder()
    decoder.keyDecodingStrategy = .convertFromSnakeCase

    guard let decodedData = try? decoder.decode(Item.self, from: data) else {
        return .failure(.decodingFail)
    }

    return .success(decodedData)
}
```

**3. JSONParserTests의 Bundle.main.path 관련 문제 해결**   
decode 메서드에 대한 테스트를 진행하기 위해 `Bundle.main.path`를 통해 MockProduct JSON 데이터에 접근하도록 했는데, path에 nil이 반환되며 Bundle에 접근하지 못하는 문제가 발생했습니다. LLDB 확인 결과 JSON 파일이 포함된 Bundle은 `OpenMarketTests.xctest`이며, 테스트 코드를 실행하는 주체는 OpenMarket `App Bundle`임을 파악했습니다. (LLDB 내용: `OpenMarket.app/PlugIns/OpenMarketTests.xctest`)
따라서 현재 executable의 Bundle 개체를 반환하는 `Bundle.main` (즉, App Bundle)이 아니라, 테스트 코드를 실행하는 주체를 가르키는 `Bundle(for: type(of: self))` (즉, XCTests Bundle)로 path를 수정하여 JSON 파일에 접근할 수 있었습니다.

```swift
// 개선 전 코드
func test_Product타입_decode했을때_Nil이_아닌지_테스트() {
    guard let path = Bundle.main.path(forResource: "MockProduct", ofType: "json"),  // path에 nil이 반환되는 문제 발생
          let jsonString = try? String(contentsOfFile: path) else {
        return
    }
    //...
}

// 개선 후 코드
func test_Product타입_decode했을때_Nil이_아닌지_테스트() {
    guard let path = Bundle(for: type(of: self)).path(forResource: "MockProduct", ofType: "json"),
          let jsonString = try? String(contentsOfFile: path) else {
              XCTFail()
              return
          }
    //...
}
```

이외에도 테스트 코드 내부에서 옵셔널 바인딩을 하는 경우 else문 내부에 `XCTFail()`을 추가하여 예상 결과값이 반환되지 않았음에도 테스트를 Pass 하는 문제를 방지했습니다.

## STEP2 상품 목록 화면 구현
### 2-1 키워드
* Collection View : FlowLayout (List/Grid), DataSource/Delegate, Custom Cell, reloadData(), reloadDataWithCompletion()
* View : Navigation Bar, Segmented Control, CALayer, NSAttributedString 
* Indicator : Activity Indicator, Scroll Indicator
* Interface Builder 없이 View 구성하기
* Cache : Memory Cache, NSCache, didReceiveMemoryWarningNotification
   
### 2-2 구현 내용
API 서버에 요청한 상품 목록 데이터를 받아서 화면을 구성했습니다. 상품 보기 모드를 List (목록형) 또는 Grid (격자형)로 변경할 수 있고, 상품명, (할인)가격, 썸네일 이미지 등의 상품 정보를 확인 가능합니다. Acticity Indicator를 통해 사용자는 데이터가 Loading 중임을 알 수 있습니다.

### 2-3 고민한 점 
**1. List(목록형), Grid(격자형) 두가지 형태의 Cell을 대응하는 방법**   
여러 가지 방법을 찾아봤습니다.
+ Modern Collection View : iOS 14이상에서 사용할 수 있는 방법으로 프로젝트 최소 빌드 타켓이 iOS 13.2이기 때문에 사용하지 못했습니다.
+ 컬렉션 뷰 레이아웃을 두개 구성하고 스위치하는 방법 (기존 Flow Layout 사용)
+ 두 가지 형태의 커스텀 셀을 구성하고 cellForItemAt 메서드에서 셀을 스위치하는 방법
+ 리스트 형태는 테이블 뷰, 그리드 형태는 콜렉션 뷰로 구현
두 가지 형태의 커스텀 셀을 구성하고 셀의 크기에 따라 UICollectionViewDelegateFlowLayout를 사용해 두 가지 형태의 셀을 전부 대응할 수 있도록 구현했습니다.

**2. fetch한 데이터를 Cell에 반영하는 역할의 주체**   
기존에는 cellForItemAt 메서드에서 Cell View를 업데이트하도록 했지만, Custom Cell 타입이 해당 역할을 맡는 것이 적절하다고 판단되어 수정했습니다. cellForItemAt 메서드가 비대해지는 것을 방지할 수 있었고, 단일책임원칙에 부합하도록 개선했습니다.

```swift 
// 개선 전 - CollectionView의 CellForItemAt 메서드로 구현
func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier,
                                                        for: indexPath) as? ProductCellProtocol else {
        fatalError()
    }

    cell.productThumbnailView.image = UIImage(data: thumbnailData)  // fetch한 이미지를 Cell에 반영
    //...
}

// 개선 후 - Custom Cell 내부 메서드로 구현
func updateThumbnailView(with image: UIImage?) {  // 매개변수로 fetch한 이미지를 전달받아 Cell에 반영
    productThumbnailView.image = image  
}
```
**3. Image Cache**   
상품의 Thumbnail을 매번 서버에서 요청받아 화면에 띄우는건 비효율적이고 비용도 크다는 생각을 했습니다.
따라서 NSCache를 이용한 메모리 캐시를 도입했습니다.
Thumbnail의 URL을 key로 하고 먼저 메모리에 해당 키를 가진 Thumbnail이 있는지 확인합니다.
메모리에 이미지가 존재한다면 이미지를 반환해주고, 존재하지 않는다면 서버에 요청해 이미지를 받아옵니다. 
이때 성공적으로 이미지를 받아왔다면 메모리에 이미지를 캐시에 저장해서 다음번에 이미지를 사용하는 경우 캐시에서 이미지를 받아올 수 있도록 했습니다.
   
### 2-4 Trouble Shooting
**1. 화면 전환 시 Scroll 위치 유지**   
사용자가 최근 확인한 상품을 화면 전환 시 그대로 볼 수 있게 하기 위해 Scroll 위치를 유지하도록 구현하고자 했습니다. 하지만 List 화면에서 Grid 화면으로 전환 시, Grid 화면의 `Scroll Indicator`가 다소 아래로 내려가 있는 문제가 발생했습니다. 이를 해결하기 위해 List/Gird 화면 각각의 전체 높이에 대한 화면 전환 이전의 `Scroll Indicator`의 상대적인 위치를 고려하여 Scroll Offset을 지정하도록 개선했습니다. (수식 `화면전환 이후의 Scroll Indicator의 위치 = 화면전환 이후의 화면 높이 * 현재 Scroll Indicator의 상대적인 위치`을 활용)
   
```swift 
private func currentScrollRatio() -> CGFloat {
    return productCollectionView.contentOffset.y / productCollectionView.contentSize.height  // 현재 화면 전체 높이에 대한 Scroll Indicator의 상대적인 위치
}

private func syncScrollIndicator(with currentScrollRatio: CGFloat) {
    let nextViewMaxHeight = productCollectionView.contentSize.height
    let offset = CGPoint(x: 0, y: nextViewMaxHeight * currentScrollRatio)  // 화면전환 이후의 Scroll Indicator의 위치 = 화면전환 이후의 화면 높이 * 현재 Scroll Indicator의 상대적인 위치
    productCollectionView.setContentOffset(offset, animated: false)
}
```
   
**2. 화면 전환 시 애니메이션 버그**   
화면이 전환될 때 아래 gif처럼 스크롤 과정의 잔상이 보이는 문제가 발생했습니다.  
|개선 전|개선 후|
|-|-|
|![](https://i.imgur.com/AjHBJhJ.gif)|![](https://i.imgur.com/0CK2D01.gif)|

reloadData() 메서드는 completion을 별도로 지니고 있지 않기 때문에 기존에는 performBatchUpdates 메서드를 사용했습니다. 하지만
performBatchUpdates 메서드를 잘못 사용한 것이 원인이었습니다. 
performBatchUpdates 메서드는 Collection View의 여러 애니메이션들을 수행하고, 그에 따른 Completion을 동작시켜주는 메서드입니다.
기존 방법으로 performBatchUpdates의 매개변수인 updates 클로저 내부에서 reloadData() 메서드를 호출했고, completion 클로저에서 스크롤을 움직이라는 코드를 배치했습니다.
하지만 위와 같은 버그가 발생했습니다.

개선 방법   
performBatchUpdates 메서드 대신 reloadData() 메서드의 완료를 알 수 있는 또 다른 방법을 활용했습니다.
reloadData가 호출되면 아래 순서에 따라 코드가 실행됩니다.
1. numberOfItemsInSection 메서드에서 Cell의 개수를 결정
2. cellForItemAt 메서드에서 화면에 보여질 만큼의 Cell을 생성
3. collection View의 layoutSubViews 호출

즉, reloadData 메서드가 완료되면 layoutSubViews 메서드가 호출됩니다. 이에 따라 커스텀 Collection View 클래스를 만들고 아래의 메서드와 프로퍼티를 추가했습니다. 
또한 UX 개선을 위해 Fade in/out 기능을 추가적으로 구현했습니다.
```swift
var reloadDataCompletionHandler: (() -> Void)?
    
func reloadDataCompletion(_ completion: @escaping () -> Void) {
    reloadDataCompletionHandler = completion
    super.reloadData()
}
   
override func layoutSubviews() {
    super.layoutSubviews()
    if let handler = reloadDataCompletionHandler {
        handler()
        reloadDataCompletionHandler = nil
    }
}
    
func fadeIn(withDuration: TimeInterval = 0.5, completion: ((Bool) -> Void)? = nil) {
    UIView.animate(withDuration: 0.5, animations: {
        self.alpha = 1
    }, completion: completion)
}

func fadeOut(withDuration: TimeInterval = 0.5, completion: ((Bool) -> Void)? = nil) {
    UIView.animate(withDuration: 0.5, animations: {
        self.alpha = 0
    }, completion: completion)
}
```   
