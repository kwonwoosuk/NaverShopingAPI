//
//  FavoriteListViewController.swift
//  NaverShopingAPI
//
//  Created by 권우석 on 3/4/25.


import UIKit
import SnapKit
import RealmSwift

final class FavoriteListViewController: BaseViewController {

    let searchBar = UISearchBar()
    let tableView = UITableView()
    let emptyView = UIView()
    let emptyLabel = UILabel()
    
    private let realm = try! Realm()
    private var favoriteItems: Results<FavoriteItem>!

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchFavoriteItems()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchFavoriteItems()
        tableView.reloadData()
    }

    override func configureHierarchy() {
        [searchBar, tableView, emptyView].forEach { view.addSubview($0) }
        emptyView.addSubview(emptyLabel)
    }
    
    override func configureLayout() {
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(44)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom)
            make.horizontalEdges.bottom.equalToSuperview()
        }
        
        emptyView.snp.makeConstraints { make in
            make.edges.equalTo(tableView)
        }
        
        emptyLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(20)
        }
    }
    
    override func configureView() {
        navigationItem.title = "좋아요 목록"
        navigationController?.navigationBar.topItem?.backButtonTitle = ""
        
        searchBar.placeholder = "검색어를 입력해주세오..."
        searchBar.barTintColor = .black
        searchBar.searchTextField.textColor = .white
        searchBar.searchBarStyle = .minimal
        searchBar.delegate = self
        
        tableView.backgroundColor = .black
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(FavoriteTableViewCell.self, forCellReuseIdentifier: FavoriteTableViewCell.identifier)
        tableView.rowHeight = 100
        tableView.separatorStyle = .singleLine
        tableView.separatorColor = .darkGray
        
    
        emptyView.backgroundColor = .black
        emptyView.isHidden = true
        
        emptyLabel.text = "좋아요한 상품이 없습니다"
        emptyLabel.textColor = .white
        emptyLabel.textAlignment = .center
        emptyLabel.font = .systemFont(ofSize: 16)
    }

    private func fetchFavoriteItems() {
        favoriteItems = realm.objects(FavoriteItem.self).sorted(byKeyPath: "savedDate", ascending: false)
        updateEmptyView()
        tableView.reloadData()
    }
    
    private func updateEmptyView() {
        emptyView.isHidden = favoriteItems.count > 0
    }
}


extension FavoriteListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoriteItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FavoriteTableViewCell.identifier, for: indexPath) as? FavoriteTableViewCell else {
            return UITableViewCell()
        }
        
        let item = favoriteItems[indexPath.row]
        cell.configure(with: item)
        
        cell.likeButtonTapHandler = {
            // 선택한 항목 가져오기
            let data = self.favoriteItems[indexPath.row]
            
            do {
                try self.realm.write {
                    // 렘에서 삭제
                    self.realm.delete(data)
                    self.tableView.reloadData()
                }
            } catch {
                print("렘에서 데이ㅓ삭제 실패")
            }
        }
        return cell
    }
}


extension FavoriteListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        print(searchText)
        if searchText.isEmpty {
            fetchFavoriteItems()
        } else {
            favoriteItems = realm.objects(FavoriteItem.self)
                .sorted(byKeyPath: "savedDate", ascending: false)
                .where {
                    $0.title.contains(searchText, options: .caseInsensitive)
                }
            
            updateEmptyView()
            tableView.reloadData()
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}
