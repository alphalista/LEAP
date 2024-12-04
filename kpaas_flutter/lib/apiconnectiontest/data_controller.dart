import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'api_service.dart';

class DataController extends GetxController {
  var isLoading = true.obs;
  var market_bond_issue_info = [].obs;
  var market_bond_inquire_daily_price = [].obs;
  var news = [].obs;
  var market_bond_code = [].obs;
  var market_bond_nextPage = ''.obs;
  var market_bond_prevPage = ''.obs;

  var otc_bond_code = [].obs;

  final ApiService apiService = ApiService();

  Future<List<dynamic>> fetchNewsData() async {
    isLoading(true);
    try {
      final response = await apiService.fetchData(
          'http://localhost:8000/api/koreaib/news/data/?query=채권&sort=date');
      if (response.statusCode == 200 && response.data is Map) {
        news.clear();
        news.assignAll(response.data['items']); // 뉴스 데이터 업데이트
        return news; // 데이터를 반환합니다.
      } else {
        print('Failed to load news data');
        return [];
      }
    } catch (e) {
      print('Error fetching news: $e');
      return [];
    } finally {
      isLoading(false);
    }
  }

  Future<Map<String, dynamic>> fetchEtBondData(String url) async {
    isLoading(true);
    try {
      // Fetch data using apiService
      final response = await apiService.fetchData(url);

      // Check if the response is valid and contains a map
      if (response.statusCode == 200 && response.data is Map<String, dynamic>) {
        var data = response.data as Map<String, dynamic>;
        market_bond_code.assignAll(data['results'] ?? []);
        market_bond_nextPage.value = data['next'] ?? '';
        market_bond_prevPage.value = data['previous'] ?? '';
        return data;
      } else {
        print('Failed to load market bond data');
        return {};
      }
    } catch (e) {
      print('Error fetching market bond data: $e');
      return {};
    } finally {
      isLoading(false);
    }
  }

  Future<Map<String, dynamic>> fetchOtcBondData(String url) async {
    isLoading(true);
    try {
      final response = await apiService.fetchData(url);
      if (response.statusCode == 200 && response.data is Map) {
        var data = response.data;
        market_bond_code.assignAll(data['results']);
        market_bond_nextPage.value = data['next'] ?? '';
        market_bond_prevPage.value = data['previous'] ?? '';
        return data;
      } else {
        print('Failed to load market bond data');
        return {};
      }
    } catch (e) {
      if (e is DioException) {
        print('Error fetching otcBond data: ${e.message}');
        print('Error status code: ${e.response?.statusCode}');
        print('Error response data: ${e.response?.data}');
      } else {
        print('Unexpected error: $e');
      }
      return {};
    } finally {
      isLoading(false);
    }
  }

  Future<Map<String, dynamic>> fetchOtcDailyBondData(String url) async {
    isLoading(true);
    try {
      final response = await apiService.fetchData(url);
      if (response.statusCode == 200 && response.data is Map<String, dynamic>) {
        var data = response.data;
        otc_bond_code.assignAll(data['results'] ?? []);
        market_bond_nextPage.value = data['next'] ?? '';
        market_bond_prevPage.value = data['previous'] ?? '';
        return data;
      } else {
        print('Failed to load new bond data');
        return {};
      }
    } catch (e) {
      if (e is DioException) {
        print('Error fetching new bond data: ${e.message}');
        print('Error status code: ${e.response?.statusCode}');
        print('Error response data: ${e.response?.data}');
      } else {
        print('Unexpected error: $e');
      }
      return {};
    } finally {
      isLoading(false);
    }
  }

  Future<Map<String, dynamic>> fetchUserOtcBondData(String url, String idToken) async {
    final dio = Dio();
    isLoading(true); // 로딩 상태 시작
    try {
      // Dio GET 요청
      final response = await dio.get(
        url,
        options: Options(
          headers: {
            'Authorization': 'Bearer $idToken', // 헤더에 Authorization 추가
          },
        ),
      );

      if (response.statusCode == 200 && response.data is Map) {
        var data = response.data;
        market_bond_code.assignAll(data['results']); // 데이터 업데이트
        market_bond_nextPage.value = data['next'] ?? ''; // 다음 페이지 URL 저장
        market_bond_prevPage.value = data['previous'] ?? ''; // 이전 페이지 URL 저장
        return data; // 성공적으로 데이터를 반환
      } else {
        print('Failed to load market bond data'); // 요청 실패 로그
        return {}; // 빈 데이터를 반환
      }
    } catch (e) {
      // DioException을 처리
      if (e is DioException) {
        print('Error fetching otcBond data: ${e.message}');
        print('Error status code: ${e.response?.statusCode}');
        print('Error response data: ${e.response?.data}');
      } else {
        print('Unexpected error: $e'); // 기타 오류 처리
      }
      return {};
    } finally {
      isLoading(false); // 로딩 상태 종료
    }
  }
}
