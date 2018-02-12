
SimpleCov.start do
  command_name "DCE pid " + Process.pid.to_s
  root File.dirname(__FILE__)
end
