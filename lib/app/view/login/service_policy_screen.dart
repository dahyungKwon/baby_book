import 'package:baby_book/base/resizer/fetch_pixels.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../base/color_data.dart';
import '../../../base/widget_utils.dart';

class ServicePolicyScreen extends StatefulWidget {
  const ServicePolicyScreen({Key? key}) : super(key: key);

  @override
  State<ServicePolicyScreen> createState() => _ServicePolicyScreenState();
}

class _ServicePolicyScreenState extends State<ServicePolicyScreen> {
  @override
  Widget build(BuildContext context) {
    FetchPixels(context);
    return WillPopScope(
        child: Scaffold(
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
                          getMultilineCustomFont("""제1장 총칙

제1조 (목적)
이 약관은 아이곰컴퍼니(이하 “회사”라 한다)가 운영하는 아이곰책육아 어플리케이션에서 제공하는 모바일 App 관련 서비스(이하 “서비스”라 한다)를 이용함에 있어 아이곰책육아와 이용자의 권리/의무 및 책임사항을 규정함을 목적으로 한다.

제2조 (용어의 정의) 
이 약관에서 사용하는 용어의 정의는 다음과 같습니다
1. 이용자 : 본 약관에 따라 회사에서 제공하는 서비스를 받는 자
2. 가입 : 회사가 제공하는 신청서 양식에 해당 정보를 기입하고, 회사의 이용약관에 동의하여 서비스 이용계약을 완료시키는 행위
3. 회원 : 서비스를 이용하기 위하여 이용약관에 동의하고, 회사의 회원으로 가입한 자
4. 아이디(ID) : 회원 식별과 회원의 서비스 이용을 위하여 회사에서 지정하거나 회원이 선정한 영문자와 숫자의 조합
5. 비밀번호 : 회원 식별과 회원의 서비스 이용을 위하여 회원임을 확인하고 개인정보보호를 위해 회원 자신이 설정한 문자와 숫자의 조합
6. 탈퇴 : 회원이 이용계약을 종료시키는 행위

제3조 (약관의 효력과 변경)
이용자가 본 약관에 동의하는 경우 회사의 서비스 제공 행위 및 귀하의 서비스 사용 행위에 대해 본 약관이 우선적으로 적용되어 그 효력이 발생한다.
회사가 필요하다고 인정되는 경우 본 약관을 임의로 변경할 수 있으며, 변경된 약관은 회사 내 공지하거나 전자우편 등의 방법으로 회원에게 공지 또는 통지함으로써 그 효력이 발생한다.
이용자가 변경된 약관에 동의하지 않는 경우, 서비스 이용을 중단하거나 회원등록을 취소 또는 탈퇴 할 수 있다.
단, 변경된 약관이 효력이 발생한 이후에도 서비스를 계속 사용할 경우 변경사항에 동의한 것으로 간주된다.

제4조 (약관 외 준칙)
본 약관에 명시되지 않은 사항은 전기통신기본법, 전기통신사업법, 정보통신윤리위원회 심의규정, 정보통신 윤리강령, 정보통신망 이용촉진 및 정보보호 등에 관한 법률 및 기타 관계 법령 등의 규정에 따른다.


제2장 서비스 이용


제5조 (이용계약의 성립)
1. 이용계약은 신청자가 온라인으로 회사에서 제공하는 소정의 회원가입신청양식에서 요구하는 사항을 기록하여 가입을 완료하는 것으로 성립된다.
2. 회사는 다음 각 호에 해당하는 이용계약에 대하여 가입을 취소할 수 있다.
① 다른 사람의 명의를 사용하여 신청한 경우
② 이용계약 신청서의 내용을 허위로 기재하였거나 신청한 경우
③ 다른 사람의 회사 서비스 이용을 방해하거나 그 정보를 도용하는 등의 행위를 한 경우
④ 회사를 이용하여 법령과 본 약관이 금지하는 행위를 하는 경우
⑤ 기타 회사가 정한 이용신청요건이 미비 된 경우
3. 회사는 다음 각 호에 해당하는 경우 그 사유가 해소될 때까지 이용계약 성립을 유보할 수 있다.
① 서비스 관련 제반 용량이 부족한 경우
② 기술상 장애 사유가 있는 경우
4. 회사는 회원 가입 및 이용계약을 신청한 이용자 중 다음 각 호에 해당하지 않는 한 회원으로 등록한다. 
- 가입신청자가 만 14세 미만인 경우
- 회원정보에 허위, 기재 누락, 오기가 있는 경우
- 가입신청자가 본 약관 제11조에 따라 이전에 회원자격을 상실한 적이 있는 경우(다만, 본 약관 제11조에 의한 회원자격 상실 후 6개월이 경과한 자로서 아기곰책육아의 회원 재가입 승낙을 얻은 경우에는 예외)
- 회원으로 등록하는 것이 기술상 현저히 곤란한 경우
- 기타 본 약관에 위배되거나 위법 또는 부당한 이용신청임이 확인된 경우 및 아기곰책육아가 합리적인 판단에 의하여 필요하다고 인정하는 경우
5. 아기곰책육아는 회원의 종류 및 등급을 구분할 수 있으며, 구분별로 이용할 수 있는 아기곰책육아의 서비스 종류, 혜택을 세분하는 등으로 회원 간 이용에 차등을 둘 수 있습니다.

제6조 (이용계약사항의 변경)
회원은 이용계약 시 기재한 사항이 변경되었을 경우에는 그 정보를 수정 및 갱신하여야 하며 미변경으로 인하여 발생하는 문제의 책임은 회원 본인에게 있다.

제7조 (이용계약의 해지)
회원이 서비스 이용계약을 해지하고자 할 경우에는 온라인 또는 회사에서 정하는 방법을 통하여 이용계약의 해지를 신청해야 한다.

제8조 (회원정보 사용에 대한 동의)
1. 회원의 개인정보는 개인정보보호법에 의해 보호된다.
2. 회원의 개인정보는 본 이용계약의 이행과 본 이용계약상의 서비스 제공을 위한 목적으로만 이용된다.
3. 이용자가 본 약관에 동의하는 것은 회사가 회원가입신청양식에 기재된 회원정보를 수집ㆍ이용하는 것에 동의하는 것으로 간주된다.

제9조 (회원의 정보 보안)
1. 회사 회원가입절차를 완료하는 순간부터 회원의 개인정보의 비밀을 유지할 책임은 전적으로 회원 본인에게 있다.
2. 회원아이디와 비밀번호에 관한 모든 관리의 책임은 회원 본인에게 있으며, 회원아이디나 비밀번호가 부정하게 사용되었다는 사실을 발견한 경우에는 즉시 회사에 신고하여야 한다. 신고를 하지 않음으로 인한 모든 책임은 회원 본인에게 있다.
3. 회원아이디와 비밀번호 관리의 소홀 등의 결과로 인해 발생하는 손해 및 손실에 관한 모든 책임은 회원 본인에게 있다.

제10조 (서비스 이용시간)
1. 서비스의 이용은 회사의 업무상 또는 기술상 특별한 지장이 없는 한 연중무휴, 1일 24시간 제공하는 것을 원칙으로 한다. 다만, 회사의 정기점검 등의 서비스 점검 및 조치 등을 위하여 필요로 하는 시간은 그러하지 아니한다.
2. 회사는 서비스별로 이용할 수 있는 시간을 별도로 정할 수 있으며, 필요한 경우에는 이를 조정할 수 있다.

제11조 (서비스 제공의 중지)
1. 회사는 다음 각 호에 해당하는 경우 서비스 제공을 중지할 수 있다.
① 시설 설비의 보수 등 공사로 인한 부득이한 경우
② 전기통신사업법에 규정된 기간통신사업자가 전기통신 서비스를 중지하였을 경우
③ 기타 불가항력적 사유가 있는 경우
2. 회사는 국가비상사태, 정전, 서비스 설비의 장애 또는 서비스 이용의 폭주 등으로 정상적인 서비스 이용에 지장이 있는 때에는 서비스의 전부 또는 일부를 제한하거나 정지할 수 있다.
3. 회사는 이용자가 본 약관의 내용에 위배되는 행동을 한 경우, 임의로 서비스 사용을 제한 및 중지할 수 있다.

제12조 (게시물의 저작권)
1. 게시물에 대한 권리와 책임은 전적으로 게시자에게 있다.
2. 회원은 서비스를 이용하여 얻은 정보를 가공, 판매하는 행위 등 서비스에 게시된 자료를 상업적으로 이용할 수 없다.
3. 회사는 회원이 게시하거나 등록하는 서비스 내의 내용물이 다음 각 호에 해당된다고 판단되는 경우에 사전통지 없이 삭제할 수 있다.
① 다른 회원 또는 제3자를 비방하거나 중상모략으로 명예를 손상시키는 내용인 경우
② 공공질서 및 미풍양속에 위반되는 내용인 경우
③ 범죄적 행위에 결부된다고 인정되는 내용인 경우
④ 회사의 저작권, 제3자의 저작권 등 기타 권리를 침해하는 내용인 경우
⑤ 회사에서 규정한 게시기간을 초과한 경우
⑥ 기타 관계법령에 위반된다고 판단되는 경우
4. 회원이 게시한 게시물의 내용이 타인의 저작권을 침해함으로써 발생하는 모든 책임은 전적으로 회원 본인에게 있다.

제13조 (정보의 제공)
회사는 회원이 서비스 이용 중 필요가 있다고 인정되는 다양한 정보에 대해 전자우편이나 서신우편 등의 방법으로 회원에게 제공할 수 있다. 단, 회원이 원치 않을 경우 정보수신거부를 할 수 있다.


제3장 의무와 책임


제14조 (회사의 의무)
회사는 회원의 개인정보를 본인의 승낙 없이 제3자에게 누설, 배포되지 않는다. 단, 개인정보보호법 등의 규정에 의해 국가기관의 요구가 있는 경우, 범죄에 대한 수사상의 목적이 있거나 정보통신윤리위원회의 요청이 있는 경우 또는 기타 관계법령에서 정한 절차에 따른 요청이 있는 경우, 귀하가 회사에 제공한 개인정보를 스스로 공개한 경우에는 그러하지 아니한다.

제15조 (이용자의 의무)
1. 이용자는 서비스를 이용할 때 다음 각 호의 행위를 하여서는 아니 되며, 이로 인하여 문제가 발생될 경우 그 책임은 본인에게 있다.
① 타인의 개인정보, 아이디와 비밀번호 및 공인인증서 등의 정보를 부정 사용하는 행위
② 본인 개인정보, 아이디와 비밀번호 및 공인인증서 등의 정보를 타인에게 이용하게 하는 행위
③ 범죄행위를 목적으로 하거나 기타 범죄행위와 관련된 행위
④ 타인의 명예를 훼손하거나 모욕하는 행위
⑤ 타인의 지적재산권 등의 권리를 침해하는 행위
⑥ 해킹행위 또는 컴퓨터바이러스의 유포행위
⑦ 타인의 의사에 반하여 광고성 정보 등 일정한 내용을 지속적으로 전송하는 행위
⑧ 서비스의 안전적인 운영에 지장을 주거나 줄 우려가 있는 일체의 행위
⑨ 회사에 게시된 정보를 변경하는 행위
⑩ 본 약관 및 회사의 운영기준, 기타 관계 법령 등에 위배되는 행위
2. 이용자는 본 약관에서 규정하는 서비스 사항과 서비스 이용안내, 공지사항 또는 주의사항을 준수하여야 한다.
3. 이용자는 회사 서비스를 이용하여 얻은 정보를 회사의 사전승낙 없이 복사, 복제, 변경, 출판·방송 기타의 방법으로 사용하거나 이를 타인에게 제공할 수 없다.


제4장 아기곰책육아 이용 방법


제 16조 (통지 및 공지)
이용자는 언제든지 고객센터 또는 고객의 소리를 방문하여 서비스와 관련한 의견을 전달할 수 있다. 아기곰책육아의 회원에 대한 통지는 회원정보에 기재된 E-mail 주소로의 발송 또는 휴대폰 번호로 알림톡을 보내는 등 전자적 방법으로 이뤄지며, 이러한 전자적 통지가 회원에 도달한 때에 효력이 발생한다. 회사가 불특정 다수의 회원에게 통지를 하는 경우 1주일 이상 아기곰책육아에 게시하는 방법으로 상기 개별 통지를 대신할 수 있다. 

제 17 조 (회원탈퇴 등)
1. 회원이 더이상 아기곰책육아 이용을 원치 않는 때에는 언제든지 아기곰책육아를 통하여 탈퇴를 요청할 수 있으며, 회사는 즉시 탈퇴 조치를 한다. 단, 회원탈퇴로 인해 발생하는 불이익은 회원 본인이 부담하여야 하며, 탈퇴 처리가 완료되면 아기곰책육아가 회원에게 부가적으로 제공한 각종 혜택이 소멸 또는 회수될 수 있으니 신중하게 탈퇴 요청하여야 한다. 
2. 탈퇴한 회원이 다시 한번 아기곰책육아 이용을 희망할 경우, 회사는 그를 거절할 수 있으며 소정의 기준에 따라 서비스의 재이용을 허락할 수 있다. 
3. 회원이 다음 각 호의 사유에 해당하는 경우 아기곰책육아는 부득이하게 회원자격을 제한 및 상실시키거나 재이용에 제한을 둘 수 있다. 
- 회원이 사망한 경우
- 서비스 이용과 관련하여 회원이 부담하는 채무를 기일에 지급하지 않는 경우
- 회원 승낙거부사유가 있음이 확인된 경우
- ID 이용제한 사유가 있음이 확인된 경우
- 아기곰책육아 및 기타 제3자의 저작권 등 지식재산권에 대한 침해행위가 확인된 경우
- 아기곰책육아 및 기타 제3자의 명예를 손상시키거나 업무를 방해하는 행위가 확인된 경우
- 외설 또는 폭력적인 메시지, 화상, 음성, 기타 공서양속에 반하는 정보 및 성별, 종교, 장애, 연령 등을 차별하거나 이에 대한 편견을 조장하는 내용 등 본 약관을 위배하는 행위가 확인된 경우
- 본 약관 또는 개별약관을 위반한 경우
- 기타 회원의 불법행위 등 아기곰책육아가 서비스 제공을 거부할 필요가 있다고 인정하는 경우
4. 아기곰책육아가 회원자격을 상실시키는 경우에는 회원 등록을 말소한다. 이 경우 회원에게 이를 통지하고, 소명할 기회를 부여한다. 
5. 본 조에 의하여 아기곰책육아가 회원자격을 상실시키더라도, 상실 이전에 이용한 서비스와 관련하여서는 본 약관이 적용된다. 


제5장 기타


제18조 (양도금지)
회원이 서비스의 이용권한, 기타 이용계약상의 지위를 타인에게 양도, 증여할 수 없으며, 이를 담보로 제공할 수 없다.

제19조 (손해배상)
회사는 서비스와 관련하여 이용자에게 어떠한 손해가 발생하더라도 회사가 고의로 행한 범죄행위를 제외하고는 이에 대하여 책임을 부담하지 아니한다.

제20조 (면책사항)
1. 회사는 귀하가 서비스를 이용하여 기대하는 손익이나 서비스를 통하여 얻은 자료로 인한 손해 등에 관하여 책임을 지지 않으며, 이용자가 본 서비스에 게시한 정보, 자료, 사실의 신뢰도, 정확성 등의 내용에 대하여 책임을 지지 않는다.
2. 회사는 회원간 또는 회원과 제3자간에 서비스를 매개로 하여 물품거래, 금전거래 등과 관련하여 어떠한 책임도 부담하지 아니한다.
3. 회사는 천재지변, 정전, 회사의 관리 범위 외의 서비스 시설 장애, 서비스 이용량의 폭주 기타 서비스 장애 등으로 정상적인 서비스를 제공하지 못하여 생기는 손해 등에 대하여 책임을 지지 아니한다.

제21조 (재판관할)
서비스 이용과 관련하여 회사와 이용자 및 회원 사이에 분쟁이 발생한 경우, 쌍방간의 분쟁의 해결을 위해 성실히 협의한 후가 아니면 제소할 수 없다.


부 칙
제1조 (시행일)
본 약관은 제정 및 개정 후 회사에 공지한 날로부터 시행한다.
 
처리방침 시행일
2023년 8월 1일

""", 16, Colors.black, fontWeight: FontWeight.w400, txtHeight: 1.3)
                        ])))
              ],
            ),
          ),
        ),
        onWillPop: () async {
          Get.back();
          return false;
        });
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
              "서비스 이용약관",
              22,
              Colors.black,
              1,
              fontWeight: FontWeight.w600,
            ),
          ],
        ));
  }
}
