import 'package:baby_book/base/resizer/fetch_pixels.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../base/color_data.dart';
import '../../../base/widget_utils.dart';

class PrivacyPolicyScreen extends StatefulWidget {
  const PrivacyPolicyScreen({Key? key}) : super(key: key);

  @override
  State<PrivacyPolicyScreen> createState() => _PrivacyPolicyScreenState();
}

class _PrivacyPolicyScreenState extends State<PrivacyPolicyScreen> {
  @override
  Widget build(BuildContext context) {
    FetchPixels(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: backGroundColor,
      body: SafeArea(
        child: Column(
          children: [
            buildTop(context),
            // getVerSpace(FetchPixels.getPixelHeight(30)),
            Expanded(
                child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(
                        vertical: FetchPixels.getPixelWidth(15), horizontal: FetchPixels.getPixelWidth(25)),
                    child: Column(children: [
                      getMultilineCustomFont("""1. 개인정보 처리방침이란?
아기곰책육아(이하"회사")는 이용자의 ‘동의를 기반으로 개인정보를 수집·이용 및 제공’하고 있으며, ‘이용자의 권리 (개인정보 자기결정권)를 적극적으로 보장’합니다.
회사는 정보통신서비스제공자가 준수하여야 하는 대한민국의 관계 법령 및 개인정보보호 규정, 가이드라인을 준수하고 있습니다.
“개인정보처리방침”이란 이용자의 소중한 개인정보를 보호함으로써 이용자가 안심하고 서비스를 이용할 수 있도록 회사가 준수해야 할 지침을 의미합니다.
본 개인정보처리방침은 본 회사가 제공하는 서비스(이하 ‘서비스'라 함)에 적용됩니다.
회사의 개인정보 처리방침은 법령 및 고시 등의 변경 또는 회사의 약관 및 내부 정책에 따라 변경될 수 있으며 이를 개정하는 경우 회사는 변경사항에 대하여 회사 홈페이지에 공지합니다.
이용자는 개인정보의 수집, 이용, 제공, 위탁 등과 관련한 아래 사항에 대하여 원하지 않는 경우 동의를 거부할 수 있습니다. 다만, 이용자가 동의를 거부하는 경우 서비스의 전부 또는 일부를 이용할 수 없음을 알려드립니다.


2. 개인정보 수집
서비스 제공을 위한 필요 최소한의 개인정보를 수집하고 있습니다.
회원 가입 시 또는 서비스 이용 과정에서 홈페이지 또는 개별 어플리케이션이나 프로그램 등을 통해 아래와 같은 서비스 제공을 위해 필요한 최소한의 개인정보를 수집하고 있으며,
모든 개인정보는 특정개인을 식별 할 수 없도록 암호화 조치합니다.

2-1 개인정보의 수집방법 
회사는 다음과 같은 방법으로 개인정보를 수집합니다. 
   - 서비스 가입이나 사용 중 이용자의 자발적 제공을 통한 수집
   - 회원의 선택에 따라 카카오톡 등 SNS 아이디를 이용하여 로그인하는 회원의 경우 해당 회사에서 회원에게 동의를 받은 후 제공받아 수집
   - 기기정보, 서비스 이용 기록 등 생성정보는 서비스 이용과정에서 자동으로 수집
2-2 필수 항목
   - 회원의 개인정보 : 카카오톡 등 SNS 계정으로 접속 시 해당 계정 ID정보, 자녀와의 관계, 이름(닉네임)
   - 회원의 자녀정보 : 성별, 닉네임, 생일
2-3 서비스 이용시 아래와 같은 정보들이 자동으로 생성되어 수집될 수 있습니다.
   - IP Address, 쿠키, 기기정보, 방문 일시, 서비스 이용 기록, 사용자 작성 컨텐츠 (텍스트, 이미지, 비디오) 등
2-4 회사는 소셜 로그인(이하 “OAuth“라고 함)을 사용하도록 하고 있습니다. OAuth 서비스 제공자의 OAuth 서비스를 이용하고자 할 경우 다음의 필수 정보를 입력하여야 합니다.
  - 이용자 ID : OAuth를 제공하는 서비스의 사용자ID
또한, OAuth 서비스 제공자의 OAuth 서비스 이용 시 고객님의 데이터에 액세스하고 서비스에 사용할 수 있습니다. OAuth 서비스 이용 과정에서 자동생성 되어 저장되는 정보는 아래와 같습니다.
  - OAuth 서비스 제공자에게 전달받은 Token 정보
    회사는 OAuth 서비스를 이용하여 제공받은 데이터나 개인정보를 저장하지 않습니다. OAuth 서비스의 이용을 원치 않는 경우 언제든지 연결 해제 버튼을 클릭하여 연결을 해제할 수 있으며, 이 경우 저장되어 있던 Token 정보는 삭제됩니다.


3. 개인정보의 공유 및 제공
회사는 회원의 개인정보를 '개인정보의 수집 및 이용 목적'에서 명시한 범위에서 사용하며, 이에 따라 서비스 이용과정에서 다음의 정보가 공개될 수 있습니다. 또한, 서비스의 목적상 필수적으로 제공되어야 하거나 회원의 사전 동의가 있는 경우 또는 아래 예외적인 경우를 제외하고는, 그 범위를 초과하여 이용하거나 제3자에 제공하지 않습니다.

- 이용자가 사전에 동의한 경우
- 법령의 규정에 의거하거나, 수사 목적으로 법령에 정해진 절차와 방법에 따라 수사기관의 요구가 있는 경우   
- 매각, 인수합병등에 의해 서비스 제공자의 권리, 의무가 승계 또는 이전되는 경우 이를 사전에 고지하며 이용자의 개인정보에 대한 동의 철회의 선택권을 부여합니다.


4. 개인정보의 취급 위탁
원칙적으로 이용자 동의 없이 개인정보를 외부에 제공하지 않습니다.
이용자의 사전 동의 없이 개인정보를 외부에 제공하지 않습니다. 단, 이용자가 외부 제휴사의 서비스를 이용하기 위하여 개인정보 제공에 직접 동의를 한 경우, 그리고 관련 법령에 의거해 개인정보 제출 의무가 발생한 경우, 이용자의 생명이나 안전에 급박한 위험이 확인되어 이를 해소하기 위한 경우에 한하여 개인정보를 제공하고 있습니다.


5. 개인정보 보유 및 이용기간
- 회원의 개인정보는 원칙적으로 개인정보의 수집 및 이용 목적이 달성되면 지체 없이 파기합니다. 단, 다음의 경우에 대해서는 상법 등 관계법령 및 회사 방침에 따라서 아래의 보존 이유를 위해 명시한 기간 동안 보존합니다.
- 개인정보보호를 위하여 이용자가 180일 이상 서비스를 이용하지 않은 경우 개인정보를 휴면계정으로 분리하여 해당 계정의 이용을 중지할 수 있습니다. 또한 휴면 계정 전환 후 1년 이상 로그인 시도 기록이 없는 경우 계정이 자동 탈퇴 처리됩니다. 

5-1 계약 또는 청약철회 등에 관한 기록: 5년 (전자상거래 등에서의 소비자보호에 관한 법률)
5-2 대금결제 및 재화 등의 공급에 관한 기록: 5년 (전자상거래 등에서의 소비자보호에 관한 법률)
5-3 소비자의 불만 또는 분쟁처리에 관한 기록: 3년 (전자상거래 등에서의 소비자보호에 관한 법률)
5-4 웹사이트 또는 플랫폼 방문기록, 서비스 이용기록 : 3개월 (통신비밀보호법)
5-5 부정이용기록: 1년 (내부 방침에 따른 부정이용, 거래의 방지)


6. 개인정보의 파기
개인정보는 수집 및 이용목적이 달성되면 지체없이 파기하며, 절차 및 방법은 아래와 같습니다.
전자적 파일 형태인 경우 복구 및 재생되지 않도록 안전하게 삭제하고, 그 밖에 기록물, 인쇄물, 서면 등의 경우 분쇄하거나 소각하여 파기합니다.
다만, 내부 방침에 따라 일정 기간 보관 후 파기하는 정보는 아래와 같습니다.

- 파기절차 : 이용자가 입력한 정보는 목적 달성 후 별도의 DB에 옮겨져(종이의 경우 별도의 서류) 내부 방침 및 기타 관련 법령에 따라 일정기간 저장된 후 혹은 즉시 파기됩니다. 이 때, DB로 옮겨진 개인정보는 법률에 의한 경우가 아니고서는 다른 목적으로 이용되지 않습니다.
- 파기기한 : 이용자의 개인정보는 개인정보의 보유기간이 경과된 경우에는 보유기간의 종료일로부터 5일 이내에, 개인정보의 처리 목적 달성, 해당 서비스의 폐지, 사업의 종료 등 그 개인정보가 불필요하게 되었을 때에는 개인정보의 처리가 불필요한 것으로 인정되는 날로부터 5일 이내에 그 개인정보를 파기합니다.
- 파기방법 : 종이에 출력된 개인정보는 분쇄기로 분쇄하거나 소각을 통하여 파기하며 전자적 파일 형태의 정보는 기록을 재생할 수 없는 기술적 방법을 사용합니다.


7. 개인정보의 열람, 수정, 삭제 및 개인정보의 도용
이용자는 언제든지 자신의 개인정보를 열람, 공개 및 비공개 처리하거나 수정할 수 있으며 삭제 및 파기를 요청할 수 있습니다.

- 이용자는 언제든지 등록되어 있는 자신의 개인정보를 열람, 수정 및 삭제 할 수 있으며, 회사의 개인정보 처리에 동의하지 않는 경우 동의를 거부하거나 가입해지(회원탈퇴)를 요청할 수 있습니다. 다만, 그러한 경우 서비스 이용이 제한될 수 있습니다.
- 이용자의 개인정보 열람, 수정은 서비스내의 ‘회원정보수정’을 이용하거나 고객센터를 통하여 가능하며, 가입해지(동의철회)를 위해서는 ‘회원탈퇴’ 클릭 또는 고객센터로의 문의를 통해서 가능합니다.
- 회사는 이용자의 요청에 의해 삭제된 개인정보 및 회원 탈퇴 후의 개인정보에 대해서는 “개인정보의 보유 및 이용기간”에 명시된 바에 따라 처리하고 그 외의 용도로 열람 또는 이용할 수 없도록 관리하고 있습니다.
- 회사는 이용자의 권리에 따른 열람의 요구, 정정 및 삭제 요구, 회원 탈퇴 등의 요구 시 그 요구를 한 자가 본인이거나 정당한 대리인인지를 확인 합니다.
- 회사는 타인의 휴대폰 번호, 이메일 주소 및 제휴업체 아이디 또는 기타 개인정보를 도용하여 회원가입한 자 또는 서비스를 이용한 자를 발견한 경우 지체 없이 해당 아이디에 대한 서비스 이용 정지 또는 회원 탈퇴 등 필요한 조치를 취합니다.


8. 회원의 권리와 의무
회원은 개인정보를 보호받을 권리와 함께 스스로를 보호하고 타인의 정보를 침해하지 않을 의무도 가지고 있습니다. 비밀번호를 포함한 회원의 개인정보가 유출되지 않도록 조심하시고 게시물을 포함한 타인의 개인정보를 훼손하지 않도록 유의해 주십시오. 회원이 입력한 부정확한 정보로 인해 발생하는 사고의 책임은 이용자 자신에게 있습니다. 회원은 개인정보를 최신의 상태로 정확하게 입력하여 불의의 사고를 예방하여야 할 의무가 있습니다. 회원이 위 책임을 다하지 못하고 타인의 정보 및 존엄성을 훼손할 시에는 『정보통신망 이용촉진 및 정보보호 등에 관한 법률』등 관련 법률에 의해 처벌받을 수 있습니다


9. 개인정보의 기술적/관리적 보호대책
이용자의 개인정보를 가장 소중한 가치로 여기고 개인정보를 처리함에 있어서 다음과 같은 노력을 다하고 있습니다.
- 이용자의 개인정보를 암호화하고 있습니다.
- 이용자의 개인정보를 암호화된 통신구간을 이용하여 전송하고, 비밀번호 등 중요정보는 암호화하여 보관하고 있습니다.
- 처리 직원의 최소화 및 교육 회사의 개인정보관련 처리 직원은 담당자에 한정시키고 있고 이를 위한 별도의 비밀번호를 부여하여 정기적으로 갱신하고 있으며, 담당자에 대한 수시 교육을 통하여 회사의 개인정보처리방침의 준수를 항상 강조하고 있습니다.
- 개인정보보호전담기구의 운영 회사는 사내 개인정보보호전담기구 등을 통하여 회사의 개인정보처리방침의 이행사항 및 담당자의 준수여부를 확인하여 문제가 발견될 경우 즉시 수정하고 바로 잡을 수 있도록 노력하고 있습니다. 단, 회원 본인의 부주의나 회사의 고의 또는 중대한 과실이 아닌 사유로 개인정보가 유출되어 발생한 문제에 대해 회사는 일체의 책임을 지지 않습니다.


10. 개인정보관리 책임자
서비스를 이용하면서 발생하는 모든 개인정보보호 관련 문의, 불만, 조언이나 기타 사항은 개인정보 보호책임자 및 담당부서로 연락해 주시기 바랍니다.  여러분의 목소리에 귀 기울이고 신속하고 충분한 답변을 드릴 수 있도록 최선을 다하겠습니다.
이메일 : ko.babybear.book@gmail.com

기타 개인정보침해에 대한 신고나 상담이 필요하신 경우에는 아래 기관에 문의하시기 바랍니다.
- 개인정보침해신고센터 (www.118.or.kr / 118)
- 정보보호마크인증위원회 (www.eprivacy.or.kr / 02-580-0533~4)
- 대검찰청 사이버수사과 (cid@spo.go.kr / 국번없이 1301)
- 경찰청 사이버수사국 (www.ecrm.cyber.go.kr / (국번없이 182)


11. 고지의 의무
법률이나 서비스의 변경사항을 반영하기 위한 목적 등으로 개인정보처리방침을 수정할 수 있습니다. 개인정보처리방침이 변경되는 경우 회사는 변경 사항을 게시하며, 변경된 개인정보처리방침은 게시한 날로부터 7일 후부터 효력이 발생합니다.
다만, 수집하는 개인정보의 항목, 이용목적의 변경 등과 같이 이용자 권리의 중대한 변경이 발생할 때에는 최소 30일 전에 미리 알려드리겠습니다.
- 공고일자: 2023년 07월 01일
- 시행일자: 2023년 08월 01일

""", 16, Colors.black, fontWeight: FontWeight.w400, txtHeight: 1.3)
                    ])))
          ],
        ),
      ),
    );
  }

  Widget buildTop(BuildContext context) {
    return Container(
        padding: const EdgeInsets.fromLTRB(5, 10, 0, 0),
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            getSimpleImageButton("back_outline.svg", FetchPixels.getPixelHeight(50), FetchPixels.getPixelHeight(50),
                Colors.white, FetchPixels.getPixelHeight(26), FetchPixels.getPixelHeight(26), () async {
              Get.back();
            }),
            getCustomFont(
              "개인정보 처리방침",
              22,
              Colors.black,
              1,
              fontWeight: FontWeight.w600,
            ),
          ],
        ));
  }
}
