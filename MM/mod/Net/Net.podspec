Pod::Spec.new do |s|

s.name                  = 'Net'
s.version               = '2022.07.03'
s.license               = 'ZLIB'
s.summary               = 'MM'
s.homepage              = 'https://github.com/kornerr/MM'
s.author                = 'Michael Kapelko'
s.source                = { :git => 'https://fake.com/FAKE.git', :tag => s.version }
s.source_files          = 'src/*.swift'
s.swift_version         = '5.2'
s.ios.deployment_target = '13.0'

end
