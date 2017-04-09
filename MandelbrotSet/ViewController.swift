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
    let calculateMandelbrotSet: Bool = true
    
    
    
    let calculator = MandelbrotCalculator()
    @IBOutlet weak var imageView: NSImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(NSScreen.main()!.frame)
        self.calculator.loopDepth = 40
        let newFrame = NSScreen.main()!.frame
        //self.view.setFrameSize(NSSize(width: 2250, height: 1972))
        self.view.frame = newFrame
        self.updateImageView()
    }

    func updateImageView() -> Void {
        let timer = Date()
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
                
                var result: Int
                if (self.calculateMandelbrotSet) {
                    result = self.calculator.calculate(numToTest: complexNum)
                } else {
                    result = self.calculator.calculateJulia(numToTest: complexNum)
                }
            
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
                    
                    let rChannel = UInt8(powf(resultFrac, 0.5)*255.0)
                    let gChannel = UInt8(0)
                    let bChannel = UInt8(resultFrac*255.0)
                    
                    pixel = PixelData(
                        a: 255,
                        r: rChannel,
                        g: gChannel,
                        b: bChannel)
                }
                pixels.append(pixel)
            }
        }
        
        return pixels
    }
    
    let rgbColorSpace = CGColorSpaceCreateDeviceRGB()
    let bitmapInfo: CGBitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedFirst.rawValue)
    
    func imageFromBitmap(_ pixels:[PixelData], width: Int, height: Int) -> NSImage {
        let bitsPerComponent = 8
        let bitsPerPixel = 32
        
        assert(pixels.count == Int(width*height))
        
        var data: [PixelData] = pixels
//        var dataSize = MemoryLayout<PixelData>.size
//        let pointer = UnsafePointer<UInt8>(&data)
//        let data = Data(bytes: pointer, count: (data.count * MemoryLayout<PixelData>.size))
        
        let providerRef = CGDataProvider(
            data: Data(bytes: UnsafeRawPointer!(&data), count: data.count * MemoryLayout<PixelData>.size) as CFData
        )
        
//        let providerRef = CGDataProvider(
//            data: Data(bytes: UnsafePointer<UInt8>(&data), count: data.count * sizeof(PixelData))
//        )
//        let providerRef = CGDataProvider(
//        data: Data(bytes: UnsafePointer<UInt8>(&data), count: data.count * sizeof(PixelData))
//        )
        
        let gcim = CGImage(
            width: width,
            height: height,
            bitsPerComponent: bitsPerComponent,
            bitsPerPixel: bitsPerPixel,
            bytesPerRow: width*MemoryLayout<PixelData>.size,
            space: self.rgbColorSpace,
            bitmapInfo: self.bitmapInfo,
            provider: providerRef!,
            decode: nil,
            shouldInterpolate: true,
            intent: CGColorRenderingIntent.defaultIntent)
        
        return NSImage(cgImage: gcim!, size: CGSize(width: width, height: height))
    }
}
