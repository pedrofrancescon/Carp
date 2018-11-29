//
//  ProfilePictureView.swift
//  Carp
//
//  Created by Eldade Marcelino on 26/11/18.
//  Copyright © 2018 Pedro Francescon Cittolin. All rights reserved.
//

import Foundation

class ProfilePictureView: View {

    private var photoData: CGImage?
    let cameraView = CameraView()
    lazy var cameraFrame: UIImageView = {
        let image = View.fix(UIImageView(image: UIImage(named: "camera_frame.png")))
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        return image
    }()
    lazy var descView = View.fix(View())

    lazy var cameraButton: View = {
        let view = View.fix(View())
        view.backgroundColor = UIColor.green
        view.widthAnchor.constraint(equalToConstant: 65).isActive = true
        view.heightAnchor.constraint(equalToConstant: 65).isActive = true
        view.clipsToBounds = true
        view.layer.cornerRadius = 65 / 2
        let button = View.fix(UIButton())
        button.setTitle("\u{f030}", for: .normal)
        button.titleLabel?.textColor = .white
        button.titleLabel?.font = UIFont(name: "FontAwesome5FreeSolid", size: 24)
        button.addTarget(self, action: #selector(takePicture), for: .touchUpInside)
        view.addSubview(button)
        button.constraintEdges(to: view)
        return view
    }()

    lazy var titleLabel: UILabel = {
        let label = View.fix(UILabel().defaultFont())
        label.font = label.font.withSize(22)
        label.text = "Foto de perfil"
        label.textColor = UIColor.greenText
        return label
    }()

    lazy var explanationLabel: UILabel = {
        let label = View.fix(UILabel().defaultFont())
        label.textColor = UIColor.greyText
        label.text = "A foto de perfil é importante para que as pessoas possam se identificar com mais segurança."
        label.textAlignment = .center
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        return label
    }()

    lazy var nextButton = SocialButton(text: "continuar", color: UIColor.green, icon: nil)
    var continueAction: (() -> Void)? {
        set {
            nextButton.touchHandler = newValue
        }
        get {
            return nil
        }
    }

    override func didMoveToWindow() {
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
            if self.cameraView.view.frame.width > 0 {
                self.cameraView.setup()
                timer.invalidate()
            }
        }
    }

    override func setupView() {
        addSubview(cameraView)
        addSubviews([cameraFrame, descView, cameraButton])
        descView.addSubviews([titleLabel, explanationLabel, nextButton.view])
        cameraFrame.constraintEdges(to: cameraView.view)
        [
            cameraView.view.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.5),
            cameraView.view.widthAnchor.constraint(equalTo: self.widthAnchor),
            descView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.5),
            descView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            descView.widthAnchor.constraint(equalTo: self.widthAnchor),
            cameraButton.centerYAnchor.constraint(equalTo: descView.topAnchor),
            cameraButton.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            titleLabel.centerXAnchor.constraint(equalTo: descView.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: cameraButton.bottomAnchor, constant: 25),
            explanationLabel.centerXAnchor.constraint(equalTo: descView.centerXAnchor),
            explanationLabel.widthAnchor.constraint(equalTo: descView.widthAnchor, constant: -40),
            explanationLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            nextButton.view.bottomAnchor.constraint(equalTo: descView.bottomAnchor, constant: -20),
            nextButton.view.leftAnchor.constraint(equalTo: descView.leftAnchor, constant: 20),
            nextButton.view.rightAnchor.constraint(equalTo: descView.rightAnchor, constant: -20)
        ].forEach({ $0.isActive = true })
    }

    @objc
    func takePicture() {
        if photoData == nil {
            cameraView.takePicture { image in
                (self.cameraButton.subviews.first as? UIButton)?.setTitle("\u{f2f1}", for: .normal)
                self.cameraFrame.image = UIImage(cgImage: image)
                self.photoData = image
                self.cameraView.stop()
            }
        } else {
            (self.cameraButton.subviews.first as? UIButton)?.setTitle("\u{f030}", for: .normal)
            photoData = nil
            cameraFrame.image = UIImage(named: "camera_frame.png")
            self.cameraView.start()
        }
    }
}
