class User {
  final String id;
  final String userName;
  final String email;
  final String password;
  final String? profileImage;

  User({
    required this.id,
    required this.userName,
    required this.email,
    required this.password,
    this.profileImage = 'https://via.placeholder.com/150',
  });
}
