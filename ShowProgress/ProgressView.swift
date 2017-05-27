//
//  ProgressView.swift
//  ShowProgress
//
//  Created by 刘恒 on 2017/2/28.
//  Copyright © 2017年 YunRuiJiTuan. All rights reserved.
//

import UIKit


class ProgressView: UIView {
    
    private let backGroundLayer = CAShapeLayer()
    private let aboveLayer = CAShapeLayer()
    private let moveLayer = CAShapeLayer()
    private let beginX:CGFloat = 20  //进度条距离左右边界的距离
    private var fromProgress:CGFloat? //最初的进度
    private var lineWidth:CGFloat?
    private let circalRadius:CGFloat = 40
    
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.createUI()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func createUI(){
        self.layer.addSublayer(backGroundLayer)
        self.layer.addSublayer(aboveLayer)
        self.backGroundLayer.frame = CGRect(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height)
        self.aboveLayer.frame = CGRect(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height)
        
    }
    //
    open var signArray:Array<Int>?{
        didSet{
            self.lineWidth = self.bounds.width - circalRadius*(CGFloat)((signArray?.count)!)-beginX*2.0
            self.lineWidth = self.lineWidth!/(CGFloat)((signArray?.count)!-1)
            for i in 0..<(signArray?.count)!{
                
                //根据数组个数创建相等数量的圆圈，分别加在backGroundLayer和aboveLayer上
                self.generatePoint(frame: CGRect(x: beginX+(circalRadius+lineWidth!)*CGFloat(i), y: 10, width: circalRadius, height: circalRadius), text: String((signArray?[i])!), aboveFlag: false)
                self.generatePoint(frame: CGRect(x: beginX+(circalRadius+lineWidth!)*CGFloat(i), y: 10, width: circalRadius, height: circalRadius), text: String((signArray?[i])!), aboveFlag: true)
                
                //下面这段代码是对进度的每一个圆圈下的说明，自己可以定义,想看效果可以关闭注释
                self.generateTipLabel(frame: CGRect(x: beginX+(circalRadius+lineWidth!)*CGFloat(i), y: 10, width: circalRadius, height: circalRadius), text: String((signArray?[i])!), aboveFlag: false)
                self.generateTipLabel(frame: CGRect(x: beginX+(circalRadius+lineWidth!)*CGFloat(i), y: 10, width: circalRadius, height: circalRadius), text: String((signArray?[i])!), aboveFlag: true)
                
                //下面的代码主要是画取两个圆圈之间的连线
                if i < (signArray?.count)!-1 {
                    self.generateUnitLine(frame: CGRect(x: beginX+(circalRadius-2)+(circalRadius+lineWidth!)*CGFloat(i), y: 28, width: lineWidth!+4, height: 4), aboveFlag: false)
                    self.generateUnitLine(frame: CGRect(x: beginX+(circalRadius-2)+(circalRadius+lineWidth!)*CGFloat(i), y: 28, width: lineWidth!+4, height: 4), aboveFlag: true)
                }
            }
        }
    }
    private func generatePoint(frame:CGRect,text:String,aboveFlag:Bool){
        let textLayer = CATextLayer()
        textLayer.frame = CGRect(x: 0, y: (frame.size.height-16)/2, width: frame.size.width, height: 16)
        textLayer.backgroundColor = UIColor.clear.cgColor
        textLayer.string = text
        textLayer.contentsScale = UIScreen.main.scale
        textLayer.alignmentMode = kCAAlignmentCenter
        textLayer.fontSize = 12
        
        let  backLayer = CAShapeLayer()
        backLayer.cornerRadius = frame.size.width/2
        backLayer.frame = frame
        backLayer.borderWidth = 4.0
        backLayer.backgroundColor = UIColor.white.cgColor
        backLayer.addSublayer(textLayer)
        if aboveFlag {
            backLayer.borderColor = UIColor(red: 1.0/255.0, green: 169.0/255.0, blue: 209.0/255.0, alpha: 1.0).cgColor
            textLayer.foregroundColor = UIColor(red: 1.0/255.0, green: 169.0/255.0, blue: 209.0/255.0, alpha: 1.0).cgColor
            self.aboveLayer.addSublayer(backLayer)
        }
        else{
            backLayer.borderColor = UIColor(red: 231.0/255.0, green: 231.0/255.0, blue: 231.0/255.0, alpha: 1.0).cgColor
            textLayer.foregroundColor = UIColor(red: 153.0/255.0, green: 153.0/255.0, blue: 153.0/255.0, alpha: 1.0).cgColor
            self.backGroundLayer.addSublayer(backLayer)
        }
    }
    private func generateUnitLine(frame:CGRect,aboveFlag:Bool){
        let lineLayer = CAShapeLayer()
        lineLayer.frame = frame
        if aboveFlag {
            lineLayer.backgroundColor = UIColor(red: 1.0/255.0, green: 169.0/255.0, blue: 209.0/255.0, alpha: 1.0).cgColor
            self.aboveLayer.addSublayer(lineLayer)
        }
        else{
            lineLayer.backgroundColor = UIColor(red: 231.0/255.0, green: 231.0/255.0, blue: 231.0/255.0, alpha: 1.0).cgColor
            self.backGroundLayer.addSublayer(lineLayer)
        }
    }
    private func generateTipLabel(frame:CGRect,text:String,aboveFlag:Bool){
        let bottomTextLayer = CATextLayer()
        bottomTextLayer.frame = CGRect(x: frame.origin.x-15, y: frame.size.height+15, width: frame.size.width+30, height: 25)
        bottomTextLayer.string = text
        bottomTextLayer.contentsScale = UIScreen.main.scale
        bottomTextLayer.alignmentMode = kCAAlignmentCenter
        bottomTextLayer.fontSize = 12
        bottomTextLayer.foregroundColor = UIColor(red: 1.0/255.0, green: 169.0/255.0, blue: 209.0/255.0, alpha: 1.0).cgColor
        if aboveFlag {
            self.aboveLayer.addSublayer(bottomTextLayer)
        }
        else{
            self.backGroundLayer.addSublayer(bottomTextLayer)
        }
    }
    //根据进度数据获取进度，同时给moveLayer赋值，对aboveLayer进行切割
    open func configMask(position:Int){
        fromProgress = self.obtainProgress(position: position)
        self.moveLayer.bounds = self.aboveLayer.bounds
        self.moveLayer.fillColor = UIColor.black.cgColor
        self.moveLayer.path = UIBezierPath(rect: self.aboveLayer.bounds).cgPath
        self.moveLayer.position = CGPoint(x: -self.aboveLayer.bounds.size.width / 2.0+beginX+fromProgress!, y: self.aboveLayer.bounds.size.height / 2.0)
        self.aboveLayer.mask = self.moveLayer
    }
    //点击按钮，进行进度变化，通过moveLayer的position变化改变对aboveLayer切割效果
    open func startAnimation(topositon:Int){
        let toprogress = self.obtainProgress(position: topositon)
        self.moveLayer.position = CGPoint(x: -self.aboveLayer.bounds.size.width / 2.0+toprogress+beginX, y: self.aboveLayer.bounds.size.height / 2.0)
        
        //layer本身就自带动画，下面的代码是为moveLayer换一种速度比较慢的动画
//        let rightAnimation = CABasicAnimation(keyPath: "position")
//        rightAnimation.fromValue = NSValue(cgPoint: CGPoint(x: -self.aboveLayer.bounds.size.width / 2.0+fromProgress!+beginX, y: self.aboveLayer.bounds.size.height / 2.0))
//        rightAnimation.toValue = NSValue(cgPoint: CGPoint(x: -self.aboveLayer.bounds.size.width / 2.0+toprogress+beginX, y: self.aboveLayer.bounds.size.height / 2.0))
//        rightAnimation.duration = 1
//        rightAnimation.repeatCount = 0
//        rightAnimation.isRemovedOnCompletion = false
//        self.moveLayer.add(rightAnimation, forKey: "rightAnimation")
//        fromProgress = toprogress;
    }
    
    //根据当前数字获取进度（主要）
    private func obtainProgress(position:Int) -> CGFloat{
        var progress:CGFloat = 0.0
        var day = (signArray?[0])!
        if position >= day {
            var currentPosition = 0;
            for i in 0..<(signArray?.count)!{
                day = (signArray?[i])!
                if day>=position {
                    currentPosition = i;
                    break;
                }
            }
            if day == position {
                progress = circalRadius*CGFloat(currentPosition+1)+lineWidth!*CGFloat(currentPosition)
            }
            else if day > position{
                let lastday = signArray?[currentPosition-1]
                let daySub = day-lastday!-1
                progress = circalRadius*CGFloat(currentPosition)+lineWidth!*CGFloat(Float(position-lastday!)/Float(daySub))+lineWidth!*CGFloat(currentPosition-1)
            }
            else{
                progress = circalRadius
            }
        }
        return progress
    }
    
}
