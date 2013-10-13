[
define yahoo_stockquote => type {
	// Retrieves and displays delayed stock quotes from Yahoo! Finance.
	data
		public symbols:: map	= map
 
	public onCreate() => {}
	// allow add on create
	public onCreate(in) => { return .add(#in) }
	
	// lookup data for new symbols
	public add(in) => {	
		// strip any non-alphanumeric characters except commas from input
		#in = string_replaceregexp(
			#in,
			-find='[^a-zA-Z0-9,]',
			-replace=''
		)

		// retrieve the data
		local(response  = 
			include_url('http://download.finance.yahoo.com/d/quote.csv?s=' + #in + '&f=sl1d1t1c&e=.txt')->asString
		)
		
		// parse results
		local(out = map)
		
		 
		local(current = string, lastupdate = null)
		 
		protect => {
			handle_error => { return error_msg+'<pre>'+error_stack+'</pre>' }
			local(keys = array)
			with line in #response->split('\r\n') do => {
				#line->replace('"','')
			
				local(linedata = #line->split(','))
				if(#linedata->size) => {
					#keys->insert(#linedata->get(1))
					local(this = yahoo_stockquote_impl)		
					#this->org			= #linedata->get(1)
					#this->price		= decimal(#linedata->get(2))
					#this->lastupdate	= date(#linedata->get(3)+' '+#linedata->get(4), -format='%D %-H:%M%p')
					#this->change		= #linedata->get(5)
					#out->insert(#linedata->get(1) = #this)
					.symbols->insert(#linedata->get(1) = #this)
				}				
			}
		}  
	}
	 
	// returns the data for the requested symbol
	public getsymbol(in) => {
		return .symbols->find(#in)
	}
	 
	// allows lookups by symbol directly
	public _unknownTag() => {
		return .getsymbol(method_name->asString)
	}
}
define yahoo_stockquote_impl => type {
	data
		public org::string		= '',
		public price::decimal 	= 0.00,
		public lastupdate::date	= date,
		public change::string 	= ''
	public asString() => {
		return map(
			'org' 			= .org,
			'price' 		= .price,
			'lastupdate' 	= .lastupdate,
			'change' 		= .change
			)
	}
}

]