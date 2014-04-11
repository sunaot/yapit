require "yapit/version"
require 'yaml'
require 'pathname'
require 'forwardable'

class Yapit
  class Configuration
    extend Forwardable
    attr_accessor :root, :default_profile
    def_delegators :@yapit, :root=, :default_profile=

    def initialize(yapit)
      @yapit = yapit
    end
  end

  class << self
    attr_accessor :root, :default_profile

    def configure &block
      c = Configuration.new(Yapit)
      block.call(c)
    end
  end

  def initialize profile = nil
    @root = Pathname.new(self.class.root || '~/.pit').expand_path
    @default_profile = self.class.default_profile || 'default'
    @profile = profile
  end

  def write name, value
    lock_file = @root + ".#{profile}.lock"
    lock_file.open('w') do |f|
      f.flock(File::LOCK_EX)
      object = read_file
      object[name] = value
      profile_file.open('w') {|f| f.write(YAML::dump(object)) }
      lock_file.unlink
    end
  end
  alias_method :set, :write

  def read name
    read_file[name] || {}
  end
  alias_method :get, :read

  private
  def read_file
    YAML::load(profile_file.read)
  rescue Errno::ENOENT
    {}
  end

  def profile
    "#{@profile || @default_profile}.yaml"
  end

  def profile_file
    @root + profile
  end
end
