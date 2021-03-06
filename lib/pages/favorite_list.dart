import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../blocs/bloc_provider.dart';
import '../blocs/favorite_bloc.dart';
import '../routes/router.dart';
import '../widgets/navigation_bar.dart';

class FavoriteListPage extends StatefulWidget {
  @override
  _FavoriteListPageState createState() => _FavoriteListPageState();
}

class _FavoriteListPageState extends State<FavoriteListPage>
    with SingleTickerProviderStateMixin {
  int _total;

  get _bloc => BlocProvider.of<FavoriteBloc>(context).first;

  @override
  void initState() {
    _total = 0;
    _bloc.total.listen((total) {
      setState(() {
        _total = total;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: MyNavigationBar(
        middle: Text('$_total条收藏'),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return StreamBuilder<List<String>>(
              stream: _bloc.favoriteList,
              builder:
                  (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
                return snapshot.data == null || snapshot.data.isEmpty
                    ? Center(
                        child: Text(
                          '_(:з」∠)_\n空空如也',
                          style: TextStyle(
                            color: CupertinoColors.inactiveGray,
                          ),
                        ),
                      )
                    : ListView.separated(
                        shrinkWrap: true,
                        padding: EdgeInsets.all(
                          8.0,
                        ),
                        itemBuilder: (context, index) {
                          return _buildFavoriteList(
                              context, snapshot.data[index]);
                        },
                        separatorBuilder: (context, index) => Divider(),
                        itemCount: snapshot.data.length,
                      );
              });
        },
      ),
    );
  }

  Widget _buildFavoriteList(BuildContext context, String info) {
    final _infos = info.split('-');
    final _id = _infos.first;
    final _title = _infos.last;

    return GestureDetector(
      child: Container(
        child: Text(
          _title,
        ),
      ),
      onTap: () {
        Navigator.push(context, CupertinoPageRoute(builder: (context) {
          return Router.widget(
            '/movie/$_id',
            context,
            params: {'id': _id},
          );
        }));
      },
    );
  }
}
