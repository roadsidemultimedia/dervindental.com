/*
[9/21/2009 12:06:03 PM] Justin: Smile Gallery need:
1. Title, sub title, portrait/closeup/Description options
2. editable thumbnails (able to change size, rollover transition, selected trasition, have it display more thumbnails if we want)
[9/21/2009 12:09:46 PM] Justin: 3. and rollovers on the thumbnails that can be enabled/disabled as we want
*/

/************************************************/
// THUMBNAIL MENU
/************************************************/
_global.galleryMenu = _global.mainMenu._parent.gallery_menu_mc;
_global.galleryMenu.enabled = false;
_global.galleryMenu._alpha = 0;
/*
function refreshGalleryMenu() {
	trace("Gallery Menu Refreshed");
	if (_root.mainMenu_xml.item[_global.mainMenu.currentMain].item.type == "gallery" || _root.mainMenu_xml.item[_global.mainMenu.currentMain].item[_global.mainMenu.currentSub].type == "gallery") {
		_global.galleryMenu.isNeeded = true;
		initThumbMenu(_global.galleryMenu);
	} else {
		_global.galleryMenu.isNeeded = false;
		_global.galleryMenu.hidegalleryMenu();
	}
}

function showGalleryMenu() {
	if (_global.galleryMenu.isNeeded == true && _global.galleryMenu.isVisible == false) {
		_global.galleryMenu.enabled = true;
		_global.galleryMenu.isVisible = false;
		_global.TweenLite.to(_global.galleryMenu, 0.5, {autoAlpha:100});
	}
}
*/
function hideGalleryMenu() {
	_global.galleryMenu.enabled = false;
	_global.galleryMenu.isVisible = false;
	_global.TweenLite.to(_global.galleryMenu, 0.5, {autoAlpha:0});
}

function initGalleryMenu(mc) {
	_global.galleryMenu.gotoAndStop(2);
	this.onEnterFrame = function() {
		trace(_root.assetsPreloaded);
		if (_root.assetsPreloaded == true) {
			_global.galleryMenu.gotoAndStop(1);
			// define thumb array
			_global.mainMenu.galleryMenuIsVisible = true;
			_global.galleryMenu.id_num = _global.mainMenu.currentMain;
			_global.galleryMenu.enabled = true;
			_global.TweenLite.to(_global.galleryMenu, 0.5, {autoAlpha:100});
			/*
			if (_global.mainMenu.currentSub > 0) {
				_global.galleryMenu.thumb_array = _root.mainMenu_xml.item[_global.mainMenu.currentMain].item[_global.mainMenu.currentSub].thumb;
			} else {
				_global.galleryMenu.thumb_array = _root.mainMenu_xml.item[_global.mainMenu.currentMain].thumb;
			}
			*/
			_global.galleryMenu.item_array = _root.flashContent_xml.custom;
			trace(".....................");
			trace(_root.flashContent_xml.swf[0].src);
			trace(_root.flashContent_xml.custom.length);
			trace(".....................");

			mc.xTarget = mc.panel_mc._x;
			mc.xHome = mc.panel_mc._x;
			mc.panel_mc.setMask(mc.mask_mc);
			xpos=0;
			for (t=0; t < _global.galleryMenu.item_array.length; t++) {
				trace("------------------ MAKING NEW THUMB -----------------");
				trace(_global.galleryMenu.item_array[t].src)
				trace(_root.mainMenu_xml.item[_global.mainMenu.currentMain].item[t].path);
				mc.panel_mc.attachMovie("thumb_item_mc","thumb"+t,mc.panel_mc.getNextHighestDepth());
				thumb = mc.panel_mc["thumb" + t];
				thumb.id_num = t;
				thumb.image_mc.loadMovie(_global.galleryMenu.item_array[t].src);
				thumb.path = _root.mainMenu_xml.item[_global.mainMenu.currentMain].item[t].path;
				thumb._x = xpos;
				xpos += thumb._width + 5;
				thumb.onRollOver = function() {
					if (_global.galleryMenu.current_thumb != this.id_num) {
						this.gotoAndPlay("over");
					}
				};
				thumb.onRollOut = function() {
					if (_global.galleryMenu.current_thumb != this.id_num) {
						this.gotoAndPlay("out");
					}
				}
				thumb.onPress = function() {
					_global.galleryMenu.panel_mc["thumb"+_global.galleryMenu.current_thumb].gotoAndPlay("out");
					_global.galleryMenu.current_thumb = this.id_num;
					_global.galleryMenu.gallery["thumb"+_global.galleryMenu.current_thumb].gotoAndPlay("press");
					_root.reloadContent(this.path);
				}
				if (t == 0) {
					_global.galleryMenu.current_thumb = 0;
					thumb.gotoAndPlay("press");
				}
				if (t == _global.galleryMenu.item_array.length-1) {
					if (_global.galleryMenu.panel_mc._width <= _global.galleryMenu.mask_mc._width) {
						_global.galleryMenu.page_prev_mc._visible = false;
						_global.galleryMenu.page_next_mc._visible = false;
					}
				}		
			}
			_global.galleryMenu.nextPage = function() {
				//trace("xHome = " + int(_global.galleryMenu.xHome));
				trace("gallery width = " + int(_global.galleryMenu.panel_mc._width));
				trace("xTarget = " + int(_global.galleryMenu.xTarget));
				trace("mask x = " + int(_global.galleryMenu.mask_mc._x));
				trace("mask width = " + int(_global.galleryMenu.mask_mc._width));
				trace("left hand = " + int(_global.galleryMenu.panel_mc._width + _global.galleryMenu.xTarget));
				trace("right hand = " + int(_global.galleryMenu.mask_mc._x +  _global.galleryMenu.mask_mc._width));
				if (_global.galleryMenu.panel_mc._width + _global.galleryMenu.xTarget > _global.galleryMenu.mask_mc._x +  _global.galleryMenu.mask_mc._width) {
					_global.galleryMenu.xTarget -= _global.galleryMenu.mask_mc._width;
					_global.TweenLite.to(_global.galleryMenu.panel_mc, 1, {_x:_global.galleryMenu.xTarget});
				}
			}
			_global.galleryMenu.prevPage = function() {
				if (_global.galleryMenu.xTarget < 0) {
					_global.galleryMenu.xTarget += _global.galleryMenu.mask_mc._width;
					_global.TweenLite.to(_global.galleryMenu.panel_mc, 1, {_x:_global.galleryMenu.xTarget});
				}
			}
			_global.galleryMenu.nextItem = function() {
				_global.galleryMenu.panel_mc["thumb"+_global.galleryMenu.current_thumb].gotoAndPlay("out");
				if (_global.galleryMenu.current_thumb < _global.galleryMenu.item_array.length-1) {
					_global.galleryMenu.current_thumb++;
					if ((_global.galleryMenu.xTarget + _global.galleryMenu.panel_mc["thumb"+_global.galleryMenu.current_thumb]._x) >= (_global.galleryMenu.mask_mc._x + _global.galleryMenu.mask_mc._width)) {
						_global.galleryMenu.xTarget -= _global.galleryMenu.mask_mc._width;
					} 
				} else if (_global.galleryMenu.current_thumb >= _global.galleryMenu.item_array.length-1) {
					_global.galleryMenu.current_thumb = 0;
					_global.galleryMenu.xTarget = _global.galleryMenu.xHome;
				}
				_global.TweenLite.to(_global.galleryMenu.panel_mc, 1, {_x:_global.galleryMenu.xTarget});
				_global.galleryMenu.panel_mc["thumb"+_global.galleryMenu.current_thumb].gotoAndPlay("press");
				_root.reloadContent(_global.galleryMenu.panel_mc["thumb"+_global.galleryMenu.current_thumb].path);
				// if ((xTarget + current_thumb._x)) > (mask_mc._x + mask_mc._width)) { then move the panel
			}
			_global.galleryMenu.prevItem = function() {
				if (_global.galleryMenu.current_thumb > 0) {
					_global.galleryMenu.panel_mc["thumb"+_global.galleryMenu.current_thumb].gotoAndPlay("out");
					_global.galleryMenu.current_thumb--;
					_global.galleryMenu.panel_mc["thumb"+_global.galleryMenu.current_thumb].gotoAndPlay("press");
					_root.reloadContent(_global.galleryMenu.panel_mc["thumb"+_global.galleryMenu.current_thumb].path);
				}
				if ((_global.galleryMenu.xTarget + _global.galleryMenu.panel_mc["thumb"+_global.galleryMenu.current_thumb]._x) < _global.galleryMenu.mask_mc._x) {
					_global.galleryMenu.xTarget += _global.galleryMenu.mask_mc._width;
					_global.TweenLite.to(_global.galleryMenu.panel_mc, 1, {_x:_global.galleryMenu.xTarget});
				}
			}
			mc.page_next_mc.onRollOver = function() {
				this.gotoAndPlay("over");
			};
			mc.page_next_mc.onRollOut = function() {
				this.gotoAndPlay("out");
			};
			mc.page_next_mc.onPress = function() {
				_global.galleryMenu.nextPage();
			};
			mc.page_prev_mc.onRollOver = function() {
				this.gotoAndPlay("over");
			};
			mc.page_prev_mc.onRollOut = function() {
				this.gotoAndPlay("out");
			};
			mc.page_prev_mc.onPress = function() {
				_global.galleryMenu.prevPage();
			};
			mc.item_next_mc.onRollOver = function() {
				this.gotoAndPlay("over");
			};
			mc.item_next_mc.onRollOut = function() {
				this.gotoAndPlay("out");
			};
			mc.item_next_mc.onPress = function() {
				_global.galleryMenu.nextItem();
			};
			mc.item_prev_mc.onRollOver = function() {
				this.gotoAndPlay("over");
			};
			mc.item_prev_mc.onRollOut = function() {
				this.gotoAndPlay("out");
			};
			mc.item_prev_mc.onPress = function() {
				_global.galleryMenu.prevItem();
			};
			delete this.onEnterFrame;
		}
	}
}