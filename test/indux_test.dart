import 'package:indux/indux.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

class Action {
  final String type;
  const Action(this.type);
}

class StoreListener<S,A> extends StatelessWidget {
  final List<StoreUpdate<S,A>> storeUpdate = [];

  @override
  Widget build(BuildContext buildContext) {
    storeUpdate.add(Store.storeStateOf(buildContext));
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
            (StoreUpdate update, Dispatch<String> dispatcher) {
              stateUpdates.add(update.state);
            }
          ]
        )
    );
    await tester.pump(new Duration(milliseconds: 1));
    expect(stateUpdates, ['initialState']);
    expect(storeListener.storeUpdate, [new StoreUpdate('initialState', null, null)]);
  });
}
