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
        self.calculator.loopDepth = 200
        let newFrame = NSScreen.mainScreen()!.frame
        self.view.frame = newFrame
        
        self.updateImageView()
    }

    func updateImageView() -> Void {
        let timer = NSDate()
        let bitmap = self.calculateBitmap()
        //let bitmap = [PixelData](count: Int(self.view.frame.size.height*self.view.frame.size.width), repeatedValue: PixelData(a: 255, r: 255, g: 0, b: 0))
        print(-timer.timeIntervalSinceNow)
        let image = imageFromBitmap(bitmap, width: Int(self.view.frame.size.width*2), height: Int(self.view.frame.size.height*2))
        image.size = self.view.frame.size
        self.imageView.image = image
        print(-timer.timeIntervalSinceNow)
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
                let pixel: PixelData!

                if result == -1 {
                    pixel = PixelData(a: 255, r: 0, g: 0, b: 0)
                } else {
//                    let color = NSColor(
//                        calibratedHue: CGFloat((Float(result)+(2.0*Float(self.calculator.loopDepth)))/(Float(self.calculator.loopDepth)*3)),
//                        saturation: 1.0,
//                        brightness: CGFloat(Float(result)/(Float(self.calculator.loopDepth))),
//                        alpha: 1.0)
                    
                    let resultFrac = Float(result)/Float(self.calculator.loopDepth + 1)
                    //let brightness = UInt8(0.5-(powf(resultFrac, 3.0)/2.0))
                    let rChannel = UInt8()
                    let gChannel = true ? UInt8((resultFrac*0.5)*255.0) : UInt8(0.0)
//                    let blueChannel = UInt8(powf(resultFrac*0.9, 1.5)*255.0)
                    let bChannel = true ? UInt8((0.2+(resultFrac*0.7))*255.0) : UInt8(0) // (0.1+(1*0.9))*255.0
                    pixel = PixelData(
                        a: 255,
                        r: rChannel,
                        g: gChannel,
                        b: bChannel)
                    
//                    pixel = PixelData(
//                        a: 255,
//                        r: UInt8(255.0*Float(color.redComponent)),
//                        g: UInt8(255.0*Float(color.greenComponent)),
//                        b: UInt8(255.0*Float(color.blueComponent)))
                }
                pixels.append(pixel)
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
