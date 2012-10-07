require "./lib/defile"

pwd = Dir.pwd

RSpec.configure do |config|
  config.before do
    #Always return to the calling path
    Dir.chdir(pwd)
  end
end

