import 'dart:math';

String getRandomString({int length = 32}) {
  var result = '';
  var characters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
  var charactersLength = characters.length;

  for (var i = 0; i < length; i++) {
    result += characters[Random().nextInt(charactersLength)];
  }

  return result;
}
