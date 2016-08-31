//
//  YHAlertView.swift
//  Thuong Nguyen
//
//  Created by Thuong Nguyen on 1/9/16.
//

import UIKit

public class YHAlertView: UIViewController {
    
    public enum AlertType: Int {
        case Alert
    }

    public enum AnimationStyle: Int {
        case FadeIn
        case FlyLeft
        case FlyTop
        case FlyRight
        case FlyBottom
        case BounceLeft
        case BounceRight
        case BounceBottom
        case BounceTop
    }
    
    private var tapOutsideTouchGestureRecognizer: UITapGestureRecognizer = UITapGestureRecognizer()
    public var allowTouchOutsideToDismiss: Bool = true {
        didSet {
            if allowTouchOutsideToDismiss == false {
                self.tapOutsideTouchGestureRecognizer.removeTarget(self, action: #selector(dismiss))
            }
            else {
                self.tapOutsideTouchGestureRecognizer.addTarget(self, action: #selector(dismiss))
            }
        }
    }

    static let BackgroundAlpha: CGFloat       = 0.5
    
    // MARK: -
    public var alertType: AlertType = AlertType.Alert
    
    public static var backgroundAlpha: CGFloat       = YHAlertView.BackgroundAlpha

    // Master views
    public var backgroundView: UIView!
    public var alertView: UIView!
    public static var animationStyle: AnimationStyle   = .FadeIn
    
    public var SCREEN_WIDTH = UIScreen.mainScreen().bounds.width
    public var SCREEN_HEIGHT = UIScreen.mainScreen().bounds.height
    
    public static var damping:CGFloat                = 0.5
    public var timeDuration:NSTimeInterval               = 0.3
    public static var initialSpringVelocity:CGFloat  = 0.5
    
    // Windows
    var previousWindow: UIWindow!
    var alertWindow: UIWindow!
    
    // Old frame
    var oldFrame: CGRect!
    
    
    // MARK: - Initializers
    
    init(size:CGSize,style:AnimationStyle,title:String) {
        super.init(nibName: nil, bundle: nil)
        self.setupViews(size)
        self.setupWindow()
    }
    

    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setupWindow() {
       
        let window = UIWindow(frame: (UIApplication.sharedApplication().keyWindow?.bounds)!)
        self.alertWindow = window
        self.alertWindow.windowLevel = UIWindowLevelAlert
        self.alertWindow.backgroundColor = UIColor.clearColor()
        self.alertWindow.rootViewController = self
        self.previousWindow = UIApplication.sharedApplication().keyWindow
    }
    
    func setupViews(size:CGSize) {
      
        self.view = UIView(frame: (UIApplication.sharedApplication().keyWindow?.bounds)!)
        // Setup background view
        self.backgroundView = UIView(frame: self.view.bounds)
        self.backgroundView.backgroundColor = UIColor.blackColor()
        self.backgroundView.alpha = YHAlertView.backgroundAlpha
        self.view.addSubview(backgroundView)
        
        if allowTouchOutsideToDismiss == true {
            self.tapOutsideTouchGestureRecognizer.addTarget(self, action: #selector(dismiss))
        }
        backgroundView.addGestureRecognizer(self.tapOutsideTouchGestureRecognizer)
        
        // Setup alert view
        self.alertView                    = UIView(frame: CGRectMake((SCREEN_WIDTH-size.width)/2,(SCREEN_HEIGHT-size.height)/2,size.width,size.height))
        self.alertView.backgroundColor    = UIColor.whiteColor()
        self.view.addSubview(alertView)
        
    }

    
    override public func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
     
        
        }

    // MARK: - Show & hide
    
    public func show() {
  
        self.alertWindow.addSubview(self.view)
        self.alertWindow.makeKeyAndVisible()
        switch YHAlertView.animationStyle {
        case .FadeIn:
            self.view.alpha = 0
            UIView.animateWithDuration(timeDuration) { () -> Void in
                self.view.alpha = 1
            }
        case .FlyLeft:
            self.backgroundView.alpha = 0
            let currentFrame = self.alertView.frame
            self.alertView.frame = CGRectMake(self.view.frame.size.width, currentFrame.origin.y, currentFrame.size.width, currentFrame.size.height)
            UIView.animateWithDuration(timeDuration) { () -> Void in
                self.alertView.frame = currentFrame
                self.backgroundView.alpha = YHAlertView.backgroundAlpha
            }
        case .FlyRight:
            self.backgroundView.alpha = 0
            let currentFrame = self.alertView.frame
            self.alertView.frame = CGRectMake(-currentFrame.size.width, currentFrame.origin.y, currentFrame.size.width, currentFrame.size.height)
            UIView.animateWithDuration(timeDuration) { () -> Void in
                self.alertView.frame = currentFrame
                self.backgroundView.alpha = 1
            }
        case .FlyBottom:
            self.backgroundView.alpha = 0
            let currentFrame = self.alertView.frame
            self.alertView.frame = CGRectMake(currentFrame.origin.x, self.view.frame.size.height, currentFrame.size.width, currentFrame.size.height)
            UIView.animateWithDuration(timeDuration) { () -> Void in
                self.alertView.frame = currentFrame
                self.backgroundView.alpha = YHAlertView.backgroundAlpha
            }
        case .FlyTop:
            self.backgroundView.alpha = 0
            let currentFrame = self.alertView.frame
            self.alertView.frame = CGRectMake(currentFrame.origin.x, -currentFrame.size.height, currentFrame.size.width, currentFrame.size.height)
            UIView.animateWithDuration(0.3) { () -> Void in
                self.alertView.frame = currentFrame
                self.backgroundView.alpha = YHAlertView.backgroundAlpha
            }
        case .BounceTop:
            self.backgroundView.alpha = 0
            let currentFrame = self.alertView.frame
            self.alertView.frame = CGRectMake(currentFrame.origin.x, -currentFrame.size.height*4, currentFrame.size.width, currentFrame.size.height)
            
            UIView.animateWithDuration(timeDuration, delay: 0, usingSpringWithDamping: YHAlertView.damping, initialSpringVelocity: YHAlertView.initialSpringVelocity, options: UIViewAnimationOptions.AllowUserInteraction, animations: { () -> Void in
                
                self.alertView.frame = currentFrame
                self.backgroundView.alpha = YHAlertView.backgroundAlpha
                
                }, completion: {  _ in
                    
            })
            
        case .BounceBottom:
            self.backgroundView.alpha = 0
            let currentFrame = self.alertView.frame
            self.alertView.frame = CGRectMake(currentFrame.origin.x, self.view.frame.size.height, currentFrame.size.width, currentFrame.size.height)
            
            UIView.animateWithDuration(timeDuration, delay: 0, usingSpringWithDamping: YHAlertView.damping, initialSpringVelocity: YHAlertView.initialSpringVelocity, options: UIViewAnimationOptions.AllowUserInteraction, animations: { () -> Void in
                
                self.alertView.frame = currentFrame
                self.backgroundView.alpha = YHAlertView.backgroundAlpha
                
                }, completion: {  _ in
                    
            })
        case .BounceLeft:
            self.backgroundView.alpha = 0
            let currentFrame = self.alertView.frame
            self.alertView.frame = CGRectMake(self.view.frame.size.width, currentFrame.origin.y, currentFrame.size.width, currentFrame.size.height)
            
            UIView.animateWithDuration(timeDuration, delay: 0, usingSpringWithDamping: YHAlertView.damping, initialSpringVelocity: YHAlertView.initialSpringVelocity, options: UIViewAnimationOptions.AllowUserInteraction, animations: { () -> Void in
                
                self.alertView.frame = currentFrame
                self.backgroundView.alpha = YHAlertView.backgroundAlpha
                
                }, completion: {  _ in
                    
            })
            
        case .BounceRight:
            self.backgroundView.alpha = 0
            let currentFrame = self.alertView.frame
            self.alertView.frame = CGRectMake(-currentFrame.size.width, currentFrame.origin.y, currentFrame.size.width, currentFrame.size.height)
            UIView.animateWithDuration(timeDuration, delay: 0, usingSpringWithDamping: YHAlertView.damping, initialSpringVelocity: YHAlertView.initialSpringVelocity, options: UIViewAnimationOptions.AllowUserInteraction, animations: { () -> Void in
                
                self.alertView.frame = currentFrame
                self.backgroundView.alpha = YHAlertView.backgroundAlpha
                
                }, completion: {  _ in
                    
            })
        }
        }
    
    public func dismiss() {
    
        let completion = { (complete: Bool) -> Void in
            if complete {
        self.view.removeFromSuperview()
        self.alertWindow.hidden = true
        self.alertWindow = nil
        self.previousWindow.makeKeyAndVisible()
        self.previousWindow = nil
            }
        }
        switch YHAlertView.animationStyle {
        case .FadeIn:
            self.view.alpha = 1
            UIView.animateWithDuration(timeDuration,
                                       animations: { () -> Void in
                                        self.view.alpha = 0
                }, completion: completion)
        case .FlyLeft:
            self.backgroundView.alpha = YHAlertView.backgroundAlpha
            let currentFrame = self.alertView.frame
            UIView.animateWithDuration(timeDuration,
                                       animations: { () -> Void in
                                        self.alertView.frame = CGRectMake(self.view.frame.size.width, currentFrame.origin.y, currentFrame.size.width, currentFrame.size.height)
                                        self.backgroundView.alpha = 0
                },
                                       completion: completion)
        case .FlyRight:
            self.backgroundView.alpha = YHAlertView.backgroundAlpha
            let currentFrame = self.alertView.frame
            UIView.animateWithDuration(timeDuration,
                                       animations: { () -> Void in
                                        self.alertView.frame = CGRectMake(-currentFrame.size.width, currentFrame.origin.y, currentFrame.size.width, currentFrame.size.height)
                                        self.backgroundView.alpha = 0
                },
                                       completion: completion)
        case .FlyBottom:
            self.backgroundView.alpha = YHAlertView.backgroundAlpha
            let currentFrame = self.alertView.frame
            UIView.animateWithDuration(timeDuration,
                                       animations: { () -> Void in
                                        self.alertView.frame = CGRectMake(currentFrame.origin.x, self.view.frame.size.height, currentFrame.size.width, currentFrame.size.height)
                                        self.backgroundView.alpha = 0
                },
                                       completion: completion)
        case .FlyTop:
            self.backgroundView.alpha = YHAlertView.backgroundAlpha
            let currentFrame = self.alertView.frame
            UIView.animateWithDuration(timeDuration,
                                       animations: { () -> Void in
                                        self.alertView.frame = CGRectMake(currentFrame.origin.x, -currentFrame.size.height, currentFrame.size.width, currentFrame.size.height)
                                        self.backgroundView.alpha = 0
                },
                                       completion: completion)
            
        case .BounceBottom:
            self.backgroundView.alpha = YHAlertView.backgroundAlpha
            let currentFrame = self.alertView.frame
            UIView.animateWithDuration(timeDuration, delay: 0, usingSpringWithDamping: YHAlertView.damping, initialSpringVelocity: YHAlertView.initialSpringVelocity, options: UIViewAnimationOptions.AllowUserInteraction, animations: { () -> Void in
                self.alertView.frame = CGRectMake(currentFrame.origin.x, self.view.frame.size.height, currentFrame.size.width, currentFrame.size.height)
                self.backgroundView.alpha = 0
                }, completion: completion)
            
        case .BounceTop:
            self.backgroundView.alpha = YHAlertView.backgroundAlpha
            let currentFrame = self.alertView.frame
            UIView.animateWithDuration(timeDuration, delay: 0, usingSpringWithDamping: YHAlertView.damping, initialSpringVelocity: YHAlertView.initialSpringVelocity, options: UIViewAnimationOptions.AllowUserInteraction, animations: { () -> Void in
                self.alertView.frame = CGRectMake(currentFrame.origin.x, -currentFrame.size.height, currentFrame.size.width, currentFrame.size.height)
                self.backgroundView.alpha = 0
                }, completion: completion)
            
        case .BounceLeft:
            self.backgroundView.alpha = YHAlertView.backgroundAlpha
            let currentFrame = self.alertView.frame
            UIView.animateWithDuration(timeDuration, delay: 0, usingSpringWithDamping: YHAlertView.damping, initialSpringVelocity: YHAlertView.initialSpringVelocity, options: UIViewAnimationOptions.AllowUserInteraction, animations: { () -> Void in
                self.alertView.frame = CGRectMake(self.view.frame.size.width, currentFrame.origin.y, currentFrame.size.width, currentFrame.size.height)
                self.backgroundView.alpha = 0
                }, completion: completion)
            
        case .BounceRight:
            
            self.backgroundView.alpha = YHAlertView.backgroundAlpha
            let currentFrame = self.alertView.frame
            UIView.animateWithDuration(timeDuration, delay: 0, usingSpringWithDamping: YHAlertView.damping, initialSpringVelocity: YHAlertView.initialSpringVelocity, options: UIViewAnimationOptions.AllowUserInteraction, animations: { () -> Void in
                self.alertView.frame = CGRectMake(-currentFrame.size.width, currentFrame.origin.y, currentFrame.size.width, currentFrame.size.height)
                self.backgroundView.alpha = 0
                }, completion: completion)
        }
    }
    
}
