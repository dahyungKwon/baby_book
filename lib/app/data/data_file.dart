import 'package:baby_book/app/models/model_address.dart';
import 'package:baby_book/app/models/model_age_group.dart';
import 'package:baby_book/app/models/model_book_detail.dart';
import 'package:baby_book/app/models/model_book_state.dart';
import 'package:baby_book/app/models/model_booking.dart';
import 'package:baby_book/app/models/model_card.dart';
import 'package:baby_book/app/models/model_cart.dart';
import 'package:baby_book/app/models/model_category.dart';
import 'package:baby_book/app/models/model_color.dart';
import 'package:baby_book/app/models/model_country.dart';
import 'package:baby_book/app/models/model_intro.dart';
import 'package:baby_book/app/models/model_notification.dart';
import 'package:baby_book/app/models/model_other.dart';
import 'package:baby_book/app/models/model_popular_service.dart';
import 'package:baby_book/app/models/model_salon.dart';

import '../../base/color_data.dart';

class DataFile {
  static List<ModelIntro> introList = [
    ModelIntro(
        1,
        "Best Services For Your Home ",
        "Homecare is health care provided by a professional caregiver in the individual home.",
        "intro1.png",
        intro1Color),
    ModelIntro(
        2,
        "Care Your Home With Us",
        "Some nurses travel to multiple homes per day and provide short visits to multiple patients.",
        "intro2.png",
        intro2Color),
    ModelIntro(
        3,
        "Using Smart Gadgets ",
        "Homecare is also known as domiciliary care, social care or in-home care.",
        "intro3.png",
        intro3Color),
  ];

  static List<ModelCountry> countryList = [
    ModelCountry("image_fghanistan.jpg", "Afghanistan (AF)", "+93"),
    ModelCountry("image_ax.jpg", "Aland Islands (AX)", "+358"),
    ModelCountry("image_albania.jpg", "Albania (AL)", "+355"),
    ModelCountry("image_andora.jpg", "Andorra (AD)", "+376"),
    ModelCountry("image_islands.jpg", "Aland Islands (AX)", "+244"),
    ModelCountry("image_angulia.jpg", "Anguilla (AL)", "+1"),
    ModelCountry("image_armenia.jpg", "Armenia (AN)", "+374"),
    ModelCountry("image_austia.jpg", "Austria (AT)", "+372"),
  ];

  static List<ModelCategory> categoryList = [
    ModelCategory("자연관찰"),
    ModelCategory("자연동화"),
    ModelCategory("수학동화"),
    ModelCategory("과학동화"),
    ModelCategory("창작동화"),
    ModelCategory("전래동화"),
    ModelCategory("명작동화"),
    ModelCategory("위인전기"),
    ModelCategory("역사영역"),
    ModelCategory("육아서"),
  ];

  static List<ModelSalon> salonProductList = [
    ModelSalon("hair1.png", "Haircut", "Men’s Haircut", "4.5", 10.00, 0),
    ModelSalon("shaving.png", "Shaving", "Men’s Beard Shave", "4.4", 8.00, 0),
    ModelSalon("facecare.png", "Face Care", "Men’s Face Care", "4.4", 12.00, 0),
    ModelSalon(
        "haircolor.png", "Hair Color", "Men’s Hair Color", "4.4", 8.00, 0),
  ];

  static List<ModelColor> hairColorList = [
    ModelColor("blackhair.png", "Black", "Black Hair Color", "4.5", 6.00, 0),
    ModelColor("brownhair.png", "Brown", "Brown Hair Color", "4.5", 10.00, 0),
  ];

  static Map<String, ModelCart> cartList = {};

  static List<ModelOther> otherProductList = [
    ModelOther("beard_shape.png", "Beard Shaping", 13.00, 0),
    ModelOther("head_massage.png", "Head Massage", 16.00, 0),
  ];

  static List<String> timeList = [
    "06:00 AM",
    "08:00 AM",
    "10:00 AM",
    "12:00 PM",
    "13:00 PM",
    "14:00 PM",
    "16:00 PM",
    "18:00 PM",
    "19:00 PM",
    "20:00 PM",
    "21:00 PM"
  ];

  static List<ModelCard> cardList = [
    ModelCard("paypal.svg", "Paypal", "xxxx xxxx xxxx 5416"),
    ModelCard("mastercard.svg", "Master Card", "xxxx xxxx xxxx 8624"),
    ModelCard("visa.svg", "Visa", "xxxx xxxx xxxx 4565")
  ];

  // ModelBooking(
  //    this.image,
  //    this.name,
  //    this.date,
  //    this.rating,
  //    this.price,
  //    this.owner,
  //    this.tag,
  //    this.bgColor,
  //    this.textColor);
  static List<ModelBooking> bookingList = [
    ModelBooking("grgr2.png",
                  "그래그래",
                  "그레이트북스",
                  "4.3",
                  367000,
                  "By Mendy Wilson",
                  "reading",
                  0xFFEEFCF0,
                  success),
    ModelBooking("booking2.png", "Painting", "22 April, 2022, 08:00 am", "4.2",
        50.00, "By Jenny Winget", "ready", 0xFFF0F8FF, completed),
    ModelBooking("booking3.png", "Cleaning", "20 April, 2022, 06:00 pm", "4.3",
        18.00, "By Jacob Jones", "out", 0xFFFFF3F3, error),
    ModelBooking("booking4.png", "Repairing", "20 April, 2022, 06:00 pm", "4.3",
        18.00, "By Jacob Jones", "", 0xFFF0F8FF, completed),
  ];
  static List<ModelBooking> scheduleList = [
    ModelBooking("booking1.png", "Cleaning", "23 April, 2022, 11:00 am", "4.3",
        20.00, "By Mendy Wilson", "Active", 0xFFEEFCF0, success),
    ModelBooking("booking2.png", "Painting", "22 April, 2022, 08:00 am", "4.2",
        50.00, "By Jenny Winget", "Completed", 0xFFF0F8FF, completed),
  ];

  static List<ModelAddress> addressList = [
    ModelAddress("Alena Gomez",
        "3891 Ranchview Dr. Richardson, California 62639", "(907) 555-0101"),
    ModelAddress("Alena Gomez", "4140 Parker Rd. Allentown, New Mexico 31134",
        "(907) 555-0101"),
  ];

  static List<ModelNotification> notificationList = [
    ModelNotification(
        "Lorem ipsum dolor",
        "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed maximus congue rutrum. Morbi malesuada eleifend eros vel malesuada. Duis sed molestie purus.",
        "1 h ago",
        "Today"),
    ModelNotification(
        "Lorem ipsum dolor",
        "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed maximus congue rutrum. Morbi malesuada eleifend eros vel malesuada. Duis sed molestie purus.",
        "1 h ago",
        "Today"),
    ModelNotification(
        "Lorem ipsum dolor",
        "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed maximus congue rutrum. Morbi malesuada eleifend eros vel malesuada. Duis sed molestie purus.",
        "03:00 pm",
        "Yesterday"),
    ModelNotification(
        "Lorem ipsum dolor",
        "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed maximus congue rutrum. Morbi malesuada eleifend eros vel malesuada. Duis sed molestie purus.",
        "01:00 pm",
        "Yesterday"),
  ];

  static List<String> searchList = [];

  static List<String> popularSearchList = [
    "cleaning",
    "washing",
    "painting",
    "salon",
    "health",
    "transport",
    "gardening",
    "beauty",
    "trashing",
    "plumbing"
  ];

  static List<ModelPopularService> popularServiceList = [
    ModelPopularService("wallpaper.png", "Wall Painting", "Painter"),
    ModelPopularService("barber.png", "Salon For Men", "Barber"),
    ModelPopularService("wallpaper.png", "Wall Painting", "Painter"),
    ModelPopularService("barber.png", "Salon For Men", "Barber"),
  ];

  static List<ModelAgeGroup> ageGroupList = [
    ModelAgeGroup(0, 0, 18),
    ModelAgeGroup(1, 18, 36),
    ModelAgeGroup(2, 36, 48),
    ModelAgeGroup(3, 48, 60),
    ModelAgeGroup(4, 60, 72),
    ModelAgeGroup(5, 72, 240),
    ModelAgeGroup(6, 240, 1200),
  ];

  static List<ModelBookState> bookStateList = [
    ModelBookState("ready"),
    ModelBookState("reading"),
    ModelBookState("out"),
  ];

  static List<ModelBookDetail> bookDetailList = [
    ModelBookDetail("price", "정가", "만원"),
    ModelBookDetail("salePrice", "공구가", "만원"),
    ModelBookDetail("trendRanking", "트렌드랭킹", "위"),
    ModelBookDetail("category", "카테고리", ""),
    ModelBookDetail("composition", "구성", ""),
    ModelBookDetail("homePage", "공식페이지", ""),
    ModelBookDetail("compareList", "비교전집", ""),
    ModelBookDetail("history", "개정판 히스토리", ""),
    ModelBookDetail("video", "소개영상", ""),
  ];
}
