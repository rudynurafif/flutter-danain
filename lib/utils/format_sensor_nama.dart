String formatSensorNama(String nama) {
  final List<String> namaParts = nama.split(' ');
  if (namaParts.length > 1) {
    return '${namaParts[0]} ${'*' * (namaParts[1].length)}';
  } else {
    return nama;
  }
}
