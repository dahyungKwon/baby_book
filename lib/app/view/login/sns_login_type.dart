enum SnsLoginType {
  kakao("KAKAO", "카카오 로그인"),
  apple("APPLE", "애플 로그인"),
  none("NONE", "선택안함");

  final String code;
  final String desc;

  const SnsLoginType(this.code, this.desc);

  static SnsLoginType findByCode(String code) {
    return SnsLoginType.values.firstWhere((value) => value.code == code, orElse: () => SnsLoginType.none);
  }
}
