function viewport() {
	var doc = $(document),
		h = doc.height();
		
	// for the horror browsers
	if ($.browser.msie) {
		// If there are no scrollbars then use window.height as width
		var w = h;
		return [
			window.innerWidth || 						// ie7+
			document.documentElement.clientWidth || 			// ie6  
			document.body.clientWidth, 					// ie6 quirks mode
			h - w < 20 ? w : h
		];
	}
	// for cute and well behaving browsers
	return [doc.width(), h]; 
}