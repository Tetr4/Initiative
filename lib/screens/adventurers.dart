import 'package:flutter/material.dart';
import 'package:initiative/localization/localization.dart';
import 'package:initiative/model/data.dart';
import 'package:initiative/model/groups.dart';
import 'package:initiative/screens/dialogs/adventurer.dart';
import 'package:scoped_model/scoped_model.dart';

class AdventurersScreen extends StatefulWidget {
  final int groupIndex;

  AdventurersScreen({Key key, @required this.groupIndex}) : super(key: key);

  @override
  _AdventurersScreenState createState() => _AdventurersScreenState();
}

// TODO generic multi select widget for both groups and adventurers?
class _AdventurersScreenState extends State<AdventurersScreen> {
  GroupsModel _groups;
  Group group;
  Map<Character, bool> selection = Map();
  List<Character> selectedAdventurers;

  bool get isSelecting => selectedAdventurers.length > 0;

  bool isSelected(adventurer) => selection[adventurer] == true;

  void _initState(GroupsModel groups) {
    _groups = groups;
    group = groups.items[widget.groupIndex];
    selection = Map.fromIterable(group.members, value: isSelected);
    selectedAdventurers = selection.keys.where(isSelected).toList();
  }

  void toggleSelection(Character adventurer) => setState(() {
        selection[adventurer] = !selection[adventurer];
      });

  void deselectAll() => setState(() => selection.clear());

  Future<bool> _onBackPressed() {
    if (isSelecting) {
      deselectAll();
    }
    return Future.value(!isSelecting);
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<GroupsModel>(
      builder: (context, child, groups) {
        _initState(groups);
        return WillPopScope(
          onWillPop: _onBackPressed,
          child: Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: _buildAppBar(context, selectedAdventurers.length),
            body: group.members.isEmpty
                ? EmptyGroupBody()
                : _buildAdventurersList(group.members),
            floatingActionButton: _buildCreateAdventurerButton(context),
          ),
        );
      },
    );
  }

  Widget _buildAppBar(BuildContext context, int selectedItems) {
    final List<Widget> actions = [];
    if (selectedItems == 1) {
      actions.add(_buildEditButton(context));
    }
    if (selectedItems > 0) {
      actions.add(Builder(builder: _buildDeleteButton));
    }
    return AppBar(
      title: Text(
        selectedItems > 0
            ? AppLocalizations.of(context).itemsSelected(selectedItems)
            : AppLocalizations.of(context).titleEdit(group.name),
      ),
      actions: actions,
    );
  }

  Widget _buildEditButton(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.edit),
      tooltip: AppLocalizations.of(context).edit,
      onPressed: () {
        deselectAll();
        _showEditAdventurerDialog(context, selectedAdventurers.first);
      },
    );
  }

  Widget _buildDeleteButton(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.delete),
      tooltip: AppLocalizations.of(context).delete,
      onPressed: () {
        final Map<Character, int> memberToIndex = Map.fromIterable(
            selectedAdventurers,
            value: (adventurer) => group.members.indexOf(adventurer));
        _groups.removeMembers(widget.groupIndex, selectedAdventurers);
        _showUndoBar(context, memberToIndex);
      },
    );
  }

  Widget _buildAdventurersList(List<Character> adventurers) {
    return Scrollbar(
      child: ListView.builder(
        itemCount: adventurers.length,
        itemBuilder: (context, index) {
          final adventurer = adventurers[index];
          return _buildAdventurerItem(adventurer, isSelected(adventurer));
        },
      ),
    );
  }

  Widget _buildAdventurerItem(Character adventurer, bool isSelected) {
    final icon = isSelected ? Icons.check : Icons.face;
    return ListTile(
      leading: CircleAvatar(child: Icon(icon)),
      title: Text(adventurer.name),
      subtitle: Text(adventurer.description),
      onTap: isSelecting ? () => toggleSelection(adventurer) : null,
      onLongPress: () => toggleSelection(adventurer),
    );
  }

  FloatingActionButton _buildCreateAdventurerButton(BuildContext context) {
    return FloatingActionButton(
      onPressed: () => _showCreateAdventurerDialog(context),
      tooltip: AppLocalizations.of(context).tooltipAddMember,
      child: Icon(Icons.add),
    );
  }

  void _showEditAdventurerDialog(
      BuildContext context, Character adventurer) async {
    final newAdventurer = await showDialog(
      context: context,
      builder: (BuildContext context) =>
          AdventurerDialog(adventurer: adventurer),
    );
    if (newAdventurer != null) {
      _groups.replaceMember(widget.groupIndex, adventurer, newAdventurer);
    }
  }

  void _showCreateAdventurerDialog(BuildContext context) async {
    final newAdventurer = await showDialog(
      context: context,
      builder: (BuildContext context) => AdventurerDialog(),
    );
    if (newAdventurer != null) {
      _groups.addMember(widget.groupIndex, newAdventurer);
    }
  }

  void _showUndoBar(BuildContext context, Map<Character, int> memberToIndex) {
    Scaffold.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(
        content: Text(
          memberToIndex.length == 1
              ? AppLocalizations.of(context)
                  .deleted(memberToIndex.keys.first.name)
              : AppLocalizations.of(context)
                  .membersDeleted(memberToIndex.length),
        ),
        action: SnackBarAction(
          label: AppLocalizations.of(context).undo,
          onPressed: () =>
              _groups.addAllMembers(widget.groupIndex, memberToIndex),
        ),
      ));
  }
}

class EmptyGroupBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(64),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(flex: 80, child: _buildImage()),
            Padding(
              padding: EdgeInsets.only(top: 16, bottom: 16),
              child: _buildText(context),
            ),
            Expanded(flex: 20, child: _buildSubText(context)),
          ],
        ),
      ),
    );
  }

  Widget _buildImage() {
    return LayoutBuilder(builder: (context, constraint) {
      return Icon(
        Icons.person_add,
        size: constraint.biggest.shortestSide * 3 / 4,
        color: Theme.of(context).primaryColorLight,
      );
    });
  }

  Widget _buildText(BuildContext context) {
    return Text(
      AppLocalizations.of(context).emptyTitleGroup,
      style: Theme.of(context).textTheme.headline6,
    );
  }

  Widget _buildSubText(BuildContext context) {
    return Text(
      AppLocalizations.of(context).emptySubtitleGroup,
      style: Theme.of(context).textTheme.subtitle2,
    );
  }
}
