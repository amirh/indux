import 'package:indux/indux.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

class Action {
  final String type;
  const Action(this.type);
}

class StoreListener<S,A> extends StatelessWidget {
  final List<CurrentStoreState<S,A>> lastStateUpdate = [];

  @override
  Widget build(BuildContext buildContext) {
    lastStateUpdate.add(Store.storeStateOf(buildContext));
    return new Container();
  }
}

void main() {
  testWidgets('Initial state passed to middleware and listeners', (WidgetTester tester) async {
    StoreListener<String, String> storeListener = new StoreListener<String, String>();
    List<String> stateUpdates = [];
    await tester.pumpWidget(
        new Store<String, String>(
          initialState: 'initialState',
          child: storeListener,
          reducer: (String state, String action) => action,
          middleware: <OnStoreUpdate<String>> [
            (CurrentStoreState lastUpdate, Dispatch<String> dispatcher) {
              stateUpdates.add(lastUpdate.state);
            }
          ]
        )
    );
    await tester.pump(new Duration(milliseconds: 1));
    expect(stateUpdates, ['initialState']);
    expect(storeListener.lastStateUpdate, [new CurrentStoreState('initialState', null, null)]);
  });
}
