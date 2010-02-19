require "test/unit"
require "osxscreenshot"

class TestOsxscreenshot < Test::Unit::TestCase

  def test_loads_url
    @tmpfile = OSX::Screenshot.capture("http://example.com")
    assert_not_nil @tmpfile
    assert File.exist?(@tmpfile)
  end

  def test_loads_tall_url
    @tmpfile = OSX::Screenshot.capture("http://blog.peepcode.com/archives")

    extra_file_name = @tmpfile.gsub(/-0\.png$/, "-1.png")
    assert !File.exist?(extra_file_name)
  end

  def test_uses_custom_tmpdir
    @tmpfile = OSX::Screenshot.capture("http://example.com", :tmpdir => "./tmp")
    assert_match(/^\.\/tmp/, @tmpfile)
    assert File.exist?(@tmpfile)
  end

  def test_handles_timeout
    @tmpfile = OSX::Screenshot.capture("http://example.com", {
                                         :timeout => 1,
                                         :webkit2png => "sleep 5 &&"
                                       })
    assert_nil @tmpfile
  end

  def test_handles_error_when_exiting
    @tmpfile = nil
    assert_raise OSX::Screenshot::CommandFailed do
      OSX::Screenshot.capture("http://example.com", {
                                :webkit2png => "exit 1;"
                              })
    end
  end

  def teardown
    if @tmpfile
      FileUtils.rm @tmpfile
    end
  end

end
