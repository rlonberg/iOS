import UIKit
import Darwin

let firstExperimentConstant: Float = 4
let piGenerations: Int = 150


class NamedShape {
    var numberOfSides: Int = 0
    var name: String
    
    init(name: String) {
        self.name = name
    }
    
    func simpleDescription() -> String {
        return "A shape with \(numberOfSides) sides."
    }

}

class Square: NamedShape {
    var sideLength: Double
    init(sideLength: Double, name: String) {
        self.sideLength = sideLength
        super.init(name: name)
        numberOfSides = 4
    }
    
    func area() -> Double {
        return sideLength * sideLength
    }
    
    override func simpleDescription() -> String {
        return "A square with \(numberOfSides) sides of length \(sideLength)."
    }
    
}
    
let test = Square(sideLength: 5.2, name: "my test square")

test.area()

test.simpleDescription()

// Make another subclass of NamedShape called Circle that takes a radius and a name as arguments to its initializer. Implement an area and a simpleDescription method on the Circle class

class Circle : NamedShape {
    var radius: Double
    
    init(radius:Double,name: String) {
        self.radius = radius
        super.init(name: name)
    }
    
    func pi() -> Double {
        var squareMap: Int = 0
        var circleMap: Int = 0
        var distance: Double = 0
        var X: Int = 0
        var Y: Int = 0
        var iterator: Int = 0
        while (iterator <= piGenerations) {
            iterator = iterator + 1
            X = Int(arc4random_uniform(UInt32(piGenerations)))
            Y = Int(arc4random_uniform(UInt32(piGenerations)))
            distance = sqrt( Double (  (X*X) + (Y*Y)  )  )
            
            squareMap = squareMap + 1
            
            if distance/Double(piGenerations) <= 1.0
            {
                circleMap = circleMap + 1
            }
        }
        
        let ratio: Double = Double(circleMap) / Double(squareMap)
        return 4 * ratio
        
    }
    
    func area() -> Double {
        return self.pi()*(radius*radius)
    }
    
    override func simpleDescription() -> String {
        return "A circle with a radius of length \(radius)."
    }
}

var ncc1701 = Circle(radius: 1, name: "pi")

ncc1701.pi()

























