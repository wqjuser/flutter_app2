import 'package:flutter_app2/http/http_manager.dart';

class Api{
  static const String baseUrl = "https://www.wanandroid.com/";
  static const String ARTICLE_LIST = "article/list/";
  static const String BANNER_LIST = "banner/json";

  ///获取文章列表
  static getArticleList(int page) async{
    return await HttpManager.getInstance().request("$ARTICLE_LIST$page/json");
  }

  ///获取banner数据
  static getBanner() async{
    return await HttpManager.getInstance().request(BANNER_LIST);
  }

}