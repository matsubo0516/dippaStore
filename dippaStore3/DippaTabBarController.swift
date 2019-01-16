//
//  DippaTabBarController.swift
//  dippaStore3
//
//  Created by 松本直樹 on 2019/01/12.
//  Copyright © 2019年 松本直樹. All rights reserved.
//

import UIKit

/// 下記を参考にした
/// https://stackoverflow.com/questions/36014073/make-custom-button-on-tab-bar-rounded
class DippaTabBarController: UITabBarController {

    var centerButton: UIButton?

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        if self.centerButton == nil {
            if let window = view.window {
                setupCenterButton(bottomOffset: window.safeAreaInsets.bottom)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /// bottomOffset: iPhoneXでのボタンのレイアウト調整
    func setupCenterButton(bottomOffset: CGFloat) {
        let size: CGFloat = 77
        let x = (view.bounds.width - size) / 2
        let y = (view.bounds.height - size) - bottomOffset - 0.5
        self.centerButton = UIButton(frame: CGRect(x: x, y: y, width: size, height: size))
        if let button = self.centerButton {
            button.layer.cornerRadius = size / 2
            button.setImage(UIImage(named: "plus"), for: .normal)
            button.addTarget(self, action: #selector(didTapCenterButton), for: .touchUpInside)

            view.addSubview(button)
            view.layoutIfNeeded()
        }
    }

    public func show() {
        self.tabBar.isHidden = false
        self.centerButton?.isHidden = false
    }

    public func hide() {
        self.tabBar.isHidden = true
        self.centerButton?.isHidden = true
    }

    // MARK: - Actions

    @objc func didTapCenterButton(sender: UIButton) {
        let navigationController = self.viewControllers![0] as! UINavigationController
        let menusViewContoller = navigationController.viewControllers[0] as! MenusViewController
        menusViewContoller.presentAddMenuViewController()
    }

}
