    // Start of Selection
    import '../models/pension.dart';
    import 'package:dio/dio.dart';
    import 'package:shared_preferences/shared_preferences.dart';
    
    class PensionRepository {
      final Dio _dio = Dio();
    
      Future<List<Pension>> fetchPensionData() async {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String? token = prefs.getString('token');
    
        final response = await _dio.get(
          'https://api.pensionapp.com/pensions',
          options: Options(headers: {'Authorization': 'Bearer $token'}),
        );
    
        if (response.statusCode == 200) {
          List<Pension> pensions = [];
          for (var p in response.data['pensions']) {
            pensions.add(Pension.fromJson(p));
          }
          return pensions;
        } else {
          throw Exception('Failed to load pension data');
        }
      }
    
          Future<void> addPensionData(Pension pension) async {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            String? token = prefs.getString('token');
        
            final response = await _dio.post(
              'https://api.pensionapp.com/pensions',
              data: {
                'scheme_name': pension.schemeName,
                'contributions': pension.contributions,
                'balance': pension.balance,
                'pension_type': pension.pensionType,
              },
              options: Options(headers: {'Authorization': 'Bearer $token'}),
            );
        
            if (response.statusCode != 201) {
              throw Exception('Failed to add pension data');
            }
          }
    }