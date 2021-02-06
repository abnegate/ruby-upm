require "fileutils"

Before do |scenario|
  FileUtils.rm_rf("~/.upm")
end

After do |scenario|
  FileUtils.rm_rf("tmp/aruba/*")
end

