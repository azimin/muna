//
//  AnimatedBarIcon.swift
//  Muna
//
//  Created by Egor Petrov on 08.09.2020.
//  Copyright © 2020 Abstract. All rights reserved.
//

import Cocoa
import Lottie
import SnapKit

final class AnimatedBarIconView: View {
    private let imageView = ImageView(name: "icon_menu", aspectRation: .resize)
    private var centerYViewConstraint: Constraint?

    private let animation = Animation.named("splash_anim")
    let animationView = AnimationView()

    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)

        self.animationView.animation = self.animation

        self.setupInitialLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupInitialLayout() {
        self.snp.makeConstraints { make in
            make.size.equalTo(21)
        }

        self.addSubview(self.animationView)
        self.animationView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        self.addSubview(self.imageView)
        self.imageView.snp.makeConstraints { make in
            self.centerYViewConstraint = make.centerY.equalToSuperview().constraint
            make.centerX.equalToSuperview()
            make.size.equalTo(20)
        }
    }

    func animateView() {
        NSAnimationContext.runAnimationGroup({ context in
            context.duration = 0.25
            context.allowsImplicitAnimation = true

            self.centerYViewConstraint?.update(offset: -100)
            self.layoutSubtreeIfNeeded()
        },
                                             completionHandler: { [weak self] in
            self?.centerYViewConstraint?.update(offset: 100)

            self?.animationView.play { _ in
                NSAnimationContext.runAnimationGroup { context in
                    context.duration = 0.25
                    context.allowsImplicitAnimation = true

                    self?.centerYViewConstraint?.update(offset: 0)

                    self?.layoutSubtreeIfNeeded()
                }
            }
        })
    }
}
