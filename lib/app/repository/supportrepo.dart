import 'base_repo.dart';

class SupportRepo extends BaseRepo {
  Future<Map<String, dynamic>> createTicket(
      {required Map<String, dynamic> json}) async {
    try {
      String endpoint = '/create-ticket';
      var response = await postWithToken(json, endpoint);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> viewTicket({required String ticketId}) async {
    try {
      String endpoint = '/view-ticket/$ticketId';
      var response = await getRequest(endpoint);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> ticketList() async {
    try {
      String endpoint = '/ticket-list';
      var response = await getRequest(endpoint);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> deleteTicket({required String ticketId}) async {
    try {
      String endpoint = '/delete-ticket/$ticketId';
      var response = await deleteRequest(endpoint);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> closeTicket({required String ticketId}) async {
    try {
      String endpoint = '/close-ticket/$ticketId';
      var response = await patchRequest({}, endpoint);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> replyTicket(
      {required String ticketId, required Map<String, dynamic> json}) async {
    try {
      String endpoint = '/reply-ticket/$ticketId';
      var response = await postWithToken(json, endpoint);
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
