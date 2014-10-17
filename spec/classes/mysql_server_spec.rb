require 'spec_helper'

describe 'mysql::server' do

  let(:facts) {{
    :operatingsystem     => 'Debian',
    :osfamily            => 'Debian',
  }}

  it { should compile.with_all_deps }

end
