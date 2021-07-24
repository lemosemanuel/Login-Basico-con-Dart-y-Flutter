bool esNumero(String i) {
  // si es nulo ya de por si no es un numero , retorno false
  if (i.isEmpty) return false;
  // veo si se puede parsear a numero
  final n = num.tryParse(i);
  return (n == null) ? false : true;
}
