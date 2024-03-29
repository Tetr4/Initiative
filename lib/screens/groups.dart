import 'package:flutter/material.dart';
import 'package:initiative/localization/localization.dart';
import 'package:initiative/model/data.dart';
import 'package:initiative/model/groups.dart';
import 'package:initiative/screens/adventurers.dart';
import 'package:initiative/screens/dialogs/group.dart';
import 'package:scoped_model/scoped_model.dart';

class GroupsScreen extends StatefulWidget {
  const GroupsScreen({super.key});

  @override
  State<StatefulWidget> createState() => _GroupsScreenState();
}

class _GroupsScreenState extends State<GroupsScreen> {
  late GroupsModel _groups;
  late List<Group> selectedGroups;
  Map<Group, bool> selection = {};

  bool get isSelecting => selectedGroups.isNotEmpty;

  bool isSelected(group) => selection[group] == true;

  void _initState(GroupsModel groups) {
    _groups = groups;
    selection = Map.fromIterable(groups.items, value: isSelected); // keep state
    selectedGroups = selection.keys.where(isSelected).toList();
  }

  void toggleSelection(Group group) => setState(() {
        selection[group] = !selection[group]!;
      });

  void deselectAll() => setState(() => selection.clear());

  Future<void> _editGroup(BuildContext context, Group group) {
    deselectAll();
    final index = _groups.items.indexOf(group);
    return Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AdventurersScreen(groupIndex: index),
      ),
    );
  }

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
            appBar: _buildAppBar(context, selectedGroups.length),
            body: _groups.items.isEmpty ? const EmptyGroupsBody() : _buildGroupsList(groups.items),
            floatingActionButton: _buildCreateGroupButton(context),
          ),
        );
      },
    );
  }

  AppBar _buildAppBar(BuildContext context, int selectedItems) {
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
            : AppLocalizations.of(context).titleAddGroup,
      ),
      actions: actions,
    );
  }

  Widget _buildEditButton(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.edit),
      tooltip: AppLocalizations.of(context).edit,
      onPressed: () => _editGroup(context, selectedGroups.first),
    );
  }

  Widget _buildDeleteButton(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.delete),
      tooltip: AppLocalizations.of(context).delete,
      onPressed: () {
        final Map<Group, int> groupToIndex =
            Map.fromIterable(selectedGroups, value: (group) => _groups.items.indexOf(group));
        _groups.removeAll(selectedGroups);
        _showUndoBar(context, groupToIndex);
      },
    );
  }

  Widget _buildGroupsList(List<Group> groups) {
    return Scrollbar(
      child: ListView.builder(
        itemCount: groups.length,
        itemBuilder: (context, index) {
          final group = groups[index];
          return _buildGroupItem(group, isSelected(group));
        },
      ),
    );
  }

  Widget _buildGroupItem(Group group, bool isSelected) {
    final icon = isSelected ? Icons.check : Icons.group;
    return ListTile(
      leading: CircleAvatar(child: Icon(icon)),
      title: Text(group.name),
      subtitle: Text(AppLocalizations.of(context).groupSubtitle(group)),
      onTap: () => isSelecting ? toggleSelection(group) : Navigator.pop(context, group),
      onLongPress: () => toggleSelection(group),
    );
  }

  Widget _buildCreateGroupButton(BuildContext context) {
    return FloatingActionButton(
      onPressed: () => _showCreateGroupDialog(context),
      tooltip: AppLocalizations.of(context).tooltipCreateGroup,
      child: const Icon(Icons.add),
    );
  }

  Future<void> _showCreateGroupDialog(BuildContext context) async {
    final newGroup = await showDialog(
      context: context,
      builder: (BuildContext context) => const GroupDialog(),
    );
    if (newGroup != null) {
      _groups.add(newGroup);
      if (!context.mounted) return;
      _editGroup(context, newGroup);
    }
  }

  void _showUndoBar(BuildContext context, Map<Group, int> groupToIndex) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(
        actionOverflowThreshold: 0.5,
        content: Text(
          groupToIndex.length == 1
              ? AppLocalizations.of(context).deleted(groupToIndex.keys.first.name)
              : AppLocalizations.of(context).groupsDeleted(groupToIndex.length),
        ),
        action: SnackBarAction(
          label: AppLocalizations.of(context).undo,
          onPressed: () => _groups.addAll(groupToIndex),
        ),
      ));
  }
}

class EmptyGroupsBody extends StatelessWidget {
  const EmptyGroupsBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(64),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(flex: 80, child: _buildImage()),
            Padding(
              padding: const EdgeInsets.only(top: 16, bottom: 16),
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
        Icons.group_add,
        size: constraint.biggest.shortestSide * 3 / 4,
        color: Theme.of(context).primaryColorLight,
      );
    });
  }

  Widget _buildText(BuildContext context) {
    return Text(
      AppLocalizations.of(context).emptyTitleGroups,
      style: Theme.of(context).textTheme.titleLarge,
    );
  }

  Widget _buildSubText(BuildContext context) {
    return Text(
      AppLocalizations.of(context).emptySubtitleGroups,
      style: Theme.of(context).textTheme.titleSmall,
    );
  }
}
