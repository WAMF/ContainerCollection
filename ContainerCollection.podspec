Pod::Spec.new do |spec|
  spec.name         = 'ContainerCollection'
  spec.version      = '1.0.0'
  spec.summary      = 'Rendering engine to easily stack views in different layouts'
  spec.description  = 'This framework enables to embed view controllers into table view or collection view cells, thus providing a rendering system to create complex layouts by implement smaller components as usual view controllers.'
  spec.license      = { :type => 'MIT', :file => 'LICENSE' }
  spec.homepage     = 'http://www.wearemobilefirst.com'
  spec.authors      = { 'Pere Daniel Prieto' => 'pere@wearemobilefirst.com', 'Christian Aranda' => 'christian@wearemobilefirst.com', 'Francesco Deliro' => 'francesco@wearemobilefirst.com', 'Daniel Daverio' => 'daniel@wearemobilefirst.com', 'Lee Higgins' => 'lee@wearemobilefirst.com' }
  spec.source       = { :git => 'git@github.com:WAMF/ContainerCollection.git', :tag => spec.version }

  spec.ios.deployment_target  = '10.0'
  spec.tvos.deployment_target  = '10.0'

  spec.ios.source_files = ['ContainerCollection/Common/**/*.{h,m,swift,storyboard}', 'ContainerCollection/iOS/**/*.{h,m,swift,storyboard}']
  spec.tvos.source_files = ['ContainerCollection/Common/**/*.{h,m,swift,storyboard}', 'ContainerCollection/tvOS/**/*.{h,m,swift,storyboard}']
end
