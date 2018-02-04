module Pixelflut
  LibDir = File.realdirpath('../pixelflut', __FILE__).freeze
  autoload :App, File.join(LibDir, 'app.rb')
  autoload :Server, File.join(LibDir, 'server.rb')
  autoload :Canvas, File.join(LibDir, 'canvas.rb')
  autoload :VERSION, File.join(LibDir, 'version.rb')
end
