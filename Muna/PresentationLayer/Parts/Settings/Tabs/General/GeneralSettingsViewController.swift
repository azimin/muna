//
//  GeneralSettingsViewController.swift
//  Muna
//
//  Created by Alexander on 5/16/20.
//  Copyright © 2020 Abstract. All rights reserved.
//

import Cocoa

class GeneralSettingsViewController: NSViewController, ViewHolder {
    typealias ViewType = GeneralSettingsView

    private let settingsItemViewModel: SettingsItemViewModel

    override init(nibName nibNameOrNil: NSNib.Name?, bundle nibBundleOrNil: Bundle?) {
        self.settingsItemViewModel = SettingsItemViewModel()

        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        self.view = GeneralSettingsView()
        self.settingsItemViewModel.delegate = self.rootView.settingsItemView
        self.rootView.settingsItemView.delegate = self.settingsItemViewModel
    }

    override func viewDidLoad() {
        self.title = "General"

        self.settingsItemViewModel.setup()
    }
}
