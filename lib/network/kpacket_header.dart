class MalformedPacket implements Exception {}

class KPacketHeader {
  static const List<int> MAGIC_NUMBER = [0xC1, 0xA0];
  static const int HEADER_LENGTH = 16;

  final int bodyLength;
  final bool isKeepAlive;

  int get bodyAndHeaderLength => this.bodyLength + HEADER_LENGTH;

  KPacketHeader({required this.bodyLength, this.isKeepAlive = true});

  static List<int> headerLengthIntToBytes(int value) => [
        (value >> 24) & 0xFF,
        (value >> 16) & 0xFF,
        (value >> 08) & 0xFF,
        (value >> 00) & 0xFF,
      ];

  static int headerLengthBytesToInt(List<int> bytes) =>
      ((bytes[0] << 24) & 0xFF000000) +
      ((bytes[1] << 16) & 0x00FF0000) +
      ((bytes[2] << 08) & 0x0000FF00) +
      ((bytes[3] << 00) & 0x000000FF);

  static KPacketHeader fromBytes(List<int> bytes) {
    // Header length sanity check
    if (bytes.length != 16) {
      throw MalformedPacket();
    }

    final bodyLengthBytes = bytes.sublist(2, 6);
    final keepAliveBytes = bytes.sublist(6, 10);

    final bodyLength = KPacketHeader.headerLengthBytesToInt(bodyLengthBytes);
    final isKeepAlive = keepAliveBytes.last == 1;

    return KPacketHeader(bodyLength: bodyLength, isKeepAlive: isKeepAlive);
  }

  List<int> toBytes() => [
        ...MAGIC_NUMBER, // 2 bytes
        ...KPacketHeader.headerLengthIntToBytes(this.bodyLength), // 4 bytes
        ...[0, 0, 0, this.isKeepAlive ? 1 : 0], // 4 bytes
        ...[0, 0, 0, 0, 0, 0], // 6 bytes
      ];
}
