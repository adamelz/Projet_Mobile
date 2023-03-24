
class Utilisateur {
  final String username;
  final String email;
  final String motDePasse;

  Utilisateur({required this.username, required this.email, required this.motDePasse});

  Map<String, dynamic> toJson() {
    return {
      'surnom': username,
      'email': email,
      'motDePasse': motDePasse
    };
  }
}
