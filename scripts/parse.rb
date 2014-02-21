require 'nokogiri'

def domain_status(domain_name)
  matches = domain_name.match(/(.*)\.(.*)\.py/)
  raw_html = `curl -s 'http://www.nic.py/cgi-nic/consultas/domdetzzz' -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8' -H 'Accept-Encoding: gzip, deflate' -H 'Accept-Language: en-US,en;q=0.5' -H 'Cache-Control: max-age=0' -H 'Connection: keep-alive' -H 'Host: www.nic.py' -H 'Referer: http://www.nic.py/cgi-nic/consultas/domlistzzz' -H 'User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Firefox/24.0' -H 'Content-Type: application/x-www-form-urlencoded' --data 'dom=#{matches[1]}&tip=#{matches[2]}'`
  return Nokogiri::HTML( raw_html ).css('.texto_1')[4].inner_text
end

$threads = []

File.read('datos/dnsadmin_dominio.sql').split("\n")[20,40].each do |ln|
  $threads << Thread.new do
   splits = ln.split(',')
   domain_name = splits[0].match(/\('(.*)'/)[1].strip
   tld = splits[1].gsub("'", '').strip
   domain = "#{domain_name}.#{tld}.py"
   puts [ domain, domain_status(domain) ]
  end
end


$threads.each do |th|
  th.join
end
