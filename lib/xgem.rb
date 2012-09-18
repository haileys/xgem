module XGem
  ROOT = File.expand_path "#{File.expand_path(__FILE__)}/../.."
  
  def self.resolve_require_path(path)
    @require_paths ||= Marshal.load(File.open("#{ROOT}/data/require_paths", "rb") { |f| f.read })
    @require_paths[path]
  end
  
  def self.resolve_autoload_path(path)
    if xgem_path = resolve_require_path(path)
      Gem.suffixes.each do |suffix|
        return "#{xgem_path}#{suffix}" if File.file? "#{xgem_path}#{suffix}"
      end
    end
    path
  end
  
  def self.require(path)
    __xgem_original_require resolve_require_path(path) || path
  end
end

module Kernel
  # save the pristine require *BEFORE* loading rubygems so we don't have to go
  # through its slow path...
  alias :__xgem_original_require  :require
  alias :__xgem_original_autoload :autoload
  
  require "rubygems"
  
  def require(path)
    XGem.require path
  end
  
  def autoload(symbol, path)
    __xgem_original_autoload symbol, XGem.resolve_autoload_path(path)
  end
end

class Module
  alias :__xgem_original_autoload :autoload
  
  def autoload(symbol, path)
    __xgem_original_autoload symbol, XGem.resolve_autoload_path(path)
  end
end