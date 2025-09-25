enum Flags {
  yes,
  no;

  @override
  String toString() {
    switch (this) {
      case Flags.yes:
        return "Y";
      case Flags.no:
        return "N";
    }
  }
}
