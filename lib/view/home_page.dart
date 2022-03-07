import 'package:flutter/material.dart';
import 'package:pagination_demo/model/user_model.dart';
import 'package:pagination_demo/repository/page_status.dart';
import 'package:pagination_demo/repository/user_repository.dart';
import 'package:pagination_demo/view/widget/list_item.dart';

PageStorageKey pageStorageKey = const PageStorageKey('pageStorageKey');
final PageStorageBucket pageStorageBucket = PageStorageBucket();

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  UserRepository userRepository = UserRepository();
  ScrollController? scrollController;
  @override
  void initState() {
    createScrollController();
    userRepository.getInitialUsers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: body(),
    ));
  }

  Widget body() {
    return ValueListenableBuilder<PageStatus>(
        valueListenable: userRepository.pageStatus,
        builder: (conext, PageStatus pageStatus, _) {
          switch (pageStatus) {
            case PageStatus.idle:
              return idleWidget();
            case PageStatus.firstPageLoading:
              return firstPageLoadingWidget();
            case PageStatus.firstPageError:
              return firstPageErrorWidget();
            case PageStatus.firstPageNoItemsFound:
              return firstPageNoItemsFoundWidget();
            case PageStatus.newPageLoaded:
            case PageStatus.firstPageLoaded:
              return firstPageLoadedWidget();
            case PageStatus.newPageLoading:
              return newPageLoadingWidget();
            case PageStatus.newPageError:
              return newPageErrorWidget();
            case PageStatus.newPageNoItemsFound:
              return newPageNoItemsFoundWidget();
          }
        });
  }

  Widget listViewBuilder() {
    if (scrollController!.hasClients) {
      scrollController!.jumpTo(scrollController!.position.maxScrollExtent);
    }
    return PageStorage(
      key: pageStorageKey,
      bucket: pageStorageBucket,
      child: ListView.builder(
        controller: scrollController,
        itemCount: userRepository.users.length,
        itemBuilder: (context, index) {
          var currentUser = userRepository.users[index];
          return ListItem(currentUser, index);
        },
      ),
    );
  }

  Widget idleWidget() => const SizedBox();

  Widget firstPageLoadingWidget() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget firstPageErrorWidget() {
    return const Center(
      child: Text("Hata Oluştu"),
    );
  }

  Widget firstPageNoItemsFoundWidget() {
    return const Center(
      child: Text("İçerik Bulunamadı"),
    );
  }

  Widget firstPageLoadedWidget() {
    return listViewBuilder();
  }

  Widget newPageLoadingWidget() {
    return Stack(
      children: [
        listViewBuilder(),
        bottomIndicator(),
      ],
    );
  }

  Widget newPageErrorWidget() {
    return Column(
      children: [
        Expanded(child: listViewBuilder()),
        bottomMessage('Yeni Sayfa Bulunamadı'),
      ],
    );
  }

  Widget newPageNoItemsFoundWidget() {
    return Column(
      children: [
        Expanded(child: listViewBuilder()),
        bottomMessage('İlave İçerik Bulunamadı'),
      ],
    );
  }

  Widget bottomIndicator() {
    return bottomWidget(
        child: const Padding(
      padding: EdgeInsets.all(18),
      child: LinearProgressIndicator(color: Colors.black),
    ));
  }

  Widget bottomMessage(String message) {
    return bottomWidget(
        child: Padding(
      padding: EdgeInsets.all(18),
      child: Text(message),
    ));
  }

  void createScrollController() {
    scrollController = ScrollController();
    scrollController?.addListener(loadMoreUsers);
  }

  Future<void> loadMoreUsers() async {
    if (scrollController!.position.pixels >=
            scrollController!.position.maxScrollExtent &&
        userRepository.pageStatus.value != PageStatus.newPageLoading) {
      await userRepository.loadMoreUsers();
    } else {}
  }

  Widget bottomWidget({required Widget child}) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        height: 50,
        alignment: Alignment.center,
        child: child,
      ),
    );
  }

  @override
  void dispose() {
    scrollController?.dispose();
    super.dispose();
  }
}
