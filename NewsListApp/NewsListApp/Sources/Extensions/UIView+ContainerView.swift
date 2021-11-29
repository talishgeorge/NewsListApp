//
//  UIView+ContainerView.swift
//  NewsListApp
//
//  Created by Talish George on 29/11/21.
//

import Foundation
import UIKit

enum ConstraintType {
    case none
    case layoutMarginsGuide
}

class ContainerView<T: UIView>: UIView {
    
    public var contentView: T
    
    // MARK: - Init Methods
    
    override init(frame: CGRect) {
        contentView = T()
        super.init(frame: frame)
        setupView(contentView, constraintType: .layoutMarginsGuide, contentEdgeInsets: .zero)
    }
    
    init(contentView: T, constraintType: ConstraintType = .layoutMarginsGuide, layoutMargins: UIEdgeInsets? = nil, contentEdgeInsets: UIEdgeInsets = .zero) {
        self.contentView = contentView
        super.init(frame: .zero)
        setupView(contentView, constraintType: constraintType, layoutMargins: layoutMargins, contentEdgeInsets: contentEdgeInsets)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView(_ view: UIView, constraintType: ConstraintType, layoutMargins: UIEdgeInsets? = nil, contentEdgeInsets: UIEdgeInsets) {
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        
        switch constraintType {
        case .none:
            view.pinToSuperview(guide: .none, contentEdgeInsets: contentEdgeInsets)
        case .layoutMarginsGuide:
            view.pinToSuperview(guide: .layoutMarginsGuide, layoutMargins: layoutMargins, contentEdgeInsets: contentEdgeInsets)
        }
    }
}

extension UIView {
    
    enum LayoutGuide {
        case none
        case layoutMarginsGuide
        case safeAreaGuide
        case frameLayoutGuide
        case contentLayoutGuide
    }
    
    
    
    func pinToSuperview(guide: LayoutGuide,
                        edges: UIRectEdge = .all,
                        layoutMargins: UIEdgeInsets? = nil,
                        contentEdgeInsets: UIEdgeInsets = .zero,
                        priority: UILayoutPriority = .required) {
        guard let superview = superview else { return }
        let layoutGuide: UILayoutGuide? = superview.layoutGuide(for: guide)
        var constraints: [NSLayoutConstraint] = []
        
        if let layoutMargins = layoutMargins {
            superview.layoutMargins = layoutMargins
        }
        
        if edges.contains(.top) {
            constraints.append(topAnchor.constraint(equalTo: layoutGuide?.topAnchor ?? superview.topAnchor,
                                                    constant: contentEdgeInsets.top).with(priority: priority))
        }
        if edges.contains(.bottom) {
            constraints.append(bottomAnchor.constraint(equalTo: layoutGuide?.bottomAnchor ?? superview.bottomAnchor,
                                                       constant: -contentEdgeInsets.bottom).with(priority: priority))
        }
        if edges.contains(.left) {
            constraints.append(leadingAnchor.constraint(equalTo: layoutGuide?.leadingAnchor ?? superview.leadingAnchor,
                                                        constant: contentEdgeInsets.left).with(priority: priority))
        }
        if edges.contains(.right) {
            constraints.append(trailingAnchor.constraint(equalTo: layoutGuide?.trailingAnchor ?? superview.trailingAnchor,
                                                         constant: -contentEdgeInsets.right).with(priority: priority))
        }
        
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(constraints)
    }
    
    private func layoutGuide(for guide: LayoutGuide) -> UILayoutGuide? {
        switch guide {
        case .none: return nil
        case .layoutMarginsGuide: return layoutMarginsGuide
        case .safeAreaGuide: return safeAreaLayoutGuide
        case .frameLayoutGuide:
            guard let scrollView = self as? UIScrollView else {
                assertionFailure("frameLayoutGuide does only exist on UIScrollView")
                return nil
            }
            return scrollView.frameLayoutGuide
        case .contentLayoutGuide:
            guard let scrollView = self as? UIScrollView else {
                assertionFailure("contentLayoutGuide does only exist on UIScrollView")
                return nil
            }
            return scrollView.contentLayoutGuide
        }
    }
    
    func constraintBased() -> Self {
        translatesAutoresizingMaskIntoConstraints = false
        return self
    }
}

extension NSLayoutConstraint {
    
    func with(priority: UILayoutPriority) -> NSLayoutConstraint {
        self.priority = priority
        return self
    }
}
