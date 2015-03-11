require 'bundler'
Bundler.require

require_relative 'config.rb'

get '/' do
  $p = Pry.new
  $q = Pry.new
  haml :index
end

post '/' do
  process_command(input: params[:code])
end

def process_command(input:)
  stdout_stream = capture(:stdout) { $p.eval(input) }
  stderr_stream = capture(:stderr) { $q.eval(input) }
  handle(stdout_stream, stderr_stream)
end

def handle(stdout, stderr)
  if !$p.eval_string.empty?
    "*"
  elsif stdout
    decolor(stdout)
  else
    decolor(stderr)
  end
end

def decolor(str)
  str.gsub!(/=> \e\[1;36m/, "")
  str.gsub!(/\e\[0m/, "")
  str.gsub!(/=> \e\[33m/, "")
  str.gsub!(/\[32m/, "")
  str.gsub!(/\[1;34m/, "")
  str.gsub!(/\[;31m/, "")
  str.gsub!(/\[1;31m/, "")
  str.gsub!(/\[31m/, "")
  str.gsub!(/\[1;34;4m/, "")
  return str
end
