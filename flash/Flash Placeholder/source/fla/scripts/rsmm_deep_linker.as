/*********************************/
//Smart linker
/*********************************/
_root.deepLink = function(titles) {
	titles_array = new Array();
	titles_array = titles.split(",");
	trace("titles array length = "+titles_array.length);
	mainTitle = titles_array[0];
	trace("mainTitle = " + mainTitle);
	if (titles_array.length>1) {
		subTitle = titles_array[1];
		trace("subTitle = " + subTitle);
	}
	for (m=0; m<_root.mainMenu_xml.item.length; m++) {
		if (_root.mainMenu_xml.item[m].title == mainTitle) {
			trace(mainTitle+" = "+m);
			if (titles_array.length<2) {
				_global.mainMenu.currentMain = m;
				_global.mainMenu.currentSub = 0;
				_root.reloadContent(_root.mainMenu_xml.item[m].path);
				_global.mainMenu.refreshMainMenu();
			} else {
				for (s=0; s<_root.mainMenu_xml.item[m].item.length; s++) {
					if (_root.mainMenu_xml.item[m].item[s].title == subTitle) {
						trace(subTitle+" = "+s);
						_global.mainMenu.currentMain = m;
						_global.mainMenu.currentSub = s;
						_root.reloadContent(_root.mainMenu_xml.item[m].item[s].path);
						_global.mainMenu.refreshMainMenu();
					}
				}
			}
		}
	}
};