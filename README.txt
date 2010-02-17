= osxscreenshot

* http://gemcutter.org/gems/osxscreenshot

== DESCRIPTION:

Wrapper around webkit2png.py to easily and programmatically capture
screenshots, crop, and resize them on Mac OS X.

== FEATURES/PROBLEMS:

* Uses the Python built-in to Mac OS X.
* You may be able to use snapurl instead of webkit2png.py: http://gemcutter.org/gems/snapurl

== REQUIREMENTS:

* Uses Python's Cocoa support (standard in Mac OS X). 

== INSTALL:

* gem install osxscreenshot

== DEVELOPERS:

Call the +capture+ method with the desired URL and some (optional) options.

    output_screenshot_path =
      OSX::Screenshot.capture(my_url, {
                         :tmp        => "#{Sinatra::Application.root}/tmp",
                         :webkit2png => "#{Sinatra::Application.root}/bin/webkit2png.py",
                         :mogrify    => "/opt/local/bin/mogrify",
                         :width      => 220,
                         :height     => 270
                       })
    system "mv #{output_screenshot_path} #{local_path}"

== LICENSE:

(The MIT License)

Copyright (c) 2010 Topfunky Corporation

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
