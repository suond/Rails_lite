require 'erb'

class ShowExceptions
  attr_reader :app
  def initialize(app)
    @app = app
  end

  def call(env)
    begin
      @app.call(env)
    rescue => exception
      res = Rack::Response.new
      ['500', {'Content-type' => 'text/html'}, ['RuntimeError']]
    end
  end

  private

  def render_exception(e)
  end

end
