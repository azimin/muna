// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License.

import AppCenter
import AppCenterCrashes
import Cocoa
import NotificationCenter

class TodayViewController: NSViewController, NCWidgetProviding, MSCrashesDelegate {
  
    @IBOutlet weak var addAttachments: NSButton!
    @IBOutlet weak var popupButton: NSPopUpButton!
    @IBOutlet weak var extensionLabel: NSTextField!
    var crashes = [MSCrash]()
    
    override var nibName: NSNib.Name? {
        return NSNib.Name("TodayViewController")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let dateString = DateFormatter.localizedString(from: Date.init(), dateStyle: DateFormatter.Style.medium, timeStyle: DateFormatter.Style.medium)
        extensionLabel.stringValue = "Run #\(dateString)"
        MSAppCenter.setLogLevel(.verbose)
        MSCrashes.setDelegate(self)
        MSAppCenter.start("0b559191-f276-4e9d-9b70-4dadd5886c4e", withServices: [MSCrashes.self])
        crashes = CrashLoader.loadAllCrashes(withCategories: false) as! [MSCrash]
        popupButton.menu?.removeAllItems()
        for (index, crash) in crashes.enumerated() {
            popupButton.menu?.addItem(NSMenuItem(title: crash.title, action: nil, keyEquivalent: "\(index)"))
        }
    }
    
    @IBAction func crashMe(_ sender: Any) {
        let selectedCrashIndex = popupButton.indexOfSelectedItem
        crashes[selectedCrashIndex].crash()
    }
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        completionHandler(.noData)
    }
    
    func attachments(with crashes: MSCrashes, for errorReport: MSErrorReport) -> [MSErrorAttachmentLog] {
        if (addAttachments.state == .on) {
            let attachment1 = MSErrorAttachmentLog.attachment(withText: "Hello world!", filename: "hello.txt")
            let attachment2 = MSErrorAttachmentLog.attachment(withBinary: "Fake image".data(using: String.Encoding.utf8), filename: nil, contentType: "image/jpeg")
            return [attachment1!, attachment2!]
        }
        return [];
    }
}
