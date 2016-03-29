//
//  ViewController.swift
//  MandelbrotSet
//
//  Created by Skyler Arnold on 3/25/16.
//  Copyright © 2016 Skyler Arnold. All rights reserved.
//

import Cocoa

struct PixelData {
    var a: UInt8
    var r: UInt8
    var g: UInt8
    var b: UInt8
}

class ViewController: NSViewController {
    let calculator = MandelbrotCalculator()
    @IBOutlet weak var imageView: NSImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let newFrame = NSScreen.mainScreen()!.frame
        self.view.frame = newFrame
        
        self.updateImageView()
    }

    func updateImageView() -> Void {
        let bitmap = self.calculateBitmap()
        //let bitmap = [PixelData](count: Int(self.view.frame.size.height*self.view.frame.size.width), repeatedValue: PixelData(a: 255, r: 255, g: 0, b: 0))
        let image = imageFromBitmap(bitmap, width: Int(self.view.frame.size.width*2), height: Int(self.view.frame.size.height*2))
        image.size = self.view.frame.size
        self.imageView.image = image
    }
    
    func calculateBitmap() -> [PixelData]{
        var pixels = [PixelData]()
        
        let height = Float(self.view.frame.height*2)
        let width = Float(self.view.frame.width*2)
        
        let yScaleFactor = 2.0/height
        let xScaleFactor = 3.0/width

        for y in 0..<Int(height) {
            let complexComp = (Float(y) * yScaleFactor) - 1.0

            for x in 0..<Int(width) {
                let realComp = (Float(x) * xScaleFactor) - 2.0
                let complexNum = ComplexNum(realComponent: realComp, complexComponent: complexComp)
                let result = self.calculator.calculate(numToTest: complexNum)
                let pixel: PixelData?
                if result == -1 {
                    pixel = PixelData(a: 255, r: 0, g: 0, b: 0)
                } else {
                    pixel = PixelData(a: 255, r: 255, g: 255, b: 255)
                }
                
                pixels.append(pixel!)
            }
        }
        
        return pixels
    }
    
    let rgbColorSpace = CGColorSpaceCreateDeviceRGB()
    let bitmapInfo: CGBitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.PremultipliedFirst.rawValue)
    
    func imageFromBitmap(pixels:[PixelData], width: Int, height: Int) -> NSImage {
        let bitsPerComponent = 8
        let bitsPerPixel = 32
        
        assert(pixels.count == Int(width*height))
        
        var data = pixels
        let providerRef = CGDataProviderCreateWithCFData(
        NSData(bytes: &data, length: data.count * sizeof(PixelData))
        )
        
        let gcim = CGImageCreate(
            width,
            height,
            bitsPerComponent,
            bitsPerPixel,
            width*sizeof(PixelData),
            self.rgbColorSpace,
            self.bitmapInfo,
            providerRef,
            nil,
            true,
            CGColorRenderingIntent.RenderingIntentDefault)
        
        return NSImage(CGImage: gcim!, size: CGSize(width: width, height: height))
    }
    
    
    override var representedObject: AnyObject? {
        didSet {
        // Update the view, if already loaded.
        }
    }
}
