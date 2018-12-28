import "menu_items.dart";

class CategoryItems {
  String name;
  List<menuItem> menuItems = List<menuItem>();

  CategoryItems(this.name);

  addMenuItems(menuItem item) {
    this.menuItems.add(item);
  }
}
