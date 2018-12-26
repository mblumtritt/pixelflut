module Pixelflut
  LIB_DIR = File.realdirpath('../pixelflut', __FILE__).freeze
  autoload :App, File.join(LIB_DIR, 'app.rb')
  autoload :Server, File.join(LIB_DIR, 'server.rb')
  autoload :Canvas, File.join(LIB_DIR, 'canvas.rb')
  autoload :Converter, File.join(LIB_DIR, 'converter.rb')
  autoload :VERSION, File.join(LIB_DIR, 'version.rb')
end
