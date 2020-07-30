//
//  PurchaseSubscriptionChoosePlanView.swift
//  VPNClient
//
//  Created by Igor Kasyanenko on 20.07.2020.
//  Copyright © 2020 VPNUK. All rights reserved.
//

import UIKit
class PurchaseSubscriptionChoosePlanView: UIView {
    private lazy var appearance = Appearance()
    private var tappedAction: (() -> Void)?
    // MARK: - Content
    private lazy var contentStackView: UIStackView = {
           let stackView = UIStackView(arrangedSubviews: [
               planLabel,
               detailLabel
           ])
           stackView.axis = .vertical
           stackView.spacing = appearance.contentStackViewSpacing
           return stackView
       }()
    
    private lazy var planMarkImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "unchecked.pdf"))
        return imageView
    }()
    
    private lazy var flagImageView: UIImageView = {
        let imageView = UIImageView(image: nil)
        
        return imageView
    }()
    private lazy var leftView: UIView = {
        let view = UIView()
        view.backgroundColor = Style.Color.grayTextColor
        return view
    }()
    private lazy var rightView: UIView = {
        let view = UIView()
        view.backgroundColor = Style.Color.grayTextColor
        return view
    }()
    private lazy var planLabel : UILabel = {
        let label = UILabel()
        label.font = appearance.planLabelFont
        return label
    }()
    
    private lazy var detailLabel : UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.font = appearance.detailLabelFont
        return label
    }()
    
    init() {
        super.init(frame: .zero)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(model: Model) {
        tappedAction = model.tappedAction
        planLabel.text = model.title
        detailLabel.text = model.subTitle
        flagImageView.image = model.imageFlag
        flagImageView.isHidden = model.imageFlag == nil
        switch model.isSelected {
        case true:
            planMarkImageView.image = UIImage(named: "checked.pdf")
            self.layer.borderColor = Style.Color.blueColor
        case false:
            planMarkImageView.image = UIImage(named: "unchecked.pdf")
            self.layer.borderColor = Style.Color.grayColor
        }
    }
    private func setupSubviews() {
        addSubview(planMarkImageView)
        addSubview(contentStackView)
        addSubview(flagImageView)
        addSubview(leftView)
        addSubview(rightView)
        leftView.isHidden = true
        rightView.isHidden = true
    }
    
    private func setupConstraints() {
        contentStackView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(appearance.contentStackViewConstraint)
            make.left.equalTo(planMarkImageView.snp.right).offset(appearance.contentStackViewConstraint)
        }
        flagImageView.snp.makeConstraints { (make) in
            make.right.equalToSuperview().inset(appearance.flagImageViewRightConstraint)
            make.centerY.equalToSuperview()
            make.left.greaterThanOrEqualTo(contentStackView.snp.right).offset(appearance.flagImageViewLeftInsetConstraint)
            make.top.bottom.equalToSuperview().inset(27)
        }
        planMarkImageView.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalTo(appearance.planMarkImageViewLeftConstraint)
        }
        leftView.snp.makeConstraints { (make) in
            make.width.equalTo(2)
            make.height.equalToSuperview()
            make.left.equalToSuperview()
        }
        rightView.snp.makeConstraints { (make) in
            make.width.equalTo(2)
            make.height.equalToSuperview()
            make.right.equalToSuperview()
        }
    }
    
    private func commonInit() {
        setupSubviews()
        setupConstraints()
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapped))
        self.addGestureRecognizer(tap)
    }
    
    @objc private func didTapped(_ gesture: UIGestureRecognizer){
        tappedAction?()
    }
}

extension PurchaseSubscriptionChoosePlanView {
    struct Model {
        let title: String
        let subTitle: String?
        let imageFlag: UIImage?
        let isSelected: Bool
        let tappedAction: () -> Void
    }
    struct Appearance {
        let contentStackViewSpacing = Style.Spacing.smallSpacing
        let contentStackViewConstraint = Style.Constraint.standartConstreint
        let planLabelFont = Style.Fonts.bigBoldFont
        let flagImageViewRightConstraint = Style.Constraint.standartConstreint
        let flagImageViewLeftInsetConstraint = Style.Constraint.bigConstreint
        let planMarkImageViewLeftConstraint = Style.Constraint.standartConstreint
        let detailLabelFont = Style.Fonts.standartFont
        let selfViewCornerRadius = Style.CornerRadius.standartCornerRadius
        let selfViewBorderColor = Style.Color.grayColor
        let selfViewBorderWidth: CGFloat = 2
        let isFirst = CACornerMask([.layerMaxXMinYCorner, .layerMinXMinYCorner])
        let isLast = CACornerMask([.layerMinXMaxYCorner, .layerMaxXMaxYCorner])
    }
    func showBorderViews(value: Bool) {
        leftView.isHidden = value
        rightView.isHidden = value
        contentStackView.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview().inset(14)
        }
    }
}
