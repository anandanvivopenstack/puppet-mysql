require 'spec_helper'

describe 'mysql::server' do

  let(:facts) {{
    :operatingsystem     => 'Debian',
    :osfamily            => 'Debian',
  }}

  it { pending('rspec-puppet bug ?') { should compile.with_all_deps } }

end
