//
//  ShoppingView.swift
//  NaverShopingAPI
//
//  Created by 권우석 on 2/26/25.
//
import UIKit
import SnapKit


final class ShoppingView: BaseView {
    
    let totalLabel = UILabel()
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: createCollectionViewLayout())
    
    let accuracyButton = FlatUIButton()
    let dateButton = FlatUIButton()
    let priceDscButton = FlatUIButton()
    let priceAscButton = FlatUIButton()
    
    override func configureHierarchy() {
        [totalLabel, accuracyButton, dateButton, priceDscButton, priceAscButton, collectionView].forEach { addSubview($0) }
    }
    
    override func configureLayout() {
        let buttonWidth = 60
        
        totalLabel.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(16)
            make.leading.equalTo(safeAreaLayoutGuide).offset(16)
        }
        
        accuracyButton.snp.makeConstraints { make in
            make.top.equalTo(totalLabel.snp.bottom).offset(12)
            make.leading.equalToSuperview().offset(16)
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
    
    override func configureView() {
        backgroundColor = .black
        
        totalLabel.textColor = .green
        totalLabel.font = .boldSystemFont(ofSize: 14)
        
        configureSortButtons()
        
        collectionView.backgroundColor = .clear
        collectionView.register(ShoppingViewCell.self, forCellWithReuseIdentifier: ShoppingViewCell.identifier)
    }
    
    private func configureSortButtons() {
        [accuracyButton, dateButton, priceDscButton, priceAscButton].forEach { button in
            button.setTitleColor(.white, for: .normal)
            button.setTitleColor(.black, for: .selected)
            button.titleLabel?.font = .systemFont(ofSize: 12)
            button.layer.cornerRadius = 8
            button.layer.borderWidth = 1
            button.layer.borderColor = UIColor.white.cgColor
        }
        
        accuracyButton.setTitle("정확도순", for: .normal)
        dateButton.setTitle("날짜순", for: .normal)
        priceDscButton.setTitle("가격높은순", for: .normal)
        priceAscButton.setTitle("가격낮은순", for: .normal)
        
        
        accuracyButton.tag = 1
        dateButton.tag = 2
        priceDscButton.tag = 3
        priceAscButton.tag = 4
    }
    
    private func createCollectionViewLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        let deviceWidth = UIScreen.main.bounds.width
        let cellWidth = deviceWidth / 2
        layout.itemSize = CGSize(width: cellWidth - 20, height: (cellWidth * 1.5))
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        return layout
    }
    
    
    func updateSortButtonsState(for sortType: SortType) {
        [accuracyButton, dateButton, priceDscButton, priceAscButton].forEach {
            $0.isSelected = false
            $0.backgroundColor = .clear
        }
        
        let selectedButton: UIButton
        switch sortType {
        case .sim:
            selectedButton = accuracyButton
        case .date:
            selectedButton = dateButton
        case .dsc:
            selectedButton = priceDscButton
        case .asc:
            selectedButton = priceAscButton
        }
        
        selectedButton.isSelected = true
        selectedButton.backgroundColor = .white
    }
}
