/*
VERSION: 0.8
DATE: 06/16/2009
DESCRIPTION:
	A tooltip that can contain html text formatting.

DOCUMENTATION & EXAMPLES: 
	http://docs.roadside2.com/index.php/ToolTip_Documentation

CHANGE LOG:
	06.16:
		- Added ability to load in external swf and load an image and caption text into it
			- swf must contain movieClip named "image_mc" and a text field labeled "caption_txt"
		- Changed default styling to be slightly more transparent.
		- Failed to fix string replacement issue. convertHTMLString() function still not working correctly.
	02.01:
		- Created function 
*/
var findKey = new Array("<br>", "</br>", "<BR>", "</BR>", "<p>", "</p>", "<P>", "</P>");
var replaceKey = new Array(" \n", "", " \n", "", " \n", "", " \n", "");
// 
function convertHTMLString(sourceText) {
	var mytext:String = sourceText;
	for (i=0; i<findKey.length; i++) {
		var splitText:Array = mytext.split(findKey[i]);
		mytext = splitText.join(replaceKey[i]);
	}
	trace(mytext);
	return mytext;
}
//set Tooltip defaults//
toolTipVars = new Object();
toolTip = new Object();
_global.toolTip = tooltip;
//myTooltip._alpha = 0;
function setToolTipDefaults() {
	/* ========================= */
	/* = Builtin functionality = */
	/* ========================= */
	toolTipVars.alpha = 30;
	
	//box color and shape
	toolTipVars.color = "0x222222";
	toolTipVars.cornerRadius = 4;
	toolTipVars.tailHeight = 16;
	toolTipVars.position = "left"; //which side the tail is on
	
	//text
	toolTipVars.textColor = "0xffffff";
	toolTipVars.textFont = "Verdana";
	toolTipVars.textSize = 9;
	toolTipVars.textHtml = true;
	toolTipVars.autoSize = true;
	toolTipVars.textAlign = "left";
	toolTipVars.padding = 4;
	
	//shadow
	toolTipVars.shadow = true;
	toolTipVars.shadowAlpha = 20;
	toolTipVars.shadowAngle = 45;
	toolTipVars.shadowBlurX = 3;
	toolTipVars.shadowBlurY = 3;
	toolTipVars.shadowColor = "0x000000"
	toolTipVars.shadowDistance = 3;
	toolTipVars.shadowKnockout = false;
	toolTipVars.shadowQuality = 2;
	toolTipVars.shadowStrength = 80;
	
	//Border
	toolTipVars.border = true;
	toolTipVars.borderColor = "0x000000";
	toolTipVars.borderSize = 1;
	toolTipVars.borderAlpha = 30;
	
	//misc.
	toolTipVars.animateResize = false;
	toolTipVars.preloader = false;
	toolTipVars.autoDrag = true;
	toolTipVars.autoShow = false;
	toolTipVars.type = "text";
	/* ===================== */
	/* = New functionality = */
	/* ===================== */
	toolTipVars.tweenFollow = true;
	toolTipVars.positionX = 0;
	toolTipVars.positionY = 0;
	toolTipVars.tweenFade = true;
	/////////////////////////
	/////////////////////////
	//Run through the toolTipVars and apply the settings to the tooltip
	for (i in toolTipVars) {
		trace("i = "+i+" : "+toolTipVars[i]);
		myTooltip[i] = toolTipVars[i];
	}
}
//
function toolTipShow(textInfo, toolTipVars) {
	setToolTipDefaults();
	for (i in toolTipVars) {
		myTooltip[i] = toolTipVars[i];
	}
	myTooltip._x = toolTipVars.positionX+(_root.main_mc._x)+(_root.main_mc.swfLoader_mc._x);
	myTooltip._y = toolTipVars.positionY+(_root.main_mc._y)+(_root.main_mc.swfLoader_mc._y);
	toolTipType = textInfo.substring(textInfo.length-3, textInfo.length);
	if (toolTipType == "swf" || toolTipType == "SWF" || toolTipType == "Swf" || toolTipType == "jpg" || toolTipType == "JPG" || toolTipType == "Jpg" || toolTipType == "jpeg" || toolTipType == "JPEG" || toolTipType == "Jpeg" || toolTipType == "png" || toolTipType == "PNG" || toolTipType == "Png" || toolTipType == "gif" || toolTipType == "GIF" || toolTipType == "Gif") {
		myTooltip.type = "image";
	}
	if(myTooltip.type == "image"){
		//myTooltip.animateResize = true;
		myTooltip.content = textInfo;
	} else {
		myTooltip.content = "<font face='Verdana' color='#ffffff'>"+convertHTMLString(textInfo)+"</font>";
	}
	/* ======================================================= */
	/* = Listener for applying text to externally loaded swf = */
	/* ======================================================= */
	
	if(toolTipType == "swf"){
		myTooltip.publicListener.onLoadInit = function(target_mc) {
			target_mc.image_mc.loadMovie(toolTipVars.imageSrc, target_mc.getNextHighestDepth())
			target_mc.caption_txt.htmlText = toolTipVars.captionTxt;
		}
	}

	/* ============================= */
	/* = Enhanced Follow Behaviour = */
	/* ============================= */
	/*	
	if(toolTipVars.autoDrag == true && toolTipVars.tweenFollow == true){
		myTooltip.autoDrag = false;
		_root.onMouseMove = function() {
			if(toolTipVars.position == "right"){
				TweenMax.to(myTooltip, .25, {_x:_root._xmouse+40, _y:_root._ymouse-myTooltip._height, ease:Quadratic.easeOut});
			} else {
				TweenMax.to(myTooltip, .25, {_x:_root._xmouse-40, _y:_root._ymouse-myTooltip._height, ease:Quadratic.easeOut});
			}
		}
	}
	*/
	
	/* ============================= */
	/* = Enhanced Fading Behaviour = */
	/* ============================= */
	myTooltip.showTooltip();
	/*
		if(myTooltip.tweenFade == true){
			//myTooltip._alpha = 0;
			//myTooltip._visible = true;
			TweenMax.to(myTooltip, .2, {_alpha:100});
		}*/
}
function toolTipHide() {
	/*
	if(myTooltip.tweenFade == true){
		TweenMax.to(myTooltip, .2, {_alpha:0, onComplete:hideTooltip, onCompleteScope:myTooltip});
	}else {
		myTooltip.hideTooltip();
	}*/
	
	myTooltip.hideTooltip();
}
//_global.toolTip = myToolTip;
toolTip.show = toolTipShow;
toolTip.hide = toolTipHide;

