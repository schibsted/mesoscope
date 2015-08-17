#!/bin/sh

http_get() {

	url_="$1"

	usable_http_client_=$( getPath_ 'curl' )
	if [ -x "$usable_http_client_" ]; then
		$usable_http_client_ -s $url_
	else
		usable_http_client_=$( getPath_ 'wget' )
		if [ -x "$usable_http_client_" ]; then
			$usable_http_client_ -q -O - $url_
		else
			echo "Failed doing a HTTP Get against $url_, can't find curl or wget" >&2 
		fi
	fi

}
