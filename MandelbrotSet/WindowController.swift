//
//  WindowController.swift
//  MandelbrotSet
//
//  Created by Skyler Arnold on 3/27/16.
//  Copyright © 2016 Skyler Arnold. All rights reserved.
//

import Cocoa

class WindowController: NSWindowController {

    override func windowDidLoad() {
        super.windowDidLoad()
    
        // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
        self.window!.styleMask = [.titled, .texturedBackground, .unifiedTitleAndToolbar, .miniaturizable, .closable/*, .resizable*/]
        self.window!.isMovable = true
        self.window!.title = "Mandelbrot Set"
    }
}
