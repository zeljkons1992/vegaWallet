class Store{
  final int id;
  final List<AddressCities> addressCities;
  final String category;
  final List<String> conditions;
  final List<String> discounts;
  final String name;

  const Store({required this.id,required this.addressCities, required this.category, required this.conditions, required this.discounts, required this.name});

}

class AddressCities{
  final String address;
  final String city;
  const AddressCities({required this.address, required this.city});
}