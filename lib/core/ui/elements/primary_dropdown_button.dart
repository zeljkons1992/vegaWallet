import 'package:flutter/material.dart';
import '../../../features/stores/domain/entities/address_city.dart';

class PrimaryDropdownButton extends StatefulWidget {
  final List<AddressCity> items;
  final ValueChanged<AddressCity?>? onChanged;
  final AddressCity? selectedItem;

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
  AddressCity? _selectedItem;
  late List<AddressCity> _items;

  @override
  void initState() {
    super.initState();
    _items = List.from(widget.items);
    _selectedItem = widget.selectedItem ?? _items[0];

    List<AddressCity> newItems = [];
    for (var item in _items) {
      if (item.address.contains('\n')) {
        var addresses = item.address.split('\n');
        for (var i = 1; i < addresses.length; i++) {
          newItems.add(item.copyWith(address: addresses[i]));
        }
        item.address = addresses[0];
      }
    }

    _items.addAll(newItems);
  }

  String _getFirstLine(String text) {
    return text.split('\n').first;
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

    final selectedItem = await showMenu<AddressCity>(
      context: context,
      surfaceTintColor: Theme.of(context).colorScheme.surface,
      position: position,
      items: _items.map((AddressCity item) {
        return PopupMenuItem<AddressCity>(
          value: item,
          child: InkWell(
            onTap: () {
              Navigator.pop(context, item);
            },
            borderRadius: BorderRadius.circular(10),
            splashColor: const Color(0xffffeee8),
            child: Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Row(
                children: [
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
                          style: TextStyle(fontSize: 14, color: Theme.of(context).colorScheme.onSurface),
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
      color: Theme.of(context).colorScheme.surface,
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
    ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Expanded(
      child: InkWell(
        onTap: _items.length > 1 ? () => _showDropdownMenu(context) : null,
        child: Container(
          height: 50,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.onSurface,
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
                      _getFirstLine(_selectedItem?.city ?? '',),
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: colorScheme.surface),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      _getFirstLine(_selectedItem?.address ?? ''),
                      style: TextStyle(fontSize: 14, color: colorScheme.surface),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              if (_items.length > 1)
                Icon(Icons.arrow_drop_down, color: colorScheme.surface),
            ],
          ),
        ),
      ),
    );
  }
}
