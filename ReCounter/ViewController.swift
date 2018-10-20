import UIKit
import ReSwift

let mainStore = Store<AppState>(reducer: counterReducer, state: nil)

struct AppState: StateType {
    var counter: Int = 0
}

enum CounterAction: Action {
    case increase, decrease
}

func counterReducer(action: Action, state: AppState?) -> AppState {
    var state = state ?? AppState()
    guard let action = action as? CounterAction else { return state }
    switch action {
    case .increase:
        state.counter += 1
    case .decrease:
        state.counter -= 1
    }
    return state
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
