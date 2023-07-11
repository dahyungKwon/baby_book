import 'package:flutter/services.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import '../../base/pref_data.dart';

Future<bool> isLogin() async {
  return await PrefData.getAccessToken().then((accessToken) async {
    if (accessToken == null) {
      return false;
    }

    return await AuthApi.instance.hasToken() && await validateKakaoToken();
  });
}

Future<bool> isAgreed() async {
  return await PrefData.getAgreed().then((agreed) async {
    if (agreed == null) {
      return false;
    }

    return agreed;
  });
}

Future<bool> validateKakaoToken() async {
  try {
    AccessTokenInfo tokenInfo = await UserApi.instance.accessTokenInfo();
    print('토큰 유효성 체크 성공 ${tokenInfo.id} ${tokenInfo.expiresIn}');
    return true;
  } catch (error) {
    if (error is KakaoException && error.isInvalidTokenError()) {
      print('토큰 만료 $error');
    } else {
      print('토큰 정보 조회 실패 $error');
    }

    return false;
  }
}

Future<OAuthToken?> kakaoLogin() async {
  // 카카오톡 실행 가능 여부 확인
  // 카카오톡 실행이 가능하면 카카오톡으로 로그인, 아니면 카카오계정으로 로그인
  if (await isKakaoTalkInstalled()) {
    try {
      print('카카오톡 존재');
      OAuthToken token = await UserApi.instance.loginWithKakaoTalk();
      print('카카오톡으로 로그인 성공 ${token.accessToken}');
      return token;
    } catch (error) {
      print('카카오톡으로 로그인 실패 $error');

      // 사용자가 카카오톡 설치 후 디바이스 권한 요청 화면에서 로그인을 취소한 경우,
      // 의도적인 로그인 취소로 보고 카카오계정으로 로그인 시도 없이 로그인 취소로 처리 (예: 뒤로 가기)
      if (error is PlatformException && error.code == 'CANCELED') {
        return null;
      }
      // 카카오톡에 연결된 카카오계정이 없는 경우, 카카오계정으로 로그인
      try {
        print('카카오톡에 연결된 계정없음');
        OAuthToken token = await UserApi.instance.loginWithKakaoAccount();
        print('카카오계정으로 로그인 성공 ${token.accessToken}');
        return token;
      } catch (error) {
        print('카카오계정으로 로그인 실패 $error');
      }
    }
  } else {
    //카카오톡이 없는 케이스
    try {
      print('카카오톡 없음');
      OAuthToken token = await UserApi.instance.loginWithKakaoAccount();
      print('카카오계정으로 로그인 성공 ${token.accessToken}');
      return token;
    } catch (error) {
      print('카카오계정으로 로그인 실패 $error');
    }
  }

  return null;
}
