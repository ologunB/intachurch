import 'package:flutter/cupertino.dart';
import 'package:mms_app/core/api/families_api.dart';
import 'package:mms_app/core/models/connect_model.dart';
import 'package:mms_app/core/models/family_tree_response.dart';
import 'package:mms_app/core/models/login_response.dart';
import 'package:mms_app/core/storage/local_storage.dart';
import 'package:mms_app/core/utils/custom_exception.dart';
import 'package:mms_app/views/widgets/utils.dart';

import '../../locator.dart';
import 'base_vm.dart';

class FamiliesViewModel extends BaseModel {
  final FamiliesApi _familiesApi = locator<FamiliesApi>();
  List<Profile> allUsers = [];
  List<ConnectData> sentConnects = [];
  List<Members> childrenList = [];
  List<Members> partnerList = [];
  List<ConnectData> pendingConnects = [];
  List<ConnectData> receivedConnects = [];
  FamilyData familyData;
  String error;
  bool isAccepted;

  Future<void> searchUsers(String a) async {
    if (a.isEmpty) return;
    setBusy(true);
    try {
      allUsers = await _familiesApi.searchUsers(a);
      setBusy(false);
      notifyListeners();
    } on CustomException catch (e) {
      setBusy(false);
      error = e.message;
      notifyListeners();
    }
  }

  Future<void> getSentConnects() async {
    setBusy(true);
    try {
      sentConnects = await _familiesApi.getSentConnects();
      setBusy(false);
      notifyListeners();
    } on CustomException catch (e) {
      setBusy(false);
      error = e.message;
      notifyListeners();
    }
  }

  Future<void> getReceivedConnects() async {
    setBusy(true);
    try {
      receivedConnects = await _familiesApi.getReceivedConnects();
      setBusy(false);
      notifyListeners();
    } on CustomException catch (e) {
      setBusy(false);
      error = e.message;
      notifyListeners();
    }
  }

  TextEditingController partnerController = TextEditingController();

  Future<void> getFamilyTree() async {
    setBusy(true);
    try {
      familyData = await _familiesApi.getFamilyTree();
      sentConnects = [];
      childrenList = [];
      partnerList = [];
      partnerController.text = '';
      familyData.members.forEach((connect) {
        if (connect.familyPosition == 'offspring') {
          childrenList.add(connect);
          //    } else  if (connect.profile.userId != AppCache.getUser.profile.userId){
        } else if (connect.familyPosition.toLowerCase() !=
            AppCache.myRelationship.toLowerCase()) {
          partnerList.add(connect);
          partnerController.text = connect.profile.fullName.toTitleCase();
        }
      });

      //remove me from partners
      partnerList.removeWhere((connect) => connect.id != AppCache.getUser.id);

      setBusy(false);
      notifyListeners();
    } on CustomException catch (e) {
      setBusy(false);
      error = e.message;
      showErrDialog(error);
      notifyListeners();
    }
  }

  Future<void> getChurch() async {
    setBusy(true);
    try {
      Church church = await _familiesApi.getChurch();
      AppCache.setMyChurch(church);
      setBusy(false);
      notifyListeners();
    } on CustomException catch (e) {
      setBusy(false);
      error = e.message;
      notifyListeners();
    }
  }

  int progress;

  Future<void> getProgress() async {
    setBusy(true);
    try {
      String progressStr = await _familiesApi.getAccProgress();
      progressStr = progressStr.split('%')[0];
      progress = int.tryParse(progressStr) ?? 0;
      setBusy(false);
      notifyListeners();
    } on CustomException {
      setBusy(false);
      notifyListeners();
    }
  }

  Future<bool> addSpouse(Map<String, dynamic> data) async {
    setBusy(true);
    try {
      await _familiesApi.sendSpouseRequest(data);
      setBusy(false);
      showSuccessDialog('Spouse');
      notifyListeners();
      return true;
    } on CustomException catch (e) {
      setBusy(false);
      error = e.message;
      showErrDialog(error);
      notifyListeners();
      return false;
    }
  }

  Future<bool> addAdult(Map<String, dynamic> data) async {
    setBusy(true);
    try {
      await _familiesApi.sendAdultRequest(data);
      setBusy(false);
      showSuccessDialog('Person');
      notifyListeners();
      return true;
    } on CustomException catch (e) {
      setBusy(false);
      error = e.message;
      showErrDialog(error);
      notifyListeners();
      return false;
    }
  }

  Future<bool> addChild(Map<String, dynamic> data) async {
    setBusy(true);
    try {
      await _familiesApi.sendChildRequest(data);
      setBusy(false);
      showSuccessDialog('Child');
      notifyListeners();
      return true;
    } on CustomException catch (e) {
      setBusy(false);
      error = e.message;
      showErrDialog(error);
      notifyListeners();
      return false;
    }
  }

  Future<void> acceptConnect(int id) async {
    setBusy(true);
    try {
      await _familiesApi.acceptConnectRequest(id);
      isAccepted = true;
      setBusy(false);
      notifyListeners();
    } on CustomException catch (e) {
      setBusy(false);
      error = e.message;
      showErrDialog(error);
      notifyListeners();
    }
  }

  Future<void> rejectConnect(int id) async {
    setBusy(true);
    try {
      await _familiesApi.rejectConnectRequest(id);
      isAccepted = false;
      setBusy(false);
      notifyListeners();
    } on CustomException catch (e) {
      setBusy(false);
      error = e.message;
      showErrDialog(error);
      notifyListeners();
    }
  }

  void showErrDialog(String e) {
    dialog.showDialog(
      title: 'Error',
      description: e,
      buttonTitle: 'OK',
    );
  }

  void showSuccessDialog(String e) {
    dialog.showDialog(
      title: 'Success',
      description: e + ' has been added successfully.',
      buttonTitle: 'OK',
    );
  }
}
