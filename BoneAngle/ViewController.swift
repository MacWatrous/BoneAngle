//
//  ViewController.swift
//  BoneAngle
//
//  Created by Mac Watrous on 12/11/15.
//  Copyright © 2015 Mac Watrous. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIGestureRecognizerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var photoButton: UIButton!
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var line1: UIButton!
    @IBOutlet weak var line2: UIButton!
    @IBOutlet weak var angle: UILabel!
    var runCleanup1 = false
    var runCleanup2 = false
    var fired1 = false
    var fired2 = false
    var taps = 0
    var taps2 = 0
    var newLine = false
    var index = 0
    var appear1 = false
    var appear2 = false
    var bothFired = false
    var points = [CGPoint]()
    var points2 = [CGPoint]()
    var lastPoint: CGPoint!
    var newLiner = false
    var initialTrayCenter: CGPoint!
    var picker = UIImagePickerController()
    //var myLine1: Line = Line(start: CGPoint(x: 0,y: 0),end: CGPoint(x: 0,y: 0))
    //var myLine2: Line = Line(start: CGPoint(x: 0,y: 0),end: CGPoint(x: 0,y: 0))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        angle.text = "0"
        imageView.image = UIImage(named:"background.jpg")
        picker.delegate = self
        self.view.backgroundColor = UIColor.blackColor()
        var panGestureRecognizer = UIPanGestureRecognizer(target: self, action: "panImage:")
        var rotationGestureRecognizer = UIRotationGestureRecognizer(target: self, action: "rotateImage:")
        panGestureRecognizer.delegate = self;
        rotationGestureRecognizer.delegate = self;
        imageView.addGestureRecognizer(panGestureRecognizer)
        imageView.addGestureRecognizer(rotationGestureRecognizer)
        imageView.layer.anchorPoint = CGPointMake(0, 0)
        resetCords(nil)
    }
    
    @IBAction func cameraClick(sender: UIButton) {
        picker.sourceType = UIImagePickerControllerSourceType.Camera
        
        presentViewController(picker, animated: true, completion: nil)
         imageView.layer.anchorPoint = CGPointMake(0, 0)
    }
    
    @IBAction func photoClick(sender: UIButton) {
        
        
        picker.sourceType = .PhotoLibrary
        
        presentViewController(picker, animated: true, completion: nil)
         imageView.layer.anchorPoint = CGPointMake(0, 0)
    }
    
    @IBAction func scaleImage(sender: UIPinchGestureRecognizer) {
        self.imageView.transform = CGAffineTransformScale(self.imageView.transform, sender.scale, sender.scale)
        sender.scale = 1
    }
    
    @IBAction func panImage(sender: UIPanGestureRecognizer) {
        var point = sender.locationInView(view)
        var velocity = sender.velocityInView(view)
        var translation = sender.translationInView(view)
        if sender.state == UIGestureRecognizerState.Began {
            initialTrayCenter = imageView.center
        }
        else if sender.state == UIGestureRecognizerState.Changed {
            imageView.center = CGPoint(x: initialTrayCenter.x + translation.x, y: initialTrayCenter.y + translation.y)
        }
        else if sender.state == UIGestureRecognizerState.Ended{
        }
        
    }
    
    @IBAction func rotateImage(sender: UIRotationGestureRecognizer) {
        let rotation = sender.rotation
        let imageView = sender.view as! UIImageView
        let previousTransform = imageView.transform
        imageView.transform = CGAffineTransformRotate(previousTransform, rotation)
        sender.rotation = 0
    }
    
    @IBAction func resetCords(sender: UIButton?) {
        print("hello")
        self.imageView.transform = CGAffineTransformIdentity
        imageView.center = CGPoint(x: 0, y: 0)
    }
    
    @IBAction func tapImage(sender: UITapGestureRecognizer) {
        bothFired = false
        
        if runCleanup1 && newLine {
            points = []
            runCleanup1 = false
        }
        if runCleanup2 && newLiner {
            points2 = []
            runCleanup2 = false
        }
        
        if sender.state == .Ended && taps < 2 && newLine == true {
            taps++
            points.append(sender.locationInView(view))
            if taps == 2 {
                var path = UIBezierPath();
                path.moveToPoint(CGPointMake(points[0].x, points[0].y));
                path.addLineToPoint(CGPointMake(points[1].x, points[1].y));
                var shapeLayer = CAShapeLayer();
                shapeLayer.path = path.CGPath
                shapeLayer.zPosition = 2
                shapeLayer.strokeColor = UIColor.blueColor().CGColor;
                shapeLayer.lineWidth = 3.0;
                shapeLayer.fillColor = UIColor.clearColor().CGColor;
                if appear1 == true {
                    if appear2 == false {
                        view.layer.sublayers?.removeLast()
                    }
                    else if view.layer.sublayers?.last?.zPosition == 2 {
                        view.layer.sublayers?.removeLast()
                    }
                    //if the last line was a line2 we need to
                    else if view.layer.sublayers?.last?.zPosition == 3 {
                        var tempLayer = view.layer.sublayers?.last
                        view.layer.sublayers?.removeLast()
                        view.layer.sublayers?.removeLast()
                        view.layer.addSublayer(tempLayer!)
                    }
                }
                appear1 = true
                view.layer.addSublayer(shapeLayer)
                newLine = false
                fired1 = true
                print(String("tapImage fired"))
                runCleanup1 = true
                taps = 0
            }
        }
        
        //Line2
        if sender.state == .Ended && taps2 < 2 && newLiner == true {
            taps2++
            points2.append(sender.locationInView(view))
            if taps2 == 2 {
                var path = UIBezierPath();
                path.moveToPoint(CGPointMake(points2[0].x, points2[0].y));
                path.addLineToPoint(CGPointMake(points2[1].x, points2[1].y));
                var shapeLayer2 = CAShapeLayer();
                shapeLayer2.path = path.CGPath
                shapeLayer2.zPosition = 3
                shapeLayer2.strokeColor = UIColor.redColor().CGColor;
                shapeLayer2.lineWidth = 3.0;
                shapeLayer2.fillColor = UIColor.clearColor().CGColor;
                if appear2 == true {
                    if appear1 == false {
                        view.layer.sublayers?.popLast()
                    }
                    else if view.layer.sublayers?.last?.zPosition == 3 {
                        view.layer.sublayers?.removeLast()
                    }
                    else if view.layer.sublayers?.last?.zPosition == 2 {
                        var tempLayer = view.layer.sublayers?.last
                        view.layer.sublayers?.removeLast()
                        view.layer.sublayers?.removeLast()
                        view.layer.sublayers?.append(tempLayer!)
                    }
                }
                appear2 = true
                view.layer.addSublayer(shapeLayer2)
                newLiner = false
                fired2 = true
                taps2 = 0
                print(String("tapImage fired"))
                runCleanup2 = true
            }
        }
        if fired1 && fired2 {
            updateAngle()
            points = []
            points2 = []
            taps = 0
            taps2 = 0
            bothFired = true
        }
        /*else if runCleanup1 && appear2 {
            updateAngle()
            points = []
            runCleanup1 = false
        }
        else if runCleanup2 && appear1 {
            updateAngle()
            points2 = []
            runCleanup2 = false
        }*/
    }
    
    
    @IBAction func newLine1(sender: UIButton) {
        newLine = true
    }
    
    @IBAction func newLine2(sender: UIButton) {
        newLiner = true
    }
    
    func updateAngle(){
        fired1 = false
        fired2 = false
        var line1Slope = (points[1].y-points[0].y)/(points[1].x - points[0].x)
        var line2Slope = (points2[1].y-points2[0].y)/(points2[1].x - points2[0].x)
        var tanAngle = abs((line1Slope - line2Slope)/(1+line1Slope*line2Slope))
        var theAngle = atan(tanAngle)
        angle.text = String(Double(theAngle)*(180/M_PI))
    }
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
            imageView.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}

