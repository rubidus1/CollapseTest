//
//  CollapsingCell.swift
//  DynamicCollapsingCollection
//
//  Created by Сергей Каменский on 01.09.2021.
//

import UIKit

protocol CollapsingCellDelegate: AnyObject {
    func didTriggerCollapseEvent(cell: CollapsingCell)
}

public class CollapsingCell: UICollectionViewCell {
    var isCollapsed: Bool? {
        didSet {
            contentLabel.isHidden = isCollapsed ?? false
        }
    }

    static var identifier: String {
        String(describing: self)
    }

    weak var delegate: CollapsingCellDelegate?
    private let titleLabel = UILabel()
    private let collapseButton = UIButton(type: .system)
    private let stackView = UIStackView()
    private let contentLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        contentView.clipsToBounds = true
        contentView.layer.cornerRadius = 9
        contentView.backgroundColor = .white

        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        contentView.addSubview(stackView)

        let headerView = UIView()
        headerView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textColor = .black
        titleLabel.font = .systemFont(ofSize: 22, weight: .bold)
        headerView.addSubview(titleLabel)
        collapseButton.addTarget(self, action: #selector(collapseButtonTapped), for: .touchUpInside)
        collapseButton.setTitle("Collapse/Expend", for: .normal)
        collapseButton.translatesAutoresizingMaskIntoConstraints = false
        headerView.addSubview(collapseButton)
        stackView.addArrangedSubview(headerView)

        contentLabel.numberOfLines = 0
        contentLabel.lineBreakMode = .byWordWrapping
        contentLabel.textColor = .black
        contentLabel.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(contentLabel)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 16),
            titleLabel.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -16),
            collapseButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            collapseButton.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 16),

            stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }

    @objc func collapseButtonTapped() {
        delegate?.didTriggerCollapseEvent(cell: self)
    }

    func configure(title: String, contentTitle: String) {
        titleLabel.text = title
        contentLabel.text = contentTitle
    }

    public override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        let targetSize = CGSize(width: layoutAttributes.frame.width, height: 0)
        let size = contentView.systemLayoutSizeFitting(targetSize, withHorizontalFittingPriority: .required, verticalFittingPriority: .fittingSizeLevel)
        layoutAttributes.frame.size = size
        return layoutAttributes
    }
}
