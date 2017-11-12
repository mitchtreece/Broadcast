
Pod::Spec.new do |s|

  s.name             = "Broadcast"
  s.version          = "1.3.1"
  s.summary          = "Lightweight instance syncing & property binding."
  s.description      = <<-DESC
    Broadcast is a quick-and-dirty solution for instance syncing and property binding.
    DESC
  s.homepage         = "https://github.com/mitchtreece/Broadcast"
  s.license          = { :type => "MIT", :file => "LICENSE" }
  s.author           = { "Mitch Treece" => "mitchtreece@me.com" }
  s.source           = { :git => "https://github.com/mitchtreece/Broadcast.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/MitchTreece'

  s.platform         = :ios, "8.0"
  s.source_files     = 'Broadcast/Classes/**/*'

end
