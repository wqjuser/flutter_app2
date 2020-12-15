import 'package:banner_view/banner_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app2/http/api.dart';
import 'package:flutter_app2/widgets/article_item.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class ArticleListPage extends StatefulWidget {
  @override
  _ArticleListPageState createState() => _ArticleListPageState();
}

class _ArticleListPageState extends State<ArticleListPage> {
  ///是否展示加载框
  bool _isHide;

  ///文章列表数据集合
  List articles = [];

  ///banner数据集合
  List banners = [];

  ///文章数据当前页码
  int curPage = 0;

  ///文章数据最大页数
  int maxPage = 0;

  ///刷新加载控制器
  RefreshController _refreshController;

  //初始化数据
  @override
  void initState() {
    super.initState();
    _refreshController = RefreshController(initialRefresh: true);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {


    return Scaffold(
        body: SmartRefresher(
      enablePullDown: true,
      enablePullUp: true,
      header: WaterDropHeader(),
      footer: CustomFooter(
        builder: (BuildContext context, LoadStatus mode) {
          Widget body;
          if (mode == LoadStatus.idle) {
            body = Text("上拉加载");
          } else if (mode == LoadStatus.loading) {
            body = CupertinoActivityIndicator();
          } else if (mode == LoadStatus.failed) {
            body = Text("加载失败！点击重试！");
          } else if (mode == LoadStatus.canLoading) {
            body = Text("松手,加载更多!");
          } else {
            body = Text("没有更多数据了!");
          }
          return Container(
            height: 55.0,
            child: Center(child: body),
          );
        },
      ),
      controller: _refreshController,
      onRefresh: _onRefresh,
      onLoading: _onLoadMore,
      child: ListView.builder(
        itemBuilder: (context,i)=>_buildItem(i),
        itemCount: articles.length + 1,
      ),
    ));

  }

  ///刷新数据使用
  Future<void> _onRefresh() async {
    curPage = 0;
    ///组合两个异步任务，创建一个都完成后的新的Future
    Iterable<Future> futures = [_getArticleListData(), _getBannerData()];
    await Future.wait(futures);
    _refreshController.refreshCompleted();
    _isHide = false;
    setState(() {});
    return null;
  }

  ///加载数据使用
  void _onLoadMore() {
    if(curPage<maxPage){
      _getArticleListData();
      _refreshController.loadComplete();
    }
  }

  _getBannerData([bool update = true]) async {
    var data = await Api.getBanner();
    if (data != null) {
      banners.clear();
      banners.addAll(data['data']);
      if (update) {
        setState(() {});
      }
    }
  }

  _getArticleListData([bool update = true]) async {
    /// 请求成功是map，失败是null
    var data = await Api.getArticleList(curPage);
    if (data != null) {
      var map = data['data'];
      var datas = map['datas'];

      ///文章总页数
      maxPage = map["pageCount"];

      if (curPage == 0) {
        articles.clear();
      }
      curPage++;
      articles.addAll(datas);

      ///更新ui
      if (update) {
        setState(() {});
      }
    }
  }
  Widget _buildItem(int i) {

    if (i == 0) {
      //Container ：容器
      return new Container(
        //MediaQuery.of(context).size.height: 全屏幕高度
        height: MediaQuery.of(context).size.height*0.3,
        child: _bannerView(),
      );
    }
    var itemData = articles[i - 1];
    return new ArticleItem(itemData);
  }

  Widget _bannerView() {
    //map:转换 ,将List中的每一个条目执行 map方法参数接收的这个方法,这个方法返回T类型，
    //map方法最终会返回一个  Iterable<T>
    List<Widget> list = banners.map((item) {
      return Image.network(item['imagePath'], fit: BoxFit.cover); //fit 图片充满容器
    }).toList();
    return list.isNotEmpty
        ? BannerView(
      list,
      //控制轮播时间
      intervalDuration: const Duration(seconds: 3),
    )
        : null;
  }
}
