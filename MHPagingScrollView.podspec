
Pod::Spec.new do |s|
  s.name         = "MHPagingScrollView"
  s.version      = "1.1.0"
  s.summary      = "A UIScrollView subclass that shows previews of the pages on the left and right."
  s.description  = <<-DESC
                   A UIScrollView subclass that shows previews of the pages on the left and right. It uses a delegate much in the way UITableView uses a data source.
                   DESC
  s.homepage     = "http://www.hollance.com"
  s.license      = { :type => 'Apache License, Version 2.0', :text => <<-LICENSE
      Licensed under the Apache License, Version 2.0 (the "License");
      you may not use this file except in compliance with the License.
      You may obtain a copy of the License at
      
      http://www.apache.org/licenses/LICENSE-2.0
      
      Unless required by applicable law or agreed to in writing, software
      distributed under the License is distributed on an "AS IS" BASIS,
      WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
      See the License for the specific language governing permissions and
      limitations under the License.
      LICENSE
  }
  s.author       = { "Matthijs Hollemans" => "mail@hollance.com" }
  
  s.platform     = :ios, '5.0'
  s.source       = { :git => "https://github.com/hollance/MHPagingScrollView.git", :tag => "#{s.version}" }
  s.source_files  = 'MHPagingScrollView/MHPagingScrollView.{h,m}'
  s.preserve_paths = "README.md"
  s.requires_arc = true
end
