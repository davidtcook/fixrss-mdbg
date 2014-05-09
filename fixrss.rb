require 'rubygems'
require 'sinatra'

require 'rss'
require 'open-uri'

feeds = { :hsk1 => "http://www.mdbg.net/chindict/chindict_feed.php?feed=hsk_1",
:hsk2 => "http://www.mdbg.net/chindict/chindict_feed.php?feed=hsk_2",
:hsk3 => "http://www.mdbg.net/chindict/chindict_feed.php?feed=hsk_3",
:hsk4 => "http://www.mdbg.net/chindict/chindict_feed.php?feed=hsk_4",
:hsk5 => "http://www.mdbg.net/chindict/chindict_feed.php?feed=hsk_5",
:hsk6 => "http://www.mdbg.net/chindict/chindict_feed.php?feed=hsk_6"
}

rss_content = {}
rss = {}
today = Time.new.strftime("%Y%m%d")

feeds.each_key { |feed|
ts = Time.new.strftime("%Y%m%d:%H:%M:%S")
	puts "#{ts}: Processing feed #{feed.to_s} - URL: #{feeds[feed]}"
	# Variable for storing feed content
	rss_content[feed] = ""

	# Read the feed into rss_content
	open(feeds[feed]) do |f|
	   rss_content[feed] = f.read
	end

	# Parse the feed, dumping its contents to rss
	rss[feed] = RSS::Parser.parse(rss_content[feed], false)

	rss[feed].entries.each { |ent|
#		puts "Updating ent.id.content from |#{ent.id.content}|"
		ent.id.content = "#{ent.id.content}_#{today}"
#		puts "to |#{ent.id.content}|"
#		puts "Updating ent.link from |#{ent.link}|"
		ent.link.href[-1] = ent.link.href[-1] + "&ignore=#{today}"
#		puts "to |#{ent.link}|"
	}
}

get '/' do
#	"<html><head><title>Foo!</title></head><body>Test page!</body></html>"
	@data = feeds
	erb :index
end

get '/:feed/rss.xml' do
#	"<html><head><title>Foo!</title></head><body>Feed is #{params[:feed]}</body></html>"
	
	rss[params[:feed].to_sym].to_xml
end
