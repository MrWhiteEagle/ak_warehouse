import 'package:ak_warehouse/database/product.dart';
import 'package:flutter/material.dart';

class SellItem extends StatefulWidget {
  const SellItem({super.key, required this.item, required this.amountSelected});

  final Product item;
  final Function(int) amountSelected;

  @override
  State<SellItem> createState() => _SellItemState();
}

class _SellItemState extends State<SellItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Color.lerp(
          Theme.of(context).colorScheme.primary,
          Colors.white,
          0.75,
        ),
      ),
      padding: EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          //NAME
          SizedBox(
            width: 200,
            child: Text(
              widget.item.name,
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
            ),
          ),
          SizedBox(
            child: Row(
              children: [
                //Picked number
                Text(
                  'Ilość',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                ),
                SizedBox(width: 25),
                DropdownMenu<int>(
                  initialSelection: 1,
                  dropdownMenuEntries:
                      createAmountFromMaxCount(widget.item.count).map((amount) {
                        return DropdownMenuEntry<int>(
                          value: amount,
                          label: amount.toString(),
                        );
                      }).toList(),
                  onSelected: (value) {
                    if (value != null) {
                      widget.amountSelected(value);
                    }
                  },
                ),
              ],
            ),
          ),
          //MAX NUMBER (STAN)
          Text(
            'Stan: ${widget.item.count}',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
          ),
          SizedBox(width: 1),
        ],
      ),
    );
  }
}

List<int> createAmountFromMaxCount(int maxCount) {
  List<int> amountList = [];
  if (maxCount != 0) {
    for (int i = 1; i <= maxCount; i++) {
      amountList.add(i);
    }
  }
  return amountList;
}
