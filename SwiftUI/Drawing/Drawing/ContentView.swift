//
//  ContentView.swift
//  Drawing
//
//  Created by Shae Willes on 5/30/21.
//

import SwiftUI

struct ContentView: View {
    @State private var innerRadius = 125.0
    @State private var outerRadius = 75.0
    @State private var distance = 25.0
    @State private var amount: CGFloat = 1.0
    @State private var hue = 0.6
    
    var body: some View {
        VStack(spacing: 0) {
            Spacer()

            Spirograph(innerRadius: Int(innerRadius), outerRadius: Int(outerRadius), distance: Int(distance), amount: amount)
                .stroke(Color(hue: hue, saturation: 1, brightness: 1), lineWidth: 1)
                .frame(width: 300, height: 300)

            Spacer()

            Group {
                Text("Inner radius: \(Int(innerRadius))")
                Slider(value: $innerRadius, in: 10...150, step: 1)
                    .padding([.horizontal, .bottom])

                Text("Outer radius: \(Int(outerRadius))")
                Slider(value: $outerRadius, in: 10...150, step: 1)
                    .padding([.horizontal, .bottom])

                Text("Distance: \(Int(distance))")
                Slider(value: $distance, in: 1...150, step: 1)
                    .padding([.horizontal, .bottom])

                Text("Amount: \(amount, specifier: "%.2f")")
                Slider(value: $amount)
                    .padding([.horizontal, .bottom])

                Text("Color")
                Slider(value: $hue)
                    .padding(.horizontal)
            }
        }
    }
}

struct Triangle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.minY))
        
        return path
    }
}

struct Trapezoid: Shape {
    var insetAmount: CGFloat
    
    var animatableData: CGFloat {
        get { insetAmount }
        set { self.insetAmount = newValue }
    }
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        path.move(to: CGPoint(x:0, y: rect.maxY))
        path.addLine(to: CGPoint(x: insetAmount, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX - insetAmount, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: 0, y: rect.maxY))
        
        return path
    }
}

struct Arc: InsettableShape {
    var startAngle: Angle
    var endAngle: Angle
    var clockwise: Bool
    var insetAmount: CGFloat = 0
    
    func path(in rect: CGRect) -> Path {
        let rotationAdjustment = Angle.degrees(90)
        let modifiedStart = startAngle - rotationAdjustment
        let modifiedEnd = endAngle - rotationAdjustment
        
        var path = Path()
        
        path.addArc(center: CGPoint(x: rect.midX, y: rect.midY), radius: rect.width / 2 - insetAmount,
                    startAngle: modifiedStart, endAngle: modifiedEnd, clockwise: !clockwise)
        return path
    }
    
    func inset(by amount: CGFloat) -> some InsettableShape {
        var arc = self
        arc.insetAmount += amount
        return arc
    }
}

struct Arrow: Shape {
    var thickness: CGFloat
    
    var animatableData: CGFloat {
        get {
            thickness
        }
        
        set {
            thickness = newValue
        }
    }
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.midX - thickness, y: rect.maxY / 3))
        path.addLine(to: CGPoint(x: rect.midX - thickness / 2, y: rect.maxY / 3))
        path.addLine(to: CGPoint(x: rect.midX - thickness / 2, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.midX + thickness / 2, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.midX + thickness / 2, y: rect.maxY / 3))
        path.addLine(to: CGPoint(x: rect.midX + thickness, y: rect.maxY / 3))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.minY))
        
        return path
    }
}

struct Checkerboard: Shape {
    var rows: Int
    var columns: Int
    
    var animatableData: AnimatablePair<Double, Double> {
        get {
            AnimatablePair(Double(rows), Double(columns))
        }
        
        set {
            self.rows = Int(newValue.first)
            self.columns = Int(newValue.second)
        }
    }
    
    func path(in rect: CGRect) -> Path {
        //the path that will hold all of the squares
        var path = Path()
        
        //figure out how big each row/column needs to be
        let rowSize = rect.height / CGFloat(rows)
        let columnSize = rect.width / CGFloat(columns)
        
        //loop over all rows and columns, making alternating squares colored
        for row in 0..<rows {
            for column in 0..<columns {
                if (row + column).isMultiple(of: 2) {
                    //this square should be colored; add a rectangle here
                    let startX = columnSize * CGFloat(column)
                    let startY = rowSize * CGFloat(row)
                    let rect = CGRect(x: startX, y: startY, width: columnSize, height: rowSize)
                    path.addRect(rect)
                }
            }
        }
        
        //sends back the completed checkerboard
        return path
    }
}

struct Flower: Shape {
    //How much to move this petal away from the center
    var petalOffset: Double = -20
    //How wide to make each petal
    var petalWidth: Double = 100
    
    func path(in rect: CGRect) -> Path {
        //The path that will hold all of the petals
        var path = Path()
        
        //Count from 0 through 2*pi moving up by pi/8 each time
        for number in stride(from: CGFloat.zero, to: CGFloat.pi * 2, by: CGFloat.pi / 8){
            //Rotate the petal by the current value of our loop
            let rotation = CGAffineTransform(rotationAngle: number)
            
            //Move the petal to be at the center of our view
            let position = rotation.concatenating(CGAffineTransform(translationX: rect.width / 2, y: rect.height / 2))
            
            //Create a path for this petal, using our properties plus a fixed Y height
            let originalPetal = Path(ellipseIn: CGRect(x: CGFloat(petalOffset), y: 0, width: CGFloat(petalWidth), height: rect.width / 2))
            
            //Apply the rotation/position transformation to the petal
            let rotatedPetal = originalPetal.applying(position)
            
            //Add the path for the petal to our flower path
            path.addPath(rotatedPetal)
        }
        
        //return the path of the completed flower
        return path
    }
}

struct ColorCyclingCircle: View {
    var amount = 0.0
    let steps = 100
    
    var body: some View {
        ZStack {
            ForEach(0..<steps) { value in
                Circle()
                    .inset(by: CGFloat(value))
                    .strokeBorder(LinearGradient(gradient: Gradient(colors: [self.color(for: value, brightness: 1), self.color(for: value, brightness: 0.5)]), startPoint: .top, endPoint: . bottom), lineWidth: 2)
            }
        }
        .drawingGroup()
    }
    
    func color(for value: Int, brightness: Double) -> Color {
        var targetHue = Double(value) / Double(self.steps) + self.amount
        
        if targetHue > 1 {
            targetHue -= 1
        }
        
        return Color(hue: targetHue, saturation: 1, brightness: brightness)
    }
}

struct ColorCyclingRectangle: View {
    var amount = 0.0
    let steps = 100
    
    var body: some View {
        ZStack {
            ForEach(0..<steps) { value in
                Rectangle()
                    .inset(by: CGFloat(value))
                    .strokeBorder(LinearGradient(gradient: Gradient(colors: [self.color(for: value, brightness: 1), self.color(for: value, brightness: 0.5)]), startPoint: .top, endPoint: .bottom), lineWidth: 2)
            }
        }
        .drawingGroup()
    }
    
    func color(for value: Int, brightness: Double) -> Color {
        var targetHue = Double(value) / Double(self.steps) + self.amount
        
        if targetHue > 1 {
            targetHue -= 1
        }
        
        return Color(hue: targetHue, saturation: 1, brightness: brightness)
    }
}

struct Spirograph: Shape {
    let innerRadius: Int
    let outerRadius: Int
    let distance: Int
    let amount: CGFloat
    
    //Finds the greatest common divisor of two integers
    func gcd(_ a: Int, _ b: Int) -> Int {
        var a = a
        var b = b
        
        while b != 0 {
            let temp = b
            b = a % b
            a = temp
        }
        
        return a
    }
    
    func path(in  rect: CGRect) -> Path {
        //convert struct instance properties to CGFloat
        let innerRadiusCGF = CGFloat(innerRadius)
        let outerRadiusCGF = CGFloat(outerRadius)
        let distanceCGF = CGFloat(distance)
        
        //calculate the greatest common divisor of the radii of the inner and outer circles
        let divisor = CGFloat(gcd(innerRadius, outerRadius))
        
        //calculate the difference between the radii of the inner and outer circles
        let difference = innerRadiusCGF - outerRadiusCGF
        
        //calculate the number of points needed to draw the percentage of the full roulette specified by amount
        let endPoint = ceil(2 * CGFloat.pi * outerRadiusCGF / divisor) * amount
        
        
        //holds the path that will be returned from this function later
        var path = Path()
        
        //draws the roulette by calculating x and y coordinates of each point until the endpoint is reached
        for theta in stride(from: CGFloat.zero, through: endPoint, by: CGFloat(0.01)) {
            //equations for calculating x and y coordinates of a hypotrochoid roulette
            var x = difference * cos(theta) + distanceCGF * cos(difference / outerRadiusCGF * theta)
            var y = difference * sin(theta) - distanceCGF * sin(difference / outerRadiusCGF * theta)
            
            //ensures that the path is centered on our drawing space
            x += rect.width / 2
            y += rect.height / 2
            
            if theta == 0 {
                //this is the start point of the path
                path.move(to: CGPoint(x: x, y: y))
            } else {
                //a line needs to be drawn to this point
                path.addLine(to: CGPoint(x: x, y: y))
            }
        }
        
        //returns the completed path
        return path
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
