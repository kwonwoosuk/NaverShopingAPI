//
//  WishFolderViewController.swift
//  NaverShopingAPI
//
//  Created by 권우석 on 3/6/25.
//

import UIKit
import SnapKit
import RealmSwift

final class WishFolderViewController: BaseViewController {
    
    private let tableView = UITableView()
    private var list: Results<WishFolder>!
    private let repository: WishFolderRepository = WishFolderTableRepository()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        list = repository.fetchAll()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    override func configureHierarchy() {
        view.addSubview(tableView)
    }
    
    
    override func configureLayout() {
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    
    override func configureView() {
        view.backgroundColor = .black
        navigationItem.title = "WishList"
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.topItem?.backButtonTitle = ""
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .black
        tableView.register(ListTableViewCell.self, forCellReuseIdentifier: ListTableViewCell.id)
        
        let plus = UIImage(systemName: "plus")
        let plusButton = UIBarButtonItem(image: plus, style: .done, target: self, action: #selector(plusButtonTapped))
        navigationItem.rightBarButtonItem = plusButton
    }
    
    @objc
    func plusButtonTapped() {
        repository.createItem(name: "개인")
        repository.createItem(name: "샐활")
        repository.createItem(name: "공부")
        repository.createItem(name: "학용품")
        
        tableView.reloadData()
    }
}

extension WishFolderViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let data = list[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: ListTableViewCell.id, for: indexPath) as! ListTableViewCell
        
        cell.titleLabel.text = data.name
        cell.subTitleLabel.text = "\(data.wishList.count)개"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = list[indexPath.row]
        let vc = WishListViewController()
        vc.wishList = Array(data.wishList.sorted(byKeyPath: "date", ascending: false))
        vc.naviName = data.name
        vc.id = data.id
        
        navigationController?.pushViewController(vc, animated: true)
    }
    /*
     let data = list[indexPath.row]
     let vc = FolderDetailViewController()//        vc.list = data.detail //  타입이 맞지 않는다... 근데 타입 바꾸기 위해 메인을 건드리는건 아쉬우니 folder에 대한 detailviewcon을 하나더 만드는것으로
     vc.list = data.detail
     //PrimaryKey만 보낼까~?
     vc.id = data.id
     navigationController?.pushViewController(vc, animated: true)
     */
    
}


