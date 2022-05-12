import PlaygroundSupport
import UIKit


protocol BallProtocol {
    init(color: UIColor, radius: Int, coordinates: (x: Int, y: Int))
}

protocol SquareAreaProtocol {
    init(size: CGSize, color: UIColor)
    
    func setBalls(withColors: [UIColor], andRadius: Int)
}


class Ball: UIView, BallProtocol {
    required public init(color: UIColor, radius: Int, coordinates: (x: Int, y: Int)) {
        super.init(frame: CGRect(x: coordinates.x, y: coordinates.y, width: radius * 2, height: radius * 2))
        self.layer.cornerRadius = self.bounds.width / 2.0
        self.backgroundColor = color
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder: ) has not been implemented")
    }
}


public class SquareArea: UIView, SquareAreaProtocol {
    private var balls: [Ball] = []
    private var animator: UIDynamicAnimator?
    private var  snapBehavior: UISnapBehavior?
    private var collisionBehavior: UICollisionBehavior
    
    required public init(size: CGSize, color: UIColor) {
        collisionBehavior = UICollisionBehavior(items: [])
        super.init(frame: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        self.backgroundColor = color
        collisionBehavior.setTranslatesReferenceBoundsIntoBoundary(with: UIEdgeInsets(top: 1, left: 1, bottom: 1, right: 1))
        animator = UIDynamicAnimator(referenceView: self)
        animator?.addBehavior(collisionBehavior)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder: ) has not been implemented")
    }
    
    public func setBalls(withColors ballsColor: [UIColor], andRadius radius: Int) {
        for (index, oneBallColor) in ballsColor.enumerated() {
            let coordinateX = 10 + (2 * radius) * index
            let coordinateY = 10 + (2 * radius) * index
            let ball = Ball(color: oneBallColor, radius: radius, coordinates: (x: coordinateX, y: coordinateY))
            self.addSubview(ball)
            self.balls.append(ball)
            collisionBehavior.addItem(ball)
        }
    }
        
    override public func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let touchLocation = touch.location(in: self)
            for ball in balls {
                if (ball.frame.contains(touchLocation)) {
                    snapBehavior = UISnapBehavior(item: ball, snapTo: touchLocation)
                    snapBehavior?.damping = 0.5
                    animator?.addBehavior(snapBehavior!)
                }
            }
        }
    }
    
    override public func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let touchLocation = touch.location(in: self)
            if let snapBehavior = snapBehavior {
                snapBehavior.snapPoint = touchLocation
            }
        }
    }
    
    override public func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let snapBehavior = snapBehavior {
            animator?.removeBehavior(snapBehavior)
        }
        snapBehavior = nil
    }
}


let sizeIfArea = CGSize(width: 300, height: 500)
var area = SquareArea(size: sizeIfArea, color: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1))
area.setBalls(withColors: [#colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1), #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1), #colorLiteral(red: 0.5843137503, green: 0.8235294223, blue: 0.4196078479, alpha: 1), #colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1)], andRadius: 30)
PlaygroundPage.current.liveView = area





