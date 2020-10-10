import 'package:flutter/material.dart';
import 'package:great_places/providers/great_places.dart';
import 'package:great_places/utils/app_routes.dart';
import 'package:provider/provider.dart';

class PlacesListScreen extends StatelessWidget {
  const PlacesListScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Meus Lugares'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(AppRoute.PLACE_FORM);
            },
          )
        ],
      ),
      body: FutureBuilder(
        future: Provider.of<GreatPlaces>(context, listen: false).loadPlaces(),
        builder: (context, snapshot) => snapshot.connectionState ==
                ConnectionState.waiting
            ? Center(child: CircularProgressIndicator())
            : Consumer<GreatPlaces>(
                builder: (context, greatPlaces, ch) => greatPlaces.itemsCount ==
                        0
                    ? ch
                    : ListView.builder(
                        itemCount: greatPlaces.itemsCount,
                        itemBuilder: (context, index) {
                          return ListTile(
                            leading: CircleAvatar(
                              backgroundImage: FileImage(
                                greatPlaces.itemByIndex(index).image,
                              ),
                            ),
                            title: Text(greatPlaces.itemByIndex(index).title),
                            subtitle: Text(greatPlaces
                                .itemByIndex(index)
                                .location
                                .address),
                            onTap: () {
                              Navigator.of(context).pushNamed(
                                AppRoute.PLACE_DETAIL,
                                arguments: greatPlaces.itemByIndex(index),
                              );
                            },
                          );
                        },
                      ),
                child: Center(
                  child: Text('Nenhum Local cadastrado!'),
                ),
              ),
      ),
    );
  }
}
