import UIKit

enum UIFactory {

    static func textField(placeholder: String) -> UITextField {
        let tf = UITextField()
        tf.placeholder = placeholder
        tf.borderStyle = .none
        tf.backgroundColor = DS.Color.secondaryBg
        tf.layer.cornerRadius = DS.Radius.sm
        tf.font = DS.Font.body()
        tf.textColor = DS.Color.text
        tf.autocapitalizationType = .none

        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.heightAnchor.constraint(equalToConstant: DS.Height.textField).isActive = true

        // left padding
        let pad = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: 1))
        tf.leftView = pad
        tf.leftViewMode = .always

        return tf
    }

    static func primaryButton(title: String) -> UIButton {
        let b = UIButton(type: .system)
        b.setTitle(title, for: .normal)
        b.titleLabel?.font = DS.Font.button()
        b.backgroundColor = DS.Color.primary
        b.tintColor = .white
        b.layer.cornerRadius = DS.Radius.sm
        b.translatesAutoresizingMaskIntoConstraints = false
        b.heightAnchor.constraint(equalToConstant: DS.Height.button).isActive = true
        return b
    }

    static func secondaryButton(title: String) -> UIButton {
        let b = UIButton(type: .system)
        b.setTitle(title, for: .normal)
        b.titleLabel?.font = DS.Font.button()
        b.backgroundColor = DS.Color.secondaryBg
        b.tintColor = DS.Color.primary
        b.layer.cornerRadius = DS.Radius.sm
        b.translatesAutoresizingMaskIntoConstraints = false
        b.heightAnchor.constraint(equalToConstant: DS.Height.button).isActive = true
        return b
    }

    static func titleLabel(_ text: String? = nil) -> UILabel {
        let l = UILabel()
        l.text = text
        l.font = DS.Font.title()
        l.textColor = DS.Color.text
        l.numberOfLines = 0
        return l
    }

    static func bodyLabel(_ text: String? = nil) -> UILabel {
        let l = UILabel()
        l.text = text
        l.font = DS.Font.body()
        l.textColor = DS.Color.text
        l.numberOfLines = 0
        return l
    }

    static func captionLabel(_ text: String? = nil) -> UILabel {
        let l = UILabel()
        l.text = text
        l.font = DS.Font.caption()
        l.textColor = DS.Color.subtext
        l.numberOfLines = 0
        return l
    }
}

