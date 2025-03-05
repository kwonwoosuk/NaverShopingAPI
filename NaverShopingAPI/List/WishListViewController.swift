//
//  WishListViewController.swift
//  NaverShopingAPI
//
//  Created by 권우석 on 2/26/25.
//
// List Configuration 과 DiffableDataSource 이해하기⭐️
import UIKit
import SnapKit
import RealmSwift
//collectionView -> createLayout -> var dataSource<섹션, 타입> ->configureDataSource
// reload() ==> apply <-> updateSnapShot()
// 클릭 이벤트 필요시 기존 Delegate사용

//struct WishList: Hashable, Identifiable {
//    let id = UUID() //  UUID는 앱을 설치해서 사용하는 동안 사용자를 어느정도 특정할 수 있고 고유성을 보장하기 위해 주는값? 앱 지우면 사라짐 , 앱별로 다른 UUID부여됨
//    let name: String
//    let date = Date()
//}


final class WishListViewController: BaseViewController {
    // 서치바 글자 입력후 리턴키 누르면 위시리스트 추가
    //위시 리스트 모델 ( 상품명, 날짜 ) 구조체
    // 셀 선택시 위시 리스트 제거
    // uiCollectionCiewListCell을 통해 시스템 셀로 구성
    enum Section: CaseIterable {
        case WishList // 휴먼에러 방지를 위해 명시적으로 열거형으로 구현 / 반드시 열거형을 사용할 필요는 없음 (값만 잘 맞추면)
    }
    
    private let SearchBar = UISearchBar()
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
    private var dataSource: UICollectionViewDiffableDataSource<Section, WishList>!
    private let repository: WishListRepository = WishListTableRepository()
    private let folderRepository: WishFolderRepository = WishFolderTableRepository()
    var wishList: [WishList] = []
    //    var wishList: RealmSwift.List<WishList>!
    var id: ObjectId!
    var naviName = "" //  네비게이션타이틀 / 폴더명
    
    
    //    private var wishList: [WishList] = [
    //        WishList(name: "맥북프로"),
    //        WishList(name: "맥북에어"),
    //        WishList(name: "맥프로"),
    //        WishList(name: "맥스튜디오"),
    //        WishList(name: "맥미니")
    //    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureDataSource()
        repository.getFileURL()
        updateSnapShot()
        
    }
    // List Configuration 헷갈리잖슈 당신들
    private func createLayout() -> UICollectionViewLayout {
        var configuration = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        configuration.showsSeparators = false
        configuration.backgroundColor = .black
        
        let layout = UICollectionViewCompositionalLayout.list(using: configuration)
        return layout
    }
    
    // ListCell / ViewConfiguration
    private func configureDataSource() {
        let registration = UICollectionView.CellRegistration<UICollectionViewListCell, WishList> { cell, indexPath, itemIdentifier in
            
            var content = UIListContentConfiguration.subtitleCell()
            
            content.text = itemIdentifier.name
            content.textProperties.color = .white
            content.textProperties.font = .boldSystemFont(ofSize: 16)
            
            content.secondaryText = itemIdentifier.date.toString()
            content.secondaryTextProperties.color = .yellow
            content.secondaryTextProperties.font = .systemFont(ofSize: 14)
            
            content.image = UIImage(systemName: "cart.fill")
            content.imageProperties.tintColor = .white
            
            cell.contentConfiguration = content
            
            var backgroundConfig = UIBackgroundConfiguration.listCell()
            backgroundConfig.backgroundColor = .black
            backgroundConfig.strokeColor = .black
            backgroundConfig.strokeWidth = 2
            
            cell.backgroundConfiguration = backgroundConfig
        }
        // 각셀에 으떤게 보여질건디
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            let cell = collectionView.dequeueConfiguredReusableCell(using: registration, for: indexPath, item: itemIdentifier)
            return cell
        })
    }
    
    //DiffableDataSource
    private func updateSnapShot() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, WishList>()
        snapshot.appendSections(Section.allCases)
        //        snapshot.appendItems(wishList, toSection: .WishList) ///////////////////
        var uniqueItems = [ObjectId: WishList]()
        for item in wishList {
            uniqueItems[item.id] = item
        }
        
        snapshot.appendItems(Array(uniqueItems.values), toSection: .WishList)
        dataSource.apply(snapshot) // 다시 보여주
        
        
        
    }
    
    override func configureHierarchy() {
        [SearchBar, collectionView].forEach{ view.addSubview($0) }
    }
    
    
    override func configureLayout() {
        SearchBar.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(44)
        }
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(SearchBar.snp.bottom)
            $0.bottom.horizontalEdges.equalToSuperview()
        }
    }
    
    
    override func configureView() {
        view.backgroundColor = .black
        navigationItem.title = naviName
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.topItem?.backButtonTitle = ""
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        
        collectionView.delegate = self
        collectionView.backgroundColor = .black
        
        SearchBar.delegate = self
        SearchBar.tintColor = .white
        SearchBar.searchTextField.textColor = .white
        SearchBar.placeholder = "Adding WishList..."
        SearchBar.barTintColor = .black
        
    }
}


extension WishListViewController: UISearchBarDelegate, UICollectionViewDelegate {
    // 컬렉션뷰 셀 클릭시 삭제
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //        wishList.remove(at: indexPath.item)
        let data = wishList[indexPath.item]
        let folder = folderRepository.fetchAll()
            .where {
                $0.id == id
            }.first! // 타입을 바꿔주기 위함 하나만 넣을거기도 하고
        
        //        repository.createItemInFolder(folder: folder)
        repository.deleteItem(data: data)
        
        
        let updatedWishList = folder.wishList.sorted(byKeyPath: "date", ascending: false)
        wishList = Array(updatedWishList)
        
        updateSnapShot() // => reloadData()
    }
    // 리턴키 입력시 추가쓰
    // 서치바 입력후 해당 폴더에 위시리스트 추가
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print(#function)
        //        let addList = WishList(name: searchBar.text ?? "")
        //        wishList.append(addList)
        
        let folder = folderRepository.fetchAll()
            .where {
                $0.id == id
            }.first!
        
        repository.createItem(name: searchBar.text ?? "", folder: folder)
        
        let updatedWishList = folder.wishList.sorted(byKeyPath: "date", ascending: false)
        wishList = Array(updatedWishList)
        
        searchBar.text = ""
        updateSnapShot()
        
        
    }
}
