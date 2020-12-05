//
//  PurchaseSubscriptionChoosePlanView.swift
//  VPNClient
//
//  Created by Igor Kasyanenko on 20.07.2020.
//  Copyright © 2020 VPNUK. All rights reserved.
//

import UIKit
class PurchaseSubscriptionChoosePlanView: UIView {
    private var appearance: Appearance
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
    
    // MARK: - ImageViews
    private lazy var planMarkImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "unchecked.pdf"))
        imageView.setContentCompressionResistancePriority(.required, for: .horizontal)
        return imageView
    }()
    
    private lazy var flagImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    // MARK: - BorderViews
    private lazy var leftView: UIView = {
        let view = UIView()
        view.backgroundColor = appearance.borderViewsBackGroundColor
        return view
    }()
    
    private lazy var rightView: UIView = {
        let view = UIView()
        view.backgroundColor = appearance.borderViewsBackGroundColor
        return view
    }()
    
    // MARK: - Labels
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
    
    init(appearance: Appearance) {
    self.appearance = appearance
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
        if model.isSelected {
            planMarkImageView.image = UIImage(named: "checked.pdf")
            self.layer.borderColor = appearance.selectedBorderColor.cgColor
            self.layer.borderWidth = appearance.borderWidth
        } else {
            planMarkImageView.image = UIImage(named: "unchecked.pdf")
            self.layer.borderColor = appearance.borderColor.cgColor
        }
    }
    
    private func setupSubviews() {
        addSubview(planMarkImageView)
        addSubview(contentStackView)
        addSubview(flagImageView)
        addSubview(leftView)
        addSubview(rightView)
        leftView.isHidden = appearance.viewsHiddenValue
        rightView.isHidden = appearance.viewsHiddenValue
        layer.borderColor = appearance.borderColor.cgColor
        layer.cornerRadius = appearance.cornerRadius
        layer.borderWidth = appearance.borderWidth
        layer.maskedCorners = appearance.cornersMask
    }
    
    private func setupConstraints() {
        contentStackView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(appearance.contentStackViewInsetSize)
            make.left.equalTo(planMarkImageView.snp.right).offset(appearance.contentStackViewSize)
        }
        flagImageView.snp.makeConstraints { (make) in
            make.right.equalToSuperview().inset(appearance.flagImageViewRightSize)
            make.centerY.equalToSuperview()
            make.left.greaterThanOrEqualTo(contentStackView.snp.right).offset(appearance.flagImageViewLeftInsetSize)
            make.top.bottom.equalToSuperview().inset(appearance.flagImageViewTopInsetSize)
        }
        planMarkImageView.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalTo(appearance.planMarkImageViewLeftSize)
        }
        leftView.snp.makeConstraints { (make) in
            make.width.equalTo(appearance.leftRightBottomEmptyViewWidth)
            make.height.equalToSuperview()
            make.left.equalToSuperview()
        }
        rightView.snp.makeConstraints { (make) in
            make.width.equalTo(appearance.leftRightBottomEmptyViewWidth)
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
        let contentStackViewSize = Style.Constraint.standartConstreint
        let contentStackViewInsetSize: CGFloat
        let contentStackViewMiddlePlanInsetSize = 14
        let planLabelFont = Style.Fonts.bigBoldFont
        let flagImageViewRightSize = Style.Constraint.standartConstreint
        let flagImageViewLeftInsetSize = Style.Constraint.bigConstraint
        let planMarkImageViewLeftSize = Style.Constraint.standartConstreint
        let detailLabelFont = Style.Fonts.standartFont
        let cornerRadius: CGFloat
        let borderColor = Style.Color.grayColor
        let selectedBorderColor = Style.Color.blueColor
        let borderWidth: CGFloat
        let cornersMask: CACornerMask
        let viewsHiddenValue: Bool
        let flagImageViewTopInsetSize = 27
        let leftRightBottomEmptyViewWidth = 2
        let borderViewsBackGroundColor = Style.Color.grayUIColor
    }
}

extension PurchaseSubscriptionChoosePlanView.Appearance {
    static let firstItemAppearance: PurchaseSubscriptionChoosePlanView.Appearance = .init(
        contentStackViewInsetSize: Style.Constraint.standartConstreint,
        cornerRadius: 5,
        borderWidth: 2,
        cornersMask: [.layerMaxXMinYCorner, .layerMinXMinYCorner],
        viewsHiddenValue: true
    )
    
    static let lastItemAppearance: PurchaseSubscriptionChoosePlanView.Appearance = .init(
        contentStackViewInsetSize: Style.Constraint.standartConstreint,
        cornerRadius: 5,
        borderWidth: 2,
        cornersMask: [.layerMinXMaxYCorner, .layerMaxXMaxYCorner],
        viewsHiddenValue: true
    )
    
    static let middleItemAppearance: PurchaseSubscriptionChoosePlanView.Appearance = .init(
        contentStackViewInsetSize: 14,
        cornerRadius: 0,
        borderWidth: 0,
        cornersMask: [],
        viewsHiddenValue: false
    )
    
    static let oneItemAppearance: PurchaseSubscriptionChoosePlanView.Appearance = .init(
        contentStackViewInsetSize: Style.Constraint.standartConstreint,
        cornerRadius: 5,
        borderWidth: 2,
        cornersMask: [.layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMinXMinYCorner],
        viewsHiddenValue: true
    )
}

