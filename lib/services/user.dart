class AppUser{
  late String id;
  late String name;
  late List fav;
  late List rooms;
  // admin or user or manager
  late String status;
  AppUser(this.id, this.name, this.fav, this.status, this.rooms);
}