import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:memotips/fetch-data/fetch-data.dart';

Future<void> checkInternetAndFetchData() async {
  var connectivityResult = await (Connectivity().checkConnectivity());

  print(connectivityResult);
  if (connectivityResult[0] == ConnectivityResult.mobile || connectivityResult[0] == ConnectivityResult.wifi) {
    print("Internet is Connected");
    fetchData();
     // Call your function to send a request
  } else {
    print('No internet connection.');
  }
}