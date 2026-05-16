import 'package:flutter/material.dart';

import '../../../../l10n/l10n_extension.dart';

class SavePage extends StatelessWidget {
  const SavePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.saveTitle)),
      body: Center(child: Text(context.l10n.saveTodo)),
    );
  }
}
