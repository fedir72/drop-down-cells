//
//  FirstCell.swift
//  ExpandableCollectionViewCell
//
//  Created by Fedii Ihor on 26.04.2022.
//

import UIKit
import SnapKit

class FirstCell: UICollectionViewCell {
    
    static let id = "FirstCell"
    
    //переопределяем  isSelected чтобы на каждое изменение вывывать updateAppearence()
    override var isSelected: Bool {
        didSet {
            updateAppearense()
        }
    }
    
    //MARK: - container for an expanded state
    private var expandedConstraint: Constraint!
    //MARK: - container for an collapsed constraint
    private var collepsedConstraint: Constraint!
    
    //MARK: - subviews
    private lazy var mainContainer = UIView()
    private lazy var topContainer = UIView()
    private lazy var bottomContainer = UIView()
    private lazy var arrowImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "arrow.down")?.withRenderingMode(.alwaysTemplate))
        imageView.tintColor = .black
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    //нажатие на нижний контейнер не обрабатывается
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        topContainer.point(inside: point, with: event)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        //configureView()
    }
    
    private func updateAppearense() {
        collepsedConstraint.isActive = !isSelected
        expandedConstraint.isActive = isSelected
        UIView.animate(withDuration: 0.3) {
            let upsideDown = CGAffineTransform(rotationAngle: .pi * -0.999)
            self.arrowImageView.transform =  self.isSelected ? upsideDown : .identity
        }
    }
    
    private func configureView() {
        
        topContainer.backgroundColor = UIColor.systemYellow
        bottomContainer.backgroundColor = UIColor.systemGreen
        
        //cornerradius put on contentview
        contentView.layer.cornerRadius = 10
        contentView.clipsToBounds = true
        
        //shadow put on cell
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowRadius = 5
        layer.shadowOpacity = 0.5
        layer.shadowOffset = .init(width: -5, height: 5)
        
        makeConstraints()
        updateAppearense()
    }
    
    private func makeConstraints() {
        
        contentView.addSubview(mainContainer)
        mainContainer.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        mainContainer.addSubview(topContainer)
        mainContainer.addSubview(bottomContainer)
        topContainer.snp.makeConstraints { make in
            make.top.left.right.top.equalToSuperview()
            make.height.equalTo(50)
        }
        
        //MARK: - constraint for collapsed state of cell
        bottomContainer.snp.prepareConstraints{ make in
            collepsedConstraint = make.height.equalTo(0).constraint
            collepsedConstraint.layoutConstraints.first?.priority = .defaultLow
        }
        
        topContainer.addSubview(arrowImageView)
        
        arrowImageView.snp.makeConstraints { make in
            make.height.equalTo(16)
            make.width.equalTo(24)
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-20)
        }
        bottomContainer.snp.makeConstraints { make in
            make.top.equalTo(topContainer.snp.bottom)
            make.left.right.equalToSuperview()
            make.height.equalTo(0)
        }
        
        //MARK: - container for expanded state of cell
        bottomContainer.snp.makeConstraints { make in
            expandedConstraint = make.height.equalTo(150).constraint
            expandedConstraint.layoutConstraints.first?.priority = .defaultLow
        }
    }
}
