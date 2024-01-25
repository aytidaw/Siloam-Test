//
//  SearchTableViewCell.swift
//  TestingTest
//
//  Created by Aditya on 24/01/24.
//

import UIKit
import SDWebImage


protocol SearchTableViewCellDelegate {
    func zooming(started: Bool)
}

class SearchTableViewCell: UITableViewCell {

    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var wrapperView: UIView!
    @IBOutlet weak var mealImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var tagsLabel: UILabel!
    
    let cornerRadius = 6.0
    
    var delegate: SearchTableViewCellDelegate?
    var overlayView: UIView!
    let maxOverlayAlpha: CGFloat = 0.8
    let minOverlayAlpha: CGFloat = 0.4
    var initialCenter: CGPoint?
    var windowImageView: UIImageView?
    var startingRect = CGRect.zero
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        shadowView.addShadow(offset: CGSize(width: 0, height: 2), color: UIColor.lightGray.withAlphaComponent(0.7), borderColor: .clear, radius: cornerRadius, opacity: 0.8)
        shadowView.layer.cornerRadius = cornerRadius
        wrapperView.layer.cornerRadius = cornerRadius
        mealImageView.layer.cornerRadius = cornerRadius
    }
    
    func configureCell(data: MealModel) {
        if let imageURL = URL(string: data.strMealThumb ?? "") {
            mealImageView.sd_setImage(with: imageURL, placeholderImage: UIImage(named: ""))
        }
    
        titleLabel.text = data.strMeal ?? ""
        categoryLabel.text = data.strCategory ?? ""
        tagsLabel.text = "Tags:  \(data.strTags ?? "-")"
        mealImageView.isUserInteractionEnabled = true
        let pinch = UIPinchGestureRecognizer(target: self, action: #selector(self.pinch(sender:)))
        pinch.delegate = self
        self.mealImageView.addGestureRecognizer(pinch)
    }
    
    @objc func pinch(sender: UIPinchGestureRecognizer) {
        if sender.state == .began {
            let currentScale = self.mealImageView.frame.size.width / self.mealImageView.bounds.size.width
            let newScale = currentScale * sender.scale
            if newScale > 1 {
                guard let currentWindow = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) else {return}
                
                self.delegate?.zooming(started: true)
                
                overlayView = UIView.init(
                    frame: CGRect(
                        x: 0,
                        y: 0,
                        width: (currentWindow.frame.size.width),
                        height: (currentWindow.frame.size.height)
                    )
                )
                
                overlayView.backgroundColor = UIColor.black
                overlayView.alpha = CGFloat(minOverlayAlpha)

                currentWindow.addSubview(overlayView)
                
                initialCenter = sender.location(in: currentWindow)
                
                windowImageView = UIImageView.init(image: self.mealImageView.image)
                windowImageView!.contentMode = .scaleAspectFill
                
                windowImageView!.clipsToBounds = true
                let point = self.mealImageView.convert(
                    mealImageView.frame.origin,
                    to: nil
                )
                
                startingRect = CGRect(
                    x: point.x,
                    y: point.y,
                    width: mealImageView.frame.size.width,
                    height: mealImageView.frame.size.height
                )
            
                windowImageView?.frame = startingRect
                
                currentWindow.addSubview(windowImageView!)

                mealImageView.isHidden = true
            }
        } else if sender.state == .changed {
            guard let currentWindow = UIApplication.shared.windows.first(where: { $0.isKeyWindow }),
                  let initialCenter = initialCenter,
                  let windowImageWidth = windowImageView?.frame.size.width
            else { return }

            let currentScale = windowImageWidth / startingRect.size.width
            let newScale = currentScale * sender.scale
            
            overlayView.alpha = minOverlayAlpha + (newScale - 1) < maxOverlayAlpha ? minOverlayAlpha + (newScale - 1) : maxOverlayAlpha
            
            let pinchCenter = CGPoint(
                x: sender.location(in: currentWindow).x - (currentWindow.bounds.midX),
                y: sender.location(in: currentWindow).y - (currentWindow.bounds.midY)
            )
        
            let centerXDif = initialCenter.x - sender.location(in: currentWindow).x
            let centerYDif = initialCenter.y - sender.location(in: currentWindow).y
            
            let zoomScale = (newScale * windowImageWidth >= mealImageView.frame.width) ? newScale : currentScale
            
            let transform = currentWindow.transform
                .translatedBy(x: pinchCenter.x, y: pinchCenter.y)
                .scaledBy(x: zoomScale, y: zoomScale)
                .translatedBy(x: -centerXDif, y: -centerYDif)

            windowImageView?.transform = transform
            
            sender.scale = 1
        } else if sender.state == .ended || sender.state == .failed || sender.state == .cancelled {
            guard let windowImageView = self.windowImageView else { return }
            

            UIView.animate(withDuration: 0.3, animations: {
                
                windowImageView.transform = CGAffineTransform.identity
                
            }, completion: { _ in
            
                windowImageView.removeFromSuperview()
                
                self.overlayView.removeFromSuperview()
                
                self.mealImageView.isHidden = false

                self.delegate?.zooming(started: false)
            })
        }
    }
    
}
