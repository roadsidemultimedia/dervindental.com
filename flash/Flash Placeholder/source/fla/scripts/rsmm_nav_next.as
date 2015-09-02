/************************************************/
// NEXT BUTTONS
/************************************************/
// init
_global.nextBtn = _global.mainMenu._parent.next_mc;
_global.nextBtn._alpha = false;
_global.nextBtn.enabled = false;
//
_global.prevBtn = _global.mainMenu._parent.prev_mc;
_global.prevBtn._alpha = false;
_global.prevBtn.enabled = false;
// refresh NEXT buttons (during swf reload)
function refreshNextBtns() {
	_global.nextBtn.enabled = false;
	_global.prevBtn.enabled = false;
	_global.TweenMax.to(_global.nextBtn, 0.5, {autoAlpha:0});
	_global.TweenMax.to(_global.prevBtn, 0.5, {autoAlpha:0});
	if (_root.mainMenu_xml.item[_global.mainMenu.currentMain].next == true) {
		_global.nextBtn.onEnterFrame = function() {
			if (_root.swfLoading == false) {
				_global.TweenMax.to(_global.nextBtn, 0.5, {autoAlpha:100});
				_global.TweenMax.to(_global.prevBtn, 0.5, {autoAlpha:100});
				_global.nextBtn.enabled = true;
				_global.prevBtn.enabled = true;
				delete _global.nextBtn.onEnterFrame;
			}
		};
	}
}
_global.nextBtn.onRollOver = function() {
	this.gotoAndPlay("over");
	// FUTURE IDEA: Have a tooltip appear that says the name of the next section
};
_global.nextBtn.onRollOut = function() {
	this.gotoAndPlay("out");
};
_global.nextBtn.onPress = function() {
	this.gotoAndStop(1);
	// reset button
	if (_global.mainMenu.currentSub<_root.mainMenu_xml.item[_global.mainMenu.currentMain].item.length-1) {
		_global.mainMenu.currentSub++;
	} else if (_global.mainMenu.currentSub>=_root.mainMenu_xml.item[_global.mainMenu.currentMain].item.length-1) {
		_global.mainMenu.currentSub = 0;
	}
	_global.mainMenu.refreshSubmenuItems();
	_global.mainMenu.refreshNextBtns();
	_global.mainMenu.refreshThumbMenu();
	next_path = _root.mainMenu_xml.item[_global.mainMenu.currentMain].item[_global.mainMenu.currentSub].path;
	_root.reloadContent(next_path);
};
//
_global.prevBtn.onRollOver = function() {
	this.gotoAndPlay("over");
};
_global.prevBtn.onRollOut = function() {
	this.gotoAndPlay("out");
};
_global.prevBtn.onPress = function() {
	this.gotoAndStop(1);
	if (_global.mainMenu.currentSub>0) {
		_global.mainMenu.currentSub--;
	} else if (_global.mainMenu.currentSub == 0) {
		_global.mainMenu.currentSub = _root.mainMenu_xml.item[_global.mainMenu.currentMain].item.length-1;
	}
	_global.mainMenu.refreshSubmenuItems();
	_global.mainMenu.refreshNextBtns();
	_global.mainMenu.refreshThumbMenu();
	next_path = _root.mainMenu_xml.item[_global.mainMenu.currentMain].item[_global.mainMenu.currentSub].path;
	_root.reloadContent(next_path);
};
