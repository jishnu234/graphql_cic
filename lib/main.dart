import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

const productsGraphQL = """
query products {
   products(first: 10, channel: "default-channel") {
    edges {
      node {
        id
        name
        description
        thumbnail {
          url
        }
      }
    }
  } 
}
""";

// const productsGraphQL = """query {
//   customerFairUsePolicies {
//     id
//     policy_title
//     policy_description
//   }
// }""";
void main() {
  final HttpLink httpLink = HttpLink("https://demo.saleor.io/graphql/");

  ValueNotifier<GraphQLClient> client = ValueNotifier(
    GraphQLClient(
      link: httpLink,
      cache: GraphQLCache(store: InMemoryStore()),
    ),
  );

  var app = GraphQLProvider(
    child: const MyApp(),
    client: client,
  );
  runApp(app);
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'GraphQL Flutter'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Query(
          options: QueryOptions(
            document: gql(productsGraphQL),
          ),
          builder: (QueryResult result, {fetchMore, refetch}) {
            if (result.hasException) {
              return Text(result.exception.toString());
            }

            if (result.isLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            final productList = result.data?['products']['edges'];
            // print(productList);

            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    "Products",
                    style: Theme.of(context).textTheme.headline6,
                  ),
                ),
                Expanded(
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 2.0,
                      crossAxisSpacing: 2.0,
                      childAspectRatio: 0.75,
                    ),
                    itemCount: productList.length,
                    itemBuilder: (_, index) {
                      var product = productList[index]['node'];

                      return Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(2.0),
                            width: 180,
                            height: 180,
                            child: Image.network(product['thumbnail']['url']),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: Text(
                              product['name'],
                              style: Theme.of(context).textTheme.subtitle2,
                            ),
                          ),
                          const Text("\$4.50")
                        ],
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),
        floatingActionButton: Padding(
          padding: const EdgeInsets.all(16.0),
          child: FloatingActionButton(
            onPressed: () {},
            child: const Icon(Icons.send),
          ),
        ));
  }
}
