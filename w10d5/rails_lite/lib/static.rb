class Static
  attr_reader :app
  def initialize(app)
    @app = app
    @path_pattern = '../lib/public/'

  end

  def call(env)
    begin
       @app.call(env)
       req = Rack::Request.new(env)
       result = File.open(@path_pattern + 'hello.txt')
       res = Rack::Response.new(env)
       res.write(result)
       res.finish
    rescue => exception
      
    end
  end
end
