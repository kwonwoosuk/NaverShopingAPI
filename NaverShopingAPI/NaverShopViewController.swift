//
//  NaverShopViewController.swift
//  NaverShopingAPI
//
//  Created by 권우석 on 1/15/25.
//

import UIKit
import Alamofire
import Kingfisher
import SnapKit
/*
 상품 전체(총) 갯수 total 컬렉션뷰에 고정으로 구현
 
 셀에서 image, mallName, title(2줄까지), lprice  //  좋아요 기능 travelApp참고 ... 테이블뷰라..으ㅡ음
 option 정렬 영역, 다른파라미터로 정렬기능 구현-> 네트워크 통신 다시호출 button으로 만들어야하ㄴ?
 */


struct List: Decodable {
    //let lastBuildDate: String //  정렬옵션에서 날짜순할때 쓰면될거같고....ㄹ
    let total: Int
    let start: Int
    let display: Int
    let items: [Item]
}

struct Item: Decodable {
    let image: String //이미지 보여주고
    let mallName: String // 월드캠핑카
    let title: String // 스타리아 2층캠핑카 어쩌고저쩌고 두줄
    let lprice: String // 얼마얼마     - 가격높은순?sort 를 asc가격순으로 오름차순 정렬 dsc가격순으로 내림차순 정렬 -메서드 만들어서 네트워크 다시 불러오면 알아서 정렬해줄듯  ⭐️sim 정확도순으로 내림차순 이걸 기본으로 해두자
    var deleteTagTitle: String {
        get {
            title.replacingOccurrences(of: "<[^>]+>|&quot;",
                                        with: "",
                                        options: .regularExpression,
                                        range: nil)
        }
    }
}


var sort: String = "sim"
class NaverShopViewController: UIViewController {
    var searchText: String = "" // 검색어 들어옴 나이스
    
    var itemList: [Item] = []
    var totalCount: Int = 0
    
    var start: Int = 1
    
    let totalLabel = {
        let label = UILabel()
        label.textColor = .green
        label.font = .boldSystemFont(ofSize: 14)
        return label
    }()
    
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: createCollectionView())
    
    func createSortButton(title: String, tag: Int) -> UIButton {
        let button: FlatUIButton = FlatUIButton()
        button.setTitle(title, for: .normal)
        button.tag = tag
        button.addTarget(self, action: #selector(sortButtonTapped(_:)), for: .touchUpInside)
        return button
    }
    
    lazy var accuracyButton = createSortButton(title: "정확도순", tag: 1)
    lazy var dateButton = createSortButton(title: "날짜순", tag: 2)
    lazy var priceDscButton = createSortButton(title: "가격높은순", tag: 3)
    lazy var priceAscButton = createSortButton(title: "가격낮은순", tag: 4)
      
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        changeUINaviCon()
        configureUI()
        configureCollectionView()
        callRequest(query: searchText, sort: "sim")
        //print(searchText)
        accuracyButton.isSelected = true
        accuracyButton.backgroundColor = .white
    }
   
    func createCollectionView() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        let deviceWidth = UIScreen.main.bounds.width
        let cellWidth = deviceWidth / 2
        layout.itemSize = CGSize(width: cellWidth - 20, height: (cellWidth * 1.5)) //10씩들어갈거니까 빼주고 셀높이가 낮아서 레이블이 다 짤리더라고요? 왜 안보이나 했네 💢
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        return layout
    }
    
    func configureCollectionView() {
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.prefetchDataSource = self
        collectionView.backgroundColor = .clear
        collectionView.register(NaverShopCollectionViewCell.self, forCellWithReuseIdentifier: "NaverShopCollectionViewCell")
    }
    
    func configureUI() {
        view.backgroundColor = .black
        let buttonWidth = 60
        
        [totalLabel, accuracyButton, dateButton, priceDscButton, priceAscButton, collectionView].forEach { view.addSubview($0) }
        
        totalLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(16)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(16)
        }
    
        accuracyButton.snp.makeConstraints { make in
            make.top.equalTo(totalLabel.snp.bottom).offset(12)
            make.leading.equalTo(view).offset(16)
            make.width.equalTo(buttonWidth)
            make.height.equalTo(32)
        }
        
        dateButton.snp.makeConstraints { make in
            make.top.equalTo(accuracyButton)
            make.leading.equalTo(accuracyButton.snp.trailing).offset(8)
            make.width.equalTo(buttonWidth)
            make.height.equalTo(32)
        }
        
        priceDscButton.snp.makeConstraints { make in
            make.top.equalTo(accuracyButton)
            make.leading.equalTo(dateButton.snp.trailing).offset(8)
            make.width.equalTo(buttonWidth)
            make.height.equalTo(32)
        }
        
        priceAscButton.snp.makeConstraints { make in
            make.top.equalTo(accuracyButton)
            make.leading.equalTo(priceDscButton.snp.trailing).offset(8)
            make.width.equalTo(buttonWidth)
            make.height.equalTo(32)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(accuracyButton.snp.bottom).offset(12)
            make.bottom.equalToSuperview()
            make.horizontalEdges.equalToSuperview()
        }
    }
    
    @objc private func sortButtonTapped(_ sender: UIButton) {
        [accuracyButton, dateButton, priceDscButton, priceAscButton].forEach {
            $0.isSelected = false
            $0.backgroundColor = .clear
        }
        
        sender.isSelected = true //누른거 배경색 바꾹
        sender.backgroundColor = .white
        
        
        switch sender.tag {
        case 1:
            sort = "sim"
        case 2:
            sort = "date"
        case 3:
            sort = "dsc"
        case 4:
            sort = "asc"
        default:
            sort = "sim"
        }
        
        callRequest(query: searchText, sort: sort)

    }
        
    func changeUINaviCon() {
        navigationItem.title = searchText
        //navigationItem.titleView?.tintColor = .white 넌 뭐하는애야?
        navigationController?.navigationBar.tintColor = .white // title하얗게
        let backButton = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"), // 전 화면 제목 보고싶지 않다고:(
                                                           style: .plain,
                                                           target: self,
                                                            action: #selector(backButtonTapped))
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white] // title외 하얗게
        navigationItem.leftBarButtonItem = backButton
    }
    
    @objc
    func backButtonTapped(){
        navigationController?.popViewController(animated: true)
    }
    
    func callRequest(query: String, sort: String) {
        //
        let url = "https://openapi.naver.com/v1/search/shop.json?query=\(query)&display=30&start=\(start)&sort=\(sort)" // 재정렬을 서버에서 정렬된걸 가져오면 무한스크
        
        print(url)
        let header: HTTPHeaders = [
            /*/curl "https://openapi.naver.com/v1/search/shop.xml?query=%EC%A3%BC%EC%8B%9D&display=10&start=1&sort=sim" \
             -H "X-Naver-Client-Id: {애플리케이션 등록 시 발급받은 클라이언트 아이디 값}" \ 쉼표... 그래 쉼표,,, 너라도 쉬어야지
             -H "X-Naver-Client-Secret: {애플리케이션 등록 시 발급받은 클라이언트 시크릿 값}" -v*/
            "X-Naver-Client-Id": APINAVER.id,
            "X-Naver-Client-Secret": APINAVER.key
        ]
        AF.request(url,
                   method: .get,
                   headers: header)
        .responseDecodable(of: List.self) { response in
            switch response.result {
            case .success(let data):
                
                if self.start == 1 || self.start >= data.total{  // 검색결과보다 요청수가 더 많아지면 추가 더이상 안함
                    self.itemList = data.items
                } else {
                    self.itemList.append(contentsOf: data.items)
                }
                dump(data)
//                print(data.items.count)
                
                self.totalCount = data.total
                self.totalLabel.text = "\(data.total.formatted())개의 검색 결과"
                self.collectionView.reloadData()
            case .failure(let error):
                print("api일 안하냐", error)
            }
        }
    }
}

extension NaverShopViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //print(itemList.count)
        return itemList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NaverShopCollectionViewCell", for: indexPath) as! NaverShopCollectionViewCell
        
        cell.configure(item: itemList[indexPath.item])
        return cell
    }
    
    
}

extension NaverShopViewController: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        print(#function, indexPaths)
        for i in indexPaths {
            if itemList.count - 3 == i.item && start < 1001 {
                start += 30
                callRequest(query: searchText, sort: sort)
            }
        }
        // 한번에 불러올 셀의 갯수 30개 27개째 봤을때 미리 불러오고 싶고
    }

}

