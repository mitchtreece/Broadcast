
Pod::Spec.new do |s|

  s.name             = "Broadcast"
  s.version          = "1.0.0"
  s.summary          = "Simple library that helps keep multiple instances in-sync."
  s.description      = <<-DESC
    Broadcast helps keeps object instances in-sync.
    DESC
  s.homepage         = "https://github.com/mitchtreece/Broadcast"
  s.license          = { :type => "MIT", :file => "LICENSE" }
  s.author           = { "Mitch Treece" => "mitchtreece@me.com" }
  s.source           = { :git => "https://github.com/mitchtreece/Broadcast.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/MitchTreece'

  s.platform         = :ios, "8.0"
  s.source_files     = 'Broadcast/Classes/**/*'

end
