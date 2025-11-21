import "package:flutter/material.dart";
import "../database/product_database.dart";

class DbSortOutput extends StatefulWidget{
  const DbSortOutput({super.key, required this.context, required this.sortCallback});
  final BuildContext context;
  final Function(SortBy sortBy, SortOrder order) sortCallback;

  @override
  State<DbSortOutput> createState() => _DbSortOutputState();
}

class _DbSortOutputState extends State<DbSortOutput>{

  SortBy sortBy = SortBy.name;
  SortOrder sortOrder = SortOrder.asc;
  @override
  Widget build(BuildContext context){
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      spacing: 20,
      children: [
        Text("Sortuj"),
        SegmentedButton(
            segments: const <ButtonSegment<SortBy>>[
              ButtonSegment<SortBy>(value: SortBy.name, label: Text("Nazwa")),
              ButtonSegment<SortBy>(value: SortBy.count, label: Text("Stan"))
            ],
            multiSelectionEnabled: false,
            selected: <SortBy>{sortBy},
            onSelectionChanged: (Set<SortBy> newSelection) {
              setState((){
                sortBy = newSelection.first;
              });
              widget.sortCallback(sortBy, sortOrder);
            },
            emptySelectionAllowed: false,
            showSelectedIcon: false,
            style:
            ButtonStyle(
                backgroundColor: WidgetStateProperty.resolveWith((states){
                  if(states.contains(WidgetState.selected)){
                    return Theme.of(context).colorScheme.primary;
                  }else{
                    return Colors.white;
                  }
                }),
                foregroundColor: WidgetStateProperty.resolveWith((states){
                  if(states.contains(WidgetState.selected)){
                    return Colors.white;
                  }else{
                    return  Theme.of(context).colorScheme.primary;
                  }
                }),
                side: WidgetStatePropertyAll(
                    BorderSide(
                        color: Theme.of(context).colorScheme.primary
                    )
                )
            )
        ),
        SegmentedButton(
            segments: const <ButtonSegment<SortOrder>>[
              ButtonSegment<SortOrder>(value: SortOrder.asc, label: Icon(Icons.arrow_upward)),
              ButtonSegment<SortOrder>(value: SortOrder.desc, label: Icon(Icons.arrow_downward))
            ],
            multiSelectionEnabled: false,
            selected: <SortOrder>{sortOrder},
            onSelectionChanged: (Set<SortOrder> newSelection){
              setState(() {
                sortOrder = newSelection.first;
              });
              widget.sortCallback(sortBy, sortOrder);
            },
            showSelectedIcon: false,
            emptySelectionAllowed: false,
            style: ButtonStyle(
                backgroundColor: WidgetStateProperty.resolveWith((states){
                  if(states.contains(WidgetState.selected)){
                    return Theme.of(context).colorScheme.primary;
                  }else{
                    return Colors.white;
                  }
                }),
                foregroundColor: WidgetStateProperty.resolveWith((states){
                  if(states.contains(WidgetState.selected)){
                    return Colors.white;
                  }else{
                    return Theme.of(context).colorScheme.primary;
                  }
                }),
                side: WidgetStatePropertyAll(
                    BorderSide(
                        color: Theme.of(context).colorScheme.primary
                    )
                )
            ))
      ],
    );
  }
}