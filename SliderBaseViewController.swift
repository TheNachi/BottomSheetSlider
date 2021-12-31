import Foundation
import UIKit

@available(iOS 10.0, *)
open class SliderBaseViewController: UIViewController {

    private var sliderViewController: UIViewController?
    private var sliderHeight: CGFloat {
        return UIScreen.isPhoneXAndAbove ? self.view.frame.height - 50:
            self.view.frame.height - 30
    }
    private var runningAnimations = [UIViewPropertyAnimator]()
    private var animationProgessWhenInterrupted: CGFloat = 0
    var peekHeight: CGFloat = UIScreen.isPhoneXAndAbove ? 200 : 160
    private var nextState: SliderState {
        return self.currentDirection == .topToBottom ? .collapsed : .expanded
    }

    private var currentState: SliderState = .collapsed
    private var currentDirection: UIPanGestureRecognizerDirection = .bottomToTop
    var sliderVisible = false

   public func setUpSlider(sliderController: UIViewController) {
        let screenSize = UIScreen.main.bounds
        sliderController.view.backgroundColor = UIColor.white
        sliderController.view.frame = CGRect(x: 0, y: self.view.frame.height - peekHeight,
            width: screenSize.width, height: sliderHeight)
        sliderController.view.roundCorners(corners: [.topLeft, .topRight], radius: 12)
        sliderController.view.clipsToBounds = true

        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(self.handleSliderPan(recogniser:)))
        sliderController.view.addGestureRecognizer(panGestureRecognizer)
        self.addChildViewController(sliderController)
        self.view.addSubview(sliderController.view)
        self.sliderViewController = sliderController
        self.hideSlider()
    }

    @objc func handleSliderPan(recogniser: UIPanGestureRecognizer) {
        guard let sliderVC = self.sliderViewController else { return }
        self.handleControllerState(recogniser: recogniser,
            viewController: sliderVC)
    }

    private func handleControllerState(recogniser: UIPanGestureRecognizer,
        viewController: UIViewController) {
        let direction = recogniser.direction
        if (direction == .leftToRight || direction == .rightToLeft) && recogniser.state == .ended {
            self.handleSwipe(direction: direction, viewController: viewController); return
        }

        if (direction == .topToBottom || direction == .bottomToTop) {
            self.currentDirection = direction
            if recogniser.state == .began {
                self.startInteractiveTransition(state: nextState,
                    duration: 0.9,
                    viewController: viewController)
            }

            if recogniser.state == .changed {
                let translation = recogniser.translation(in: viewController.view)
                var fractionComplete = translation.y / sliderHeight
                fractionComplete = direction == .topToBottom ? fractionComplete : -fractionComplete
                self.updateInteractiveTransition(fractionCompleted: fractionComplete)
            }

            if recogniser.state == .ended {
                self.continueInteractiveTransition()
            }
            self.showSlider()
        }

    }

    private func animateTransitionIfNeeded(state: SliderState, duration: TimeInterval,
        viewController: UIViewController) {
        let frameAnimator = UIViewPropertyAnimator(duration: duration, dampingRatio: 1) {
            self.currentState = state
            switch state {
            case .expanded:
                viewController.view.frame.origin.y = self.view.frame.height - self.sliderHeight
            case .collapsed:
                    viewController.view.frame.origin.y = self.view.frame.height - self.peekHeight + (self.tabBarController?.tabBar.frame.height ?? 0)
            }
        }

        frameAnimator.addCompletion { _ in
            self.runningAnimations.removeAll()
        }

        frameAnimator.startAnimation()
        self.runningAnimations.append(frameAnimator)
    }

    private func startInteractiveTransition(state: SliderState,
        duration: TimeInterval,
        viewController: UIViewController) {

        if self.runningAnimations.isEmpty {
            animateTransitionIfNeeded(state: state,
                                      duration: duration,
                                      viewController: viewController)
        }

        for animator in self.runningAnimations {
            animator.pauseAnimation()
            animationProgessWhenInterrupted = animator.fractionComplete
        }
    }

    private func updateInteractiveTransition(fractionCompleted: CGFloat) {
        for animator in self.runningAnimations {
            animator.fractionComplete = fractionCompleted + animationProgessWhenInterrupted
            animator.continueAnimation(withTimingParameters: nil, durationFactor: 0)
        }
    }

    private func continueInteractiveTransition() {
        for animator in self.runningAnimations {
            animator.continueAnimation(withTimingParameters: nil, durationFactor: 0)
        }
    }

    private func handleSwipe(direction: UIPanGestureRecognizerDirection,
        viewController: UIViewController) {
    }

    public func showSlider() {
        guard let controller = self.sliderViewController else { return }
        controller.view.isHidden = false
        self.view.bringSubview(toFront: controller.view)
        self.sliderVisible = true
    }

    func bringSliderToFront() {
        guard let controller = self.sliderViewController else { return }
        self.view.bringSubview(toFront: controller.view)
    }

    public func hideSlider() {
        guard let controller = self.sliderViewController else { return }
        controller.view.isHidden = true
        self.sliderVisible = false
    }

    func closeToHeight(newHeight: CGFloat) {
        guard let controller = self.sliderViewController else { return }
        peekHeight = newHeight
        self.startInteractiveTransition(state: .collapsed,
            duration: 0.9,
            viewController: controller)
        self.continueInteractiveTransition()
    }

    func closeLegToHeight(newHeight: CGFloat) {
        guard let controller = self.sliderViewController,
            self.currentState == .collapsed else { return }
        peekHeight = newHeight
        self.startInteractiveTransition(state: .collapsed,
            duration: 0.9,
            viewController: controller)
        self.continueInteractiveTransition()
    }

    func openToHeight(newHeight: CGFloat) {
        guard let controller = self.sliderViewController else { return }
        peekHeight = newHeight
        self.startInteractiveTransition(state: .expanded,
            duration: 0.9,
            viewController: controller)
        self.continueInteractiveTransition()
    }

    func open() {
        guard let controller = self.sliderViewController else { return }
        self.startInteractiveTransition(state: .expanded, duration: 0.9,
            viewController: controller)
        self.continueInteractiveTransition()
    }

    func close() {
        guard let controller = self.sliderViewController else { return }
        self.startInteractiveTransition(state: .collapsed,
            duration: 0.9,
            viewController: controller)
        self.continueInteractiveTransition()
    }


}

protocol SliderDelegate: class {
    func newControllerOpened(controller: UIViewController)
    func openSlider()
    func closeSlider()
}

protocol SwipeDelegate: class {
    func onSwipe(direction: UIPanGestureRecognizerDirection)
}
