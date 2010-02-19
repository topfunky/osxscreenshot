require 'open4'

module OSX
  class Screenshot
    VERSION = '0.0.4'
    
    class CommandFailed < StandardError; end
    
    ##
    # Takes a screenshot of a website, optionally resizes it, and writes
    # it to a temporary directory. Returns the file path to the
    # temporary file.
    #
    # It's assumed that you will move the file to a permanent
    # destination or store it in a database.
    #
    # Options include:
    #
    # tmpdir::     Path to tmp directory where files will be stored
    # webkit2png:: Path to webkit2png.py command
    # mogrify::    Path to mogrify command
    #
    # Usage:
    #
    #   output_screenshot_path =
    #     OSX::Screenshot.capture(article_url, {
    #                        :tmpdir     => "#{Sinatra::Application.root}/tmp",
    #                        :webkit2png => "#{Sinatra::Application.root}/bin/webkit2png.py",
    #                        :mogrify    => "/opt/local/bin/mogrify",
    #                        :width      => 220,
    #                        :height     => 270
    #                      })
    #   system "mv #{output_screenshot_path} #{local_path}"

    def self.capture(url, options={})
      obj = new(url, options)
      obj.capture
    end

    def initialize(url, options)
      vendored_webkit2png = File.expand_path(File.join(File.dirname(__FILE__),
                                                       "..",
                                                       "vendor",
                                                       "webkit2png.py"))
      @url = url
      @options = {
        :tmpdir     => "/tmp",
        :webkit2png => vendored_webkit2png,
        :mogrify    => "mogrify",
        :width      => 320,
        :height     => 480,
        :timeout    => 30
      }.merge(options)
    end

    def capture
      random_id        = [@url.length, Time.now.to_i.to_s, rand(10000)].join('-')
      tmp_abs_filename = File.join(@options[:tmpdir], "#{random_id}-full.png")
      tmp_dir          = File.dirname(tmp_abs_filename)
      FileUtils.mkdir_p(tmp_dir)

      webkit2png_command = [@options[:webkit2png],
                            "--full",
                            "--filename",    random_id,
                            "--dir",         @options[:tmpdir],
                            @url
                           ].join(' ')

      run_command(webkit2png_command) do
        return resize(tmp_abs_filename, @options[:width], @options[:height])
      end
    end

    def resize(tmp_abs_filename, width, height)
      # Example: mogrify -resize 320x peepcodecom-full.png -crop 320x480 peepcodecom-full.png

      mogrify_command = [@options[:mogrify],
                         "-resize", "#{width}x",
                         tmp_abs_filename,
                         "-crop",   "#{width}x#{height}",
                         tmp_abs_filename
                        ].join(' ')
      run_command(mogrify_command) do
        output_filename = if File.exist?(tmp_abs_filename)
                            # Add full width and height to image
                            extent_command = [@options[:mogrify],
                                              "-extent", "#{width}x#{height}",
                                              tmp_abs_filename].join(' ')
                            run_command(extent_command) { return tmp_abs_filename }
                          elsif File.exist?(tmp_abs_filename.gsub(/\.png/, '-0.png'))
                            # Remove extra file generated by cropping.
                            FileUtils.rm(tmp_abs_filename.gsub(/\.png/, '-1.png'))
                            tmp_abs_filename.gsub(/\.png/, '-0.png')
                          end
        return output_filename
      end
    end

    def run_command(cmd, &block)
      pid = nil
      status = nil

      Timeout.timeout(@options[:timeout]) {
        pid, i, o, e = open4(cmd)
        ignored, status = Process::waitpid2 pid
      }
      
      # Success
      if (status.exitstatus == 0)
        return yield
      end
      
      # Error
      raise CommandFailed, "Command failed: #{cmd}"
    rescue Timeout::Error => e
      Process.kill "KILL", pid
      return nil
    end

  end
end


