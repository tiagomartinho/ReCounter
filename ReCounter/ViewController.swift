import UIKit
import ReSwift

let mainStore = Store<AppState>(reducer: counterReducer, state: AppState.initial)

struct AppState: StateType {
    let counter: Int
}

extension AppState {
    static var initial = AppState(counter: 0)
}

protocol CounterAction: Action {
    func apply(state: AppState) -> AppState
}

class IncreaseCounterAction: CounterAction {
    func apply(state: AppState) -> AppState {
        return AppState(counter: state.counter + 1)
    }
}

class DecreaseCounterAction: CounterAction {
    func apply(state: AppState) -> AppState {
        return AppState(counter: state.counter - 1)
    }
}

func counterReducer(action: Action, state: AppState?) -> AppState {
    guard let state = state else { return AppState.initial }
    guard let action = action as? CounterAction else { return state }
    return action.apply(state: state)
}

class ViewController: UIViewController, StoreSubscriber {

    @IBOutlet var counterLabel: UILabel!

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        mainStore.subscribe(self)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        mainStore.unsubscribe(self)
    }

    func newState(state: AppState) {
        counterLabel.text = "\(state.counter)"
    }

    @IBAction func increaseButtonTapped(_ sender: UIButton) {
        mainStore.dispatch(IncreaseCounterAction())
    }

    @IBAction func decreaseButtonTapped(_ sender: UIButton) {
        mainStore.dispatch(DecreaseCounterAction())
    }
}
