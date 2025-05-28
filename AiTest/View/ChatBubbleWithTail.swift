
import SwiftUI

// Custom chat bubble shape with a tail pointing left or right depending on the sender.

struct ChatBubbleWithTail: Shape {
    var isFromCurrentUser: Bool

    func path(in rect: CGRect) -> Path {
        var path = Path()

        let cornerRadius: CGFloat = 20
        let tailSize: CGFloat = 10

        // Calculate bubble rect depending on sender side (left or right)
        let bubbleWidth = rect.width - tailSize
        let bubbleRect = isFromCurrentUser
            ? CGRect(x: rect.minX, y: rect.minY, width: bubbleWidth, height: rect.height)
            : CGRect(x: rect.minX + tailSize, y: rect.minY, width: bubbleWidth, height: rect.height)

        // Define rounded corners excluding the tail side
        let corners: UIRectCorner = isFromCurrentUser
            ? [.topLeft, .topRight, .bottomLeft]
            : [.topLeft, .topRight, .bottomRight]

        // Create the main bubble path with rounded corners
        let bezier = UIBezierPath(
            roundedRect: bubbleRect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: cornerRadius, height: cornerRadius)
        )
        path.addPath(Path(bezier.cgPath))

        // Draw tail triangle pointing to sender side
        let tailHeight: CGFloat = 12
        let tailWidth: CGFloat = 8

        if isFromCurrentUser {
            path.move(to: CGPoint(x: bubbleRect.maxX, y: rect.maxY - 20))
            path.addLine(to: CGPoint(x: bubbleRect.maxX + tailWidth, y: rect.maxY - 16))
            path.addLine(to: CGPoint(x: bubbleRect.maxX, y: rect.maxY - 12))
        } else {
            path.move(to: CGPoint(x: bubbleRect.minX, y: rect.maxY - 20))
            path.addLine(to: CGPoint(x: bubbleRect.minX - tailWidth, y: rect.maxY - 16))
            path.addLine(to: CGPoint(x: bubbleRect.minX, y: rect.maxY - 12))
        }

        path.closeSubpath()
        return path
    }
}

