require "fileutils"

After do |scenario|
  FileUtils.rm_rf("tmp/aruba/*")
end
