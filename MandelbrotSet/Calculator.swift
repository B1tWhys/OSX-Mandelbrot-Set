//
//  Calculator.swift
//  MandelbrotSet
//
//  Created by Skyler Arnold on 3/27/16.
//  Copyright © 2016 Skyler Arnold. All rights reserved.
//

import Foundation

struct ComplexNum {
    let realComponent: Float!
    let complexComponent: Float!
}

private func + (left: ComplexNum, right: ComplexNum) -> ComplexNum {
    let resultRealPart = left.realComponent + right.realComponent
    let resultCompPart = left.complexComponent + right.complexComponent
    
    return (ComplexNum(realComponent: resultRealPart, complexComponent: resultCompPart))
}

private func abs(num: ComplexNum) -> Float {
    let aSq = powf(num.realComponent, 2.0)
    let bSq = powf(num.complexComponent, 2.0)
    let abs = sqrt(aSq + bSq)
    
    return abs
}

class MandelbrotCalculator {
    var loopDepth: Int = 200
    
    func calculate(numToTest num: ComplexNum) -> Int {
        var z = ComplexNum(realComponent: 0, complexComponent: 0)
        var count = 1
        
        while true {
            if abs(z) > 2 {
                return count
            } else if (count > self.loopDepth) {
                return -1
            }
            z = squareComp(z) + num
            count += 1
        }
    }
    
    private func squareComp(num: ComplexNum) -> ComplexNum {
        let real = powf(num.realComponent, 2.0)-powf(num.complexComponent, 2.0)
        let complex = 2.0 * num.realComponent * num.complexComponent
        
        return ComplexNum(realComponent: real, complexComponent: complex)
    }
}