//
//  ViewController.swift
//  CodCaptcha
//
//  Created by Jia Chen Yee on 20/1/24.
//

import Cocoa
import SwiftUI

class ViewController: NSViewController {

    var popover: NSView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        Timer.scheduledTimer(withTimeInterval: 10, repeats: true) { timer in
            if self.popover == nil {
                Task {
                    await self.poll()
                }
            }
        }
    }
    
    func poll() async {
        let configuration = URLSessionConfiguration.default
        
        let session = URLSession(configuration: configuration)
        
        let url = URL(string: "http://127.0.0.1:5000/network")!
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        do {
            let (data, response) = try await session.data(for: request)
            
            guard let jsonObject = try JSONSerialization.jsonObject(with: data) as? [String: Double],
                  let sizeInKB = jsonObject["size"] else { return }
            
            if sizeInKB >= 1024 {
                await MainActor.run {
                    if self.popover == nil {
                        self.createPopover(with: Int(round(sizeInKB)))
                    }
                }
            }
            
        } catch {
            print(error.localizedDescription)
        }
        
        print(Date.now)
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
        window.backgroundColor = .clear
        window.titlebarAppearsTransparent = true
        
        window.title = ""
        
        window.toolbar = nil
        window.ignoresMouseEvents = false
        
        window.isMovableByWindowBackground = false
        
        window.setFrame(.zero, display: true)
        window.isMovable = false
        window.titleVisibility = .hidden
        window.makeKeyAndOrderFront(nil)
        
//        Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { _ in
//            self.createPopover(with: 2000)
//        }
    }
    
    override func viewDidLayout() {
        super.viewDidLayout()
        
    }
    
    func createPopover(with size: Int) {
        let controller = NSHostingController(rootView: TakeOverView(size: size) {
            self.view.window!.setFrame(.zero, display: true)
            self.popover?.removeFromSuperview()
            self.popover = nil
        })
        
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
        
        view.addSubview(popover!)
        
        view.window!.setFrame(NSScreen.main!.frame, display: true)
        view.window!.makeKeyAndOrderFront(nil)
        view.window!.menu?.items.removeAll()
    }
}
