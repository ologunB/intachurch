import 'package:flutter/cupertino.dart';
import 'package:mms_app/core/api/event_api.dart';
import 'package:mms_app/core/models/events_response.dart';
import 'package:mms_app/core/models/login_response.dart';
import 'package:mms_app/core/models/quote_model.dart';
import 'package:mms_app/core/storage/local_storage.dart';
import 'package:mms_app/core/utils/custom_exception.dart';
import 'package:provider/provider.dart';

import '../../locator.dart';
import 'base_vm.dart';

class EventsViewModel extends BaseModel {
  final EventApi _eventApi = locator<EventApi>();
  List<EventModel> allEvents;
  List<LoginData> todayCelebrants, yesterCelebrants, tomoCelebrants;
  String error;
  QuoteModel quoteModel;

  void setEventList(List<EventModel> value) {
    contextEvents = value;
    notifyListeners();
  }

  List<EventModel> contextEvents;

  Future<void> getPresentQuote() async {
    setBusy(true);
    try {
      quoteModel = await _eventApi.getQuote();
      AppCache.setQuote(quoteModel);
      setBusy(false);
    } on CustomException {
      setBusy(false);
    }
  }

  Future<void> getAllEvents(BuildContext context) async {
    setBusy(true);
    try {
      allEvents = await _eventApi.getAllEvents();
      context.read<EventsViewModel>().setEventList(allEvents);

      setBusy(false);
    } on CustomException catch (e) {
      setBusy(false);
      error = e.message;
      // showDialog(e);
    }
  }

  Future<void> getTodayCelebrants() async {
    setBusy(true);
    try {
      todayCelebrants = await _eventApi.getTodayCelebrants();
      setBusy(false);
    } on CustomException catch (e) {
      setBusy(false);
      error = e.message;
    }
  }

  Future<void> getYesteCelebrants() async {
    setBusy(true);
    try {
      yesterCelebrants = await _eventApi.getYesteCelebrants();
      setBusy(false);
    } on CustomException catch (e) {
      setBusy(false);
      error = e.message;
    }
  }

  Future<void> getTomoCelebrants() async {
    setBusy(true);
    try {
      tomoCelebrants = await _eventApi.getTomoCelebrants();
      setBusy(false);
    } on CustomException catch (e) {
      setBusy(false);
      error = e.message;
    }
  }

  Future<void> searchEvents(String a) async {
    if (a.isEmpty) return;
    setBusy(true);
    try {
      allEvents = await _eventApi.searchEvents(a);
      setBusy(false);
    } on CustomException catch (e) {
      setBusy(false);
      error = e.message;
    }
  }

  void showDialog(CustomException e) {
    dialog.showDialog(
        title: 'Error', description: e.message, buttonTitle: 'Close');
  }
}
