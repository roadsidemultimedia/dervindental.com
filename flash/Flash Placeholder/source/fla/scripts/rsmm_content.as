//
//**************************//
// CSS
//**************************//
import TextField.StyleSheet;
var css = new StyleSheet();
css.onLoad = function(bSuccess) {
	if (bSuccess) {
		trace("Css loaded");
	}
};
css.load("css/full-flash/flash-text.css");

//**************************//
// GLOBAL TWEEN STYLES
//**************************//
//
function showImage(mc) {
	//mc._alpha = 0;
	//_global.TweenMax.from(mc, 1, {blurFilter:{blurX:5, blurY:5}});
	_global.TweenMax.from(mc, .5, {colorMatrixFilter:{colorize:0xffffff, amount:1, contrast:2, brightness:3, saturation:1}, ease:Default (Regular.easeOut)});
}
function hideImage(mc) {
	mc._alpha = 0;
	_global.TweenLite.to(mc,1,{autoAlpha:0, ease:Default (Regular.easeOut)});
}
function showText(mc, xml_node) {
	mc._alpha = 0;
	mc.bodyText_txt.html = true;
	mc.bodyText_txt.styleSheet = _root.css;
	mc.bodyText_txt.embedFonts = true;
	mc.bodyText_txt.condenseWhite = true;
	mc.bodyText_txt.autoSize = true;
	theText = _root.flashContent_xml[xml_node][0].value;
	if (_root.flashContent_xml[xml_node][0].readMore) {
		theTextEnd = theText.substr(-4);
		if (theTextEnd == "</p>") {
			tempString = theText.substr(0, -4);
			tempString += " <a class='readmore' href='" + _root.flashContent_xml[xml_node][0].readMore + "'>READ MORE &#62;</a></p>";
			theText = tempString;
		} else {
			theText += " <a class='readmore' href='" + _root.flashContent_xml[xml_node][0].readMore + "'>READ MORE &#62;</a>";
		}
	}
	mc.bodyText_txt.htmlText = _root.convertHTMLString(theText);
	_global.TweenLite.to(mc,1,{autoAlpha:100, ease:Default (Regular.easeOut)});
}
function hideText(mc) {
	mc._alpha = 0;
	_global.TweenLite.to(mc,1,{autoAlpha:0, ease:Default (Regular.easeOut)});
}
function showTitle(mc, xml_node) {
	mc._alpha = 0;
	mc.title_txt.autoSize = false;
	mc.title_txt.multiline = false;
	mc.title_txt.wordWrap = false;
	mc.title_txt.text = _root.flashContent_xml[xml_node][0].value;
	if (mc.title_txt.textWidth > mc.title_txt._width) {
		titleFormat = new TextFormat();
		titleFormat.size = 100;
		for (t=100; t>1; t--) {
			if (mc.title_txt.textWidth > mc.title_txt._width-3) {
				titleFormat.size--;
				trace("textWidth = " + mc.title_txt.textWidth + ". _width = " + mc.title_txt._width + ". fontSize = " + titleFormat.size);
				mc.title_txt.setTextFormat(titleFormat);
			}
		}
	}
			
	_global.TweenLite.to(mc, 1, {autoAlpha:100, ease:Default (Regular.easeOut)});
}
//
//**************************//
// SLIDESHOW FUNCTIONS
//**************************//
//
_root.SlideShow = new Object();
_root.SlideShow.fade_time = 1; //speed in seconds;
_root.SlideShow.wait_time = 5; //seconds between slides

function makeSlideShow(mc, resizeEnabledVar){
	mc.MCL = new MovieClipLoader();
	mc.slideshowPreloader = new Object();
	mc.MCL.addListener(mc.slideshowPreloader);
	mc.imageClips_array = [];
	//
	mc.slideshowPreloader.onLoadInit = function(target) {
		mc.imageClips_array.push(target);
		if (mc.imageClips_array.length == _root.flashContent_xml.image.length) {
			mc.current_slide_num = mc.imageClips_array.length;
			startSlideShow(mc, resizeEnabledVar);
		}
	}
	//
	for (i=0; i<_root.flashContent_xml.image.length; i++) {
		temp_url = _root.flashContent_xml.image[i].src;
		temp_mc = mc.createEmptyMovieClip(i, mc.getNextHighestDepth());
		temp_mc._alpha = 0;
		mc.MCL.loadClip(temp_url,temp_mc);
	}
	mc.transition_mc.swapDepths(mc.getNextHighestDepth());
}
//
function startSlideShow(mc, resizeEnabledVar){
	if (mc.current_slide_num >= mc.imageClips_array.length-1) {
		mc.current_slide_num = 0;
	} else {
		mc.current_slide_num++;
	}
	mc.transition_mc.gotoAndStop(2);
	if(resizeEnabledVar == true){
		resizeWait_delay = .6;
		picCenterX = (mc.guide_mc._width-mc.imageClips_array[mc.current_slide_num]._width)/2;
		picCenterY = (mc.guide_mc._height-mc.imageClips_array[mc.current_slide_num]._height)/2;
		
		TweenLite.to(mc.panel_border_mc, resizeWait_delay, {delay:1, _width:mc.imageClips_array[mc.current_slide_num]._width, _height:mc.imageClips_array[mc.current_slide_num]._height, _x:picCenterX, _y:picCenterY, ease:Regular.easeInOut});
		mc.panel_border_mc.swapDepths(mc.getNextHighestDepth()+2);
		
		TweenLite.to(mc.panel_mc, resizeWait_delay, {delay:1, _width:mc.imageClips_array[mc.current_slide_num]._width, _height:mc.imageClips_array[mc.current_slide_num]._height, _x:picCenterX, _y:picCenterY, ease:Regular.easeInOut});
		
		TweenLite.to(mc.imageClips_array[mc.current_slide_num], 0, {_x:picCenterX, _y:picCenterY, delay:0, overwrite:2, ease:Default (Regular.easeOut)});
		TweenLite.to(mc.imageClips_array[mc.current_slide_num], 2, {autoAlpha:100, delay:resizeWait_delay+1, ease:Default (Regular.easeOut)});
		
	} else {
		resizeWait_delay = 0
		_global.TweenLite.to(mc.imageClips_array[mc.current_slide_num], 2, {autoAlpha:100, ease:Default (Regular.easeOut)});
	}
	_global.TweenLite.to(mc.transition_mc,2, {frame:90});
	//_global.TweenLite.to(mc.imageClips_array[mc.current_slide_num], 1.3, {autoAlpha:100, ease:Default (Regular.easeOut), delay:.5});
	//_global.TweenLite.to(mc.transition_mc, 1.3, {frame:111, delay:.5});
	if (mc.imageClips_array.length > 1) {
		_global.TweenLite.to(mc.imageClips_array[mc.current_slide_num], 1, {autoAlpha:0, ease:Default (Regular.easeOut), delay:_root.SlideShow.wait_time, onStart:_root.startSlideShow, onStartParams:[mc, resizeEnabledVar]});
	}
}

//**************************//
// BEFORE & AFTER FUNCTIONS
//**************************//
//

//Before and After pic settings
_root.BeforeAfter = new Object();
_root.BeforeAfter.fade_time = 1.5;
_root.BeforeAfter.wait_time = 5;
_root.BeforeAfter.move_time = 1; // the time it takes for the after pic to move down
_root.BeforeAfter.y_position = 150; // the distance in pixels that the after pic should slide down
//
function makeBeforeAfter(mc){
	mc.label_before._alpha = 0;
	mc.label_after._alpha = 0;
	mc.MCL = new MovieClipLoader();
	mc.imagesPreloader = new Object();
	mc.MCL.addListener(mc.imagesPreloader);
	//
	mc.load_num = 0;
	mc.imagesPreloader.onLoadComplete = function(target) {
		mc.load_num++;
		if (mc.load_num == 2) {
			startBeforeAfter(mc);
		}
	}
	//
	before_url = _root.flashContent_xml.image[0].before[0].src;
	before_mc = mc.createEmptyMovieClip("img_before", mc.getNextHighestDepth());
	before_mc._alpha = 0;
	mc.MCL.loadClip(before_url, before_mc);
	//
	after_url = _root.flashContent_xml.image[0].after[0].src;
	after_mc = mc.createEmptyMovieClip("img_after", mc.getNextHighestDepth());
	after_mc._alpha = 0;
	mc.MCL.loadClip(after_url, after_mc);
}
function startBeforeAfter(mc) {
	// show before
	_global.TweenLite.to(mc.label_before, _root.BeforeAfter.fade_time, {autoAlpha:100, ease:Default (Regular.easeOut)}); // fade in before pic
	_global.TweenLite.to(mc["img_before"], _root.BeforeAfter.fade_time, {autoAlpha:100, ease:Default (Regular.easeOut)}); // fade in before label
	// show after
	mc["img_after"]._y = 170;
	_global.TweenLite.to(mc["img_after"], _root.BeforeAfter.fade_time, {autoAlpha:100, ease:Default (Regular.easeOut)}); // fade in after pic
	_global.TweenLite.to(mc.label_after, _root.BeforeAfter.fade_time, {autoAlpha:100, ease:Default (Regular.easeOut)}); // fade in after label
	//_global.TweenLite.to(mc.label_before, _root.BeforeAfter.fade_time, {autoAlpha:0, ease:Default (Regular.easeOut), delay:_root.BeforeAfter.wait_time}); // fade out before label
	// separate
	}

//
//**************************//
// PATIENT INFO FUNCTIONS
//**************************//
//

function listPatientLinks(mc) {
	mc._y = mc._parent.bodyText_txt.height + 10;
	mc.btnYpos = 10;
	trace(_root.flashContent_xml.form.length);
	for (i=0; i < _root.flashContent_xml.form.length; i++) {
		mc.attachMovie(pdf_link, "link"+i, mc.getNextHighestDepth());
		mc["link"+i].label_txt.htmlText = _root.flashContent_xml.form[i].value;
		mc["link"+i].src = _root.flashContent_xml.form[i].src;
		mc["link"+i]._y = mc.btnYpos;
		mc.btnYpos += mc["link"+i]._height + 10;
		mc["link"+i].onRollOver = function() {
		}
		mc["link"+i].onRollOut = function() {
		}
		mc["link"+i].onPress = function() {
			getURL(this.src, "_blank");
		}
	}
}