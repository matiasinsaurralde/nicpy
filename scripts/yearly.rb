require 'date'
require 'pp'

$years, $cost, $dollar_exch = {}, 200000, 4460

File.read('../datos/domains.txt').split("\n").each do |ln|
  splits = ln.split("\t")
  domain, dt = splits[0], Date.strptime( splits[1].strip, '%Y-%m-%d')
  $years.store( dt.year, 0 ) if !$years[dt.year]
  $years[dt.year] += 1

  # para curiosear los dominios mas viejitos:

  #if dt.year < 1997
  #  p [domain,dt.strftime('%Y-%m-%d') ]
  #end
end

# si consideramos el dato de registros nuevos (y que siempre costo Gs. 200.000 ):

$years.sort_by{|k,v| k }.each do |y|
  total = ( y[1]*$cost/$dollar_exch )
  puts "#{y[0]}, #{y[1]} dominios (nuevos?): #{total} U$"
end

# si consideramos que el dato hace referencia a la fecha en la que registro un dominio
# y se lo siguio renovando hasta el 2014 (y que todos los dominios del archivo estan activos):
