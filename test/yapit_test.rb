require 'minitest/autorun'
require 'minitest/unit'
require 'test_friends/tempfile'
require 'yapit'

class TestYapit < MiniTest::Unit::TestCase
  def setup
    @file = TestFriends::Tempfile.new :extname => '.yaml'
    create_sample_yaml_file @file
    Yapit.configure do |c|
      c.root = @file.dirname
    end
    @yapit = Yapit.new @file.basename(@file.extname)
  end

  def teardown
    @file.teardown
  end

  def test_read
    assert_equal 'Foo', @yapit.read('sample')['foo']
  end

  def test_write
    sample = { 'foo' => 'Changed', 'bar' => 'Bar', 'baz' => 'Baz' }
    @yapit.write('sample', sample)
    assert_equal 'Changed', @yapit.read('sample')['foo']
  end

  def test_write_does_not_break_other_record
    sample = { 'foo' => 'Changed', 'bar' => 'Bar', 'baz' => 'Baz' }
    @yapit.write('sample', sample)
    assert_equal 'Bar', @yapit.read('sample')['bar']
  end

  def test_read_a_missing_profile
    @file.unlink
    assert_equal({}, @yapit.read('sample'))
  end

  def test_invalid_root_directory
    @file.parent.rmtree
    assert_equal({}, @yapit.read('sample'))
  end

  def test_empty_yaml_file
    @file.unlink
    @file.touch
    assert_raises(NoMethodError) { @yapit.read('sample') }
  end

  def test_default
    file = TestFriends::Tempfile.new :filename => 'default.yaml'
    create_sample_yaml_file file
    Yapit.configure do |c|
      c.root = file.dirname
    end
    assert_equal 'Foo', Yapit.new.read('sample')['foo']
  end

  private
  def create_sample_yaml_file file
    file.open('w') {|f| f.write(<<-YAML.gsub(/^    /, '')) }
    ---
    sample:
      foo: Foo
      bar: Bar
      baz: Baz
    YAML
  end
end
