import 'dart:async';

// stuff for debouncing
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mms_app/app/colors.dart';
import 'package:mms_app/app/size_config/extensions.dart';
import 'package:mms_app/core/models/login_response.dart';

class TextFieldUserSearch extends StatefulWidget {
  final List<Profile> initialList;
  final String label, hintText;
  final TextEditingController controller;
  final Function future;
  final Function(Profile) selectedValue;
  final int minStringLength;

  const TextFieldUserSearch({
    Key key,
    this.initialList,
    this.label,
    @required this.controller,
    this.future,
    this.selectedValue,
    this.minStringLength = 1,
    this.hintText,
  }) : super(key: key);

  @override
  _TextFieldUserSearchState createState() => _TextFieldUserSearchState();
}

class _TextFieldUserSearchState extends State<TextFieldUserSearch> {
  final FocusNode _focusNode = FocusNode();
  OverlayEntry _overlayEntry;
  final LayerLink _layerLink = LayerLink();
  List<Profile> filteredList = [];
  bool hasFuture = false;
  bool loading = false;
  final Debouncer _debouncer = Debouncer(milliseconds: 100);
  bool itemsFound;

  void resetList() {
    List<Profile> tempList = [];
    setState(() {
      // after loop is done, set the filteredList state from the tempList
      this.filteredList = tempList;
      this.loading = false;
    });
    // mark that the overlay widget needs to be rebuilt
    this._overlayEntry.markNeedsBuild();
  }

  void setLoading() {
    if (!this.loading) {
      setState(() {
        this.loading = true;
      });
    }
  }

  void resetState(List tempList) {
    setState(() {
      // after loop is done, set the filteredList state from the tempList
      this.filteredList = tempList;
      this.loading = false;
      // if no items are found, add message none found
      itemsFound = tempList.length == 0 && widget.controller.text.isNotEmpty
          ? false
          : true;
    });
    // mark that the overlay widget needs to be rebuilt so results can show
    this._overlayEntry.markNeedsBuild();
  }

  void updateGetItems() {
    this._overlayEntry.markNeedsBuild();
    if (widget.controller.text.length > widget.minStringLength) {
      this.setLoading();
      widget.future().then((value) {
        print(value.length);
        this.filteredList = value;
        this.resetState(value);
      });
    } else {
      resetList();
    }
  }

  void updateList() {
    this.setLoading();
    // set the filtered list using the initial list
    this.filteredList = widget.initialList;

    this.resetState(filteredList);
  }

  void initState() {
    super.initState();
    // adding error handling for required params
    if (widget.controller == null) {
      throw ('Error: Missing required parameter: controller');
    }

    // throw error if we don't have an inital list or a future
    if (widget.initialList == null && widget.future == null) {
      throw ('Error: Missing required initial list or future that returns list');
    }
    if (widget.future != null) {
      setState(() {
        hasFuture = true;
      });
    }
    // add event listener to the focus node and only give an overlay if an entry
    // has focus and insert the overlay into Overlay context otherwise remove it
    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        this._overlayEntry = this._createOverlayEntry();
        Overlay.of(context).insert(this._overlayEntry);
      } else {
        this._overlayEntry.remove();
        // check to see if itemsFound is false, if it is clear the input
        // check to see if we are currently loading items when keyboard exists, and clear the input
        if (itemsFound == false || loading == true) {
          // reset the list so it's empty and not visible
          resetList();
        }
        // if we have a list of items, make sure the text input matches one of them
        // if not, clear the input

      }
    });
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    //  widget.controller.dispose();
    super.dispose();
  }

  ListView _listViewBuilder(context) {
    if (itemsFound == false) {
      return ListView(
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        children: <Widget>[
          GestureDetector(
            onTap: () {
              // clear the text field controller to reset it
              setState(() {
                itemsFound = false;
              });
              // reset the list so it's empty and not visible
              resetList();
              // remove the focus node so we aren't editing the text
              FocusScope.of(context).unfocus();
            },
            child: ListTile(
              title: Text(
                'No match found.',
                style: GoogleFonts.roboto(
                    fontSize: 14.w,
                    color: AppColors.textGrey,
                    fontWeight: FontWeight.w400),
              ),
              trailing: Icon(Icons.cancel, size: 24.h),
            ),
          ),
        ],
      );
    }
    return ListView.builder(
      itemCount: filteredList.length,
      itemBuilder: (context, i) {
        String fullName =
            filteredList[i].firstName + ' ' + filteredList[i].lastName;
        return GestureDetector(
            onTap: () {
              // set the controller value to what was selected
              setState(() {
                // if we have a label property, and getSelectedValue function
                // send getSelectedValue to parent widget using the label property
                widget.controller.text = fullName ?? 'Full Name';
                widget.selectedValue(filteredList[i]);
              });
              // reset the list so it's empty and not visible
              resetList();
              // remove the focus node so we aren't editing the text
              FocusScope.of(context).unfocus();
            },
            child: ListTile(
              title: Text(fullName ?? 'Full Name'),
              trailing: GestureDetector(
                  onTap: () {
                    // clear the text field controller to reset it
                    setState(() {
                      itemsFound = false;
                    });
                    // reset the list so it's empty and not visible
                    resetList();
                    // remove the focus node so we aren't editing the text
                    FocusScope.of(context).unfocus();
                  },
                  child: Icon(Icons.cancel, size: 24.h)),
            ));
      },
      padding: EdgeInsets.zero,
      shrinkWrap: true,
    );
  }

  Widget _loadingIndicator() {
    return Container(
      width: 50,
      height: 50,
      child: Center(
        child: CircularProgressIndicator(
          valueColor:
              AlwaysStoppedAnimation<Color>(Theme.of(context).accentColor),
        ),
      ),
    );
  }

  Widget _listViewContainer(context) {
    if (itemsFound == true && filteredList.length > 0 ||
        itemsFound == false && widget.controller.text.length > 0) {
      double _height = itemsFound == true && filteredList.length > 1 ? 110 : 55;
      return Container(
        height: _height,
        child: _listViewBuilder(context),
      );
    }
    return null;
  }

  OverlayEntry _createOverlayEntry() {
    RenderBox renderBox = context.findRenderObject();
    Size overlaySize = renderBox.size;
    Size screenSize = MediaQuery.of(context).size;
    double screenWidth = screenSize.width;
    return OverlayEntry(
        builder: (context) => Positioned(
              width: overlaySize.width,
              child: CompositedTransformFollower(
                link: _layerLink,
                showWhenUnlinked: false,
                offset: Offset(0.0, overlaySize.height + 5.0),
                child: Material(
                  elevation: 4.0,
                  child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minWidth: screenWidth,
                        maxWidth: screenWidth,
                        minHeight: 0,
                        // max height set to 150
                        maxHeight: itemsFound == true ? 110 : 55,
                      ),
                      child: loading
                          ? _loadingIndicator()
                          : _listViewContainer(context)),
                ),
              ),
            ));
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: this._layerLink,
      child: TextField(
        key: widget.key,
        controller: widget.controller,
        focusNode: this._focusNode,
        style: GoogleFonts.openSans(
          color: AppColors.pitchBlack,
          fontWeight: FontWeight.w400,
          fontSize: 16.sp,
          letterSpacing: 0.4,
        ),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(
            vertical: 15.h,
            horizontal: 15.w,
          ),
          labelText: widget.label,
          hintText: widget.hintText,
          hintStyle: GoogleFonts.openSans(
            color: AppColors.lightTextGrey,
            fontWeight: FontWeight.w300,
            fontSize: 14.sp,
          ),
          labelStyle: GoogleFonts.openSans(
            color: AppColors.lightTextGrey,
            fontWeight: FontWeight.w300,
            fontSize: 14.sp,
          ),
          border: OutlineInputBorder(
            borderSide: BorderSide(
              color: AppColors.darkTextGrey,
            ),
            borderRadius: BorderRadius.circular(5.h),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: AppColors.darkTextGrey),
            borderRadius: BorderRadius.circular(5.h),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: AppColors.darkTextGrey,
            ),
            borderRadius: BorderRadius.circular(5.h),
          ),
          disabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: AppColors.darkTextGrey,
            ),
            borderRadius: BorderRadius.circular(5.h),
          ),
        ),
        onChanged: (String value) {
          // every time we make a change to the input, update the list
          _debouncer.run(() {
            setState(() {
              if (hasFuture) {
                updateGetItems();
              } else {
                updateList();
              }
            });
          });
        },
      ),
    );
  }
}

class Debouncer {
  final int milliseconds;
  VoidCallback action;
  Timer _timer;

  Debouncer({this.milliseconds});

  run(VoidCallback action) {
    if (_timer != null) {
      _timer.cancel();
    }
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }
}
