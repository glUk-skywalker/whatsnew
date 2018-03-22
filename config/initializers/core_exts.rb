Dir[File.join(Rails.root, "lib", "core_exts", "*.rb")].each {|l| require l }
