// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:todo_app/blocs/tag_bloc/tag_bloc.dart';
import 'package:todo_app/core/bloc_state_type.dart';
import 'package:todo_app/core/helpers/ui_helper.dart';
import 'package:todo_app/data/models/tag.dart';
import 'package:todo_app/presentation/dialogs/new_edit_tag_dialog.dart';

class TagsRow extends StatefulWidget {

  final bool onlySelect;
  Function(bool, Tag) onTagSelected;
  Map<String, bool> selectedTags;

  TagsRow({
    super.key, 
    required this.onlySelect, 
    required this.onTagSelected,
    required this.selectedTags});

  @override
  State<TagsRow> createState() => _TagsRowState();
}

class _TagsRowState extends State<TagsRow> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TagBloc, TagState>(
      buildWhen: (previous, current) => current is ReadAllTagsState,
      builder: (context, state) {

        if(state is TagInitial){
          BlocProvider.of<TagBloc>(context).add(ReadAllTagsEvent());
        }

        if(state is ReadAllTagsState && state.blocStateType == BlocStateType.success){

          return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Wrap(
            alignment: WrapAlignment.center,
            spacing: 10.0,
            children: [
              if(!widget.onlySelect)
                GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => NewEditTagDialog(
                        isEdit: false,
                        onConfirmPressed: ({int? color, required String name}) {
                          tagAdded(context, name: name, color: color);
                        },
                      ),
                    );
                  
                  },
                  child: RawChip(
                    avatar: const Icon(Icons.add, size: 18.0),
                    selected: false,
                    label: Text(translate('tags_row_addtag')), 
                  ),
                ),
              ...state.tags!.map((tag) => 
                GestureDetector(
                  onLongPress: () {
                    if(widget.onlySelect) return;

                    showDialog(
                    context: context,
                    builder: (context) => NewEditTagDialog(
                      tagName: tag.name,
                      tagColor: tag.color,
                      isEdit: true,
                      onConfirmPressed: ({int? color, required String name}) {
                        tagUpdated(context, tag, name: name, color: color);
                      },
                      onDeletePressed: () {
                        tagDeleted(context, tag);
                      },
                    ),
                  );
                  },
                  child: FilterChip(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    selected: widget.selectedTags[tag.uuid] ?? false,
                    label: Text(tag.name,
                    style: 
                      widget.selectedTags[tag.uuid] ?? false ? 
                       TextStyle(color: UIHelper.getTextColorFromBackgroundColor(Color(tag.color))) 
                       : null,), 
                    checkmarkColor: UIHelper.getTextColorFromBackgroundColor(Color(tag.color)),
                    selectedColor: Color(tag.color),
                    backgroundColor: Color(tag.color).withOpacity(0.3),
                    onSelected: (select) {
                      setState(() {
                        widget.selectedTags[tag.uuid] = select;
                        widget.onTagSelected(select, tag);
                      });
                      
                    },
                  ),
                ),
              ).toList(),
              
            ],
          ),
        );
        } else if (state is ReadAllTagsState && state.blocStateType == BlocStateType.loading){
          return const Center(child: CircularProgressIndicator());

        } else {
          return Container();
        }
        
      },
    );
  }

  tagAdded(BuildContext context,{required String name, int? color}) {
    BlocProvider.of<TagBloc>(context).add(
      CreateTagEvent(Tag(name, color ?? 0xFFFFFFFF)));
  }

  tagUpdated(BuildContext context, Tag tag, {required String name, int? color}) {
    
    tag.name = name;
    tag.color = color ?? 0xFFFFFFFF;
    
    BlocProvider.of<TagBloc>(context).add(
      UpdateTagEvent(tag));
  }

  tagDeleted(BuildContext context, Tag tag) {
    
    BlocProvider.of<TagBloc>(context).add(
      DeleteTagEvent(tag.uuid));
  }
}