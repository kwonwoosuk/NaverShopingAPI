//
//  NaverShopViewController.swift
//  NaverShopingAPI
//
//  Created by 권우석 on 1/15/25.
//

import UIKit
import SnapKit


class NaverShopViewController: UIViewController {
    
    let viewModel = NaverShopViewModel()
    
    let totalLabel = {
        let label = UILabel()
        label.textColor = .green
        label.font = .boldSystemFont(ofSize: 14)
        return label
    }()
    
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: createCollectionView())
    lazy var accuracyButton = createSortButton(title: "정확도순", tag: 1)
    lazy var dateButton = createSortButton(title: "날짜순", tag: 2)
    lazy var priceDscButton = createSortButton(title: "가격높은순", tag: 3)
    lazy var priceAscButton = createSortButton(title: "가격낮은순", tag: 4)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindData()
        updateSortButtonsState(for: .accuracy) 
        changeUINaviCon()
        configureUI()
        configureCollectionView()
        viewModel.inputViewDidLoadTrigger.value = ()
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
    
    // viewModel보낼것
    @objc private func sortButtonTapped(_ sender: UIButton) {
        switch sender.tag {
        case 1:
            viewModel.inputAccuracyButtonTapped.value = ()
        case 2:
            viewModel.inputDateButtonTapped.value = ()
        case 3:
            viewModel.inputHighPriceButtonTapped.value = ()
        case 4:
            viewModel.inputLowPriceButtonTapped.value = ()
        default:
            break
        }
    }
    
    @objc// 내가 이걸 왜 만들어서 썼을까
    func backButtonTapped(){
        viewModel.inputBackButtonTapped.value = ()
    }
    
    private func bindData() {
        viewModel.outputItems.bind { [weak self] _ in
            self?.collectionView.reloadData()
        }
        
        viewModel.outputTotalCount.bind { [weak self] resultCount in
            self?.totalLabel.text = resultCount
        }
        
        viewModel.outputSortType.bind { [weak self] sortType in
            self?.updateSortButtonsState(for: sortType)
        }
        
        viewModel.outputBackButtonTapped.lazybind { [weak self] _ in
            self?.navigationController?.popViewController(animated: true)
        }
    }
    
    private func updateSortButtonsState(for sortType: NaverShopViewModel.SortType) {
        [accuracyButton, dateButton, priceDscButton, priceAscButton].forEach {
            $0.isSelected = false
            $0.backgroundColor = .clear
        }
        
        let selectedButton: UIButton
        switch sortType {
        case .accuracy:
            selectedButton = accuracyButton
        case .date:
            selectedButton = dateButton
        case .priceHigh:
            selectedButton = priceDscButton
        case .priceLow:
            selectedButton = priceAscButton
        }
        
        selectedButton.isSelected = true
        selectedButton.backgroundColor = .white
    }
    
}

extension NaverShopViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.outputItems.value.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "NaverShopCollectionViewCell",
            for: indexPath
        ) as? NaverShopCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        let item = viewModel.outputItems.value[indexPath.item]
        cell.configure(item: item)
        return cell
    }
    
    
}


extension NaverShopViewController {
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
    
    func configureCollectionView() {
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .clear
        collectionView.register(NaverShopCollectionViewCell.self, forCellWithReuseIdentifier: "NaverShopCollectionViewCell")
    }
    
    func createSortButton(title: String, tag: Int) -> UIButton {
        let button: FlatUIButton = FlatUIButton()
        button.setTitle(title, for: .normal)
        button.tag = tag
        button.addTarget(self, action: #selector(sortButtonTapped(_:)), for: .touchUpInside)
        return button
    }
    
    func changeUINaviCon() {
        navigationController?.navigationBar.tintColor = .white
        let backButton = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"),
                                         style: .plain,
                                         target: self,
                                         action: #selector(backButtonTapped))
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationItem.leftBarButtonItem = backButton
    }
    
    
}
