// === FUNCTIONS INTENDED TO INTERPRET CALLS TO LIGHTWINDOW,
// === AND CONVERT THEM TO COLORBOX CALLOUTS FOR BACKWARDS COMPATIBILITY
function lw() {}
function activateWindow(options) {
	if(options.type == 'external')options.iframe = true;
	if(options.width == undefined)options.width = '90%';
	if(options.height == undefined)options.height = '90%';
	cbSuperFunction({href:options.href, innerHeight:options.height, innerWidth:options.width, iframe:options.iframe, maxHeight:'90%'});
}
lw.prototype.activateWindow=activateWindow;
myLightWindow=new lw();

// === FUNCTION TO ALLOW FULL CONTROL OF COLORBOX FROM AN <A> TAG
// === ALSO ALLOWS COLORBOX TO BE CALLED FROM FLASH, AND PASS AN ARRAY WITH MULTIPLE IMAGES FOR A SLIDESHOW
// === 
// === TO LOAD A GALLERY
// === EXAMPLE: btn.onPress{getURL(cbSuperFunction({href:['pic1.jpg', 'pic2.jpg', 'pic3.jpg'], 'slideshow':true, slideshowSpeed:60000});
// === 
// === TO LOAD A SINGLE IMAGE
// === EXAMPLE2: btn.onPress{getURL(cbSuperFunction({href:pic1.jpg, 'slideshow':true, slideshowSpeed:60000});

function cbSuperFunction(galInfo){
	//cleanup previously created colorbox group
	$('#cbGroupDiv').remove();
	
	//define href's from arguments passed to function
	var cbItems = [];
	if(typeof galInfo.href == 'string'){
		//alert("href type was a string \n implying a single URL, rather than a group");
		cbItems.push(galInfo.href);
	} else {
		for( var i = 0; i < galInfo.href.length; i++ ) {
			cbItems.push(galInfo.href[i]);
		}
	}
	
	cbArgs = [];
	//set defaults
	if(cbArgs.iframe == true || cbArgs.iframe == true){
		cbArgs.innerWidth = '90%';
		cbArgs.innerHeight = '90%';
	}
	
	//grab arguments passed to function
	
	for(var i in galInfo) {
		if(i == "href") continue;
		cbArgs[i] = galInfo[i];
	}
	if(cbArgs.iframe == true || cbArgs.iframe == true){
		cbArgs.maxHeight = '90%'
	}
	
	//define hidden div & content to use as colorbox slideshow group
	cbGroup = "<div id='cbGroupDiv' style='display:none'>";
	$.each(
		cbItems, function( intIndex, value ){
			cbGroup += "<a href='"+value+"' rel='cbGroupRel' class='cbGroupClass'></a>";
		}
	);
	cbGroup += "</div>";
	
	//Write content to the end of the document and hide it
	$("body").append(cbGroup);
	
	//set the colorbox to open after this function is executed
	cbArgs.open="true";
	
	$(".cbGroupClass").colorbox(cbArgs); 
};