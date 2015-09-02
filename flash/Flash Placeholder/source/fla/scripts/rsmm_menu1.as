_global.mainMenu = this;
#include "scripts/rsmm_thumbnail_menu1.as"
#include "scripts/rsmm_nav_next.as"
#include "scripts/rsmm_deep_linker.as"

/*
CONTENTS:
	define constants
	function initMainMenu()
	function refreshMainMenu()
	function showSubmenu()
	function hideSubmenu()
	function refreshSubmenuItems()
	back button code
*/

// Define constants - derived from flashConfig_xml
var menuSettings = _root.flashConfig_xml.styling[0].menu[0];

_global.mainMenu.HIDE_AFFILIATES = menuSettings.hideAffiliates;
_global.mainMenu.HIDE_CALLTOACTION = menuSettings.hideCallToAction;
_global.mainMenu.MAIN_ITEM_SPACING = menuSettings.mainItemSpacing;
_global.mainMenu.SUB_ITEM_SPACING = menuSettings.subItemSpacing;
_global.mainMenu.SHOW_SUBMENU_TITLE = menuSettings.showSubmenuTitle;

/*
Key variables in this script:
	_global.mainMenu.currentMain - the number corresponding to the current item[#] node in mainMenu_xml
	_global.mainMenu.currentSub - the number corresponding to the current item[].item[#] node
	
	_global.mainMenu.selectedMainItem - the id# of the main menu item that is in the press state
	_global.mainMenu.selectedSubItem - the id# submenu item that is in the press state
	_global.mainMenu.selectedSubmenu - the id# of the currently visible submenu - usually compared to selectedMainItem



Key identifiers in this script:
	_global.mainMenu["mainItem"+x] - main menu item button, where x corresponds to the item's mainID value
	_global.mainMenu["subItem"+x] - submenu item button, where x corresponds to the item's subID value
	_global.mainMenu["submenu"+x] - submenu, contains submenu item buttons, where x is the same as corresponding main menu item's mainID value - this should be set with the showSubMenu function
	

*/

_global.mainMenu.initMainMenu();
function initMainMenu() {
	// CREATE MAIN MENU ITEMS
	var xPos = 0;
	var yPos = 0;
	for (m=0; m<_root.mainMenu_xml.item.length; m++) {
		this.attachMovie("main_menu_item", "mainItem"+m, this.getNextHighestDepth());
		mainMenuItem = this["mainItem"+m];
		mainMenuItem.mainID = m;
		mainMenuItem.subID = 0;
		mainMenuItem.linkType = _root.mainMenu_xml.item[m].type;
		mainMenuItem.path = _root.mainMenu_xml.item[m].path;
		mainMenuItem.submenu_y = _root.mainMenu_xml.item[m].submenu_y;
		mainMenuItem.item_label.label_txt.autoSize = "left";
		mainMenuItem.item_label.label_txt.wordWrap = true;
		mainMenuItem.item_label.label_txt.multiline = true;
		mainMenuItem.item_label.label_txt.text = _root.mainMenu_xml.item[m].title;
		mainMenuItem.hotspot._width = int(mainMenuItem.item_label._x + mainMenuItem.item_label._width);
		mainMenuItem.hotspot._height = int(mainMenu.item_label._y + mainMenuItem.item_label._height);
		mainMenuItem._y = yPos;
		yPos += int(mainMenuItem._height) + _global.mainMenu.MAIN_ITEM_SPACING;
		//
		mainMenuItem.onRollOver = function() {
			if (_global.mainMenu.selectedMainItem != this.mainID) {
				this.gotoAndPlay("over");
				_root.toolTip.hide();
			}
		}
		mainMenuItem.onRollOut = function() {
			if (_global.mainMenu.selectedMainItem != this.mainID) {
				this.gotoAndPlay("out");
			}
		}
		mainMenuItem.onPress = function() {
			if (this.linkType == "url") {
				if (this.path.substr(0, 25) == "javascript: myLightWindow" || this.path.substr(0, 24) == "javascript:myLightWindow") {
					getURL("this.path");
				} else {
					getURL(this.path, "_blank");
				}
				this.gotoAndPlay("out");
			} else if (this.linkType == "swf") {
				_global.mainMenu.currentMain = this.mainID;
				_global.mainMenu.currentSub = this.subID;
				_global.mainMenu.refreshMainMenu();
				_root.reloadContent(this.path);
			}
		}
		// CREATE SUBMENU
		if (_root.mainMenu_xml.item[m].item.length>0) {
			this.attachMovie("submenu", "submenu"+m, this.getNextHighestDepth());
			submenu = this["submenu"+m];
			submenu.ID = m;
			submenu._x = _global.mainMenu.submenu_target._x;
			submenu._y = _global.mainMenu.submenu_target._y;
			// CREATE SUBMENU ITEMS
			submenu.itemXPos = 0;
			submenu.itemYPos = 0;
			for (s=0; s<_root.mainMenu_xml.item[m].item.length; s++) {
				submenu.attachMovie("submenu_item", "subItem"+s, submenu.getNextHighestDepth());
				submenuItem = this["submenu"+m]["subItem"+s];
				submenuItem.mainID = m;
				submenuItem.subID = s;
				submenuItem.path = _root.mainMenu_xml.item[m].item[s].path;
				submenuItem.item_label.label_txt.autoSize = "left";
				submenuItem.item_label.label_txt.wordWrap = true;
				submenuItem.item_label.label_txt.multiline = true;
				submenuItem.item_label.label_txt.text = _root.mainMenu_xml.item[m].item[s].title;
				submenuItem.hotspot._width = int(submenuItem.item_label._x + submenuItem.item_label._width);
				submenuItem.hotspot._height = int(submenuItem.item_label._y + submenuItem.item_label._height);
				submenuItem._y = submenu.itemYPos;
				submenuItem._x = submenu.itemXPos;
				submenu.itemYPos += int(submenuItem._height) + _global.mainMenu.SUB_ITEM_SPACING;
				submenuItem.onRollOver = function() {
					if (_global.mainMenu.selectedSubItem != this.subID) {
						this.gotoAndPlay("over");
						_root.toolTip.hide();
					}
				}
				submenuItem.onRollOut = function() {
					if (_global.mainMenu.selectedSubItem != this.subID) {
						this.gotoAndPlay("out");
					}
				}
				submenuItem.onPress = function() {
					_global.mainMenu.currentMain = this.mainID;
					_global.mainMenu.currentSub = this.subID;
					_global.mainMenu.refreshMainMenu();
					_root.reloadContent(this.path);
				}
			}
			// This highlights the first main menu item
			if (m==1) {
				_global.mainMenu.currentMain = 0;
				_global.mainMenu.currentSub = 0;
				_global.mainMenu.refreshMainMenu();
			}
			// This hides all the submenus
			_global.mainMenu.submenuIsVisible = false;
			_global.TweenMax.to(submenu, 0, {autoAlpha:0});
			_global.TweenMax.to(_global.mainMenu.back_mc, 0, {autoAlpha:0});
			_global.TweenMax.to(_global.mainMenu.submenu_title_mc, 0, {autoAlpha:0});
		}
	}
}

/**************************************/
/**************************************/

function refreshMainMenu() {
	// REFRESH MAIN MENU ITEMS
	if (_global.mainMenu.selectedMainItem != _global.mainMenu.currentMain) {
		_global.mainMenu["mainItem"+_global.mainMenu.selectedMainItem].gotoAndPlay("out");
		_global.mainMenu.selectedMainItem = _global.mainMenu.currentMain;
		_global.mainMenu["mainItem"+_global.mainMenu.selectedMainItem].gotoAndPlay("press");
	}
	// REFRESH SUBMENUS
	if (_root.mainMenu_xml.item[_global.mainMenu.currentMain].item) { // if a submenu needs to be visible...
		// if there is no currently visible submenu
		if (_global.mainMenu.submenuIsVisible == false) {
			// reset selectedSubmnu, call showSubmenu function
			_global.mainMenu.selectedSubmenu = _global.mainMenu.currentMain;
			_global.mainMenu.showSubmenu();
		} else { // if there is already a visible submenu
			if (_global.mainMenu.selectedSubmenu == _global.mainMenu.currentMain) { // if the currently visible submenu is the one we want
				// refresh the submenu items
				_global.mainMenu.refreshSubmenuItems();
			} else { // if the curretly visible submenu is not the one we want
				// hide the currently visible submenu, reset selectedSubmenu, show the new submenu
				_global.mainMenu.hideSubmenu();
				_global.mainMenu.selectedSubmenu = _global.mainMenu.currentMain;
				_global.showSubmenu();
			}
		}
	} else { // if there should be no visible submenu...
		// but if a submenu is visible
		if (_global.mainMenu.submenuIsVisible == true) {
			// hide the submenu
			_global.mainMenu.hideSubmenu();
		}
	}
}

/**************************************/
/**************************************/

function showSubmenu() {
	// hide main menu
	for (m=0; m<_root.mainMenu_xml.item.length; m++) {
		_global.TweenMax.to(_global.mainMenu["mainItem"+m], 0, {autoAlpha:0});
	}
	// hide affiliates
	if (_global.mainMenu.HIDE_AFFILIATES == true) {
		_global.TweenMax.to(_global.mainMenu._parent.affiliates_mc, 1, {autoAlpha:0});
	}
	// hide call-to-action
	if (_global.mainMenu.HIDE_CALLTOACTION == true) {
		_global.TweenMax.to(_global.mainMenu._parent.cta_mc, 1, {autoAlpha:0});
	}
	// show back button
	_global.TweenMax.to(_global.mainMenu.back_mc, 1, {autoAlpha:100});
	// show submenu title
	if (_global.mainMenu.SHOW_SUBMENU_TITLE == true) {
		_global.mainMenu.submenu_title_mc.label_txt.text = _root.mainMenu_xml.item[_global.mainMenu.current_main].title;
		_global.TweenMax.to(_global.mainMenu.submenu_title_mc, 1, {autoAlpha:100});
	}
	// show submenu
	_global.TweenMax.to(_global.mainMenu["submenu"+_global.mainMenu.selectedSubmenu], 1, {autoAlpha:100});
	_global.mainMenu.submenuIsVisible = true;
	// reset and highlight selectedSubItem
	_global.mainMenu.selectedSubItem = _global.mainMenu.currentSub;
	_global.mainMenu["submenu"+_global.mainMenu.selectedSubmenu]["subItem"+_global.mainMenu.selectedSubItem].gotoAndPlay("press");
	// refresh Next Buttons, and refresh Thumnail Menu
	_global.mainMenu.refreshNextBtns();
	_global.mainMenu.refreshThumbMenu();
}

/**************************************/
/**************************************/

function hideSubmenu() {
	// show affiliates
	_global.TweenMax.to(_global.mainMenu._parent.affiliates_mc, 1, {autoAlpha:100});
	// show call-to-action
	_global.TweenMax.to(_global.mainMenu._parent.cta_mc, 1, {autoAlpha:100});
	// unhighlight current submenu item
	_global.mainMenu["submenu"+_global.mainMenu.selectedSubmenu]["subItem"+_global.mainMenu.selectedSubItem].gotoAndPlay("out");
	// hide back button
	_global.TweenMax.to(_global.mainMenu.back_mc, 0, {autoAlpha:0});
	// hide submenu title
	_global.TweenMax.to(_global.mainMenu.submenu_title_mc, 0, {autoAlpha:0});
	// hide submenu
	_global.TweenMax.to(_global.mainMenu["submenu"+_global.mainMenu.selectedSubmenu], 0, {autoAlpha:0});
	// fade in the main menu items
	for (m=0; m<_root.mainMenu_xml.item.length; m++) {
		_global.TweenMax.to(_global.mainMenu["mainItem"+m], 1, {autoAlpha:100});
	}
	_global.mainMenu.submenuIsVisible = false;
}

/**************************************/
/**************************************/

function refreshSubmenuItems() {
	if (_global.mainMenu.selectedSubItem != _global.mainMenu.currentSub) {
		_global.mainMenu["submenu"+_global.mainMenu.selectedSubmenu]["subItem"+_global.mainMenu.selectedSubItem].gotoAndPlay("out");
		_global.mainMenu.selectedSubItem = _global.mainMenu.currentSub;
		_global.mainMenu["submenu"+_global.mainMenu.selectedSubmenu]["subItem"+_global.mainMenu.selectedSubItem].gotoAndPlay("press");
	}
}


/**************************************/
/**************************************/

// BACK BUTTON
_global.mainMenu.back_mc.onRollOver = function() {
	this.gotoAndPlay("over");
}
_global.mainMenu.back_mc.onRollOut = function() {
	this.gotoAndPlay("out");
}
_global.mainMenu.back_mc.onPress = function() {
	_global.mainMenu.hideSubmenu();
}


