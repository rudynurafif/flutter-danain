String hashEmail(String email) {
  if (email.isEmpty) {
    return email; // Return the empty string if the email is empty
  }

  final parts = email.split('@');
  if (parts.length != 2) {
    return email; // Return the original email if it doesn't contain exactly one "@" symbol
  }

  final username = parts[0];
  final domain = parts[1];

  // Keep the first few characters (e.g., 3) of the username and replace the rest with asterisks
  final obfuscatedUsername = username.substring(0, 3) + '*' * (username.length - 3);

  // Combine the obfuscated username and the original domain
  final obfuscatedEmail = '$obfuscatedUsername@$domain';

  return obfuscatedEmail;
}
