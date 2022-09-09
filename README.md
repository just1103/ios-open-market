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

|목록 업데이트|List-Grid 전환|신상품 등록 알림|
|-|-|-|
|<img width="180" src="https://user-images.githubusercontent.com/70856586/189278678-8d333322-43b3-4409-8405-5738cd062655.gif">|<img width="180" src="https://user-images.githubusercontent.com/70856586/189278403-f49ac43c-ee21-4cfd-a39e-e5f47aa6d815.gif">|<img width="180" src="https://user-images.githubusercontent.com/70856586/189279165-6999c4e2-013f-47ef-98ea-525429370620.gif">
|

### 🛍️ 상품 상세화면
> * 목록화면의 상품을 탭하면 상세화면을 나타냅니다.  
> * 이미지를 좌우로 Scroll 가능해요.
> * 우상단 버튼으로 해당 상품을 수정/삭제할 수 있어요.  

|상세 화면|
|-|
|<img width="180" src="https://user-images.githubusercontent.com/70856586/189276763-b96e1498-6b6b-45f6-a9c6-d3d857ab7753.gif">|

### 🛍️ 상품 등록화면
> * `+ 버튼`으로 이미지를 추가하고, 이미지 우상단의 `- 버튼`으로 이미지를 삭제해요.  
> * 이미지 크기가 큰 경우 300KB로 축소하여 등록합니다.  
> * 이미지를 추가 시 맨 오른쪽으로 Scroll 해요.
> * 입력값이 적절한지 검증하고 필요 시 `Alert`를 나타내요.  
> * `TextView` 입력 텍스트가 키보드 뒤로 숨겨지지 않도록 처리했어요.  

|이미지 추가|이미지 수정/삭제|상품 등록 실패|상품 등록 성공|키보드 입력 처리|
|-|-|-|-|-|
|<img width="180" src="https://i.imgur.com/KsqBnFP.gif">|<img width="180" src="https://i.imgur.com/QoqzYq6.gif">|<img width="180" src="https://i.imgur.com/pcxnzgE.gif">|<img width="180" src="https://i.imgur.com/k1mBXL0.gif">|<img width="180" src="https://i.imgur.com/0Llsy78.gif">|

## STEP별 학습내용 
- [STEP1 : 모델/네트워킹 타입 구현](##STEP1-모델/네트워킹-타입-구현)
    + [키워드](#1-1-키워드)
    + [구현 내용](#1-2-구현-내용)
    + [Trouble Shooting](#1-3-trouble-shooting)
- [STEP2 : 상품 목록 화면 구현](##STEP2-상품-목록-화면-구현)
    + [키워드](#2-1-키워드)
    + [구현 내용](#2-2-구현-내용)
    + [Trouble Shooting](#2-3-trouble-shooting)
- [STEP3 : 상품 등록/수정 화면 구현](##STEP3-상품-등록/수정-화면-구현)
    + [키워드](#3-1-키워드)
    + [구현 내용](#3-2-구현-내용)
    + [Trouble Shooting](#3-3-trouble-shooting)
- [STEP4 : 상품 상세화면 구현](##STEP4-상품-상세화면-구현)
    + [키워드](#4-1-키워드)
    + [구현 내용](#4-2-구현-내용)
    + [Trouble Shooting](#4-3-trouble-shooting)

## STEP1 모델/네트워킹 타입 구현
### 1-1 키워드
* 네트워크 : URLSession, HTTP Request/Response, 서버 API
* 비동기 작업 : completionHandler, escaping closure, Result
* Unit Test : Mock Data/Mock URLSession, XCTestExpectation
* 라이브러리 : SwiftLint, CocoaPods
* JSON : Decoding, CodingKey, convertFromSnakeCase

### 1-2 구현 내용
* Parsing한 JSON 데이터를 Mapping할 Model 타입을 설계했습니다.  
* 서버와 통신하기 위해 URLSession을 활용했습니다. 
* Mock Data 및 Mock URLSession을 통해 이에 대한 Unit Test를 진행했습니다.  

### 1-3 Trouble Shooting
**1. JSONParserTests의 Bundle.main.path 관련 문제 해결**   
decode 메서드에 대한 테스트를 진행하기 위해 `Bundle.main.path`를 통해 MockProduct JSON 데이터에 접근하도록 했는데, path에 nil이 반환되며 Bundle에 접근하지 못하는 문제가 발생했습니다. LLDB 확인 결과 JSON 파일이 포함된 Bundle은 `OpenMarketTests.xctest`이며, 테스트 코드를 실행하는 주체는 OpenMarket `App Bundle`임을 파악했습니다. (LLDB 내용: `OpenMarket.app/PlugIns/OpenMarketTests.xctest`)
따라서 현재 executable의 Bundle 개체를 반환하는 `Bundle.main` (즉, App Bundle)이 아니라, 테스트 코드를 실행하는 주체를 가르키는 `Bundle(for: type(of: self))` (즉, XCTests Bundle)로 path를 수정하여 JSON 파일에 접근할 수 있었습니다.

```swift
// 개선 전 코드
func test_Product타입_decode했을때_Nil이_아닌지_테스트() {
    guard let path = Bundle.main.path(forResource: "MockProduct", ofType: "json"),  // path에 nil이 반환되는 문제 발생
          let jsonString = try? String(contentsOfFile: path) else {
        return
    }
}

// 개선 후 코드
func test_Product타입_decode했을때_Nil이_아닌지_테스트() {
    guard let path = Bundle(for: type(of: self)).path(forResource: "MockProduct", ofType: "json"),
          let jsonString = try? String(contentsOfFile: path) else {
              XCTFail()
              return
          }
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
* API 서버에 요청한 상품 목록 데이터를 받아서 화면을 구성했습니다.  
* 상품 보기 모드를 List (목록형) 또는 Grid (격자형)로 변경할 수 있고, 상품명, (할인)가격, 썸네일 이미지 등의 상품 정보를 확인 가능합니다.  
* Acticity Indicator를 통해 사용자는 데이터가 Loading 중임을 알 수 있습니다.

**1. List(목록형), Grid(격자형) 두가지 형태의 Cell을 대응하는 방법**   
여러 가지 방법을 찾아봤습니다.
1) Modern Collection View : iOS 14이상에서 사용할 수 있는 방법으로 프로젝트 최소 빌드 타켓이 iOS 13.2이기 때문에 사용하지 못했습니다.
2) 컬렉션 뷰 레이아웃을 두개 구성하고 스위치하는 방법 (기존 Flow Layout 사용)
3) 두 가지 형태의 커스텀 셀을 구성하고 cellForItemAt 메서드에서 셀을 스위치하는 방법
4) 리스트 형태는 테이블 뷰, 그리드 형태는 콜렉션 뷰로 구현

결과적으로 2+3번 방식을 선택하여 두 가지 형태의 Layout을 구현했습니다.

**2. Image Cache**   
상품의 Thumbnail을 매번 서버에서 요청받아 화면에 띄우는건 비효율적이고 비용도 크다는 생각을 했습니다.
따라서 NSCache를 이용한 메모리 캐시를 도입했습니다.
Thumbnail의 URL을 key로 하고 먼저 메모리에 해당 키를 가진 Thumbnail이 있는지 확인합니다.
메모리에 이미지가 존재한다면 이미지를 반환해주고, 존재하지 않는다면 서버에 요청해 이미지를 받아옵니다. 
이때 성공적으로 이미지를 받아왔다면 메모리에 이미지를 캐시에 저장해서 다음번에 이미지를 사용하는 경우 캐시에서 이미지를 받아올 수 있도록 했습니다.

### 2-3 Trouble Shooting
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
|<img width="180" src="https://i.imgur.com/AjHBJhJ.gif">|<img width="180" src="https://i.imgur.com/0CK2D01.gif">|

reloadData() 메서드는 completion을 별도로 지니고 있지 않기 때문에 기존에는 performBatchUpdates 메서드를 사용했습니다. 하지만
performBatchUpdates 메서드를 잘못 사용한 것이 원인이었습니다. 
performBatchUpdates 메서드는 Collection View의 여러 애니메이션들을 수행하고, 그에 따른 Completion을 동작시켜주는 메서드입니다.
기존 방법으로 performBatchUpdates의 매개변수인 updates 클로저 내부에서 reloadData() 메서드를 호출했고, completion 클로저에서 스크롤을 움직이라는 코드를 배치했습니다.
하지만 위와 같은 버그가 발생했습니다.

개선 방법   
performBatchUpdates 메서드 대신 `reloadData() 메서드의 완료를 알 수 있는 또 다른 방법`을 활용했습니다.
reloadData가 호출되면 아래 순서에 따라 코드가 실행됩니다.
1. numberOfItemsInSection 메서드에서 Cell의 개수를 결정
2. cellForItemAt 메서드에서 화면에 보여질 만큼의 Cell을 생성
3. collection View의 `layoutSubViews` 호출

즉, reloadData 메서드가 완료되면 `layoutSubViews` 메서드가 호출됩니다. 이에 따라 커스텀 Collection View 클래스를 만들고 아래의 메서드와 프로퍼티를 추가했습니다. (또한 UX 개선을 위해 Fade in/out 기능을 추가적으로 구현했습니다.)
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

## STEP3 상품 등록/수정 화면 구현
### 3-1 키워드
* Network : MultipartFormData, POST
* CollectionView : FooterView
* Gesture Recognizer, Tap Gesture

### 3-2 구현 내용
* 목록 화면의 우상단 버튼을 탭하면 상품 등록 화면을 나타냅니다.  
* 이미지를 추가하는 CollectionView가 있으며, `FooterView`에 `+버튼`을 올려서 사용자의 `Tap Gesture`를 감지하도록 했습니다.  
* 이미지 용량이 300KB를 초과하지 않도록 크기를 조정했습니다.
* 사용자 입력값을 검증하여 Alert를 나타냅니다.

**1. 이미지 추가 시 자동 Scroll 기능 구현**
이미지를 추가한 직후 사용자가 추가버튼을 바로 볼 수 있도록 CollectionView를 자동으로 Scroll하게 구현했습니다. 이 과정에서 데이터를 reload한 이후에 Scroll할 수 있도록 completionHandler 기능을 넣은 `reloadDataCompletion` 메서드를 구현했습니다.
```swift
private func scrollToRightMost() {
    var rightMostOffsetX = imageCollectionView.contentSize.width
    if rightMostOffsetX > imageCollectionView.frame.width {
        rightMostOffsetX -= imageCollectionView.frame.width
        let offset = CGPoint(x: rightMostOffsetX, y: 0)
        imageCollectionView.setContentOffset(offset, animated: true)
    }
}
```

**2. 키보드가 TextView를 가리지 않도록 수정**
Keyboard 관련 Notification을 통해 키보드가 나타날 때 ScrollView의 `Bottom Content Inset`을 `키보드 높이`만큼 지정하도록 했습니다. 또한 키보드가 내려할 때 다시 Inset을 없애도록 했습니다.

**3. 메모리 캐시 (보너스 스탭)**
저번 오픈마켓1에서 캐시를 구현해보라는 보너스 스탭이 있어 NSCache를 사용해서 메모리 캐시를 구현했습니다.
저희는 서버에서 받아오는 이미지의 URL을 캐시에 key로 사용하고, 이미지를 로드하는 흐름을 설계해봤습니다.

1) key(이미지의 URL)가 메모리에 있는지 확인한다.  
2) 메모리에 이미지가 있다면 메모리에서 꺼내서 로드한다.  
3) 메모리에 이미지가 없다면 이미지의 URL로 데이터를 다운받아 변환한 이미지를 생성한다.  
4) 생성한 메모리를 캐시에 저장한다.  

### 3-3 Trouble Shooting
**1. Tap Gesture 처리**
사용자가 화면에서 이미지 CollectionView 또는 textField/textView가 아닌 영역을 탭하면, 키보드가 내려가도록 구현하기 위해 ViewController에 Tap Gesture Recognizer를 추가했습니다.
하지만 이로 인해 사용자가 이미지를 수정하고자 이미지 Cell을 탭했을 때, `ViewController가 제스쳐를 가로채서 CollectionView가 제스쳐를 인식하지 못하는 문제` (didSeleteItemAt 메서드가 호출되지 않음)가 발생했습니다.

따라서 CollectionView의 Cell 내부에 `Button`을 얹어서 문제를 해결했습니다. (버튼은 항상 Tap Gesture의 first responder이기 때문입니다.) 또한 버튼을 눌렀을 때 어떤 indexPath의 Cell이 눌렸는지 판단하는 기능을 추가해서 문제를 해결했습니다.
```swift
// superview 중 매개변수로 받은 ofType 타입 (ex. Cell 타입)이 있다면 그 타입을 반환해주는 메서드
// Tap Gesture를 인식한 Button의 superview인 Cell이 반환됨
private extension UIView {
    func findSuperview<T>(ofType: T.Type) -> T? {
        var currentView = self
        var resultView: T?
        while let currentSuperview = currentView.superview {
            if currentSuperview is T {
                resultView = currentSuperview as? T
                break
            }
            currentView = currentSuperview
        }
        return resultView
    }
}

extension ProductRegisterViewController {
    @objc func editImageOfSelectedItem(_ sender: UIButton) {
        // cell을 눌렀을 때 버튼의 superview 중 cell 타입이 있다면 
        // cell의 indexPath를 받아와서 이미지를 수정/삭제함
        guard let productImageCell = sender.findSuperview(ofType: ProductImageCell.self),
              let indexPath = productImageCell.indexPath else {
            return
        }
        
        dataSource.touchedEditImageButton(at: indexPath.item)
    }
}
```

## STEP4 상품 상세화면 구현
### 4-1 키워드
* PageControl, ScrollView

### 4-2 구현 내용
목록 화면의 상품을 탭하면 상세화면을 나타냅니다. 상품 상세 화면의 데이터 소스 역할을 하는 ProductDetailDataSource 타입을 델리게이트 패턴을 적용하여 뷰컨트롤러 델리게이트로 사용하도록 했습니다. 
