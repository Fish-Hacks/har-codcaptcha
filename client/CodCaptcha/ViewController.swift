//
//  ViewController.swift
//  CodCaptcha
//
//  Created by Jia Chen Yee on 20/1/24.
//

import Cocoa
import SwiftUI

class ViewController: NSViewController {

    var popover: NSView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }

    override func viewDidAppear() {
        super.viewDidAppear()
        
        let window = view.window!
        
        window.level = NSWindow.Level(rawValue: Int(CGShieldingWindowLevel()) + 1)
        window.styleMask.insert(.fullSizeContentView)
        
        window.styleMask.remove(.closable)
        window.styleMask.remove(.fullScreen)
        window.styleMask.remove(.miniaturizable)
        window.styleMask.remove(.resizable)
        
        window.hasShadow = false
        window.styleMask = [.borderless]
        window.collectionBehavior = [.canJoinAllSpaces, .stationary, .fullScreenAuxiliary]
        window.backgroundColor = .red.withAlphaComponent(0.1)
        window.titlebarAppearsTransparent = true
        
        window.title = ""
        
        window.toolbar = nil
        window.ignoresMouseEvents = true
        window.acceptsMouseMovedEvents = false
        
        window.isMovableByWindowBackground = false
        
        window.setFrame(NSScreen.main!.frame, display: true)
        window.isMovable = false
        window.titleVisibility = .hidden
        window.makeKeyAndOrderFront(nil)
        
        Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { _ in
            self.createPopover()
        }
    }
    
    func createPopover() {
        let controller = NSHostingController(rootView: TakeOverView())
        
        controller.preferredContentSize = NSScreen.main!.frame.size
        
        let newView = controller.view
        newView.isHidden = false
        
        if UserDefaults.standard.string(forKey: "AppleInterfaceStyle") == "Dark" {
            newView.appearance = NSAppearance(named: .vibrantDark)
        } else {
            newView.appearance = NSAppearance(named: .vibrantLight)
        }
        
        newView.frame = NSScreen.main!.frame
        
        popover = newView
        
        view.addSubview(popover)
    }
}
