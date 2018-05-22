//
//  InitialViewController.swift
//  LoginKit
//
//  Created by Daniel Lozano Valdés on 12/8/16.
//  Copyright © 2016 danielozano. All rights reserved.
//

import UIKit

protocol InitialViewControllerDelegate: class {

    func didSelectSignup(_ viewController: UIViewController)
    func didSelectLogin(_ viewController: UIViewController)
    func didSelectFacebook(_ viewController: UIViewController)

}

class InitialViewController: UIViewController, BackgroundMovable {

    // MARK: - Properties

    weak var delegate: InitialViewControllerDelegate?

	lazy var configuration: ConfigurationSource = {
		return DefaultConfiguration()
	}()

    // MARK: Background Movable

    var movableBackground: UIView {
		return backgroundImageView
    }

    // MARK: Outlet's

    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var backgroundImageView: GradientImageView!
    @IBOutlet weak var signupButton: Buttn!
    @IBOutlet weak var loginButton: Buttn!
    @IBOutlet weak var facebookButton: UIButton!

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        _ = loadFonts
        initBackgroundMover()
        customizeAppearance()
    }

    override func loadView() {
        view = viewFromNib()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    // MARK: - Setup

    func customizeAppearance() {
        applyConfiguration()
        setupFonts()
        addShadows()
        navigationController?.isNavigationBarHidden = true
        navigationController?.delegate = self
    }

    func applyConfiguration() {
        backgroundImageView.image = configuration.backgroundImage
		backgroundImageView.gradientType = configuration.backgroundImageGradient ? .normalGradient : .none
        logoImageView.image = configuration.mainLogoImage

		if configuration.shouldShowSignupButton {
			signupButton.setTitle(configuration.signupButtonText, for: .normal)
			signupButton.setTitleColor(configuration.tintColor, for: .normal)
			signupButton.borderColor = configuration.tintColor.withAlphaComponent(0.25)
		} else {
			signupButton.isHidden = true
		}

		if configuration.shouldShowLoginButton {
			loginButton.setTitle(configuration.loginButtonText, for: .normal)
			loginButton.setTitleColor(configuration.tintColor, for: .normal)
			loginButton.borderColor = configuration.tintColor.withAlphaComponent(0.25)
		} else {
			loginButton.isHidden = true
		}

		if configuration.shouldShowFacebookButton {
			facebookButton.setTitle(configuration.facebookButtonText, for: .normal)
		} else {
			facebookButton.isHidden = true
		}
    }

    func setupFonts() {
        loginButton.titleLabel?.font = Font.montserratRegular.get(size: 13)
        signupButton.titleLabel?.font = Font.montserratRegular.get(size: 13)
        facebookButton.titleLabel?.font = Font.montserratRegular.get(size: 15)
    }

    func addShadows() {
        facebookButton.layer.shadowOpacity = 0.3
        facebookButton.layer.shadowColor = UIColor(red: 89.0/255.0, green: 117.0/255.0, blue: 177.0/255.0, alpha: 1).cgColor
        facebookButton.layer.shadowOffset = CGSize(width: 15, height: 15)
        facebookButton.layer.shadowRadius = 7
    }

    // MARK: - Action's

    @IBAction func didSelectSignup(_ sender: AnyObject) {
        delegate?.didSelectSignup(self)
    }

    @IBAction func didSelectLogin(_ sender: AnyObject) {
        delegate?.didSelectLogin(self)
    }

    @IBAction func didSelectFacebook(_ sender: AnyObject) {
        delegate?.didSelectFacebook(self)
    }

}

// MARK: - UINavigationController Delegate

extension InitialViewController: UINavigationControllerDelegate {

    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return CrossDissolveAnimation()
    }

}
