import gs.dataTransfer.PreloadAssetManager;
import gs.TweenLite;
import gs.TweenGroup;
import gs.TweenMax;
import gs.easing.*;
import scripts.XMLParser;
_global.XMLParser = XMLParser;
_global.PreloadAssetManager = PreloadAssetManager;
_global.TweenGroup = TweenGroup;
_global.TweenLite = TweenLite;
_global.TweenMax = TweenMax;
//*****************************/
#include "scripts/rsmm_content.as"
#include "scripts/tooltip.as"
#include "scripts/music_controller.as"
//
//
//
/******************************/
/********** LOAD XML **********/
flashConfig_xml = new Object();
flashIndex_xml = new Object();
_root.flashConfig_xml = flashConfig_xml;
XMLParser.load("xml/flash_config.xml", configLoaded, flashConfig_xml);
function configLoaded(success_boolean, flashConfig_xml, xml) {
	if (success_boolean) {
		XMLParser.load("xml/menu_index.xml", menuLoaded, menu_xml);
		trace("flash_config.xml loaded");
	} else {
		trace("FAILED to load flash_config.xml");
	}
}
function menuLoaded(success_boolean, menu_xml, xml) {
	if (success_boolean) {
		_root.mainMenu_xml = menu_xml;
		showMain();
		initMusic();
		trace("menu_index.xml loaded");
	} else {
		trace("FAILED to load menu_index.xml");
	}
}



//
/**************************************/
/*********** STAGE SETTINGS *********/
//
_quality = "best";
Stage.scaleMode = "noScale";
Stage.align = "TL";
Stage.showMenu = false;
Stage.addListener(this);
/***************************************/
/***** POSITION STAGE ELEMENTS *****/
//
var activeStageScale = (Stage.width/Stage.height);
this.onResize = function() {
	scaleBase();
};
var mainMovieWidth = 1080;
var mainMovieHeight = 590;
var bgImageScale = 1.333333;
main_mc._x = int(Stage.width/2-mainMovieWidth/2);
main_mc._y = int(Stage.height/2-mainMovieHeight/2);
function scaleBase() {
	//
	// Scale Main movie
	if (Stage.width<mainMovieWidth+120 || Stage.height<mainMovieHeight+120) {
		var width_ratio = Stage.width/(mainMovieWidth+120);
		var height_ratio = Stage.height/(mainMovieHeight+120);
		if (width_ratio<=height_ratio) {
			trace("too narrow");
			main_mc._xscale = int(width_ratio*100);
			main_mc._yscale = int(width_ratio*100);
		} else if (height_ratio<width_ratio) {
			trace("too short");
			main_mc._xscale = int(height_ratio*100);
			main_mc._yscale = int(height_ratio*100);
		}
	} else {
		trace("big enough");
		main_mc._xscale = 100;
		main_mc._yscale = 100;
	}
	trace(main_mc._yscale+" & "+main_mc._xscale);
	main_mc._x = int(Stage.width/2-(mainMovieWidth*main_mc._xscale/100)/2);
	main_mc._y = int(Stage.height/2-(mainMovieHeight*main_mc._yscale/100)/2);
	trace(main_mc._x);
	trace(main_mc._y);
	//
	// Scale background
	var activeStageScale = (Stage.width/Stage.height);
	if (activeStageScale>bgImageScale) {
		background_mc._width = Stage.width;
		background_mc._height = background_mc._width*(1/bgImageScale);
	} else if (activeStageScale<bgImageScale) {
		background_mc._height = Stage.height;
		background_mc._width = background_mc._height*bgImageScale;
	} else {
		background_mc._width = Stage.width;
		background_mc._height = Stage.height;
	}
	// Position preloader (uses preloader_target clip in main_mc)
	preloader_mc._x = _root.preloaderTargetX;
	preloader_mc._y = _root.preloaderTargetY;
	// Call actionbar positioning function (stored in rsmm_content.as)
	_root.positionActionBar();
}
scaleBase();
/*******************************/
/****** LOAD MAIN MOVIE ******/
function showMain():Void {
	trace("loading Main");
	if (_root.media_path) {
		_root.main_mc.loadMovie(_root.media_path+"/main.swf");
	} else {
		_root.main_mc.loadMovie("assets/flash/main.swf");
	}
}


//**************************//
//HTML tag conversions
//**************************//
// 
function convertHTMLString(sourceText) {
	_global.htmlConversions = new Array(
		new Array("</p>", "</p><br>"), 
		new Array("<strong>", "<b>"),
		new Array("</strong>", "</b>"),
		new Array("<span class='pdf_link'>", "<span><img src='assets/images/common/pdf.gif' vspace='1' hspace='8' align='left'>"),
		new Array("<span class=\"pdf_link\">", "<span><img src='assets/images/common/pdf.gif' vspace='1' hspace='8' align='left'>")
	);
	splitText = new Array();
	myText = sourceText;
	for (v=0; v<_global.htmlConversions.length; v++) {
		splitText = myText.split(_global.htmlConversions[v][0]);
		myText = splitText.join(_global.htmlConversions[v][1]);
	}
	return myText;
}



//
/********************************/
/******** LOAD NEW PAGE *********/
//
function reloadContent(xmlFile) {
	trace("\n\n\n reloadContent " + xmlFile);
	_root.swfLoading = true;
	_root.assetsPreloaded = false;
	//fade out old content
	//TweenLite.to(_root.main_mc.swf_holder_mc, 0.5, {autoAlpha:0, onComplete:showPreloader, onCompleteParams:[xmlFile]});	
	loadXML(xmlFile);
	_root.main_mc.swf_loader_mc.transOut();
}
/*
function showPreloader(xmlFile) {
	trace("showPreloader");
	//fade in preloader
	_root.main_mc.swf_holder_mc.unloadMovie();
	_root.preloader_mc._alpha = 0;
	_root.preloader_mc.gotoAndStop("on");
	TweenLite.to(_root.preloader_mc, 0.5, {autoAlpha:100});
	loadXML(xmlFile);
}
*/
function loadXML(xmlFile) {
	trace("loadXML");
	flashContent_xml = new Object();
	XMLParser.load(xmlFile, parseContentXml, flashContent_xml);
	function parseContentXml(success_boolean, flashContent_xml, xml) {
		if (success_boolean) {
			trace("content XML loaded");
			_root.preloader_obj.destroy();
			//destroy PreloadAssetManager object
			contentLoadList = new Array();
			for (i=0; i<flashContent_xml.swf.length; i++) {
				contentLoadList.push(flashContent_xml.swf[i].src);
			}
			for (i=0; i<flashContent_xml.image.length; i++) {
				if (flashContent_xml.image[i].src) {
					contentLoadList.push(flashContent_xml.image[i].src);
				}
			}
			for (i=0; i<flashContent_xml.custom.length; i++) {
				if (flashContent_xml.custom[i].src) {
					contentLoadList.push(flashContent_xml.custom[i].src);
				}
			}
			_root.flashContent_xml = flashContent_xml;
			preloadAssets(contentLoadList);
		} else {
			trace("FAILED to load content XML");
		}
	}
}
function preloadAssets(listArray, flashContent_xml) {
	trace("preloadAssets");
	_root.preloader_obj = new _global.PreloadAssetManager(listArray, _root.completeAssetsPreload, true);
	trace("Assets = "+listArray);
}
function completeAssetsPreload() {
	trace("completeAssetsPreload");
	_root.assetsPreloaded = true;
}
function loadNewSwf() {
	trace("loadNewSwf");
	//code to load new swf; also, code to load content for swf; when finished, have new swf gotoAndPlay("begin");
	_root.mcloader = new MovieClipLoader();
	_root.mcloader_listener = new Object();
	_root.mcloader.addListener(_root.mcloader_listener);
	_root.mcloader_listener.onLoadInit = function() {
		_root.reloadComplete();
	};
	_root.mcloader.loadClip(_root.flashContent_xml.swf[0].src, _root.main_mc.swf_loader_mc.swf_holder_mc);
}
function hidePreloader() {
	trace("hidePreloader");
	_global.TweenLite.to(_root.preloader_mc, .25, {autoAlpha:0, onStart:reloadComplete});
}
function reloadComplete() {
	_root.swfLoading = false;
	_root.swfLoaded = true;
	trace("reloadComplete");
	_root.preloader_mc.gotoAndStop("off");
	_root.main_mc.swf_loader_mc.transIn();
	_root.toolTip.hide();
	//_root.main_mc.swf_holder_mc._alpha = 100;
	//_root.main_mc.swf_holder_mc.gotoAndPlay("begin");
}
