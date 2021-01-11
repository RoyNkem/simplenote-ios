import UIKit

// MARK: - AccountVerificationViewController
//
class AccountVerificationViewController: UIViewController {

    /// Configuration
    ///
    struct Configuration {
        static let review = Configuration(title: Localization.Review.title,
                                          messageTemplate: Localization.Review.messageTemplate,
                                          primaryButton: Localization.Review.confirm,
                                          secondaryButton: Localization.Review.changeEmail)

        static let verify = Configuration(title: Localization.Verify.title,
                                          messageTemplate: Localization.Verify.messageTemplate,
                                          primaryButton: nil,
                                          secondaryButton: Localization.Verify.resendEmail)

        let title: String
        let messageTemplate: String

        let primaryButton: String?
        let secondaryButton: String

        private init(title: String,
                     messageTemplate: String,
                     primaryButton: String?,
                     secondaryButton: String) {
            self.title = title
            self.messageTemplate = messageTemplate
            self.primaryButton = primaryButton
            self.secondaryButton = secondaryButton
        }
    }

    @IBOutlet private weak var iconView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var textLabel: UILabel!
    @IBOutlet private weak var primaryButton: SPSquaredButton!
    @IBOutlet private weak var secondaryButton: UIButton!

    @IBOutlet private weak var dismissButton: UIButton!

    @IBOutlet private weak var scrollView: UIScrollView!

    private var configuration: Configuration
    private let email: String

    init(configuration: Configuration, email: String) {
        self.configuration = configuration
        self.email = email

        super.init(nibName: nil, bundle: nil)
        if #available(iOS 13.0, *) {
            isModalInPresentation = true
        }
        modalPresentationStyle = .formSheet
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        refreshStyle()
        refreshContent()
    }
}

// MARK: - Buttons
//
extension AccountVerificationViewController {
    @IBAction private func handleTapOnDismissButton() {
        dismiss(animated: true, completion: nil)
    }

    @IBAction private func handleTapOnPrimaryButton() {

    }

    @IBAction private func handleTapOnSecondaryButton() {

    }
}

// MARK: - Style
//
private extension AccountVerificationViewController {
    func refreshStyle() {
        view.backgroundColor = .simplenoteVerificationScreenBackgroundColor
        iconView.tintColor = .simplenoteTitleColor

        titleLabel.textColor = .simplenoteTextColor
        textLabel.textColor = .simplenoteTextColor

        primaryButton.backgroundColor = .simplenoteBlue50Color
        primaryButton.setTitleColor(.white, for: .normal)

        secondaryButton.backgroundColor = .clear
        secondaryButton.setTitleColor(.simplenoteTintColor, for: .normal)

        scrollView.contentInset = Constants.scrollContentInset
    }
}

// MARK: - Content
//
private extension AccountVerificationViewController {
    func refreshContent() {
        let message = String(format: configuration.messageTemplate, email)

        titleLabel.text = configuration.title
        textLabel.attributedText = attributedText(message, highlighting: email)
        primaryButton.setTitle(configuration.primaryButton, for: .normal)
        secondaryButton.setTitle(configuration.secondaryButton, for: .normal)

        primaryButton.isHidden = configuration.primaryButton == nil
    }

    func attributedText(_ text: String, highlighting term: String) -> NSAttributedString {
        let attributedMessage = NSMutableAttributedString(string: text, attributes: [
            .foregroundColor: UIColor.simplenoteTextColor,
            .font: UIFont.preferredFont(forTextStyle: .body)
        ])

        if let range = text.range(of: term) {
            attributedMessage.addAttribute(.font,
                                           value: UIFont.preferredFont(forTextStyle: .headline),
                                           range: NSRange(range, in: text))
        }

        return attributedMessage
    }
}

// MARK: - Constants
//
private struct Constants {
    static let scrollContentInset = UIEdgeInsets(top: 72, left: 0, bottom: 20, right: 0)
}

// MARK: - Localization
//
private struct Localization {
    struct Review {
        static let title = NSLocalizedString("Review Your Account", comment: "Title -> Review you account screen")
        static let messageTemplate = NSLocalizedString("You are registered with Simplenote using the email %1$@.\n\nImprovements to account security may result in account loss if you no longer have access to this email address.", comment: "Message -> Review you account screen. Parameter: %1$@ - email address")

        static let confirm = NSLocalizedString("Confirm", comment: "Confirm button -> Review you account screen")
        static let changeEmail = NSLocalizedString("Change Email", comment: "Change email button -> Review you account screen")
    }

    struct Verify {
        static let title = NSLocalizedString("Verify Your Email", comment: "Title -> Verify your email screen")
        static let messageTemplate = NSLocalizedString("An email has been sent to %1$@ with a link for you to click on to verify your email address. Happy note-ing!", comment: "Message -> Verify your email screen. Parameter: %1$@ - email address")

        static let resendEmail = NSLocalizedString("Resend Email", comment: "Resend email button -> Verify your email screen")
    }
}
