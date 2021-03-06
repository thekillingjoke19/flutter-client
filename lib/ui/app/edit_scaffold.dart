import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:invoiceninja_flutter/data/models/entities.dart';
import 'package:invoiceninja_flutter/redux/app/app_state.dart';
import 'package:invoiceninja_flutter/redux/settings/settings_actions.dart';
import 'package:invoiceninja_flutter/ui/app/forms/save_cancel_buttons.dart';
import 'package:invoiceninja_flutter/ui/app/menu_drawer_vm.dart';
import 'package:invoiceninja_flutter/utils/platforms.dart';

class EditScaffold extends StatelessWidget {
  const EditScaffold({
    Key key,
    @required this.title,
    @required this.onSavePressed,
    @required this.body,
    this.entity,
    this.onCancelPressed,
    this.bottomNavigationBar,
    this.floatingActionButton,
    this.appBarBottom,
    this.saveLabel,
    this.isFullscreen = false,
  }) : super(key: key);

  final BaseEntity entity;
  final String title;
  final Function(BuildContext) onSavePressed;
  final Function(BuildContext) onCancelPressed;
  final Widget appBarBottom;
  final Widget floatingActionButton;
  final Widget body;
  final Widget bottomNavigationBar;
  final String saveLabel;
  final bool isFullscreen;

  @override
  Widget build(BuildContext context) {
    final store = StoreProvider.of<AppState>(context);
    final state = store.state;

    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Scaffold(
        body: body,
        drawer: isDesktop(context) ? MenuDrawerBuilder() : null,
        appBar: AppBar(
          centerTitle: false,
          automaticallyImplyLeading: isMobile(context),
          title: Text(title),
          actions: <Widget>[
            SaveCancelButtons(
              saveLabel: saveLabel,
              isSaving: state.isSaving,
              onSavePressed: (context) {
                // Clear focus now to prevent un-focus after save from
                // marking the form as changed and to hide the keyboard
                FocusScope.of(context).unfocus();

                onSavePressed(context);

                /* The debouncer has been disabled b/c if you click
                   save too quickly the changes are lost
                if (Debouncer.isDebouncing) {
                  Timer(Duration(milliseconds: kDebounceDelay), () {
                    onSavePressed(context);
                  });
                } else {
                  onSavePressed(context);
                }
                 */
              },
              onCancelPressed: isMobile(context)
                  ? null
                  : (context) {
                      if (onCancelPressed != null) {
                        onCancelPressed(context);
                      } else {
                        store.dispatch(ResetSettings());
                      }
                    },
            ),
          ],
          bottom: appBarBottom,
        ),
        bottomNavigationBar: bottomNavigationBar,
        floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
        floatingActionButton: floatingActionButton,
      ),
    );
  }
}
