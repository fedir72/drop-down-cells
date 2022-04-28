//
//  ViewController.swift
//  ExpandableCollectionViewCell
//
//  Created by Fedii Ihor on 26.04.2022.
//

import UIKit
import SnapKit

class ViewController: UIViewController {

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.allowsMultipleSelection = true
        view.alwaysBounceVertical = true
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Главная"
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(SecondCell.self,
                                forCellWithReuseIdentifier: SecondCell.id)
        view.addSubview(collectionView)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
    }
}

extension ViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SecondCell.id, for: indexPath) as! SecondCell
        return cell
    }
    
    
}

extension ViewController: UICollectionViewDelegate {
    //MARK: - переопределяем метод для анимированного сворачивания ячейки
    func collectionView(_ collectionView: UICollectionView, shouldDeselectItemAt indexPath: IndexPath) -> Bool {
        collectionView.deselectItem(at: indexPath, animated: true)
        collectionView.performBatchUpdates(nil)
        return true
    }
    //MARK: - переопределяем метод для анимированного разворачивания ячейки
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        collectionView.selectItem(at: indexPath, animated: true, scrollPosition: [])
        collectionView.performBatchUpdates(nil)
        
        //скроллим ячейку чтобы ее было полностью видно и добавляем 20 поинтов
        DispatchQueue.main.async {
//            guard let attributes = collectionView.collectionViewLayout.layoutAttributesForItem(at: indexPath) else {
//                return
//            }
//            let desiredOffset = attributes.frame.origin.y - 20
//            let contentHeight = collectionView.collectionViewLayout.collectionViewContentSize.height
//            let maxPossibleOffset = contentHeight - collectionView.bounds.height
//            let finalOffset = max(min(desiredOffset, maxPossibleOffset), 0)
//
//            collectionView.setContentOffset(CGPoint(x: 0, y: finalOffset), animated: true)
            
            //MARK: -  we can do it easyer but not will be inset and 20 pixels above(for beauty)
            collectionView.scrollToItem(at: indexPath, at: .top, animated: true)
        }
        return true
    }
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //MARK: - проверка есть ли ячейка в массиве выбранных
        let isSelected = collectionView.indexPathsForSelectedItems?.contains(indexPath) ?? false
        return CGSize(width: collectionView.bounds.width - 10, height: isSelected ? 150 : 50 )
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 5, bottom: 10, right: 5)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        10
    }
}
