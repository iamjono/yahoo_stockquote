yahoo_stockquote
================

Lasso 9 API for Yahoo! Stock Quote

Adapted from Jason Huck's Lasso 8 tag, updtaed and extended with subtype return.

Retrieves delayed stock quotes from Yahoo! Finance, rewritten as a type with the following member tags:

`->add` - Accepts a comma-delimited list of ticker symbols to retrieve.

`->(ticker symbol)` - Returns the data for the specified symbol.

The ticker symbol returns a sub-type that contains the following data members:

`org` - The organization reference (i.e. AAPL)

`price` - the price at time of last update

`lastupdate` - the last updated time

`change` - the change string in standard format

Sample Usage
------------
```lasso
sys_listTypes !>> 'yahoo_stockquote' ? include('yahoo_stockquote.lasso')

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

```
