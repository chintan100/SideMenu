//
//  MainViewController.swift
//  SideMenu
//
//  Created by Chintan Patel on 11/11/23.
//

import UIKit

class MainViewController: UIViewController {
    
    private var sideMenuViewController: SideMenuViewController!
    private var sideMenuWidth: CGFloat = 290
    private var isSideMenuShown: Bool = false
    private var sideMenuTrailingConstraint: NSLayoutConstraint!
    
    @IBOutlet var sideMenuShadowView: UIView!
    @IBOutlet var hamburgerMenuButton: UIBarButtonItem!
    @IBOutlet var selectionLabel: UILabel!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.configureSideMenu()
    }
    
    //MARK: - Button Taps
    @IBAction func hamburgerMenuButtonTapped(_ sender: UIButton) {
        
        self.sideMenuState(expanded: self.isSideMenuShown ? false : true)
    }
    
    //MARK: - Side Menu
    func configureSideMenu() {
        
        //First we configure sideMenuShadowView with desired alpha or transparency
        //and add tapGestureRecognizer to hide side menu.
        self.sideMenuShadowView.alpha = 0.0
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(shadowViewTapGestureRecognizer))
        tapGestureRecognizer.numberOfTapsRequired = 1
        tapGestureRecognizer.delegate = self
        self.sideMenuShadowView.addGestureRecognizer(tapGestureRecognizer)
        
        //Initialize SideMenuViewController from storyboard and add subview.
        self.sideMenuViewController = self.storyboard!.instantiateViewController(withIdentifier: "SideMenuViewController") as? SideMenuViewController
        self.sideMenuViewController.delegate = self
        self.view.addSubview(self.sideMenuViewController.view)
        self.addChild(self.sideMenuViewController)
        self.sideMenuViewController!.didMove(toParent: self)
        
        // Side Menu AutoLayout configuration
        self.sideMenuViewController.view.translatesAutoresizingMaskIntoConstraints = false
        self.sideMenuTrailingConstraint = self.sideMenuViewController.view.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: -self.sideMenuWidth)
        self.sideMenuTrailingConstraint.isActive = true
        
        NSLayoutConstraint.activate([
            self.sideMenuViewController.view.widthAnchor.constraint(equalToConstant: self.sideMenuWidth),
            self.sideMenuViewController.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            self.sideMenuViewController.view.topAnchor.constraint(equalTo: self.view.topAnchor)
        ])
        
        let edgePanGestureRecognizer = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(handleEdgeSwipe))
        edgePanGestureRecognizer.edges = .left
        self.view.addGestureRecognizer(edgePanGestureRecognizer)
    }
    
    //Handles sideMenu show/hide.
    func sideMenuState(expanded: Bool) {
        
        if expanded {
            
            self.animateSideMenu(targetPosition:0) { _ in
                
                self.isSideMenuShown = true
            }
            
            //Show sideMenuShadowView by increasing alpha.
            UIView.animate(withDuration: 0.3) {
                
                self.sideMenuShadowView.alpha = 0.6
            }
        }
        
        else {
            
            self.animateSideMenu(targetPosition:(-self.sideMenuWidth)) { _ in
                
                self.isSideMenuShown = false
            }
            
            //Hide sideMenuShadowView by setting alpha to 0.
            UIView.animate(withDuration: 0.3) {
                
                self.sideMenuShadowView.alpha = 0.0
            }
        }
    }
    
    //Animates side menu show/hide by animating contraint change.
    func animateSideMenu(targetPosition: CGFloat, completion: @escaping (Bool) -> ()) {
        
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0, options: .layoutSubviews, animations: {
            
            self.sideMenuTrailingConstraint.constant = targetPosition
            self.view.layoutIfNeeded()
            
        }, completion: completion)
    }
}

extension MainViewController: UIGestureRecognizerDelegate{
    
    @objc func shadowViewTapGestureRecognizer(sender: UITapGestureRecognizer) {
        
        if sender.state == .ended {
            
            if self.isSideMenuShown {
                
                self.sideMenuState(expanded: false)
            }
        }
    }
    
    //Handle Edge Swipe from left edge to right
    @objc private func handleEdgeSwipe(gestureRecognizer: UIScreenEdgePanGestureRecognizer) {
        
        if gestureRecognizer.state == .recognized {
            
            self.sideMenuState(expanded: self.isSideMenuShown ? false : true)
        }
    }

    //Close side menu when you tap on the shadow background view
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        
        if (touch.view?.isDescendant(of: self.sideMenuViewController.view))! {
            
            return false
        }
        
        return true
    }
}

//Implement SideMenu delegate to handle cell selection.
extension MainViewController: SideMenuViewControllerDelegate {
    
    func didSelectCell(_ row: Int, title: String) {
        
        selectionLabel.text = "Selected Row: " + String(row) + " \n" + "Selected Title: " + title
        
        // Once cell is selected, we hide side menu.
        DispatchQueue.main.async {
            
            self.sideMenuState(expanded: false)
        }
    }
}

