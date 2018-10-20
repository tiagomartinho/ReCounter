import UIKit
import ReSwift

let mainStore = Store<AppState>(reducer: counterReducer, state: AppState.initial)

struct AppState: StateType {
    let counter: Int
}

extension AppState {
    static var initial = AppState(counter: 0)
}

enum CounterAction: Action {
    case increase, decrease
}

func counterReducer(action: Action, state: AppState?) -> AppState {
    guard let state = state else { return AppState.initial }
    guard let action = action as? CounterAction else { return state }
    switch action {
    case .increase:
        return AppState(counter: state.counter + 1)
    case .decrease:
        return AppState(counter: state.counter - 1)
    }
}

class ViewController: UIViewController, StoreSubscriber {

    @IBOutlet var counterLabel: UILabel!

    override func viewWillAppear(_ animated: Bool) {
        mainStore.subscribe(self)
    }

    override func viewWillDisappear(_ animated: Bool) {
        mainStore.unsubscribe(self)
    }

    func newState(state: AppState) {
        counterLabel.text = "\(state.counter)"
    }

    @IBAction func increaseButtonTapped(_ sender: UIButton) {
        mainStore.dispatch(
            CounterAction.increase
        )
    }

    @IBAction func decreaseButtonTapped(_ sender: UIButton) {
        mainStore.dispatch(
            CounterAction.decrease
        )
    }
}
