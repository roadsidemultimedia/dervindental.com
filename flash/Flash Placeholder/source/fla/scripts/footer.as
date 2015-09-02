import gs.TweenMax;
import gs.plugins.*;
TweenPlugin.activate([BlurFilterPlugin, RemoveTintPlugin, VolumePlugin, AutoAlphaPlugin, TintPlugin, VisiblePlugin, GlowFilterPlugin]);
_global.TweenMax = TweenMax;
//////:::::::::::::::::::::::::::::::::::::::::://////
import scripts.XMLParser;
_global.XMLParser = XMLParser;
flashConfig_xml = new Object();
XMLParser.load("xml/flash_config.xml", configLoaded, flashConfig_xml);
function configLoaded(success_boolean, flashConfig_xml, xml) {
	if (success_boolean) {
		trace("flash_config.xml loaded");
		fadeInFooter();
		initFooter();
	} else {
		trace("FAILED to load flash_config.xml");
	}
}

//////:::::::::::::::::::::::::::::::::::::::::://////
_quality = "best";
Stage.scaleMode = "noScale";
Stage.align = "TL";
Stage.showMenu = false;
Stage.addListener(this);
var activeStageScale = (Stage.width/Stage.height);
this.onResize = function() {
	scale();
};


//////:::::::::::::::::::::::::::::::::::::::::://////
footerRSMM_mc._alpha = 0;
footerIcons_mc._alpha = 0;
footerName_mc._alpha = 0;


//////:::::::::::::::::::::::::::::::::::::::::://////
function fadeInFooter() {
	_global.TweenMax.to(footerBar_mc, 1, {autoAlpha:100});
	_global.TweenMax.to(footerName_mc, 1, {autoAlpha:100});
	_global.TweenMax.to(footerIcons_mc, 1, {autoAlpha:100});
}


//////:::::::::::::::::::::::::::::::::::::::::://////
function scale() {
	footerBar_mc._width = Stage.width;
	footerBar_mc._y = 5;
	footerTopBar_mc._width = Stage.width;
	footerTopBar_mc._y = 0;
	footerName_mc._x = 6;
	footerName_mc._y = footerBar_mc._y+5;
	footerIcons_mc._x = footerBar_mc._width - footerIcons_mc.icons_mc._width - 25;
	footerIcons_mc._y = footerBar_mc._y+5;
}

function initFooter() {
	// NAME - PHONE
	footerName_mc.name_txt.text = _root.flashConfig_xml.clientInfo[0].clientName[0].value + " - " + _root.flashConfig_xml.clientInfo[0].phone[0].value;
	footerName_mc.name_txt.autoSize = "left";
	footerName_mc.name_txt.multiline = false;
	footerName_mc.name_txt.wordWrap = false;
	footerName_mc.nameBG_mc._width = int(footerName_mc.name_txt._width+10);
	// ICONS
	var icons_array = new Array();
	if (_root.flashConfig_xml.links[0].schedule[0].enabled == true) {icons_array.push("schedule");}
	if (_root.flashConfig_xml.links[0].contact[0].enabled == true) {icons_array.push("contact");}
	if (_root.flashConfig_xml.links[0].bookmark[0].enabled == true) {icons_array.push("bookmark")}
	if (_root.flashConfig_xml.links[0].subscribe[0].enabled == true) {icons_array.push("subscribe");}
	if (_root.flashConfig_xml.links[0].roadside[0].enabled == true) {icons_array.push("roadside");}
	trace(_root.flashConfig_xml.links[0].schedule[0].enabled);
	footerIcons_mc.icons_mc.contact_mc._visible = false;
	footerIcons_mc.icons_mc.schedule_mc._visible = false;
	footerIcons_mc.icons_mc.bookmark_mc._visible = false;
	footerIcons_mc.icons_mc.subscribe_mc._visible = false;
	footerIcons_mc.icons_mc.roadside_mc._visible = false;
	footerIcons_mc.iconLabels_mc.contact_label._visible = false;
	footerIcons_mc.iconLabels_mc.schedule_label._visible = false;
	footerIcons_mc.iconLabels_mc.bookmark_label._visible = false;
	footerIcons_mc.iconLabels_mc.subscribe_label._visible = false;
	footerIcons_mc.iconLabels_mc.roadside_label._visible = false;
	// position icons
	iconPosX = 5;
	labelPosY = 30;
	trace(icons_array.length);
	for (i=0; i < icons_array.length; i++) {
		var item = icons_array[i];
		trace(i);
		footerIcons_mc.icons_mc[item+"_mc"]._visible = true;
		footerIcons_mc.icons_mc[item+"_mc"]._x = iconPosX;
		iconPosX += footerIcons_mc.icons_mc[item+"_mc"]._width + 30;
		footerIcons_mc.iconLabels_mc[item+"_label"]._visible = true;
		footerIcons_mc.iconLabels_mc[item+"_label"]._y = labelPosY;
		labelPosY += 30;
	}
	// COLORS
	
	if (_root.flashConfig_xml.styling[0].xmlColor[0].value == true) {
		if (_root.flashConfig_xml.styling[0].footer[0].FooterColor == true) {
			var footerTopBar_color = new Color(footerTopBar_mc);
			footerTopBar_color.setRGB(_root.flashConfig_xml.styling[0].footer[0].TopBarColor);
			footerTopBar_mc._alpha = _root.flashConfig_xml.styling[0].footer[0].TopBarAlpha;
			//
			var footerBar_gradient1 = new Color(footerBar_mc.gradient1_mc);
			footerBar_gradient1.setRGB(_root.flashConfig_xml.styling[0].footer[0].Gradient1);
			footerBar_mc.gradient1_mc._alpha = _root.flashConfig_xml.styling[0].footer[0].Gradient1Alpha;
			
			
			var footerBar_gradient2 = new Color(footerBar_mc.gradient2_mc);
			footerBar_gradient2.setRGB(_root.flashConfig_xml.styling[0].footer[0].Gradient2);
			footerBar_mc.gradient2_mc._alpha = _root.flashConfig_xml.styling[0].footer[0].Gradient2Alpha;
			
			
			//
			var footerName_mc_color = new Color(footerName_mc.name_txt);
			footerName_mc_color.setRGB(_root.flashConfig_xml.styling[0].footer[0].TextColor);
			//
			var footerIcons_labels_color = new Color(footerIcons_mc.iconLabels_mc);
			footerIcons_labels_color.setRGB(_root.flashConfig_xml.styling[0].footer[0].BtnLabelColor);
			//
			var footerIcon_schedule_color1 = new Color(footerIcons_mc.icons_mc.schedule_mc.schedule_gr);
			footerIcon_schedule_color1.setRGB(_root.flashConfig_xml.styling[0].footer[0].BtnColor1);
			var footerIcon_contact_color1 = new Color(footerIcons_mc.icons_mc.contact_mc.contact_gr);
			footerIcon_contact_color1.setRGB(_root.flashConfig_xml.styling[0].footer[0].BtnColor1);
			var footerIcon_bookmark_color1 = new Color(footerIcons_mc.icons_mc.bookmark_mc.bookmark_gr);
			footerIcon_bookmark_color1.setRGB(_root.flashConfig_xml.styling[0].footer[0].BtnColor1);
			var footerIcon_subscribe_color1 = new Color(footerIcons_mc.icons_mc.subscribe_mc.subscribe_gr);
			footerIcon_subscribe_color1.setRGB(_root.flashConfig_xml.styling[0].footer[0].BtnColor1);
			footerIcons_mc.icons_mc.schedule_mc.schedule_gr._alpha = _root.flashConfig_xml.styling[0].footer[0].BtnAlpha;
			footerIcons_mc.icons_mc.contact_mc.contact_gr._alpha = _root.flashConfig_xml.styling[0].footer[0].BtnAlpha;
			footerIcons_mc.icons_mc.bookmark_mc.bookmark_gr._alpha = _root.flashConfig_xml.styling[0].footer[0].BtnAlpha;
			footerIcons_mc.icons_mc.subscribe_mc.subscribe_gr._alpha = _root.flashConfig_xml.styling[0].footer[0].BtnAlpha;
			//
			var footerIcon_r_color1 = new Color(footerIcons_mc.icons_mc.roadside_mc.roadside_gr);
			footerIcon_r_color1.setRGB(_root.flashConfig_xml.styling[0].footer[0].rColor1);
			footerIcons_mc.icons_mc.roadside_mc.roadside_gr._alpha = _root.flashConfig_xml.styling[0].footer[0].BtnAlpha;
			//			
		}
	}
}
//
scale();
stop();