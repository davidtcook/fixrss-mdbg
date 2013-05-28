require 'rubygems'
require 'sinatra'

require 'rss'
require 'open-uri'

rss_feed = "http://www.mdbg.net/chindict/chindict_feed.php?feed=hsk_1"

# Variable for storing feed content
rss_content = ""

# Read the feed into rss_content
open(rss_feed) do |f|
   rss_content = f.read
end

# Parse the feed, dumping its contents to rss
rss = RSS::Parser.parse(rss_content, false)

today = Time.new.strftime("%Y%m%d")

rss.entries.each { |ent|
	ent.id.content = "#{ent.id.content}_#{today}"
}

get '/' do
	"<html><head><title>Foo!</title></head><body>Test page!</body></html>"
end

get '/rss.xml' do
	rss.to_xml
end
