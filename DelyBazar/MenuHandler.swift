//
//  MenuHandler.swift
//  VelleMan_App
//
//  Created by Jarvics on 03/06/16.
//  Copyright © 2016 Jarvics. All rights reserved.
//

import UIKit


var globalMenuView = UIView()
var globalInnerMenuView = UIView()
var currentView = UIView()
var globalMenuButton = UIButton()

class MenuHandler: NSObject {
    func createMenu(target: HomeViewController, menuView: UIView, innerMenuView: UIView, menuBtn: UIButton){

        var isMenuAlreadyAdded = false
        
        for view in (UIApplication.shared.keyWindow?.subviews)!
        {
            if view.isKind(of: UIView.self)
            {
                if view == globalMenuView
                {
                    isMenuAlreadyAdded = true
                }
            }
        }
        if isMenuAlreadyAdded == false
        {
            globalMenuView = menuView
            globalInnerMenuView = innerMenuView
            currentView = target.view
            globalMenuButton = menuBtn
            
            
            
            globalMenuButton.addTarget(target, action: Selector(("ActionMenu:")), for: UIControlEvents.touchUpInside)
            UIApplication.shared.keyWindow?.backgroundColor = UIColor(red: 0.9294117647, green: 0.5803921569, blue: 0.1019607843, alpha: 1.0)

            UIApplication.shared.keyWindow?.addSubview(globalMenuView)
            globalMenuView.frame.origin.x = -(globalMenuView.frame.size.width + target.view.frame.origin.x)
        }
        else
        {
            print("Menu Already created")
        }

    }
    
    func addMenuButton(view:UIView)
    {
        
        currentView = view
        
        

        
        var isMenuButtonAdded = false
        
        for view in view.subviews
        {
            if view.isKind(of: UIButton.self)
            {
                if view as! UIButton == globalMenuButton
                {
                    isMenuButtonAdded = true
                }
            }

        }
        
        if isMenuButtonAdded == false
        {
            view.addSubview(globalMenuButton)
        }
        else
        {
            print("Menu Button Already Added")
        }
    }
    
}
