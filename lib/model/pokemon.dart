class Pokemon {
  String id;
  final String name;
  final String size;
  final String element1;
  final String element2;
  final String bio;
  final String pokeballType;

  Pokemon({
    this.id = '',
    required this.name,
    required this.size,
    required this.element1,
    required this.element2,
    required this.pokeballType,
    required this.bio,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'size': size,
    'element1': element1,
    'element2': element2,
    'pokeballType': pokeballType,
    'bio': bio
  };

  static Pokemon fromJson(Map<String, dynamic> json) => Pokemon(
      id: json['id'],
      name: json['name'],
      size: json['size'],
      element1: json['element1'],
      element2: json['element2'],
      bio: json['bio'],
      pokeballType: json['pokeballType']);
}