import 'package:flutter/material.dart';
import 'package:vegawallet/core/ui/theme/theme.dart';
import '../../../features/stores/data/model/store.dart';

class PrimaryDropdownButton extends StatefulWidget {
  final List<AddressCities> items;
  final ValueChanged<AddressCities?>? onChanged;
  final AddressCities? selectedItem;

  const PrimaryDropdownButton({
    super.key,
    required this.items,
    this.onChanged,
    this.selectedItem,
  });

  @override
  PrimaryDropdownButtonState createState() => PrimaryDropdownButtonState();
}

class PrimaryDropdownButtonState extends State<PrimaryDropdownButton> {
  AddressCities? _selectedItem;

  @override
  void initState() {
    super.initState();
    _selectedItem = widget.selectedItem ?? widget.items[0];
  }

  void _showDropdownMenu(BuildContext context) async {
    final RenderBox button = context.findRenderObject() as RenderBox;
    final RenderBox overlay = Overlay.of(context).context.findRenderObject() as RenderBox;

    final RelativeRect position = RelativeRect.fromRect(
      Rect.fromPoints(
        button.localToGlobal(button.size.bottomLeft(const Offset(0, 5)), ancestor: overlay),
        button.localToGlobal(button.size.bottomRight(const Offset(0, 5)), ancestor: overlay),
      ),
      Offset.zero & overlay.size,
    );

    final selectedItem = await showMenu<AddressCities>(
      context: context,
      position: position,
      items: widget.items.map((AddressCities item) {
        return PopupMenuItem<AddressCities>(
          value: item,
          child: InkWell(
            onTap: () {
              Navigator.pop(context, item);
            },
            borderRadius: BorderRadius.circular(10),
            splashColor:  const Color(0xffffeee8),
            child: Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Row(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      color: MaterialTheme.lightScheme().primaryContainer,
                    ),
                    child: Icon(
                      Icons.location_city_rounded,
                      color: MaterialTheme.lightScheme().inversePrimary,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.city,
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          item.address,
                          style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
      color: Colors.white,
      elevation: 0,
    );

    if (selectedItem != null) {
      setState(() {
        _selectedItem = selectedItem;
      });
      if (widget.onChanged != null) {
        widget.onChanged!(selectedItem);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: () => _showDropdownMenu(context),
        child: Container(
          height: 50,
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.circular(10.0),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _selectedItem?.city ?? '',
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      _selectedItem?.address ?? '',
                      style: const TextStyle(fontSize: 14, color: Colors.white),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_drop_down, color: Colors.white),
            ],
          ),
        ),
      ),
    );
  }
}
