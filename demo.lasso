[
//	sys_listTypes !>> 'yahoo_stockquote' ? 
		include('yahoo_stockquote.lasso')

	if(web_request->params->asStaticArray >> 'symbol') => {^ 
		local(myquotes = yahoo_stockquote(web_request->param('symbol')->asString))
	else
		local(myquotes = yahoo_stockquote)
	^}
	#myquotes->add('AAPL')
	#myquotes->add('GOOG')
	
	'APPLE<br>'
	'<br>AAPL price: '+#myquotes->AAPL->price
	'<br>AAPL last update: '+#myquotes->AAPL->lastupdate
	'<br>AAPL change: '+#myquotes->AAPL->change

	'<br><br>GOOGLE<br>'
	'<br>AAPL price: '+#myquotes->GOOG->price
	'<br>AAPL last update: '+#myquotes->GOOG->lastupdate
	'<br>AAPL change: '+#myquotes->GOOG->change
	
	'<br><br>Symbols<br>'
	#myquotes->symbols
]