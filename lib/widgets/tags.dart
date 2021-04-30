import 'package:flutter/material.dart';
import 'package:flutter_tags/flutter_tags.dart';
import 'package:unity/constants.dart';

class Tag {
  String title;
  Tag(this.title);
}

class TagsInput extends StatefulWidget {
  final List<Tag> tags;
  TagsInput(this.tags);
  @override
  _TagsInputState createState() => _TagsInputState();
}

class _TagsInputState extends State<TagsInput> {
  // final List<Tag> _items = [
  //   Tag('Zen'),
  //   Tag('Wim Hof'),
  //   // Tag('Tag3'),
  //   // Tag('Tag4'),
  //   // Tag('Tag5'),
  //   // Tag('Tag6'),
  //   // Tag('Tag7'),
  //   // Tag('Tag8'),
  //   // Tag('Tag9'),
  //   // Tag('Tag10'),
  // ];
  double _fontSize = 14;

  @override
  void initState() {
    super.initState();
    // _items =
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(uDefaultPadding),
      child: Tags(
        key: _tagStateKey,
        textField: TagsTextField(
          textStyle: TextStyle(fontSize: _fontSize),
          // constraintSuggestion: true, suggestions: [], // TODO: build suggestions
          onChanged: (string) => print(string),
          onSubmitted: (String str) {
            setState(() {
              // required
              widget.tags.add(Tag(str));
              // _items.add(Tag(str));
            });
          },
        ),
        itemCount: widget.tags.length, // required
        itemBuilder: (int index) {
          final item = widget.tags[index];
          return ItemTags(
            // Each ItemTags must contain a Key. Keys allow Flutter to
            // uniquely identify widgets.
            key: Key(index.toString()),
            index: index, // required
            title: item.title,
            // active: item.active,
            // customData: item.customData,
            textStyle: TextStyle(
              fontSize: _fontSize,
            ),
            combine: ItemTagsCombine.withTextBefore,
            removeButton: ItemTagsRemoveButton(
              onRemoved: () {
                // Remove the item from the data source.
                setState(() {
                  // required
                  widget.tags.removeAt(index);
                  // _items.removeAt(index);
                });
                //required
                return true;
              },
            ), // OR null,
            onPressed: (item) => print(item),
            onLongPressed: (item) => print(item),
          );
        },
      ),
    );
  }

  final GlobalKey<TagsState> _tagStateKey = GlobalKey<TagsState>();
// Allows you to get a list of all the ItemTags
  _getAllItem() {
    List<Item> lst = _tagStateKey.currentState?.getAllItem;
    if (lst != null)
      lst.where((a) => a.active == true).forEach((a) => print(a.title));
  }
}
