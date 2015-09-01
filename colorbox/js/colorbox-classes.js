jQuery(document).ready(function() {
	jQuery(".lightwindow").colorbox({
		iframe: true,
    	innerWidth: 680,
    	innerHeight: 800
	});
    jQuery(".colorbox").colorbox();
	jQuery(".cbox").colorbox();
	jQuery(".cbox_iframe").colorbox({iframe: true});
	jQuery(".cbox_wufoo").colorbox({
		iframe: true,
        innerWidth: 680,
        innerHeight: '90%'
	});
	jQuery(".cbox_directions").colorbox({
		iframe: true,
        innerWidth: '80%',
        innerHeight: '90%'
	});
	jQuery(".cbox_youtube").colorbox({
        iframe: true,
        innerWidth: 640,
        innerHeight: 360
    });
	jQuery(".cbox_youtube360").colorbox({
        iframe: true,
        innerWidth: 640,
        innerHeight: 360
    });
   jQuery(".cbox_youtube480").colorbox({
        iframe: true,
        innerWidth: 854,
        innerHeight: 480
    });
	jQuery(".cbox_youtube720").colorbox({
		iframe: true,
		innerWidth: 1280,
		innerHeight: 720
	});
    
})