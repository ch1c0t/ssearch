require 'ssearch'
require 'gutenberg/book'

require 'minitest/autorun'
require 'minitest/pride'

foreman_pid = fork { exec "foreman start -d spec" }
sleep 1

R = Redis.new
ROOT = 'spec/data'

MiniTest::Unit.after_tests do
  R.flushall
  %x! kill #{foreman_pid} !
  sleep 1

  Dir["#{ROOT}/db*"].each { |file| File.delete file }
  File.delete 'spec/dump.rdb'
end
