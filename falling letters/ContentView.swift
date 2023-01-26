//
//  ContentView.swift
//  falling letters
//
//  Created by lee on 1/25/23.
//

import SwiftUI
import SpriteKit

// A simple game scene with falling boxes

extension UIColor {
    convenience init(hex: Int) {
        let components = (
            R: CGFloat((hex >> 16) & 0xff) / 255,
            G: CGFloat((hex >> 08) & 0xff) / 255,
            B: CGFloat((hex >> 00) & 0xff) / 255
        )
        self.init(red: components.R, green: components.G, blue: components.B, alpha: 1)
    }

}

class GameScene: SKScene {
    var resetTimer: Timer!
    
    override func didMove(to view: SKView) {
        let body = SKPhysicsBody(edgeLoopFrom: frame)
        
        self.physicsBody = body
        
        self.backgroundColor = UIColor(hex: 0x87CEEB)
    }
    
    override func sceneDidLoad() {
        resetTimer = Timer.scheduledTimer(withTimeInterval: 10.0, repeats: true, block: self.refresh)
    }
    
    func refresh(_ timer: Timer) {
//        self.backgroundColor = .yellow.withAlphaComponent(0.5)
        
        let force = CGVector(dx: Int.random(in: 5000..<10000), dy: Int.random(in: 5000..<10000))
                             
        self.children.forEach { body in
            body.physicsBody!.applyForce(force)
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
            self.physicsBody = nil

        })
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: {
            self.removeAllChildren()
            
            let body = SKPhysicsBody(edgeLoopFrom: self.frame)
            
            self.physicsBody = body
            
            self.backgroundColor = .black
        })

    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        
        let color:UIColor = [
            UIColor.red,
            UIColor.green,
            UIColor.blue
        ].randomElement()!
        
        let box = SKSpriteNode(color: color, size: CGSize(width: 50, height: 50))
        box.position = location
///////////
        let textNode = SKLabelNode(fontNamed: "Arial-Black")
        textNode.text = "BUS🚌🎄⭐️🇺🇸AEIO"
            .map { String($0) }
            .randomElement()
        
        textNode.fontSize = 44
        textNode.fontColor = SKColor.black

        textNode.position = CGPoint(x: 0, y: -17)
           
        box.addChild(textNode)
/////////
        let body = SKPhysicsBody(rectangleOf: CGSize(width: 50, height: 50))
        box.physicsBody = body
        
        addChild(box)
    }
}

struct ContentView: View {
    var scene: SKScene {
        let scene = GameScene()
        scene.size = CGSize(width: 300, height: 400)
        scene.scaleMode = .aspectFill
        return scene
    }

    var body: some View {
        GeometryReader { g in
            SpriteView(scene: scene)
                .frame(width: g.size.width, height: g.size.height)
                .ignoresSafeArea()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
